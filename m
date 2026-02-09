Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45BF5E7E0C2
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 10:16:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4E196B0088; Mon,  9 Feb 2026 05:16:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05BD6B0089; Mon,  9 Feb 2026 05:16:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 906ED6B0093; Mon,  9 Feb 2026 05:16:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 760036B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 05:16:16 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2BAA6D63BA
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:16:16 +0000 (UTC)
X-FDA: 84424513152.24.928AA2E
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010020.outbound.protection.outlook.com [52.101.85.20])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1066F40008
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:16:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=zwUgUmAW;
	spf=pass (imf04.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.85.20 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770632173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qPjVqKQ0shifQuVTUoVsZHKoUNX7xnlbsvp/5ocIx4g=;
	b=s5bF3u6sOXIW68q3FsUOXbUXhJfMzlIPZ856kQI5BRRZN5gLt37/GArMK1CSsWuSYomI3F
	iKkKtXPqGJVwmH6uhNyqYoQ8cIVO2kKtAQzWPzEkbbVCaNijk0rysDyymmt4QyYpzb4bBT
	pQzb0joZ0Ml2qycDx6kK/ZT9khu4uiI=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=zwUgUmAW;
	spf=pass (imf04.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.85.20 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770632173; a=rsa-sha256;
	cv=pass;
	b=GlVHV42Bbmm213XcImXzjtcGsKki4yqsVmNBvRbqF19gyrpv7ohasDwzo+nT9beBtbC1/S
	JMTr0QthUiDKZ3N5RZKmwJUAouYp9aoB5sIy0W7FavNIkRKuMn3vhr1cmMol6ABGVaH7ra
	Rg8E3wa+MFKFtrykOUnFuCbiZxCvtX4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L2XKsA571p1vF2TdQrz1qjSVu2lCWk1MFT/mrd7wT5QehZhB6N70TQCo1uESJGxIG2vk3mD7F8Z/Uk0+t7T5EfDtYFJ3jIip3kYn5T6jdoxe/8v6rCKqZbbhAGUYWXYfotwYE59jMXPvKiraY89lKNz5ytra3EZ0u65EVzWreU0ApC4xSsarvm7BL8Fat9Np4xGPEvi0rzsbRDwqAwtxw6AVcxgBqU7HNdFUMrzGmjXCtSL56RJnOCLJy4FeeioRPHog3dRIz9y4yD4M16cmA1yeIl5Q84WlsSF/OgWNoAJw/on9rBzw/LbzDUT1yYSzQRPKR5EqR1kI+BzUZO3q5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qPjVqKQ0shifQuVTUoVsZHKoUNX7xnlbsvp/5ocIx4g=;
 b=Lv2ee53vbgRRaVCHd1IVkZuNRYYiE221Oa4SkeiQr1kurLb7Hh29XAVEBwoWyYmhZ+rPpcfbHvV8dkBy5byEWj9IKWgj1ELDUIo6DCgTypewGWkWYn4RlYpJIxvucCdlDfn4QM2qzgwu+uKIOUSLVlc/2eTSQclVYFq6+Iw/scamfAVsdFmLedScOTIPfQEcPWoaR+Fc8FR9vP2OShl9I3AHQQU1pbOQxbJF4jEJGLD+UomClIJ/AxJdF5x4i5Si3ieHxnXjDfYJS+KJ0m9MQeWdZEjKMbF0nGVtDZb98shOOy3y0Uh5652CHj0Fny5jzigYajWtS2WZedhyihvldw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qPjVqKQ0shifQuVTUoVsZHKoUNX7xnlbsvp/5ocIx4g=;
 b=zwUgUmAWIdJAu+Jph8JXxec5PkAeN3RxY3MAM4HOn9ghckPiCKRHFkC9Y6g3+H3icyLc16Zc7aHBhiASTpN+gJRat6gkN9BA5hdeaU1VKO2zLU76IoB0DZ3HXKRxRIHbUwcpAa6U9xJdaEkev01SSZW5FLuz0EHo8iEqavGCOX0=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by SJ0PR12MB5636.namprd12.prod.outlook.com (2603:10b6:a03:42b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Mon, 9 Feb
 2026 10:16:10 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 10:16:09 +0000
Message-ID: <f296a928-1ef6-4201-9326-eab43da79a84@amd.com>
Date: Mon, 9 Feb 2026 11:16:05 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/8] drm/amdkfd: Add batch userptr allocation support
To: Honglei Huang <honghuan@amd.com>, Felix.Kuehling@amd.com,
 alexander.deucher@amd.com, Philip.Yang@amd.com, Ray.Huang@amd.com
Cc: dmitry.osipenko@collabora.com, Xinhui.Pan@amd.com, airlied@gmail.com,
 daniel@ffwll.ch, amd-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, akpm@linux-foundation.org
References: <20260206062557.3718801-1-honglei1.huang@amd.com>
 <da75eadd-865e-41fe-a86b-ed9d9aa45e5a@amd.com>
 <8ba8e4f2-89f2-4968-a291-e36e6fc8ab9b@amd.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <8ba8e4f2-89f2-4968-a291-e36e6fc8ab9b@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0033.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::20) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|SJ0PR12MB5636:EE_
X-MS-Office365-Filtering-Correlation-Id: d300c7fd-6598-4221-d82d-08de67c43ebc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ajF1UVozV2xnaFNlUDFPVXZtTDhJbURkeDJTL2tnNlprbjgyY1ZtM3RhV1ln?=
 =?utf-8?B?YURJckFudXBVTDlLSE1wREFMV0RxWi9UY25OL0dDZDFLdGE2aXJwTWFlT01D?=
 =?utf-8?B?TFR0L0xXa21nbGg5dTkzQmU4VFNSU3cxTVgvaDVWYjluMWVhOTB4K1ZyTFpl?=
 =?utf-8?B?amREQUdaL2xBcnN6MEUwNXQ5VUVWb0V4WktPS0JGc0Mvb0xVaDhiTERNdlY0?=
 =?utf-8?B?UFVUNkp6UU9TYzNSaTBZaEJpaTd6U3oyZ3VTNURNMUxSejhER0xhVW05b3Ns?=
 =?utf-8?B?VC9Kd3R4MTlpclZNeWNtZ1pnRnd1NG9yRGVyWk1IYkM1bDhoSm42N05IT05m?=
 =?utf-8?B?eVNIckpKWGhybjlwcUt1RDRMZjRxUmEwUiswR0g3Z1NvVHNMVENqeUIxNm92?=
 =?utf-8?B?Um1HeUdvbjlJWUZPakZKYlhaWXl5enJzbExyekxxeFhHa3Q2S2J6L1dmTlIx?=
 =?utf-8?B?OU05bVUzYkV0eVBqb0xNWTJ6Z01kNnAyVFVHQS9ZMWozUFcxSytXRkRDL3RU?=
 =?utf-8?B?MWEveVVQNStiUVk5RHM2SVhpeEdteVdSQnFWN1prbUNIcWcrbnE5U3NvcW9D?=
 =?utf-8?B?MkxDUnFvek1EM0NKaDBDV3FBQWZSTjhYV0prZ1lLa0ZqckJYbGExMHFJM2tT?=
 =?utf-8?B?TTlhWlhZNlZqd2Mzd2N1T0FFVjl6bzZwYzhBYzUwZzZaa2FyUjhMakFwUGVt?=
 =?utf-8?B?NkNJN1lEd05FWVFNUHdRZzZKdkpqeUVDbERBTEJBMFFVdS9wd3ZDTDRTZ3dy?=
 =?utf-8?B?bzJkRXFVK1UzSmorNFpMOXNkbDlTbTJEMis1TVg0UG1oZWhSVEpmMGZCZjFB?=
 =?utf-8?B?b3U4SGVyTWhUZFZqdlE4cTh1NXN3dE5LTnZMQ1pIRkRaTlkzZlltYUZTOHVm?=
 =?utf-8?B?TUJ4OGFXclI1SU9ObjA0S0dlU3JPYmhqQVhGWGFsVXFSbnM0ZVlndnFoc3Ax?=
 =?utf-8?B?V0NHUlNLWFhhV295b2EwYkFrc2liU09tM0FJRHlBdFk4QS9ZNTVsb255U2tx?=
 =?utf-8?B?NmYxaVRtNG40VWMzZGNGd294QmpVVXM0OWFTaFl5M1FOZVQ5OEYzZWp1UVIz?=
 =?utf-8?B?YWdPVk4xQlhtZjk2YkpXZUN5OERjSzhvQXUvZnB5WWhpZWxNaHRLOERYTFN3?=
 =?utf-8?B?c2JaN1g4WkZ0TGRHM3N2VjBtaVhXSzdGMFhQQ0Z0WFVXZ0MyTG5RL2RrYk1z?=
 =?utf-8?B?N25OK3dPVzB3blAyR1FvMVN5MUxZM202MmlNYkpmNHlxeC83Qk00VWJNdnh1?=
 =?utf-8?B?am0zUDBGUHptQ2JENVpDS2ZCbjR1eE1HKzdUMjZ6MjhKcHh2bklnMmNhMnVv?=
 =?utf-8?B?SCtTQUl6Rzk3ZzEyM2NYOEppK2lZdFFwaHJwNFdNd3pqRTZhNTgvNG5nbTBZ?=
 =?utf-8?B?NUVqNWFFbkdpeExidXBoUGJ3RWxoQzk3L3Nud1RVY085Q1Z1MFg2eHlEZHVW?=
 =?utf-8?B?OTNkQW9xcFc5REFQZFU1UnY5aFBPYTlKTUtINVRGVXZpZ1NCbU9sTnBRdFYv?=
 =?utf-8?B?OXcxVkRrRW9QclZ6YjlsZklmSWdCdEpPYTZXbFcyZzk5K293SU5PbndNRGdB?=
 =?utf-8?B?d09NVEFZNnZOU1d5NlVSSDRvK2U3bnkvSHJwWWQ1QlJXQ09YcUNPdSsyVUk1?=
 =?utf-8?B?T1hCbGdINThGOGlBcW16OFJxZTVWMFlkek5xeEpQMWM4ekRnRTIzZ0p4UFlv?=
 =?utf-8?B?Y294ei9sOFVqSis1QTFLY0gycWk2K0drM3V1UjlPZHRXT3hkY2hMdjZzQjJk?=
 =?utf-8?B?T1kwN0xXMUgvVlM1cEtEVWtTQjc0Q1RyS21GQXlDWjVTOEE5ejFYWnpadEJn?=
 =?utf-8?B?UmpTL3pJNTFoYk1rSngyUXR2STR2NnF1bGhiaVZIMkVsMDlRRWFvTWlpN0hM?=
 =?utf-8?B?RHd5VmtsNU4zZGdDQXZLVU9rTm5XaWJhWU9lcHp6dUhhblc5SjhDLzdveXRw?=
 =?utf-8?B?Wll1Z1hPbHBISmMwVWRPVS9EQzB5YWNBK3piVVZYMnY0UElSNThPMFc3cjZp?=
 =?utf-8?B?bkxjVHdFSFEvdmdENDNnZjZGVlQ5QlUweFlWNHNFSWYyZHZyNzNLcTl5czh3?=
 =?utf-8?B?ampBOWhpYU1aR241Q0lmVVFGdFRuZlJseUpja2xOQXNYb0UvRWZEWkFNajlY?=
 =?utf-8?Q?gVBU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dktYVUpmNjU3L1NpNFZqMHkrUkJRMjBCVG5oVlBMRzdINDVCcWdNTGpiRXdR?=
 =?utf-8?B?NjN6cXV6b1liaVc0TzMvOXpReE14d2llZTJJT21TZUdYZnlESlc4QWdzcHVB?=
 =?utf-8?B?ZTQ0Wm9WTzZOTUVlZ2tPZlM5Y1pHNHNZSll2TzNiVG5ZMDFQaFV0Z2pzcTBn?=
 =?utf-8?B?YWxyM0xabTBrRnQwc2hwMzh3S3JRMkRqQ2RNY2x6aGVrWTFkVVFnK3Z1Z3k1?=
 =?utf-8?B?K1RxTWVOVUZEVmlqUmN3WlR2enhYaUxCdjhFbkl1WExpK2Nzejk3eDF5d29w?=
 =?utf-8?B?Z2lKaEQzTzZzRkRsZVJjQ3VmdFNIeHhveFVKYlNOWklQRVh5QnpXaVZZeGNE?=
 =?utf-8?B?WHlDQnJaMTF1aVhseFNyazYvUUJoaDQxVEhDSzVlWGpNRlh4UkIwbkkzNVlX?=
 =?utf-8?B?SnEvelY4Y1o4SHhYamVqTVBiMWUxTDFwQXF3UWZ0ZkhnYVU1QWZVMXNyU3FP?=
 =?utf-8?B?TmdwYTFMeTZhampVZTNla2U4Q3dnREYxekVyV294T1RKS0JPaVE2anVObmVk?=
 =?utf-8?B?bDdHQ0tTTkgwbXhjT01iR3FsQ2NJQ2x0TDlKcks4MmRtQm9GNkFQaWFyMTJL?=
 =?utf-8?B?bHJTbk9makRHQm13QUVLeGpjYVdhNGtVaFRyeCtuamNLRnFwSzdUMG9rOEQ1?=
 =?utf-8?B?OFNtazhVSXlKTWFRaHVMYnBtbDJlNWpDYjVnaUk2RGZmazdoU1c1dktWcmxn?=
 =?utf-8?B?V3oyTDZMbWk1Uys5bTJHMk1IRkZCZTJLZFdoQVVFYTN0bTlDSmdsZ3MxbkdL?=
 =?utf-8?B?MDFUWFFkQlJvTTJxaFEwY1hiNlBvby92ZWx2U1ZZTEJURC9wZFk3SFc1c1Vv?=
 =?utf-8?B?QytKOFhVTW1iMTVKM3ZLMzNTWlRsV2pwUng1b1M5Q0tkbjFnMkdlSzNWWisv?=
 =?utf-8?B?VGkyb20yVlpBUm9uUE5QSDdLVS93K05ZUkJ0T09ZOXZsaVBHeFcyK2NNaXB0?=
 =?utf-8?B?UFJBSVlNcFI4eXNNUmlybUk5aVJNSFF5RUtBK0cyMEV2bDlmRWFLQlI3bCtP?=
 =?utf-8?B?aEZDa1c3NzYxbDhRdWxLYS94U0s1Q2Qwb1Ayck43bGxyN2ZPNUxCVEU5OElo?=
 =?utf-8?B?L0V1clNaT0VVejd6WU0wNEp2MzZVTER0ZmhwSkdaZmhLSHNXcEExOWNZSzVw?=
 =?utf-8?B?bjVNLy9WeHZvZ1J4Yy83bG9zQzcxR0QwZHNVZEpnT3E0SGFaOGErdUVSQTRI?=
 =?utf-8?B?WFpuZnpnM21URlRHS3ZNa21UNXNIL3hza0pzNjRoaEFBejRMMjZiVU5Nd1VC?=
 =?utf-8?B?dG1wVTc5VUtvamdoTUhFZUtYQ0N1QmcvcVpRWmNBY1gyOXN1RVlVanV1OXRr?=
 =?utf-8?B?OW5pOEpXNnN3THJlSFV2K3VabnZtRVo2b0czSG1GY3JQbU9QMFg2aDBHZUJL?=
 =?utf-8?B?MEZhaDdCL3ZoaXhIU2V5ejdTTmppT2FTdDYxSFR3a3ZQa1ZhaUFSa21vT1E1?=
 =?utf-8?B?NktMRDZtWk1RaHg2b0NLcDdCR2JPT0xHQnd6dWtwRWk5YStOcE1LUklqZ2Iv?=
 =?utf-8?B?eGxlSFNiRm52QWlaM1kzaGtrMEdZcTBNNDQ0OVBlT29UYTRydU5UY0NVTWdG?=
 =?utf-8?B?d2xtNTNPWW44RVQ4ZnE0bG53NGxhK2phWTErUWtIR2xrd3J0VUkxVENlRTFS?=
 =?utf-8?B?VkN6ZlRycnFCS0I2cDA4RjBYeFB5cjkzVTBaZzA3alBDeTJreUg3bHRKQjRU?=
 =?utf-8?B?K2pheXU5T0t2T2ZCam9yd2wvWG1tMVh3KzdabzhFM2JvbmoyWHlwUmgzcCty?=
 =?utf-8?B?ZjBHdW4vR0xoZXIxVUpiaFpwYmVjK3ZVRWwrVFREL0FlRGI4am1vdTVBQmlQ?=
 =?utf-8?B?bi9PVUNHSkpsM1AwR2ZrTjBPTElpaXBxR0ZiRzE4L1R0bTNHeEd3ckZlQkJk?=
 =?utf-8?B?R2ZtN0tObzhBcmxKTWdLSCsvUTBlT3JZWnVrN3dlWi9LdVBZZTdJeHVwWi9U?=
 =?utf-8?B?OGs4ZG5VVzFyZDQ5MXVqTnQ1Nld0bkh1WStQQnppb01FZnE3TGZNQk9GeWIz?=
 =?utf-8?B?TW9LWWxseEZLVXBTVHAwU0NvL2x0UUpMZlh4d3hlRWN2VEdGdTJZblRYbUM1?=
 =?utf-8?B?RlVsZ2h1SmlyMDgvdFV2M0poWTc5NksrR0IraXcxd3B0T2czR24xN01DZ0po?=
 =?utf-8?B?ZTdBOXVhZlljbXNFN09OVWxoZnE4Njg5Und0MlUxWjhCQlo1ZEZVTWFzZnpP?=
 =?utf-8?B?bFFISGJ3SEEzZVcxUHBEc01HYWJ4aXRkOWdXUWlCVUpid1J2MVg0eXM2L2xC?=
 =?utf-8?B?QVl6UUEzbE12QUJKc0tJUzdVWTVGejZ4RGRYckhqcVFUQnRGYTk0WG5oNktM?=
 =?utf-8?Q?+GyUF8kIa9Yb3ndVJ1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d300c7fd-6598-4221-d82d-08de67c43ebc
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 10:16:09.8595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ANN+EkA+eCkKH0aAoZ9CJRThW32tXoxPeRSyWVGGcbCu8Ph5vnH4zk13enxRZtMx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5636
X-Rspamd-Server: rspam12
X-Stat-Signature: hkip54sigfpc9oyqzt9f8zsxwozuxcnw
X-Rspamd-Queue-Id: 1066F40008
X-Rspam-User: 
X-HE-Tag: 1770632172-970002
X-HE-Meta: U2FsdGVkX19YpiIDWzcyelW0zXKU5x5fGCWhceajsoJWXEvBdR4cHpqGQYTDTD37SdH09KSe8H4SuldqMi8klg3qbn/Z8wpUsZ2thPn4hBokjmRUZ8Tf/qD99i1U1w5Bf5wyctIzI+6zLc5k4D8TAL4hCf8THbg4LvI3GCV2BlMvK2JsWtO2/URGlmvvGM/CLMaaYB0cDPAX7kqbiH2OJVgJBC+al37bPIe8sTu4ST8BMs6Xv2rLNFCvVqcGFQ51sShwNrkcQb9Cv1VeeXtgO4Qiy982rQ3sEL3rOsbG9NUKZ1+XrLJyKs7shOD12ilfKOdqeCzjakcmnKMQSZKJ7ONEvXwNWEiswZOj7a3zecwdmEfCE21IgaHR6Rp4gXiOQDz6v/sa5ZZwUNV/9c13wlIIB0Q+8Yks3rdcFtjTrsaMdq9dDMGImnw0t9tBF1DC3J/qBYdaxCzDj1d1TncMZBQbC5CAm5y7a+nJ4MfT4OiSh7Ta6yaQl+SxiJGVo5/YXHH4AIeIXBkm4CulYWDlMwmlDFHh9Ra2CBd57IzAcAYE1t/jkke+Km3vy8jTpdmxFCIAHnyhSfYjCWxglrUK+4F11aPcJSKA+MDZXlgZQxrIiZnEOp8gx/PrFJuoU9q1wHx+3u0N6plbaefB0bZxdU2t7ZMX9LDeapnSss4orM8x1MeKnUKfeXemy+lFzGJrJbwSPy3FwQKZGysRH1iBQgW9C4WweMj9bR8pM6qDoKqFSHitEgL2xHhvvr9gUJ6prwnwZkXL4434O9CcNO/BCT4tLyenhiGCcII0r85u7cf3+npQ2vdfba1LhnXF3BDWLvhcwgF8Y8GLNoKLNdZkPEkJ3dWloxo/6Ltv62YKNxc+QVbIG1bldbsCP3Lss7DA3fe3G6E2hq4f/D9SWjgPqhQNbSlzlvugyecFXSuuJPnGMVJjvuCjCCiH/kEoZ7SZgZpul0EjmLkpr5sTM5Y
 MjGYsHSf
 VhrIpjeAv0+aRKjdDIOTz+zEK57yuvFd2eCKGuskrGmjhEmIxKDmRhDBnyzlbyWK8DVF278AVGWlmaGnUAbYqY1mFuXnz7kB9SjL0R2bjWA65+u9lXSz3495xqONPX7U/hAaywSJyL8uN/OqY+tjFX/PKy5K1X3e7XuCnUMiCXotXQD5CmHjiXrLA5Q4dTSQVyBtIyjR1QumjGAFX4sjCC6MlQeyFW94EP23WU/U5XElmtkDXLLciiSZ4Z4XLjTjXg4ft4D1Gk/qJ3qSsNP9FFKAiO2rcMyjb6JC37fKGN+WkS+zUueZOqaLW+G0RpCTMdPHBBgGrn+arfvrH+Nb5GAS6IPPxD8ffCA9plG6lebbo7G7vvqsW+GmJY0qu/4rrMOWTO5JTqZ33e8yMSvVna+ObX63a8soKToqGI1Nn8Cdr097HUWXETmylOn7Nc/RHIqDHYptcBB0uUBWDiRVa7+PQ31k9KLj1V3V3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 07:14, Honglei Huang wrote:
> 
> I've reworked the implementation in v4. The fix is actually inspired
> by the DRM GPU SVM framework (drivers/gpu/drm/drm_gpusvm.c).
> 
> DRM GPU SVM uses wide notifiers (recommended 512M or larger) to track
> multiple user virtual address ranges under a single mmu_interval_notifier,
> and these ranges can be non-contiguous which is essentially the same
> problem that batch userptr needs to solve: one BO backed by multiple
> non-contiguous CPU VA ranges sharing one notifier.

That still doesn't solve the sequencing problem.

As far as I can see you can't use hmm_range_fault with this approach or it would just not be very valuable.

So how should that work with your patch set?

Regards,
Christian.

> 
> The wide notifier is created in drm_gpusvm_notifier_alloc:
>   notifier->itree.start = ALIGN_DOWN(fault_addr, gpusvm->notifier_size);
>   notifier->itree.last = ALIGN(fault_addr + 1, gpusvm->notifier_size) - 1;
> The Xe driver passes
>   xe_modparam.svm_notifier_size * SZ_1M in xe_svm_init
> as the notifier_size, so one notifier can cover many of MB of VA space
> containing multiple non-contiguous ranges.
> 
> And DRM GPU SVM solves the per-range validity problem with flag-based
> validation instead of seq-based validation in:
>   - drm_gpusvm_pages_valid() checks
>       flags.has_dma_mapping
>     not notifier_seq. The comment explicitly states:
>       "This is akin to a notifier seqno check in the HMM documentation
>        but due to wider notifiers (i.e., notifiers which span multiple
>        ranges) this function is required for finer grained checking"
>   - __drm_gpusvm_unmap_pages() clears
>       flags.has_dma_mapping = false  under notifier_lock
>   - drm_gpusvm_get_pages() sets
>       flags.has_dma_mapping = true  under notifier_lock
> I adopted the same approach.
> 
> DRM GPU SVM:
>   drm_gpusvm_notifier_invalidate()
>     down_write(&gpusvm->notifier_lock);
>     mmu_interval_set_seq(mni, cur_seq);
>     gpusvm->ops->invalidate()
>       -> xe_svm_invalidate()
>          drm_gpusvm_for_each_range()
>            -> __drm_gpusvm_unmap_pages()
>               WRITE_ONCE(flags.has_dma_mapping = false);  // clear flag
>     up_write(&gpusvm->notifier_lock);
> 
> KFD batch userptr:
>   amdgpu_amdkfd_evict_userptr_batch()
>     mutex_lock(&process_info->notifier_lock);
>     mmu_interval_set_seq(mni, cur_seq);
>     discard_invalid_ranges()
>       interval_tree_iter_first/next()
>         range_info->valid = false;          // clear flag
>     mutex_unlock(&process_info->notifier_lock);
> 
> Both implementations:
>   - Acquire notifier_lock FIRST, before any flag changes
>   - Call mmu_interval_set_seq() under the lock
>   - Use interval tree to find affected ranges within the wide notifier
>   - Mark per-range flag as invalid/valid under the lock
> 
> The page fault path and final validation path also follow the same
> pattern as DRM GPU SVM: fault outside the lock, set/check per-range
> flag under the lock.
> 
> Regards,
> Honglei
> 
> 
> On 2026/2/6 21:56, Christian König wrote:
>> On 2/6/26 07:25, Honglei Huang wrote:
>>> From: Honglei Huang <honghuan@amd.com>
>>>
>>> Hi all,
>>>
>>> This is v3 of the patch series to support allocating multiple non-contiguous
>>> CPU virtual address ranges that map to a single contiguous GPU virtual address.
>>>
>>> v3:
>>> 1. No new ioctl: Reuses existing AMDKFD_IOC_ALLOC_MEMORY_OF_GPU
>>>     - Adds only one flag: KFD_IOC_ALLOC_MEM_FLAGS_USERPTR_BATCH
>>
>> That is most likely not the best approach, but Felix or Philip need to comment here since I don't know such IOCTLs well either.
>>
>>>     - When flag is set, mmap_offset field points to range array
>>>     - Minimal API surface change
>>
>> Why range of VA space for each entry?
>>
>>> 2. Improved MMU notifier handling:
>>>     - Single mmu_interval_notifier covering the VA span [va_min, va_max]
>>>     - Interval tree for efficient lookup of affected ranges during invalidation
>>>     - Avoids per-range notifier overhead mentioned in v2 review
>>
>> That won't work unless you also modify hmm_range_fault() to take multiple VA addresses (or ranges) at the same time.
>>
>> The problem is that we must rely on hmm_range.notifier_seq to detect changes to the page tables in question, but that in turn works only if you have one hmm_range structure and not multiple.
>>
>> What might work is doing an XOR or CRC over all hmm_range.notifier_seq you have, but that is a bit flaky.
>>
>> Regards,
>> Christian.
>>
>>>
>>> 3. Better code organization: Split into 8 focused patches for easier review
>>>
>>> v2:
>>>     - Each CPU VA range gets its own mmu_interval_notifier for invalidation
>>>     - All ranges validated together and mapped to contiguous GPU VA
>>>     - Single kgd_mem object with array of user_range_info structures
>>>     - Unified eviction/restore path for all ranges in a batch
>>>
>>> Current Implementation Approach
>>> ===============================
>>>
>>> This series implements a practical solution within existing kernel constraints:
>>>
>>> 1. Single MMU notifier for VA span: Register one notifier covering the
>>>     entire range from lowest to highest address in the batch
>>>
>>> 2. Interval tree filtering: Use interval tree to efficiently identify
>>>     which specific ranges are affected during invalidation callbacks,
>>>     avoiding unnecessary processing for unrelated address changes
>>>
>>> 3. Unified eviction/restore: All ranges in a batch share eviction and
>>>     restore paths, maintaining consistency with existing userptr handling
>>>
>>> Patch Series Overview
>>> =====================
>>>
>>> Patch 1/8: Add userptr batch allocation UAPI structures
>>>      - KFD_IOC_ALLOC_MEM_FLAGS_USERPTR_BATCH flag
>>>      - kfd_ioctl_userptr_range and kfd_ioctl_userptr_ranges_data structures
>>>
>>> Patch 2/8: Add user_range_info infrastructure to kgd_mem
>>>      - user_range_info structure for per-range tracking
>>>      - Fields for batch allocation in kgd_mem
>>>
>>> Patch 3/8: Implement interval tree for userptr ranges
>>>      - Interval tree for efficient range lookup during invalidation
>>>      - mark_invalid_ranges() function
>>>
>>> Patch 4/8: Add batch MMU notifier support
>>>      - Single notifier for entire VA span
>>>      - Invalidation callback using interval tree filtering
>>>
>>> Patch 5/8: Implement batch userptr page management
>>>      - get_user_pages_batch() and set_user_pages_batch()
>>>      - Per-range page array management
>>>
>>> Patch 6/8: Add batch allocation function and export API
>>>      - init_user_pages_batch() main initialization
>>>      - amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu_batch() entry point
>>>
>>> Patch 7/8: Unify userptr cleanup and update paths
>>>      - Shared eviction/restore handling for batch allocations
>>>      - Integration with existing userptr validation flows
>>>
>>> Patch 8/8: Wire up batch allocation in ioctl handler
>>>      - Input validation and range array parsing
>>>      - Integration with existing alloc_memory_of_gpu path
>>>
>>> Testing
>>> =======
>>>
>>> - Multiple scattered malloc() allocations (2-4000+ ranges)
>>> - Various allocation sizes (4KB to 1G+ per range)
>>> - Memory pressure scenarios and eviction/restore cycles
>>> - OpenCL CTS and HIP catch tests in KVM guest environment
>>> - AI workloads: Stable Diffusion, ComfyUI in virtualized environments
>>> - Small LLM inference (3B-7B models)
>>> - Benchmark score: 160,000 - 190,000 (80%-95% of bare metal)
>>> - Performance improvement: 2x-2.4x faster than userspace approach
>>>
>>> Thank you for your review and feedback.
>>>
>>> Best regards,
>>> Honglei Huang
>>>
>>> Honglei Huang (8):
>>>    drm/amdkfd: Add userptr batch allocation UAPI structures
>>>    drm/amdkfd: Add user_range_info infrastructure to kgd_mem
>>>    drm/amdkfd: Implement interval tree for userptr ranges
>>>    drm/amdkfd: Add batch MMU notifier support
>>>    drm/amdkfd: Implement batch userptr page management
>>>    drm/amdkfd: Add batch allocation function and export API
>>>    drm/amdkfd: Unify userptr cleanup and update paths
>>>    drm/amdkfd: Wire up batch allocation in ioctl handler
>>>
>>>   drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h    |  23 +
>>>   .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 539 +++++++++++++++++-
>>>   drivers/gpu/drm/amd/amdkfd/kfd_chardev.c      | 128 ++++-
>>>   include/uapi/linux/kfd_ioctl.h                |  31 +-
>>>   4 files changed, 697 insertions(+), 24 deletions(-)
>>>
>>
> 


