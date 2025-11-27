Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 079BFCFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 11:50:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 514F46B0012; Thu, 27 Nov 2025 06:50:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EC886B0027; Thu, 27 Nov 2025 06:50:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DC676B0028; Thu, 27 Nov 2025 06:50:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2D2066B0012
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:50:18 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F07A88A8EF
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:50:17 +0000 (UTC)
X-FDA: 84156218874.03.D53A81B
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012020.outbound.protection.outlook.com [40.93.195.20])
	by imf06.hostedemail.com (Postfix) with ESMTP id F3E1C180004
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:50:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="P/ezKcM5";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of jonathanh@nvidia.com designates 40.93.195.20 as permitted sender) smtp.mailfrom=jonathanh@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764244215; a=rsa-sha256;
	cv=pass;
	b=cWwil/iYcYy1PZtrNBWqKPkxiptN9VQ/OGLtIBy0feL+qc/hFZ/t7PkQs65HRo+QJM9D7Q
	wxfaI7kTzApT2OaMh66k2s1tKaX9whAKl5T2ik25F9aQFj+J0sLBfdyXgwDU3HngO0N7Xz
	EeennDamamTe3TKxGL5MwyDIpJ3wIZ0=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="P/ezKcM5";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of jonathanh@nvidia.com designates 40.93.195.20 as permitted sender) smtp.mailfrom=jonathanh@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764244215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MKI83XfO/VDNe11wEvxmX9othXZyiWfcITrtqvbfBpc=;
	b=F/+6fEXbkfFTvoJbbuJaoRhZBBiXX/BGyEkiOK8ymtnjRazuUrmiXV7f+rYPYpWMbubRDE
	hruvj6AOIHP/2G1iXcSpi3MyFkdDsp6SnKcXNCqqy8qt1bFATijD06dG4RXt1nQEsHPnNm
	iebOIOu9MDW9iP0hU10/Dyq08KVPX9A=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kPzpM/PxzMHZ3Mmpu/Fm9esyfXZ0fEwVrzD7QewyGz465ZQmrregKXrP6le59lsEpJblqj5erH5+5bBsawgPWZ+rBpqD7WtkShWTs7RhyOr/+mIOpaHwzPzxJEHsE7q7AA1oibDpTJ5aFUEXw5UfNl1QcgwYRAk3jvyC+3w5JxkA3YOpCJAtTd8hhvAu3Wt+o9e2diVyWlY/EVPteqcLq5oaeskSiJHLbyas05Y7DVr11Vn+dKoKbMWBY1WxO8PQ6KdZUdDnEzeuX2huoEGavNXzQs1QMUp/9KzArn6YiMeg4b2/3PsEaAgn2ldygLcWaYhYx97RhTTiI6I6j4md2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MKI83XfO/VDNe11wEvxmX9othXZyiWfcITrtqvbfBpc=;
 b=oGqg2AXMWLHBe8QwWA2dP/8iY1ahi+a64/s7ocINYVT0Txm7jtMbliVFwyrqHs2hIrn1hO7YFiQgVhGEObAdDSFq30rUPbpoXscUDCcSIUWAa4uTqHaTTAHu6Ly5Z8ONEaGXX1vMuAfZAFw7sigBWeiddAxnClE/SMRomNTbg4zG8YxiokjyyGGRbcIHLJYijZEYu2v9oAynQce4XuWHXmnvH/ZGfY7Aak6zEuh/mFOiaUbe4SrT709YU8uUHInwZhCHN+ucVPCP68wwzKO/kpG+1POBqzwxNNPu9wxW6sq1yC7BAtrngK82MSmPqi02Si0f73GDT91JXpdWTIEcnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MKI83XfO/VDNe11wEvxmX9othXZyiWfcITrtqvbfBpc=;
 b=P/ezKcM5QppiI6mTzoPzpCceBuBUqLJk7iR2OoC5S6gJpL9qTGYQazp96IS9wpw6BkSkL0F6OoO07KGPKri9Z7ClhztxMo9dcGF/csi7/G7c6Mh25Z7N6kpSJvk9b83sJMYi8iAXDJ8Sl6w9Rs0YiXxNSN+MTDG0cVxp1vVp2wijdS2gJldI1ddEG2Mv1XQG8AsXHj9kyXVzx77Ut0Lymib6FCM4zqpEpzKN9veeknoRNQtXxz8YcueHpxJrloJSpDV0USpSsC6U9jkslh/0BS9iJTVPL8k5ngHltSQHW1ZAs0w5hI9sy2+UhoRUWmBe1IuNWn1OpCm04p29xfPlTA==
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by CH1PR12MB9623.namprd12.prod.outlook.com (2603:10b6:610:2b3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Thu, 27 Nov
 2025 11:50:10 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%7]) with mapi id 15.20.9343.016; Thu, 27 Nov 2025
 11:50:10 +0000
Message-ID: <21767827-9bc3-4d49-8987-6a4b7654e653@nvidia.com>
Date: Thu, 27 Nov 2025 11:50:03 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/23] slab: add sheaf support for batching kfree_rcu()
 operations
From: Jon Hunter <jonathanh@nvidia.com>
To: Daniel Gomez <da.gomez@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org, linux-modules@vger.kernel.org,
 Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
 Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>,
 Lucas De Marchi <lucas.demarchi@intel.com>,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz>
 <0406562e-2066-4cf8-9902-b2b0616dd742@kernel.org>
 <e988eff6-1287-425e-a06c-805af5bbf262@nvidia.com>
Content-Language: en-US
In-Reply-To: <e988eff6-1287-425e-a06c-805af5bbf262@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0236.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::32) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|CH1PR12MB9623:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e84e5c6-703c-4519-4867-08de2dab1e4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|10070799003|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QlIyZ0ZGaVVOWlM1UDQzc3U1QUp6M1ozOVpHMitMb1JYS1d0b0FIRTBUaTFB?=
 =?utf-8?B?S1V4VzAvMlZFZzNIVXVxVHc3SitETkt5RmhFdTVBNTN5SGZWYjBZdlpUYTZu?=
 =?utf-8?B?amhjY0xJaE9sY3B0ME95MmROdWNlR2ZqaGpoS0JiaGtISjRXL0FOaElIZmha?=
 =?utf-8?B?b3c4VHRKSUgxYmRhSHlTd2hoQk9RdDdEK2FlVzAwU1M0aDVpNEMxV1NJOG5t?=
 =?utf-8?B?Q2hxYkNLSFNqNjNEL21kcGd0STFvcDEwbXpsbjBENzk1aEpQK3RRcXc1aDVm?=
 =?utf-8?B?Y1E4am5IcjI4U2d4MDE3VnJKNkdGL28wbEJiTkFEaTNUbzA5WHZZSWNGdTJm?=
 =?utf-8?B?V09iM1VodjA5QnIyMEFBbWVJK0hraHVZakRpY1kxbk9Id3d0VzcyVWdLd0Nt?=
 =?utf-8?B?S0xzWk5JZE11VUxOQU5zeHdOa1N6djYxcFBUd21kbTZJeTVEbTRaaW80Zy9H?=
 =?utf-8?B?UXdmY3BpMDY0VDIwMG0vVHgyMmRwUXEvdTlnWURnRXIySVYyZFJ0aDhQVVZR?=
 =?utf-8?B?YWV0blN1YVovajFYUVRaQkxqejFuU0E2NUQ5aUJ2Mkk1NjMrQktBeGkvTzdX?=
 =?utf-8?B?S0xTdC9kT1d4SW9DRTViOEJhbURiNExLZTkxWXZhczBjS0NJSDlFMkIwYy9x?=
 =?utf-8?B?T3gzamVBYUhwemJnb1FZa0pzSlNLcmpBRzM2cW5DOVhwMDd3c05Rb3FMRS9Y?=
 =?utf-8?B?bEJjTldZZGRtZm1NRnpsSlVQT3pjdW5ZU01ZWmpzUldTMUpNcDZRUk14dkVM?=
 =?utf-8?B?TVl3cWJndTBiem9mM3pQVEFRbE1yOTJwNWRLYTk4S0EyTGVVN2lBbm5Sek5H?=
 =?utf-8?B?SytHU3RHR0FhZm9PZkcyVVlPVW1UM2cxYlhocGhWYm9NMjhuZ3pDMkVjUDJ3?=
 =?utf-8?B?aHNsaUhqTWpCOTR1Mk1FWi9nQUhPRkZoRzhPL2NQUDNPanBpbldVQkFrVGh4?=
 =?utf-8?B?M3ZXdXRpL21BVCtFNmc4TitnUjYxcS9ncm50KzhRR29NVmw3R1hlU3c5MFpW?=
 =?utf-8?B?bzBOeVpITHJ1cGNMS2dZVjArb3NGQmpkZ2kyd3FTRGVVTUJLOFY2QjUxSS9l?=
 =?utf-8?B?alhPUVRtU1RDeHpETGhySnlaMC9xdUpiNEtBbHcvYy9KUllVanMreCtFeUYy?=
 =?utf-8?B?S0lpTXd6UkJ3UUtZNU5POXN5eFg3ZW05dWx2UHJlSU5VN2tWN2hlV21XMldr?=
 =?utf-8?B?anZoNitZRUJueUpRcUFFTnpCcitWbjlYVU1pVXUzc3BSRVZ3c2RyRFE3RWY2?=
 =?utf-8?B?QmpmMVBnaEVNTTVaR0RJUjB5dFczQjE3WlB0bEV4blpFbFFRd1AwakRFd0Nr?=
 =?utf-8?B?RkxEYVJnbDBJWEJCQjFIUjZDU0pRRGtrSlYzTFBNaVNtTWpHT2RtUHN5M2hN?=
 =?utf-8?B?eHZka2x5SUEvbHFzcjF5MFErdlVTMTk2UW80ajNHK0FscDBaK0tMMHQwYTJi?=
 =?utf-8?B?Q2JhZ2FNS3lWRGRWazlOd0dUYVA2TDBHZjY2M2NuS1IwbGMvUk5PQTRFWjRz?=
 =?utf-8?B?VTZsYmxsa0JDQWtzekN1RGZmVGJPWklaTnNhZ29pY3lDZU5IMkg5TElZTmtx?=
 =?utf-8?B?UTYrc1d1R3VJOEs1YnlRclZaeVgwd3FiRk5GTm9pTFR5Z1lrNUVoUzVoRDYr?=
 =?utf-8?B?eTE1b2pobTZRVGJxcmxCNS9WZWJKQnE5bkR2U25yTURxakV0U3BXYlloZ3V0?=
 =?utf-8?B?ZFUyY3FSZi9qTG4wcEVpd1lDZlZoRjVLSGNjTjVBQjh0RFJOQXg3MzUyR2F6?=
 =?utf-8?B?dDZleWptc0c0NlNqaG1ab2FCSnBHdExxSFJ1anloK0FjMVIxUkdZY3FtQUZL?=
 =?utf-8?B?TUthNlkyRGlJZmszUEExanRIcnFoR3BCZFAvWEdwZTBjZ2tuK215L0pxcGFW?=
 =?utf-8?B?eW5oT1VUN1BPSFE0VFM2NVZRTi83TVpzaDMxQkx3R2t4MlVUVGw3b2hab3BW?=
 =?utf-8?Q?SmRZ3grjVcliRCz0oK5tcB7eKGX/dgVk?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?elRHTDNTMFRHS2pvRGt5UVNIMWUzc0pjUHlEMlo0aW1SbVV0QUJvdlAvVlJ6?=
 =?utf-8?B?eWNxZ2JPcmw4WlJBWllub1BQYlAycDVJY0tOT00vdFlOOWFiZlo0LzdXS29H?=
 =?utf-8?B?Q01qaW5NczBTeVRlNGlDdzBueUN0ajdxc2k0bzVqNmVVOEN2RjZGRUZrbThh?=
 =?utf-8?B?WmRQUjRiZUZEVm5uRFVaWFU2bkpvcEl5dTFqMnluQnQzaG8yQ2FpMVdaUXJN?=
 =?utf-8?B?QnJYN1p5WlBSMEtXblh1MElrUkRJR0l6R0FBY2VKR1JUQTFZUVBFeFRDUEs0?=
 =?utf-8?B?MGlKamtnNUZVSFRYMzVEb1lyVTczNjRoaTRoQ2kvMks2RThiS3FqZUpBUjRP?=
 =?utf-8?B?NDdadnAzMjRqWE9pZDZ5bWY3R1RocVdhRVY2RlFhbjk4ZXFiWEZRL1A4NjRR?=
 =?utf-8?B?VStVamNMZHIwYnUxSTNuRGhyaUFwV0Z4bWZCSzVxejBkcityaDlVdW1IZ01J?=
 =?utf-8?B?Wk9DcXRjcEpZWWkrY1hJbHRhZlBRSjlnY2NYcnV6ektRL3FwWGErdmNabVhw?=
 =?utf-8?B?UFcwbnBMeC9nWlgzWmVEZ0NCeFhteC9rbjhXQTNoMWdQUFNTUXVMSTdkNGVP?=
 =?utf-8?B?czVCdU1WSzVBb2tDZzFIR3FVb1NZOXpmc2lyZ1lreHhBS20zMVprdk5Tanc3?=
 =?utf-8?B?Y2w3RFROZ05sdG5uWVB6V2tMRTNQMFk3VzJJb3ZNamlZaklBNC82VU8wV2RH?=
 =?utf-8?B?ay8wRjZyc3Bwc25zODk4ckIwU0lTamhzZWdHQVJ2ejhQejcvSmNsb0Fna1pG?=
 =?utf-8?B?aEtDUWt4Q3dwSms2bzBEbVZiZTlabkVjenhXejR4WG9BMEthY1RtMjZuMDJT?=
 =?utf-8?B?MWIzWU1kZEVHNGNRdVhEa2hQOTFtRm9SOWV4eHFBNmN0ZXN6TGtPL05yT2U3?=
 =?utf-8?B?MFM0VW9jN05OV25JeTRadkhOWjUzb0x2djFFSjdBVm4rUlhBeDMyMnlGblVX?=
 =?utf-8?B?Wk84WVp1amxDUk03Y3VwK1FxeUJvZ2dZZnRxU2VHaFpFd3l2VThXMnlySnhM?=
 =?utf-8?B?akVxMWlIWjFpdjlUczJDZnd2K3JOY29ndTBDQmJOL2FQZHBZVS9nVUkzekRo?=
 =?utf-8?B?aUFrM0pCSXlXcEI3U3VxR0dpbWFmdUZMMzQwWVFockNFc2xGeVRsbjZjL2ll?=
 =?utf-8?B?ZTNsb3FMaFhPc0ZIVUlRV0V5UWU3a0dQVGVFdTI4Ri8vUi9OdWc0U0c2OFBE?=
 =?utf-8?B?RkNpeGxkeHhQRHEvalNKVC9GTjk3ZXZ6b0psOXNNTXQ0TGJrMURoN3djTEpa?=
 =?utf-8?B?b1JiUDhZdEgyWVlVdFBlbmJuSkVPak5yMVBCbS9tb2VDZTNDOS9BMlgwVmNP?=
 =?utf-8?B?bnRkZi8xRTVyclZPTDVzYzZKV2VWUXlRZEl3NlpZWTlFZXpJODZsdStBYU00?=
 =?utf-8?B?OGY0aFg0YnhHcmYwZ3pNbVczTm1ncW9HMTgxTlVFZkRzR3N4WHh3eURFNHRa?=
 =?utf-8?B?VU9xNEhBOC8yUzRBZTZXWmRicG1GQVQ3ZzI4RmxyM2kxMSt5R2UzM21QQmUx?=
 =?utf-8?B?cUc2akQ0UVU5cjVSVEZYeFBaU014L1JvaG9kY2ptUmpxOUZydzNqZnNUS1Ba?=
 =?utf-8?B?ZDh1YVh4WDRERURlbndUR2xZaFlzWVovRDZNbFRhQldXOGRWaWpRZFV4U1Fj?=
 =?utf-8?B?OWdYMmJ2eXc5RDJxN2Ntd3A5b3diaCtMdmYvNzFpeTZiM2VDWmx2Q1NRcTQ3?=
 =?utf-8?B?emlsT2lWR1JGcmU5Vm4xMk8wV0o2azJpY0FaU3lXVkhoS3NQSUtOM0xOWGpI?=
 =?utf-8?B?czJzdEpSdnVQei9FUUU4TTRZZzlKckVuT2pld3V4bXR5RURuN3N0aUpMbSt1?=
 =?utf-8?B?ZG45ZUJ5YUVnZENtU21PcC8wcUxub3RVRGx3dTk2THROSXg2NnJyWVdJdG8y?=
 =?utf-8?B?S0lXU21mNVBvUkJhQytMWkdqWVgwTEExeWRGc0tTSDUvbFdBTWpwc1h5R21a?=
 =?utf-8?B?N1RjaHlCd3JEV3RDYytZaTc2NzA4dU5xeEhaY0g4SXBzL3hhR2RWV2ZqKzB3?=
 =?utf-8?B?aUt1cDlIbDZlQS93a1dMbEYyMHplY2ZpakhWc3hWMDQwM1BhM3FJZmVScjNa?=
 =?utf-8?B?UG1BWFE2WnRHbzgxcjZndTRBeTRYT1NJOXlGTE9HMUNxTEJxZ083bnRrTGFY?=
 =?utf-8?B?cGx0UmlHMGVOWmtRcmVWNmN4dGFmODI5MDBXMjVnaUZSdWRVbTIvVGV5RWoz?=
 =?utf-8?Q?87JHFXNiAZ797sZ5rxUf2OKdKiV8jXVCb+x0d68ViQd5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e84e5c6-703c-4519-4867-08de2dab1e4c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2025 11:50:10.5043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WEjnSXGfy/5b7u6Fba8O7xR2bIKzMLZvxSxT0Ew4Xy9vlUXCzN64u61+uLPEc4wrY6t+eelxgvnYK+gk3a+OuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9623
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F3E1C180004
X-Stat-Signature: fjqhutsdh6f4xemaqouuj99ckycfwt1g
X-Rspam-User: 
X-HE-Tag: 1764244214-488852
X-HE-Meta: U2FsdGVkX1+fORwHf6AvkB79m5nSwt4xkoEAIBKSDth6Sq0dOHG+n/oPeI0fgh/gC2vKy6QAsUaYrwR7/6cUYe2zWUaU3x+I/4pl9YkQSuhc7EenvUpOShgtW8xijBlYY170b3goAmBhcV6xlDyQwgkhldMrsnt3lCn/ikOGiaDyqD9VeyzF3IPyyYbj9GAnEmwUrNIxMrNISH1uiEWnuK9K0dECymfMXyqOiZu12Y91Vpdc3kd8xTohLfprT1MOQ9ebTXuzuaTXxhMPhRk5tbr7HklUU5yTyFcREgc3KH7JGLKVesIpGxfMikxKAXGEmntSKKViVp8bin1KFGQ5ou9Wz1C9GqI3VbL8RB6ncVVmSHxswpwW5tiIO5oXdzYPGdaTwyeIJGAMpPRt6L/NNoCL82vruWdTvbyol1fhVmXuAYt+nr717dxSGbKpFLe3R34YPKTBhBpAFKNw/YML0qoMZMRi1KZbmIqay58s+JOhZbe7TNsx3IiSE/B0UMkZ55ZLDgx+k7hCAd3UEm/yfw7tpiKv67BG4AqhZLfYgFnnuiHKYx2ch1ylNqfb0nbBbNYEn9p+vjN4CMRZeqJEfhCsG0Kzh1eNLuMOTfNhZbQxBmunL5iPBdO/ai2A7DetahtFQy1kZfAcVIQckqB1stGEMYDqe/Dui/DxZF52ajgx3hVyqlB/gzuIZGJuOBFEPNqLXF2LVS743Wf9TFOxQvppvKWiA16BU76UOFgNDYhwqCcY/u8W+F8bFbebRF0UH5jPVfxikKGNMrEGYIIvxQMPZ+M30Y/Q+XUYRNZ+L806wwC4Yf6lvYJVBtrMX4j77UbooeZw5feLCX4THt2j9jx6FYe+ZA4/cLoqUcFMnygJFXEPG4dB/hJZjkQk5d97mvUkb3q7IA1zlisTWNisgID58fqgIitCI9Bo7dM4GuGEuQzZnNTNFb6JXrH9dNaTHVCmtyDMOkL/Ue+kaWA
 oRN/L0od
 YF1O0gJVXsc5+anwORrYQdQVKD4IGkJ+tLxGXgkDVdszretXu2fikgXDo4eM8u718nAGL8puryd12pRof8MUqwOgXddW4YxYfGP87pdQOA2TgJIkh0Lny6Up1IMRX+l/l9eWyq/uR6bYZ+v7uwUuF/x5RlIuN+VwPEXtEOnA2mJ065cQy8HkES33ANsPvKlxWbksvBmvUNN8OIpYnFfGn3EfEWKjrkueLT+4hlOYOmGtJmKwR9HoFioiq39fAAuygLn2+X7Yck70OndZGIpmmtlfKlLX73X2tr1qo26b3Dr7pYbrEA2Pw34AVVXTMFIWNKCuDSUQGL8irFKGuxmo8TIak8RkFwdsH3Du3qybIfRtOiJieCdE6KKn7cFE4WI5jerqjY8L3WZ6DtUF+LqRWr4iwixy3Wj8P9+Qmw8/tK8Fs5Un/TXduWbilv2PY0/a203exie6QgXCYIlUGwVDstx/4HYnCYaVH0BZbLP3eMLzkOJh4OkqUur3cRj4QZ5S5/TavCux7jKa8la8xw3qMrlnmZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 27/11/2025 11:38, Jon Hunter wrote:
> 
> 
> On 31/10/2025 21:32, Daniel Gomez wrote:
>>
>>
>> On 10/09/2025 10.01, Vlastimil Babka wrote:
>>> Extend the sheaf infrastructure for more efficient kfree_rcu() handling.
>>> For caches with sheaves, on each cpu maintain a rcu_free sheaf in
>>> addition to main and spare sheaves.
>>>
>>> kfree_rcu() operations will try to put objects on this sheaf. Once full,
>>> the sheaf is detached and submitted to call_rcu() with a handler that
>>> will try to put it in the barn, or flush to slab pages using bulk free,
>>> when the barn is full. Then a new empty sheaf must be obtained to put
>>> more objects there.
>>>
>>> It's possible that no free sheaves are available to use for a new
>>> rcu_free sheaf, and the allocation in kfree_rcu() context can only use
>>> GFP_NOWAIT and thus may fail. In that case, fall back to the existing
>>> kfree_rcu() implementation.
>>>
>>> Expected advantages:
>>> - batching the kfree_rcu() operations, that could eventually replace the
>>>    existing batching
>>> - sheaves can be reused for allocations via barn instead of being
>>>    flushed to slabs, which is more efficient
>>>    - this includes cases where only some cpus are allowed to process rcu
>>>      callbacks (Android)
>>>
>>> Possible disadvantage:
>>> - objects might be waiting for more than their grace period (it is
>>>    determined by the last object freed into the sheaf), increasing 
>>> memory
>>>    usage - but the existing batching does that too.
>>>
>>> Only implement this for CONFIG_KVFREE_RCU_BATCHED as the tiny
>>> implementation favors smaller memory footprint over performance.
>>>
>>> Also for now skip the usage of rcu sheaf for CONFIG_PREEMPT_RT as the
>>> contexts where kfree_rcu() is called might not be compatible with taking
>>> a barn spinlock or a GFP_NOWAIT allocation of a new sheaf taking a
>>> spinlock - the current kfree_rcu() implementation avoids doing that.
>>>
>>> Teach kvfree_rcu_barrier() to flush all rcu_free sheaves from all caches
>>> that have them. This is not a cheap operation, but the barrier usage is
>>> rare - currently kmem_cache_destroy() or on module unload.
>>>
>>> Add CONFIG_SLUB_STATS counters free_rcu_sheaf and free_rcu_sheaf_fail to
>>> count how many kfree_rcu() used the rcu_free sheaf successfully and how
>>> many had to fall back to the existing implementation.
>>>
>>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>>
>> Hi Vlastimil,
>>
>> This patch increases kmod selftest (stress module loader) runtime by 
>> about
>> ~50-60%, from ~200s to ~300s total execution time. My tested kernel has
>> CONFIG_KVFREE_RCU_BATCHED enabled. Any idea or suggestions on what 
>> might be
>> causing this, or how to address it?
>>
> 
> I have been looking into a regression for Linux v6.18-rc where time 
> taken to run some internal graphics tests on our Tegra234 device has 
> increased from around 35% causing the tests to timeout. Bisect is 

I meant 'increased by around 35%'.

> pointing to this commit and I also see we have CONFIG_KVFREE_RCU_BATCHED=y.
> 
> I have not tried disabling CONFIG_KVFREE_RCU_BATCHED=y but I can. I am 
> not sure if there are any downsides to disabling this?
> 
> Thanks
> Jon
> 

-- 
nvpublic


