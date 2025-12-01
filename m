Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC7EED116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 17:58:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 142926B00AF; Mon,  1 Dec 2025 12:58:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F2D46B00B2; Mon,  1 Dec 2025 12:58:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED5956B00B3; Mon,  1 Dec 2025 12:58:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D99C86B00AF
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:58:14 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5455E14036A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:58:11 +0000 (UTC)
X-FDA: 84171661182.17.25C4DA4
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010033.outbound.protection.outlook.com [52.101.201.33])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5A3F880004
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:58:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=h2hayRok;
	spf=pass (imf02.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.201.33 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764611888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gseNGNsYHVSQP7H4moREkGesTRcS8WuJBc/9J31wVw4=;
	b=TG9zinlsPXjFdqcoltdmrGKkN7P9Ba2mM/v5G3nIFBcjXm+zLelo4m/RjDFEWzKdU5f+XM
	QOsi4Cgb3CamvVMDhOksky0YSvRLM9BwdZOwbDYlvgMNjFG8mOHHGwii0i6MlF9OnalhnY
	0qiMN9RGQl8Rw1/WuGq52aMwa4lrgic=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=h2hayRok;
	spf=pass (imf02.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.201.33 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764611888; a=rsa-sha256;
	cv=pass;
	b=MlcHicf3CIKfAfbg99yQWKSgSpwP8gCcwLNikpwQ06ZZFyzCQHFldAMqxvJwaHT8Kl54zc
	3TpB+oX84YmMVXu3i8o9aEevCL+q0hruauFt9Xa1Qp9loRPkrNVhbM1Z5rf88I0PwV2MDU
	YSaxtwO9gLHK07+ZQGRgI1Yf3SoOooE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rqBy/bb4IH2Cm+zTggE8FE4mRgZ0QI/9fBYsWqcKZeUJZrNBictVpnM1QZXyWiqfRLf1YdQX1dt3Vh3iMWd8ZFKiBKBnNjjlxp6yQZSoN7G1F1PMazt0pdiYUd3yq6QwHeRo1gjCFMg3bc+APg3slK2/vYJDB+XumOwMkB+ldj9WbQ0ly3J4eSoULqDB0wALl5q9NUQK/XJGTvchQd/ELWxWuTx7Ql1opsl0yq9iRE0XUG4yMhTjnfnP+fSZRibfRGPSO1EGQ40/o0vNXS2rjAEuqItn8cXaxpS+MVwF+MGcu5sHWplDXzsdA+jv/Hx6KzholhFMvt9ABtdTmdBJgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gseNGNsYHVSQP7H4moREkGesTRcS8WuJBc/9J31wVw4=;
 b=qaDiTrpEuh7zLypVzATtleiIQ1JgfbC1roUS6O8jVtI7hrh8mDKC29j3S8l3GgGBMuL5AlV5mQFmNKCjaYe4Y3125fosmdJSnIT9W2C0ad4kSFmmOpCCNQ/BGDSUr0zNdgrXLM2nye+UcWl2pkyxtX7I6KpVk9W1NPgPA4XSN56eUx5cU9W2svCHBQSDLyF11kZ9Oh76CPmOf5lJgmXbKDmgMuitKMktbKZ430yYK4nqmYUM46nwr+lZ6uSmWgeGq7sbAJ2ed74S4AaO+ZUz1LuuVmVjSi5GgvNAaJWHID5ySbBUGI90zQXYOp5cArc+eJ17kEksxqsi1t4pLIS1Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gseNGNsYHVSQP7H4moREkGesTRcS8WuJBc/9J31wVw4=;
 b=h2hayRokMWWNpD0h9ORouDyg44AiiSeUGZvWwtK6NDKMnCGUTbWbGRmCCzoONkCJVesi3jn1kinlBe9STW7mZFu2mF0lTLInq2Ut4Lq4PDyElPsC0E9c4bG+VJOFptcFJZ4rrhPBcD9u90PbVDXu730JoMmvcdgmaAUh2kdaqho=
Received: from CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5)
 by MW5PR12MB5624.namprd12.prod.outlook.com (2603:10b6:303:19d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 17:58:04 +0000
Received: from CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::222c:662:e585:3404]) by CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::222c:662:e585:3404%4]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 17:58:04 +0000
Message-ID: <ac627386-eeb5-46d4-9d4b-dfb902280370@amd.com>
Date: Mon, 1 Dec 2025 11:58:02 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/4] mm: Add support for unaccepted memory hotplug
To: Kiryl Shutsemau <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev,
 linux-efi@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, ardb@kernel.org, akpm@linux-foundation.org,
 david@redhat.com, osalvador@suse.de, thomas.lendacky@amd.com,
 michael.roth@amd.com
References: <20251125175753.1428857-1-prsampat@amd.com>
 <20251125175753.1428857-3-prsampat@amd.com>
 <66ylzwknm4ftd6utn3nqr63jmhl2ccvcdvyi5fechfnvmfxivu@37pckhjixayh>
 <14df1d99-7df0-4982-8029-e66dfb140399@amd.com>
 <dy65eupwalp5wsljetlto27l6tjjvoygeotjd3n7mk7zjc4dma@jf4hzsy6rtcd>
 <f60d968e-6be3-4bad-8bf4-8500ad039817@amd.com>
 <maleev6ofzlnhi3rmqjawlllxkda4mrgwmb6msz5gz77klfrxl@adpqtakqrxrj>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <maleev6ofzlnhi3rmqjawlllxkda4mrgwmb6msz5gz77klfrxl@adpqtakqrxrj>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0155.namprd13.prod.outlook.com
 (2603:10b6:806:28::10) To CH3PR12MB8660.namprd12.prod.outlook.com
 (2603:10b6:610:177::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8660:EE_|MW5PR12MB5624:EE_
X-MS-Office365-Filtering-Correlation-Id: 98cb7e27-3fd1-4cf0-561e-08de31032d1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dWtZclBiWG84ajBPckpKR0pSNkFaUXdqMTB5ZEJuTEFMYi9SKzVibncrNU93?=
 =?utf-8?B?amlDSXlza1JOSkxBR2srck9LR3RKSU5lN0RRcVpmeVdjaHRsdWorOWY5NWlj?=
 =?utf-8?B?cWZ5NkxXUzFpdW1JZ2dDWmR4Vit0ZkZTVHc1L3VReVhJUGNFOE1EdTE2RGdq?=
 =?utf-8?B?akRLZ0M2YU5ZNjltcDArYzFFTDhkbkx5bU9HWElxeGRZNkJVK21RRk1QQ052?=
 =?utf-8?B?QjZPdUxRbGdVYVpRTjVaMGxvNFlDbk1VUXNRcEYyb3QvNDhmcTFsNXBjSkEr?=
 =?utf-8?B?eks1ZTZwOEdtaVFRbmFEa25RUTNidCtVbDFieDhSdU5CeWk0L1gyYy83ZXNG?=
 =?utf-8?B?YWpqZ2pnMHkyZy9qV2xNTFBZaEdMN2NYa01BVncxVDh3eCt6YU8rMmg3N3FO?=
 =?utf-8?B?R1cyUWc2VVQ5Nmhaak9CelJoZ0tGaVNNclVnNTdJay9YRU5aSGcvamVLVGhw?=
 =?utf-8?B?M3lZU2w4ajhCZTR4SzZSVGVkYUpJZEJGZ20vd3hGSWFYWkVYK0xBNW9hdDRK?=
 =?utf-8?B?cSt1Nm0xalpLU3JNRlBRcXhCcktyM2lTVDRHTTc1bTNiSDY4Rm9aaW5oVjFW?=
 =?utf-8?B?bk5nMFloWHc1eFluZkRzV253VlE4VGJmSHdTVnJpWDB0ZjZnN2lvaXpFSXky?=
 =?utf-8?B?WTJvcXBoK0lhUmZQMHlZam0vRXNMenNDbFdxSFVYell5cWdmdysvdVNJVVBS?=
 =?utf-8?B?UUtQS2hzZjE1d1BCWTdaWWtGeDc3YWcybE5VUGZ5dDZQWUhPS1RKMFpncVY3?=
 =?utf-8?B?dndZQ0JnU3dmWC9WRWRQOUJYRE55TEorS1ZHTisxSnVpRlF5dStibFpXOWZ1?=
 =?utf-8?B?SnM0VFJabHAyTDcyWDVINytoTW9sNXZxV1VFTTJNemthQzYrUE9GRWNoN3BI?=
 =?utf-8?B?Z1ZNS25pcnp3N2swMm0zdHRPVE5hSHZCWTNrTEJvU3VWaXpLRjgwUUN5NGcv?=
 =?utf-8?B?UmczdnhvejJpS2tnQWJscEZYYUdIL3pldWEyTWQya2lXangySlBKVEJHY1J3?=
 =?utf-8?B?cGpyTDlCSnd3SkRvZDFaMUZUZGpSY1dZbFVEenJyQ3BNbmpEUDh1ZytFaC82?=
 =?utf-8?B?Z1MvZm4vZUJwSE9BQzBYbDVtb2VqRjZZRDFSbm1LdWNSNlZQd0VCU3dsK3hN?=
 =?utf-8?B?WFFwa0c4bTNhaklZTTJPZXluazloSnRTWUF4djl4ekc1c1FLdDRlSVJUYnBP?=
 =?utf-8?B?dVlaU1lvRHFqOGVFdVhxR2x1RFNRSmFpdkcvRzd5emhIeVZrcGxDN0o5RW94?=
 =?utf-8?B?RWJVSnFBSm5PamRZT3o1dXNabDdZZEdaTTFDMDJZd2ZyNGVnaDhmRUxZMmJa?=
 =?utf-8?B?WVRkdUw5V0lobVlTNTIvdGhOQUJ0OEMvVkFYaFRQWlpSelo3MndIRUFzL0Zr?=
 =?utf-8?B?cU5JdzZoMXhnWU5EWTExb0Q5WEZLYjA3ZUJON1JSOUFqWndiUnB2MmQ1STdr?=
 =?utf-8?B?THVuU0l0dmJLZHlPMTVCWUNsMWd2aVpBVm5icHErNzVNTWRoMTd1TE0xb2pE?=
 =?utf-8?B?TjRrZlVvTVBxYUMrTG0zZWhhbTE1Q3JobTd1eHJJZkZqRmJWWUVLZHYwam95?=
 =?utf-8?B?WVZJb0hsRC9NUjNJdWZpdU1oQ2h1aGNBZ3NlMDhuRmhaa0xLN1dsS1pRSnRW?=
 =?utf-8?B?WWxQaXVoOTdGZEJXWmZweEgzRGVvWmw1cG1IM1NUMDFpYVRnUnJqblIzNTRJ?=
 =?utf-8?B?M1JtT1ByVWVUZmdtblB6MUJ6TzIyczF1aG1rOFhxTVIrVEdaK2FTRCtNcUlU?=
 =?utf-8?B?VmlNelBTSzlFaEszaGtaVit5ZkNLOVUyRkJ5VlNPdGxoYlBxdlRXUW9pMEps?=
 =?utf-8?B?L1cwdXZtOWhCK3hDQTdVeTRnQm1DK0hYZGUwaSt2WGg5eG9WZi9ZYUJabnpm?=
 =?utf-8?B?SjhqRGdFSnUwNFpjTXNoaHhzWXpmekh6dTJ3Vzg0SG11ZUNZSG9LMldlOWFl?=
 =?utf-8?Q?Q7co5purLAK34MaTp24xRcKVWcN8wldy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8660.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cHVJL2xiQXZzcEFqSUhkOXU1dFVRWldVeXFLUmROUHFzd2tKMFBOM01GZWU4?=
 =?utf-8?B?azVQWGUvL3pHOUFURW9UWjAvcEtTQmdTMnFhOXAwMmpGZldwUE1PdG1DWmpP?=
 =?utf-8?B?QmhOQkdJZGwyZnc5NU1JSFkwTUxib01kL3k0TkhYckxkV1NibmtYSy9GdXdV?=
 =?utf-8?B?cnBQNXVpdGVHSE1DMXROY3dlREh6NGdiT3liNllSUXBJZ3piK1d1RHJqRjVM?=
 =?utf-8?B?STlDMmJ4VkpzVjdCOHJqRkNjckNlSndCd2M4TTNlcXVUUVRCenpucER2Mklq?=
 =?utf-8?B?NFpzY3VzZDU2YWkxUDQ1Z3hpc0kvVFdZTmtRVVJZRC9GdnVVM05tM0hOKzMy?=
 =?utf-8?B?c1FkZUd3RGRTQ0x4YVhrekxmalIwa3NGQTRwUDRzclFGdHZobHB0VW1LOVB2?=
 =?utf-8?B?RW1nZWNQYWpOZmVBKzRFOTM1b2k0MG5rV1VYYVZDV1FrQ1l5dUdjY1JkVUVS?=
 =?utf-8?B?bU96N1ZHTFhKTDVlZThncWsrcHFCT2UyTWsxQ2ZXNyt3dEJ5M204cDh0dk01?=
 =?utf-8?B?V29DTlNxT2dYWkhIUnIrQTNETWtnRVl3Wjlya040aUUyUkdqYnVWYnpZRDFi?=
 =?utf-8?B?ZE53MTY3NVBCcVA1TjJwekZlRy85VHNqQlk5ZU5qbjhLTWxHdFV5NVRKV0Zu?=
 =?utf-8?B?RFlwSUpoZFUxdmxXWnRNbnJOSGpaTkZBcUgxWExMVEh0Q0gybzc1RGlTZVQr?=
 =?utf-8?B?cHk4Sy84WHdWcVNaM2lzSkVPRElUMDRSclEvOGZZQzhMYlNhdTg5bHF5ZFVv?=
 =?utf-8?B?OGd1QUZGdVo3RFZ3VHF5OXNlLzlhcjlVTndiRndJb3RWSDJ1Tkt5VXBRRURJ?=
 =?utf-8?B?ODArVng4UDgyVXNoeGlNY1JHQVIyQ1JoMGRyTmdUSGs0dUw2UnF6eXpnZ0x2?=
 =?utf-8?B?WnVaUll4SitDUWxNZjdQT2V5Vk4rVTV6WTZmei9FcW1KdEoyWEpXZkc1b3Vk?=
 =?utf-8?B?Y29DVEtyR3dmV0lJdU5ERTFuc2JMR1M2b1NsZFhhZWNKNUdmQWhuYUhPaE1I?=
 =?utf-8?B?bGUxN3B3MGZkTUluSHB6d0tieDBUV3VXL0IzUWNSVGxtWkg2Q25uYWNFdk8y?=
 =?utf-8?B?dmVrNW5ab1doUkgyZWhvMzhWaEZaQmNMRDdOSS9PUUtZVEpaTmhOdml4NEx1?=
 =?utf-8?B?WHB6c3BtSE56cGdUZTYxRysxTk9BL3haSnBGTC9NSHFlemM0bnBYWmxtZEU2?=
 =?utf-8?B?S0FOQzg0cnZXMU5sRkFMaU91Z2RpVlNhNjI1MmFYaG5CTitMMzQxS1pxbTlB?=
 =?utf-8?B?emhqMitrRWoveXZUYzBtVDM2b3lXL200SzRhWnZMcTFMVGw4dklBakFsNG5v?=
 =?utf-8?B?bWZvbTJxQzh1ZEgxay94K0lLYjkxMVFSRldIUkc1TGx2Q2xUcGVzU3FySldr?=
 =?utf-8?B?TjVUR0lZVStLd0d6a2dSbWExbFByTVZCUDdnWUE0VUl1WkdnK2NnUUtBcWEx?=
 =?utf-8?B?M0M2VlNqQWREWXd4UjNTUVAwY29uWGFiTW9VeXFLejFIUnhnbzRLWDN1Y29D?=
 =?utf-8?B?QWpXc1hxYVEyV3gxZG5IZFdOdU54a1VsYThQRVROaGd2Y0svQ0NXTkw2dEU4?=
 =?utf-8?B?dTJUMjZhUlJGV1Nnbk82MURIWkpWZG9jRGlKcklGR3dtTlRRUHZ5WllMOW4x?=
 =?utf-8?B?b3RDSkdPS2REMkFGSlVxb29GQVg0Tno3anphbzdxblZqMEZjam93N3BJY1pG?=
 =?utf-8?B?cE8zSkdET3llZFl0SWNHeW83Qi81Qmd2RXlEOENPNmJ2bHhScmxZWXBmd0Fy?=
 =?utf-8?B?RTc0NE41a2xvc2I3NENRWXpPREpqcWU4NVFkWDh2Q1FCSmxYaitvVXQ5eVFx?=
 =?utf-8?B?UkVacFEzaE0weWVJdHYydThXZ3d6T29mejFFU0FKQzRNeEVOMGVrbkMreHRq?=
 =?utf-8?B?R3NjcVhKNFNQWk55YnlQSjZGL01iYkVVR243N1NmYXYweUh0cThKdWhsTE1p?=
 =?utf-8?B?bzBqTWY4N2QyU2txZXgvUmlNbER0cmVnbkZCRDB3emlyWWk4VjVXdkJEQlJ1?=
 =?utf-8?B?RldrR0d6RlcwUTREc0ZqNnlYK00wL1dHUXdOaFpvbWpRWG1pTE15WFZpUDBD?=
 =?utf-8?B?UHVtVWdCNkREeEI4RjFVdHNEQnJ1V0ZaZEl4cDdXRVMwRFhYY0ltVVluMUlZ?=
 =?utf-8?Q?81pOKnCnCwLfClUzyMK+XfZCy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98cb7e27-3fd1-4cf0-561e-08de31032d1c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8660.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 17:58:04.7384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JLvJS5xePdFlyJLzfQ+Y7qoqmUpRu4m12yHSoWEuzlSArV0Kf4GYN1UX7u7SxntzRNMLIY5JUvt9Tn/yXm5L9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5624
X-Rspamd-Queue-Id: 5A3F880004
X-Rspamd-Server: rspam02
X-Stat-Signature: 5k8gjse56cuwabjiasirfkxgnn1myoxz
X-Rspam-User: 
X-HE-Tag: 1764611888-739353
X-HE-Meta: U2FsdGVkX18saEX/z0fUQgwPe4LoJ7QQu/HDbGqKhAlNGvfmNYwrLjhDIcEpkYa2F301aBs2IWPQ9VpD1Y7w35PlJ8IkfOWt1z0Um3hRqioOz+5Y59KsK2Jka0nPwC5m76UGjpf4Njt3njSfdoYmP3wTXs0H1U4CMWKDLOe3cff7y55SGcog9jZdl6yPgwIkPTpUWjHcyOisrd8s+lLvCW0+DUUBGffZz5Ej+PwUxlExsuDgBdHs03nAxZTkN6NERCEbgQEHDHdmxp9Y5qeAInu1iBKcwSefl+srTXGL+5afM8TI1PzBjqRREAYrK1UyoQQAvgxJkXa2+t0AWQwBtdHAU8ChOXmEpLbHrEAZk1Y4vENjvpgF871kRIOKtLbMOREKhTmFMo2nIChHcsmQK2f3nl0VH799wBtB4mUn/RanUMPV9tS6uMkm8dYJoKkMP7EuLoxosBTe2/5G6hJnIvzZuMX/wekeObtX9E+qMCMxOEINGJR1uVKqhIhco4KlFqKmH6rLjbMIyQaxbq6ii+vlxColp8qJP9HcHqGLNVJpsNZIwl7qUDwG/H/9lCY9LrWduciGsovcWpjV6Qr18j3Zm2iUEmqfOBE7vMr6ac54qshd313IqMseufpVBfx82mGKeZb/NK0/w9Qh8rQo12etJHYNykkJ2AWqIVBHq5Ip9/yPic0qg7KRzQEm/uOTreKYmCZNDjfmOLXpAFuTfe6DZtgEwIhlG8rz8nYPREkUbuYFeMlXaTdeBZ66P+9GD1eLPJsEEasijMnGDeBf7B7TEPRximAJIbArwM+FG6d4QY9qGATj0xXC+Hw98TzJewO9YmKI3WyZtu64Wz0ccyJDXN6s5MYFTFK/E3D+GqC9ADlmtX99meL8SBkx6iylFqvQTqf4qKrMV/aREIGdfh8n7S7udVkqRyp2A7g5mM01g2jebhdKdNocKzq46B+O8pSFBIv3Pxz8FjCmu14
 aRto/Pgo
 uhy4AEvhI8I/TpcvuFe+IrtjaNsxenOfOm5sgqZArnPP9M7bdEzd83B/Dx/Th81FJf22XB+tN8IavG8EI+GmGkyTF9H/1OROTnEtPQkCt5ELm4oMS4j9Vx/1zlQOcwbsVSSe5XyuSvY6fyz0O5LDIzavRlHygQPuTAIueyyHBp/BPjOtqbWhEkzByCkTBxI2N5NeSACOt0yxqV6EuMKhk9JeVO7v+IPR31RmOYIE/V0W1yV2QzbsdG98jwKcOA5woGsKFpv30fOT6tRWPSv1Wm9EDvaPODEM7P8Yh1XUjp2j0aIAoUAYOo0aTdE5TlcvnUpCEK6odGcXKlZfgyryxYp1mJ0aWMH4v5OJYHz3LUDNnsU+qrMt1al3gGailDEhqNNe3QMLWViPJdYwMNBqVgIuh/eB0/a+sa0cPq2qK/BCd9oAYfxat4FHuCuLbHhCpu9nKnWgkXJOAH9GTirRF/qyQXPiGx6TqiBa0y7Eoybgl5F5N9+HXQIoCefKzo/96LxKep/+mKKFmTpxWSvfLJVstmGKeyQbgAbNk2eNPgtRXGY1WLKPrD23KmA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/1/25 11:48 AM, Kiryl Shutsemau wrote:
> On Mon, Dec 01, 2025 at 11:15:13AM -0600, Pratik R. Sampat wrote:
>>
>>
>> On 11/27/25 11:40 AM, Kiryl Shutsemau wrote:
>>> On Wed, Nov 26, 2025 at 04:27:29PM -0600, Pratik R. Sampat wrote:
>>>>
>>>>
>>>> On 11/26/25 5:12 AM, Kiryl Shutsemau wrote:
>>>>> On Tue, Nov 25, 2025 at 11:57:51AM -0600, Pratik R. Sampat wrote:
>>>>>> The unaccepted memory structure currently only supports accepting memory
>>>>>> present at boot time. The unaccepted table uses a fixed-size bitmap
>>>>>> reserved in memblock based on the initial memory layout, preventing
>>>>>> dynamic addition of memory ranges after boot. This causes guest
>>>>>> termination when memory is hot-added in a secure virtual machine due to
>>>>>> accessing pages that have not transitioned to private before use.
>>>>>
>>>>> How does the hot-pluggable memory look in EFI memory map? I thought
>>>>> hot-pluggable ranges suppose to be declared thare. The cleanest solution
>>>>> would be to have hot-pluggable and unaccepted indicated in EFI memory,
>>>>> so we can size bitmap accordingly upfront.
>>>>>
>>>>
>>>> I'm not quite sure if I fully understand. Do you mean to refer to the
>>>> EFI_MEMORY_HOT_PLUGGABLE attribute that is used for cold plugged boot
>>>> memory? If so, wouldn't it still be desirable to increase the size of
>>>> the bitmap to what was marked as hotpluggable initially?
>>>
>>> I just don't understand how hotpluggable memory presented in EFI memory
>>> map in presence of unaccepted memory. If not-yet-plugged memory marked
>>> as unaccepted we can preallocate bitmap upfront and make unaccepted
>>> memory transparent wrt hotplug.
>>
>> If memory that hasn't been plugged yet never gets plugged in or is only
>> partially plugged in, wouldn't we be wasting space by preallocating
>> the bitmap upfront? Or would that not be a concern in favor of
>> transparency?
> 
> 4k per 64GiB of physical address space should be low enough to ignore, no?
> 
> We can look into optimizing it out when it is an actual, not imaginary
> problem.
> 

Sure, that's fair!

--Pratik


