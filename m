Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47E52D46C1B
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 03:29:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 726446B0088; Wed, 28 Jan 2026 22:29:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D4106B0089; Wed, 28 Jan 2026 22:29:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B63B6B008A; Wed, 28 Jan 2026 22:29:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C8A36B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 22:29:52 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E4A7D13BCA7
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 03:29:51 +0000 (UTC)
X-FDA: 84383572182.07.2B20373
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011040.outbound.protection.outlook.com [40.93.194.40])
	by imf01.hostedemail.com (Postfix) with ESMTP id 045A040007
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 03:29:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="arK0HxD/";
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769657389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HCyPoEoE2tQGag+LWxkyo72daHVs8+N5KrA777a0AZ8=;
	b=CTwPQaygUDni5FGTIdlSkgfqq98CVFoB5cl9xjIRW+nX8+SvWf82UQApCZ2xEgesfjH6sh
	ARTi1dO5N/vB+k0ABKJ9zsCEDZtW0Zcvl+5LsAmpNaxCeOpZwvvslv35aCecrNkgczk53H
	J6KRzcNH0s9oQiny87bdbbIndqw84Z8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="arK0HxD/";
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769657389; a=rsa-sha256;
	cv=pass;
	b=fUUBtwZLdPVjadyX8e1blwvvoQ4CkN81cLdiKYZQz5Au4lcJwKW7c+s8H1ga4/a4b1l6cS
	YXwBXExGmumVWXYZUkLxSHj3u4nwaAUJqcUkaOSUmTJjr5qPNs6JuEzDmgaRlCEQZWlCyO
	URFMG0PiIjhAesoXAJGaTaAQbQ0pxYI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Iavx2Ewg+y8H65fO8G1etKJB7H5uxyRUlD79w/MTIH7Tw5sTqROpq2OV7pvpROdlGxVAYVeKvSJFD3lJ93AlBWJBgi3DJQj8MhyE6B9d76qS8Oe9uYYJlIdiLBeG9xsCG+p+J5fJUleoLzU1GY6xV0FQdMqGe1Lc788wM91nf3Ly7RXQI4aL6A5soNV9ohqRy6h2/xpw065x3MLcr37dn/D/1ZLBv8kAO2nnQ7KlG065lsy9nQIFSpyO11oVPecH5azTAb6bkEwal62rI5DSw8SlKtGoeyj4PNW3Y/0iEZlkPbVk33/tNgkhl82aIK5GQzmnMUd4rNvw51ByGaezQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HCyPoEoE2tQGag+LWxkyo72daHVs8+N5KrA777a0AZ8=;
 b=XkEWMN1ocqLDqubveIfqh7zUshO1zh1qNun0tIktJbmUufs3RpNGL0ZFD2MMwmLrXNRL52xJRpmrDlhrKM2nlf7PJnJlfwWvSCGI+7ROYwarkss5MHLWdcZpvQy05OOIQyKSxV5VML+jpsekIDMjOK/nWeJz9HknVXzGvGu5RxQCml9QcCJL6j9vPTh9R4GbyWjKaMO0d/t4gF1g/aIm8vIgEIEpNmSEijdFnVvMcnaR8y1kY7BuSs8Z30UEHOxOhtRNh9i5NskvE4cE2epfE10Qx5OEDrChesCWhu0lkvtS91VRm+KdQaw7MAieOWPtV0kMn7pGPb0T24+0LO+Svg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HCyPoEoE2tQGag+LWxkyo72daHVs8+N5KrA777a0AZ8=;
 b=arK0HxD/fFSNM6NyTFrHUMcWPMNuT7Pw2AoCj3fuVbg8Fj8F0G3TO0f0xd+h9mEWdhEsTe+a9KRhxt9mY3ObyA31/wG9GIimNT44bHloJM9A/PT7k4cXaODeQ9PhS8kejR15wwCW3SOBrJqh2ADpTnfnfriu9qSirFnnhH4q/ywQsJMbJ1aqI8hYl6nm86gxEgHaogvaHb0dVe7b1V4OiV6Td+c8SbiHMogvyEhOujpfk05Z+wwvf+NhZsRRCkuZAjGZf+hsG74JZEaIp8EaKRMERwd8bwqK2qHtIfolvb2UaoWDuAPI7PqwVlHP+67Da8mR0b4Cj98DbJn4RAKOBQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BL1PR12MB5971.namprd12.prod.outlook.com (2603:10b6:208:39a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Thu, 29 Jan
 2026 03:29:44 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9564.006; Thu, 29 Jan 2026
 03:29:44 +0000
From: Zi Yan <ziy@nvidia.com>
To: Muchun Song <muchun.song@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
Subject: Re: [PATCHv5 09/17] mm/sparse: Check memmap alignment for
 compound_info_has_mask()
Date: Wed, 28 Jan 2026 22:29:38 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <5AFAE2FC-7274-4A23-AE92-797D5B69AA8B@nvidia.com>
In-Reply-To: <1A08D224-E1AC-4FE5-B1D0-1BAE2D5FF31E@linux.dev>
References: <20260128135500.22121-1-kas@kernel.org>
 <20260128135500.22121-10-kas@kernel.org>
 <B4674CF0-7534-462B-A761-D9124234BFE4@linux.dev>
 <3DA11168-5E37-4CE9-9934-CD1CAF3085D6@nvidia.com>
 <1A08D224-E1AC-4FE5-B1D0-1BAE2D5FF31E@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:a03:40::27) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BL1PR12MB5971:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d894e6e-1083-479d-7ac5-08de5ee6a588
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NnoyY29aQ3NHVnRpQkFjbWprRWRmUkRqT3I5cG51R3dGSnFYSHNaeWs5dE1U?=
 =?utf-8?B?d0Z2d2V4MG5kMlFHSzc4SytHYzdDa2F4c05YbklOVUVmSms4MUYxMVRqemN1?=
 =?utf-8?B?S1ZUMWgvTTFEOHZudVV3aW5KdUVsbjZvWkJZWGNMcTRWYlRVd24vRm5BNXJo?=
 =?utf-8?B?cFBlUi91M3B3TkZpRUtYV3dwZE9TaU8zZng5enplM0tJOXgzU0dqUS9Db0Vm?=
 =?utf-8?B?NktDWll2SGtLeFRURWk3SVdiNUZWMkNtT1lXSGw4bSsyM1dqeCszSTFiK1N3?=
 =?utf-8?B?L0ROQnZoUTlzWTYvM0EyQ2dKOXE0YmVTZlVhRkVXOCtXOGtEVEhJQjFENTNz?=
 =?utf-8?B?bHVCMWgzVnA5bU9FWGtiMFExRXN4SUM3WURvZ3ZsYkVkUFdneldpeDdqZmtS?=
 =?utf-8?B?aUI4b1A1cmRDT3lVUU5SODNHUDdYZlpPa2tkSzlYWmpKaFNvejRsaFlja3FB?=
 =?utf-8?B?TWxIWGNwelVndGdBNXZndURyQTUyTHFuMXJPZmh5aVNnTG5vWkdLRGlyUlRy?=
 =?utf-8?B?aUFveGNMOFpSYktKMkVPWjYxcjdUSkFYWlIrZWlITVFGUFFKQ3p6T2pWSWZh?=
 =?utf-8?B?QVg4WHNLZ0R1VXZBU1B5UUFpakVsdmJENzh3ZEc4d0lxc0lQcjdNUGNtRjdh?=
 =?utf-8?B?a1VyQjhENmk5Rit4ejd0UUlwWWZZTjg2MTVTOVJja3FCREVkMkZaR0MvekFm?=
 =?utf-8?B?N1pCVVluUEdkMEh0QTNyM2Jnb3llcUxLNEF1TnNTcXdzQTZpMEZ5SW52VEhM?=
 =?utf-8?B?RHh0VkVKeEZBUlpQOEtJZzFHSlQ2bXpsbGdYeXY3djdLTVhobzdQOHhiRlZG?=
 =?utf-8?B?U2FRdWtDcmpjZm40WUlSL2JOZnZMcWtOZzlCU04wREhhWVRMQUJBSUtIeUs4?=
 =?utf-8?B?YlU4LzdWUXZ0dU93V1VNQ0RQYngrditrZlBrNXBHc1BlZlp6ZFVkZjBYbE1P?=
 =?utf-8?B?aWZDTzZmOUVWYklHVTJEcnRmYk4yTzFqR083ekhPRUxjdXJVc1dBdjZMS3p2?=
 =?utf-8?B?NUNNV0t0VEN6Y3M5NEVhaC82QnRjU1pDN2lzS1Z0SzIvaE5tZFZXQytkM1R0?=
 =?utf-8?B?TTVqc3FKWGs5ZzhaTTVqbzJhdDNsK3FXZW1Wa3N0MGJGMS9nSFVlTUtCc2o0?=
 =?utf-8?B?V28rR1ZBMDNQUitQN29ZQU9Pc1FPUzA4RjFuZlpWWjAvSUpiSkJGZTYwbzJW?=
 =?utf-8?B?Q2dJa2RVcVkwenlHZHBrcGUwNUY0cjdKVVFTZ3UxS0ZwSkl3RzZjNTFMdXdS?=
 =?utf-8?B?c3hmendVQUNSdUViV1FYYXh5K2VtRHJ5dHNyZ1I5TUJuYVVCUDFnSnhjSWhQ?=
 =?utf-8?B?T241SnpINUhocGIvdk0yZC9MZnM5RVdpMVRDcm1oN2VTaTBtUTlicWJmVlR2?=
 =?utf-8?B?TjZrWjNpS25qNkJiNnhkaVJDMVByK3V3YVloUHE1TVI4bkVuRmdSZDhEWkx6?=
 =?utf-8?B?S2tWRnZ4dHZOdGcraE9PK1FvTnEyNEVyMTJ3d2hoNk85dzVXSFBrN09CMFJD?=
 =?utf-8?B?VGlvTFYrSVlQSkE2T2F3YkNZVko1cjV4eklJZ3lsY1hBWk5XU0pmTWZrSWFp?=
 =?utf-8?B?Zmt6MzJuSEZJcWRmYUxZbVhubWE5NkdOVFZsU1JlNFBmRGVobUJBempDRWU1?=
 =?utf-8?B?MmRMZ3ovalR6N3g4cFpZNzhGc3RKRjNaVFJLMWhzNGdYMis1UDJUcFoyNDVh?=
 =?utf-8?B?bi9uZGtjczBXNTErdE5DTDFUbTd3V2dKdXR0aWMvUU4zR1hGZWxCR2twaGVR?=
 =?utf-8?B?UGRoTThiOG12RkhzaHhUajBWR0NLMHhYRGFVUEIvNnJtenNmZ0w1SEoxV1pP?=
 =?utf-8?B?bGRyOWFRT3hLRm5menBhZmx4RTNWVWF2TFpRYlBuSzMzYVEzTDMrWGN5bjFk?=
 =?utf-8?B?NUdYZExXQnRhbjUvcFliY1UwWFZLS1hZcVhGY1NJUGJmeEl6S2tDNjd4c3BP?=
 =?utf-8?B?N3Q4eTJZMy9wWW5PZmxBN3IyUUZ2VUN5VkY4eFkwN3E4MzBMTTVjbFlFdllh?=
 =?utf-8?B?ZWhaM1lKZy9ON25XNGgwcE4wRUg5d3paVEtGYlNMU3FxbGZPeGR4Q1BZdVBL?=
 =?utf-8?B?akFXY1BocWduMVBRYVFRZlVyaGwwRWJ0TDdBc2lDMnpKZGp4MFJXTFdjQ2Yz?=
 =?utf-8?Q?kEsg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d1l6T0U1MHJIdEJxeXdvSHM2TWFzT29RVnZUaGlmYW1ON1F2Ujl2MXRHVnV3?=
 =?utf-8?B?Yk5YVks1REhnSjFoU3d4a0xTaThGMXpMeGNjUjhDdmVqZm1YYmFCb2FXb3B0?=
 =?utf-8?B?VFVjZDgzcnVwaDk1VDdoREdVSFNEdmZFekszbzV2MDkwODJuNWFUV0tXK3pu?=
 =?utf-8?B?cVdHdVptVlBCM3cyUlJuRDQwVmJrYy9vR1J5Mk9neStaVm1Zb0J2RDFCWlJy?=
 =?utf-8?B?UkltZlJObVZyUERMYlliQ1RMbDM0TXZub0JRR0VUdlA3RkRNWGFyUHMyWGFt?=
 =?utf-8?B?QklRMnBkRmNJOWk4VzQ4ZExDbXlqWmdUd1FXazdYbkdCN1hUMEtCR3VLUGov?=
 =?utf-8?B?ZUFYdWZWRUpGanVWcVd0UGczTVNxai9wcWtxM3lENTBmNEFSZWlqeUtmaWha?=
 =?utf-8?B?UHJ0Rk1iSnhDWUZBdlRLbS9LNmZ3OUZHdWZHZEliYVhnQXZxOUROb1BxOWd1?=
 =?utf-8?B?UC9WTjUzbDd0cll1VU8wci9rL0VIRlFWTi9lT1ladDJqeDNJR0RBdlB2SkVO?=
 =?utf-8?B?Vm1wcHNITDRWSW40UnBQbU9zcHJSczJVNE9TL244YVFlVE90d2pGVExIc3NI?=
 =?utf-8?B?TUZLWnhuaWJpS09WWTI0WTVoVmFvbFdGWm0wb1pTaTNhUEh6L3FUYzhLRnlP?=
 =?utf-8?B?UisvL0JaU3BnajVaOVlnSFBtRXkvbFRqdEpVTFZOVjlJN2lGQlB4Q2JZMWJO?=
 =?utf-8?B?ZGxldUxkc3RsaGRNRk9uTnV1YXdOQTdFZ2V1cWJLalRkY1BDUytVNTFUSzZv?=
 =?utf-8?B?dlRnbnRlQ08vYXVtcnVMYkNNQTNBeXVBYTBlaXJpNFlnNDJ6Z0RoTXl4WXFp?=
 =?utf-8?B?OXhma0RPcmdWQzZ5c1BydzlNVHNMemFCaWFxM0craENVUHBJR3dCbUJSSHZD?=
 =?utf-8?B?Njh5YTVUNGZJOTFBblMxR2p1WDVpVk5IMUFHL1Fmbmx6dGNrazl3cGRWNW9x?=
 =?utf-8?B?Y3YralQ3YTJnMHhpSFlkdlgxd0lEMjViUk9oM3BRTGZFQitvOUxUQVYrNVh5?=
 =?utf-8?B?d1BIYXBneExad0ZpVEVTM3VxWC8wcEpaTzlWUXYzbkE4VC9CUU02NCtoajhz?=
 =?utf-8?B?T1J4UExaZ2RmZXAyTkVvR2t3b05kZzBINWgwZGgyRkxIQlRWYXdHRVdzSzIy?=
 =?utf-8?B?WlNVRGw0Nm5DbVhSd0F5eWxXN1g0TXN2VlZUU3JOTzRESndheE9CZjhVQnFO?=
 =?utf-8?B?WHF0UmtNdHV4OWVlSHljanZHd05nNE11WHhiL2hseVlqdEFVUUxPdUhkY2Vv?=
 =?utf-8?B?eFU5SjhUZElXYys1K0pTTWkvZ1Btc2VRbm9ER3pHL3Ezc0NjRE5WTXI5L3h5?=
 =?utf-8?B?N1FVbHV4cTFyTVhEQlcwVW4zREp1Z3U0MnJ5Mi92bmZxUU84TmJHNG1FNjNH?=
 =?utf-8?B?WUtUR3ZsNzNQQWZIUXpNWTdnbXYvRVZOUStYdnBUREJzMEU0MDg1SXdqYzVB?=
 =?utf-8?B?UWcrMm43Y3Yrd0FLS2p3SkFLc29nREp0VEd5WHNnWU5OQVBQYzAzRkp2RWoz?=
 =?utf-8?B?ZHovbTNSdkp0akVBbGpvcHQ2T0s0Wk1kNVEwZUFPcVhOdU80NzFWdXlmbFVw?=
 =?utf-8?B?bEI4ZDc4d2FMMnpGWWtKeVFQZU1qYTF2eTEyekVPczZUZElhTWR3OFNaVkZR?=
 =?utf-8?B?aCtQUTBwQ3lEVmJiQ05GWjQ2dHVMK3VBeWEvaGR3emN0cUlmTllZc09iV01P?=
 =?utf-8?B?TGR2QjRPTHh0Y2xQUSs3VGVqY0xNSkdsMU9ZTUVISnM0TGJCM1hTb0t5T0xS?=
 =?utf-8?B?emQ4NlBrUndTWENFNHc3dG1URHpvRmFDS1UyU0oyZjFydzhyTk5PK2c4VW4v?=
 =?utf-8?B?RmdockVkMnF2eWt0Z3BzTExmR0tXUUFhRWVpVTZzckZsMUVpRWFOdUNkWmRr?=
 =?utf-8?B?TDZIallIMHRScGVnb1RpMHVNbkwzbU0xbGZ4ZVlsUWh5WTQzL2NFM0xCY0tR?=
 =?utf-8?B?cmp5Rkxhb3RMR2VOTDRKTEo0azlrN3ZBdENLM0hxVlhMbTNEaUF0SXZ3NnJI?=
 =?utf-8?B?bkV3ZHBnUjVHdlBQcElVM3BiZHBndWQyZUs3c1ByeDM2aUYwR0M3TGxzZm93?=
 =?utf-8?B?cW5OWGVuUVpqMGxDcFlZRDd2WXBua3VpYnluajFMYXA4SHdqOEVZT1czeGFu?=
 =?utf-8?B?TFBBY1p0bXRFSVpkVVpodkY2T3Z6alBUelRzdnlXVmpCOUVxa1RURlkwUDl2?=
 =?utf-8?B?ZEJFUDRmSHF1Z2l5YlVsbkdGK2RpZC9aZkhqVmNXVjlKTTd4MWgwKzFJakQv?=
 =?utf-8?B?SzhtQ01sWEF0Y3Q4QVZFbkJuZE5veStmbUh5emJnZ2tOeEwwVFpXeFFiN0xE?=
 =?utf-8?Q?cuZDHVGjrgsqTt2Pp+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d894e6e-1083-479d-7ac5-08de5ee6a588
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 03:29:44.6860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T/ZWK39tMFyNgVsHrVKW+99hNkpL8DVf4ftUwVR5dEaOn8K5Ecxtdgfik4qzm7oj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5971
X-Stat-Signature: 94bifrtmsku7guit6y3wjdzf3zpxzptg
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 045A040007
X-HE-Tag: 1769657388-550498
X-HE-Meta: U2FsdGVkX1+kcx1GJQZhtf5MyV+9Hhi7tdBFXMj3OIwQWNtiAdalEGQhyLIHQOe83X7qQfOuDt9neE1IL2dWb3g7Ab7XlAgQoCDg3+UF4ehvJmMWdOxGDKGJOnc7KGVdUcK6Z9EdshDSW1WLHTbqyo6RrtQ+WGzccIpamV7Wou4Z+DZjRo4auD9lKHsVSuu8TKeUcq5k6/kxlDt85zvvSkXN2oP1NEHwdm57bS3Hg3ovdSb9BvSvQzHxhrxBuX+SfvDGv+MFwZ42uV88a2u80J/scF95CwvQnrbn8xtEZ0HZ6DizfLHRbCHiaZUFKfDtSkvMNZnTX4Vou3i5TdTUhKsiZgmcMZW62CYZ0ptxsNo3ooxi/S/VLu9A1rNm+PE2la3XPnLlHKYS+FrsrsUVJAn8OivsL3kAEJoWbJ3VYSXcNHu9kvL9WvNGzA2PE0H+p/CYxsuD2QpEPQbZhV7/1Znc48KuSYIvaJmisN83I1RnaY2I17WRChSmmt+dSJzgk15vZDHTKdhhVdJNZ2JBovhqhOiKEv3pqiwvugUIGmqXj55CDBNjxMvA5DLVcsbrW7VxPV2TqXZDUnsPnrk4Q+e4vZsroV6KhFAmszFfAXb/uM5FLr+DyE/Rj28BIZAIhog8RF/M8qnGmL/3IrQsIQDskYTFYkkKrMOckVS9f22UfTp1g9a0ck0Wfw2/LBnhCL7rtwYv8pBRU+/cuUsTSZEco1L1cHlvf88uZqZg6TKbDYRpC3z0uHv62PONrOi0ekSNIzYo4m8xev45mi5ctY/PnYrhuOvwoUoPS/qg3VdamHZT7WfWtdR9GYtuBg3MGSD4v3GCTNeWYdc9zO1WRrqdJxHeMHisqV0jGbVU44anclkHJzm6C4DzBkx/Oy+1i5cbZ8dUZIdxpLcI67z3glJujmTrDnnVWTmODzLS+JtLG7dvkYiET84kf+zNkzRD0mkp/A3Thvc19Bl30CB
 r8BOdtmw
 eEyRo0SQscVBVZ185gvCTio+LNIKgq70eeRfVqHCQ14a+vXMAf5TQQz1CEY2unm+bLCOHu9WzDUr4drkbMqR0uVeeF+F16MTAtaMl8b0q1JEamauUVe581uAjhnm1Zn2/eteiTOtnE3SyAFRyC3nkQdWfXDyrgIXnyAEWELL6iTjBjmiUE/Y4GCG5jbOIqfihHUEMF2xH4a7gAX7mv6SK0ZYGbIh3alMIXLXJklWj7XzP6WUII3nOlmzS7HYO05nL/G9961S9LtKRRnwbcm1D0wevy53tl76IBAhrTEC+8d4W+4OPL3n6Kn7XVFFxMGokOOPWXSdOWT0lPsBbyAHQrCTgDnQ67Oe6xivgCKSrIh4idfUcz3yfw5eXVP5+h0p8Ky9qpGUi3byF3BiCEBgEmZQT+Cf3S8bGE158oAg43FTnryndSZH43tbEdGBysPoPAtmzuBs2qih3MG6IY8anxzeoaE4JtylAZGmJLMn5EG8Xtbk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28 Jan 2026, at 22:23, Muchun Song wrote:

>> On Jan 29, 2026, at 11:10, Zi Yan <ziy@nvidia.com> wrote:
>>
>> On 28 Jan 2026, at 22:00, Muchun Song wrote:
>>
>>>> On Jan 28, 2026, at 21:54, Kiryl Shutsemau <kas@kernel.org> wrote:
>>>>
>>>> If page->compound_info encodes a mask, it is expected that vmemmap to be
>>>> naturally aligned to the maximum folio size.
>>>>
>>>> Trigger a BUG() for CONFIG_DEBUG_VM=y or WARN() otherwise.
>>>>
>>>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
>>>> Acked-by: Zi Yan <ziy@nvidia.com>
>>>> ---
>>>> mm/sparse.c | 13 +++++++++++++
>>>> 1 file changed, 13 insertions(+)
>>>>
>>>> diff --git a/mm/sparse.c b/mm/sparse.c
>>>> index b5b2b6f7041b..9c0f4015778c 100644
>>>> --- a/mm/sparse.c
>>>> +++ b/mm/sparse.c
>>>> @@ -600,6 +600,19 @@ void __init sparse_init(void)
>>>> BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
>>>> memblocks_present();
>>>>
>>>> +  if (compound_info_has_mask()) {
>>>> +  	unsigned long alignment;
>>>> +  	bool aligned;
>>>> +
>>>> +  	alignment = MAX_FOLIO_NR_PAGES * sizeof(struct page);
>>>> +  	aligned = IS_ALIGNED((unsigned long) pfn_to_page(0), alignment);
>>>> +
>>>> +  	if (IS_ENABLED(CONFIG_DEBUG_VM))
>>>> +  		BUG_ON(!aligned);
>>>> +  	else
>>>> +  		WARN_ON(!aligned);
>>>
>>> Since you’ve fixed all the problematic architectures, I don’t believe
>>> we’ll ever hit the WARN or BUG here anymore.
>>>
>>> I think we can now simplify the code further and just use VM_BUG_ON:
>>> if any architecture changes in the future, the misalignment will be
>>> caught during testing, so we won’t need to worry about it at run-time.
>>>
>>
>> VM_WARN_ON should be sufficient, since bots should report warnings
>> from any patch/change.
>
> I’m not sure a WARN will get developers’ attention, since the message
> is unlikely to have any visible consequences and only fires on
> allocations with a special order.

If a developer misses the WARN and the patch gets into linux-mm or linux-next,
kernel test robot runs selftests on the kernel and reports any warnings
to the mailing list. Do we have any related test in selftests/mm? That should
help us catch anything if a developer does not catch it.

Best Regards,
Yan, Zi

