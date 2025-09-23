Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 098F9CAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 09:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 524988E0014; Tue, 23 Sep 2025 05:13:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D49A8E0001; Tue, 23 Sep 2025 05:13:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 375348E0014; Tue, 23 Sep 2025 05:13:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D5C58E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 05:13:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9065B1DF4D4
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:13:55 +0000 (UTC)
X-FDA: 83919952830.30.C532087
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012045.outbound.protection.outlook.com [52.101.48.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id 99CF940005
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:13:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=JUlSIIiX;
	spf=pass (imf07.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 52.101.48.45 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758618832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EeksD3g/oFcW4irEoZhbSc0RdB6Zj473qZj7Uq1LQ3k=;
	b=Q0v56lRfl4I0usybCRAZlqXiqjRyLiZ/DwQvj2ygKzospnkZdB8xN4mXSvqJ+2Fp+KMrvd
	6atVwwRmO7KIPycCFpaoOFpSGOywhprjLW1Odcxadwz0tawTjVsQApMJU52X6MOJVhB/Lb
	kBHkoLZGOqJv7aodnKgFsu+k1uA0eis=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758618832; a=rsa-sha256;
	cv=pass;
	b=Q5pXGxc+A+xbqtYrNB9VSI1czXmnE849mFJxp/faC/cMgsCjRqhNUZIy/3xlHo/P9jBMR5
	DlzNLYcorJCuoa/LoQW/MiUtXVJqrLTQrYlZUgnaRHI5XfalkS/XtSGyHpYKFVQSjCCBkY
	jmgzMDDXMrdZBVjpxwdym4wYJl1by24=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=JUlSIIiX;
	spf=pass (imf07.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 52.101.48.45 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ucfyZBPdi8a9N7BSYVsgByC080ME4UnrXJaNMyTYX+zCsyiqm0E5e7vNow5M6HFaGysOvH/3gbsfK+sA98r/VgGya4mNWgYiUD1s7b0nUUDdcWE+R0H++Cws7o+koA3+BhXrioZKlHPFxaNzEiqYhV+ZfCq3Zts9IEdgHW3XpYjTZ0XvvYHrUl6I2mGGGXUkPjd7Qyp5wM0faf9E9jlQRxCquU86niav4fodpycXqJFOr8NC4QlmdWcKa3M93dYW3pFjMO+eUteQ8g1WhUxxGzQOnd4F0VupVLcrzIme4h3Fh0TmUD5VtAOAZ88mz6iMph02AWDVuxWUOVLuwnfJSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EeksD3g/oFcW4irEoZhbSc0RdB6Zj473qZj7Uq1LQ3k=;
 b=xAKQcVre9ZnSq6G55Rb2LkHzfJCVSfTRpqQCn+XbXeQ95jB7pW+fFQH8uMWr2T34VzElcMZE3ZG4g9Gkmk+V2lnvkQc5lqvVG6BMrzkfbnBiO/6Lf9NT95XqxTLZsYaTvLBRPa2jiJU8m9AfVjg1s2HhUNeTjLYqa/JkDrM3WVoGwiXBodVZ548GtnNlfr5H1wZt0J5jcxALRrg1sAUSOXzRSVu3+VyOGFtVa4fqlfsV2OBsnHXfiRKd0hWNSuDufwqmzJPzvx36Is23lGK1UwjaeE/5j1jyA605GzjC3lr5NNa7gMpVgigTP1gMLxXxvYa2wpqd84pWviMgJX7OSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EeksD3g/oFcW4irEoZhbSc0RdB6Zj473qZj7Uq1LQ3k=;
 b=JUlSIIiXI2JQ0+kDVKctc4uuBijsxQeT01f8m7TSGDexFRt24nY+B0iK1XKPZZXScUbcYuK6R7jOH2xXI7om6DdShg9BeWWA8Rlf1mh2f0V0/KSkNm6j/rLASxcm57CruUi+pZ6LTvWWnG6bis0i842HLEqr8oE8n7xmf6antrk=
Received: from PH7PR12MB5805.namprd12.prod.outlook.com (2603:10b6:510:1d1::13)
 by PH0PR12MB8151.namprd12.prod.outlook.com (2603:10b6:510:299::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Tue, 23 Sep
 2025 09:13:48 +0000
Received: from PH7PR12MB5805.namprd12.prod.outlook.com
 ([fe80::35dc:5b7a:52da:c8f1]) by PH7PR12MB5805.namprd12.prod.outlook.com
 ([fe80::35dc:5b7a:52da:c8f1%5]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 09:13:47 +0000
Message-ID: <d3c0edba-10e0-4335-8b62-0a2f35b686e5@amd.com>
Date: Tue, 23 Sep 2025 14:43:37 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 13/16] mm: memory: support clearing page ranges
To: Raghavendra K T <rkodsara@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 david@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
 acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
 willy@infradead.org, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
 <20250917152418.4077386-14-ankur.a.arora@oracle.com>
 <20250917144418.25cb9117d64b32cb0c7908d9@linux-foundation.org>
 <02da5912-b77e-42fa-be1c-d10c915730d2@amd.com>
Content-Language: en-US
From: Raghavendra K T <raghavendra.kt@amd.com>
In-Reply-To: <02da5912-b77e-42fa-be1c-d10c915730d2@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN4P287CA0112.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2ad::7) To PH7PR12MB5805.namprd12.prod.outlook.com
 (2603:10b6:510:1d1::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5805:EE_|PH0PR12MB8151:EE_
X-MS-Office365-Filtering-Correlation-Id: d7c0c128-49ee-4f45-e59f-08ddfa81805e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aGhlTXFueW1MeDFyWUVWRE5OTXpmanpJenZ5UzVSRldPbHU1bUFEQWtwRjkw?=
 =?utf-8?B?bHZKT25vK3A1ckVJYWc2QXRtMDdreHZiZ1hqUEp1OEY2RkprcmpGMDRoRGxZ?=
 =?utf-8?B?K0ZPRWFmbFlRTVgwbFd5MUtXbVVTTTBTYkFqZUZ4S1FzM0Z2WG42czYyK3dP?=
 =?utf-8?B?czg1aVo3WXV1TUNYTUl5YlNad09Md2VmVncxWDZYN0kwT0NxTkIwbFQxem8x?=
 =?utf-8?B?cFZwclNFeTJwUEFnOElSbTJFMC9qd2FzWG01MUJCcUNNOFJiN01VekNVZ01o?=
 =?utf-8?B?Q3YzUlM0cW9jNjBYZTUxeFBpYTA4T0pWMDRGcndQdlVNcndsRFRJOFhUNVdt?=
 =?utf-8?B?L2JGRTNmUTVyWmlUVHJFQVdaaUNlQkcrMUFoM0lpY2lsQTZvZGZDTWdqTGcv?=
 =?utf-8?B?ZThsTXZ4R045MUJCREZjeG1BYTRVZzlLVnF2eVM1eW0zY1R0bnFaTGYrSDRS?=
 =?utf-8?B?bVpTdXp1dFhOMUVhTHVpN0dWUjBmSUFIMTFyKzh0amJFd0R5NHdSVG9VSTVi?=
 =?utf-8?B?OVdmQjRmVzlqSVFYWEUvMGRTd24wd2ZQaVFmdnJuaVo2a2pmL0xpOEowcitD?=
 =?utf-8?B?REZNV1owMmN5VUNXR0FZYU5DRG5LbkYzQ2tqdDN2b3RhUjhId2x1eFVpYU1a?=
 =?utf-8?B?NlJvc3dsa1BjbktKTVRycTM5VlM5b3VVMGJqazdOekttY0xsd2tPV3kwazhY?=
 =?utf-8?B?b1BCeURIeC9PK0w5QVdOVGpKWXVpNHJac0ZQUUFCZG50MUtWcXBvRXJudXJy?=
 =?utf-8?B?Z0w2U2EvYWJKMmgrMjZHaWNWVzZ3MXJTMHlQN0s2NTcrcjNHdlp0TGxOQllM?=
 =?utf-8?B?cm9KNSt5N05ScWU0NG40eHJDaExYMVgzQjVxQmVYMSs1TUhNelpTOWFNRkIx?=
 =?utf-8?B?eXI2cHdYVEFWTzd0R1NneGd6U29sTisvdFlRcFJqUEJ1SU5lZjNtNDhWdTlC?=
 =?utf-8?B?UVphQmhPbGpRNmNhVlZFT1Y1eHJjTkFWZk5iTGljTDh2UmFvM0ZKaHpaaGJE?=
 =?utf-8?B?T2pJVVNyNDVGaVE1QXZJUjg0L05vZkJ1YXQvVmUyRTcrWTRtRi9rSkFrbnpX?=
 =?utf-8?B?eWJTWVRwQWlvUE43b1Mrb2hsdEMxdlhhY1FSYkpnc2NtYVRxOVM4S3BjRGJh?=
 =?utf-8?B?NlNJamdMbkJFUm1ydmt6blNjYzNBWmtYZDdjT0lRVytUVWJ0UXF5Z0FJMFJ0?=
 =?utf-8?B?TDZ2d3c1L0E3RVhReUdxVlNRMU4rMzhaQm82Y3UyQVErVkUydENXbWRpU3kz?=
 =?utf-8?B?NCt6ZmNBQWhMSDdPV3J2SHVtYUVmS1FmdTd4TW5FUEtzUDAyYVB1ZDNLTUZi?=
 =?utf-8?B?QlBzRjNRYlBITFlyVUJEV2pEci91VHlvY3BTRGdEN2FnL2JnY0J2dVNCZmcv?=
 =?utf-8?B?c1RlQ01mcHg1RE1OQlFIWlNvYTRQcERNbStrRXlacHpSZFZwQUNhcGFSTWFu?=
 =?utf-8?B?NmtOaGJ2TzFpSnNYWUJ2Yy9rcHlhYzU1bFBxaXhpQXozRlpaSUp5bzJvWGpz?=
 =?utf-8?B?cVJ5TlQ1Rlg3OCt6UnhReHJCTCtxVXBlS1BUemtOUVVJZzV2ay9uSDYxYVA5?=
 =?utf-8?B?WFhGWUZvdHR3VkxuZkRpT2NPbEJ4UHlPaEhhOXNzTGFOOGU0aWl6T04wZEdK?=
 =?utf-8?B?Z1dpd1ZSeHNOaUJBTy91WENLTU9MUmZoekZqQWFiYy8xcEY0VTBIYnpQT0gz?=
 =?utf-8?B?OVVqSlN3dmI2WmUwbUkyMnhNZWh1UVluRGR4Nm9Kd2hsM1Vtb3RUdE9jcjBn?=
 =?utf-8?B?TGQyMVMzek8zNTZqSGRra2c2RDdEOUpVT1NOeWtEb2JrRUdURFdTSTZXSkxT?=
 =?utf-8?B?NVh4elVqWlpLdHpyVUtNYW4zaTRWM0ZMZGlUM0RyZmtoNGpSQmdyamZ6d0Vp?=
 =?utf-8?B?NDZjRU4yZVhjYWpRODhmSFRiT2RyT2p6aGttMEFXMDBtSkxMZ1dZNFNlcG9j?=
 =?utf-8?Q?ekdpt7qe1yY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5805.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NnJZL3FmQk9VbGZFdWdZSm1sNG9SYXNSNlpKcDZsT0FPeko0a3dzQldYMFJl?=
 =?utf-8?B?elNUMDREbjUvQjkzaFpSYWNCcEEwSHovbE5Hc05Pam8zM0hJT3d0b2ZKWGkw?=
 =?utf-8?B?RWo4RkJ4WHVQSFFZZ0VZRGZPL2hvM1NjNGhHOFlsVVJ0dzJPNHh2SEV0VlRQ?=
 =?utf-8?B?eExUMGYwVHlKMnpNY0lUaXozQ0szUStTY3JlZUVRNFZFWUcwZjNPNXpPZ0NU?=
 =?utf-8?B?WThoK0liQVNoS1daZzNNcVFNRmtvVnBLVXNyWUM3b3cxYmh2cGNER1djRWZ2?=
 =?utf-8?B?NCtvRDFGVFRlYndnMUp0ZFlIMHRVM3FxUFpObVZHUFArazA0Q0Y1K3ZKRFZp?=
 =?utf-8?B?UlFtL1BsSEFEVDdxb0hTc2R1QzgwNEJoZXczS2FPeFI3ZzQyNlBqMFRaODFr?=
 =?utf-8?B?WXlENjdlUDhKYlJZVnM5TVRSRWViNTJBZi83NmRtaitXVjdISGdvdTRwTElT?=
 =?utf-8?B?QVR4TWJBL3BqSVgwU2xROTVyZVJUTVU3bHUrT0JFby90cHNRbEdxc2xkSGZy?=
 =?utf-8?B?WjJBWWxhWWhQbkxnTVhPdU1zZm0rYjMxRkNtY28zaTk1VzBpUzNyWmlraGli?=
 =?utf-8?B?cjg4SkRRYzkvR2lHRFNYYjdyRFJpSmtKL0FyaW84VkFrZFNpSS9SN2pZbkgx?=
 =?utf-8?B?NzFGdkVYTlRWWSsra2hPMEJ0a3orWU1aRlBseTU4N1pkdmZLNDlPa1l4L0tL?=
 =?utf-8?B?ckxHeThHclQyYjlRSTJkcW43LzFFT21rdFA0V1B6NHNrczc2NXJDS0JrcVlQ?=
 =?utf-8?B?RTZaMlI5YmR4Z2NIVFlFR0JiL2tIMUkyelZNK3Z6UWVjV09zcnM0V0tGS2Zn?=
 =?utf-8?B?Um9jUnZXTXd6TlVLZmp0TlpSSVpMYlcra2oraGU3Z1FvTUkwcjZvSVMyaS9M?=
 =?utf-8?B?dGtKUXJrZVErNml6TS81RE90UWNCem0yTkdLM1BLZkwyR3JxKzZPTXlDMDBy?=
 =?utf-8?B?Qng1Q3o0OW1URXg3RDc1OHBJdzQ4empVZEZ4dEp0ZFl0dWNweFdaTlFTSGdD?=
 =?utf-8?B?SjEzaFIxaGlmVFkzNW1PWGdSdmR5aGZnZnlDTmMxMlN6bVZRVjFFMFNqQ0pI?=
 =?utf-8?B?bWNKcWNWYUdBK0ZMQ0xoTnhqYXQvQ1duRnNPaGo5Q0FSVkRMdnR0MVR1Qll4?=
 =?utf-8?B?clJUcmlXbHJTR2JqbjFSR09jSXFaSDJwckc3T0EvSExwNDVBU3dhbk1zZ0pE?=
 =?utf-8?B?OVFtME1Udk95cE5Uay93YXYzWHorNkJsOVlhVVIvdG5FblpKTG5UcVJGSnVm?=
 =?utf-8?B?RDNuZ0RNaWk1VUxvM2Q2UTluQWlKYTR5cVJPMGI1YjNxNTRwRUZZL1g4Vnox?=
 =?utf-8?B?MUN0ZXFuNzlyM29HMWZDU1liYTNrUDRxZFlQNnlkRDY4MGpPZTlPN3Z2MExY?=
 =?utf-8?B?WEI5YXprV2Z6RGJiclAzZ1NPcDEwVlBjSUh5eTF3RUdweGpVeVFCZjVaMjha?=
 =?utf-8?B?c3U5bVpsaW1Ic3RTYzN3QzlkYWZCamI5TDg2c3hSMHFmM1h5VkxhQ1NBY3ZX?=
 =?utf-8?B?Z3pNcmZXQXRDYWprN29ZcFVDdmtveGhtbE82OTRIWW5tdDE5amlScnhHaUVi?=
 =?utf-8?B?dUNPMVhkZ2hTY2NkeTNRTVBaaUhPVFpsK0Z3U2xkeUN5c0hMYkxYbkJLQTZ1?=
 =?utf-8?B?ckFTditOaFJJdW1Fbk1Fc21PRXJ0WWRoaTZWRGY1UlJBbDAyOU9yOXMxSW5s?=
 =?utf-8?B?YmhWMWRlZDQ3NmhRVGFxSmVKMXJQT3oza29GWkxMUXRWUEthdjJtOXZxSEt2?=
 =?utf-8?B?b3pQRTJCMGpTTEdUUnNKcjI5UzI5ckpPYWo5Ymp4WmMzWXBrY1dvem5iVG8x?=
 =?utf-8?B?Yno3RVpUS3p4RS8vNkNBaHJXUVFjV3NHQm9CNWVtQS91emlYdk5pdkZWa0pG?=
 =?utf-8?B?T2I3UjJuaXNpRTREOGFrejhBS1EvbXZWVHhYT09VYUdxNnJVT3JkZVBOS2pW?=
 =?utf-8?B?dHhYaTRXMlFDYXFDMjdvSklQZC9vVHpOREhldFVqZzNRQzRnSHhNeWU1QTBB?=
 =?utf-8?B?SGhUcis5ZVQrWHIvMGtWY0tBQlUzdmdaaGVUSmIxaWdaVFh5UFFhMnpIQjRN?=
 =?utf-8?B?TmJNc1VQcEk5bGJ0MjhtMEFpTi9QdWNMSlRoaXhQR2hCWG13eElmZVFwQVdP?=
 =?utf-8?Q?XO5fV59actl+9rzAX4TBqJF1d?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7c0c128-49ee-4f45-e59f-08ddfa81805e
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5805.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 09:13:47.1537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sqnqXDs8WGIb2zlzEDaFpLN01KdM3emW+cWvGRfdFcernw1tdeGcbony5vtrDpjwloYC6deOb+20IsnlYt/lEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8151
X-Stat-Signature: 6qind1sjw9nxrm7oz6jadcb7bctqkdkp
X-Rspam-User: 
X-Rspamd-Queue-Id: 99CF940005
X-Rspamd-Server: rspam10
X-HE-Tag: 1758618832-698096
X-HE-Meta: U2FsdGVkX1+w5ec4JjWprNe4s8EnnUTzKpNwLwo+9gx6UUeOwOAowf5q7VBOqwiMADTpMLGUN/7Z3QObFDY767UwTMMoV2Cyv4c0ar59YvkltuDn3b1SXZtGRzQkfMki1ZUkL4c8utMRJXnPlmpEHOakhCaHnDornjKvD3ie1WtGFM3vfdY1/u8T/5zazq7GIjZuMaOmnA1dxUOl7Wpm8LL2R5Gyax4GFpJ4nZCfTtnYlGO+zX58Qx556TIcUeGV4WvLdldO6NSsTxWV5LqXR9iRO8rdgJgDttr1Jux/Y24R+OT/7bmB3sFaPbO63HiRC+K7uf8bcl6AEyuSeMnid+/NwDBZ1kYFWU9JXgTSqUFU7HAYjqF4B10CmTuSg74YPC3WLPyThPMWNSYUnlF5Y/aA1veb1CvVYfQ8IkrAmX3du1o266BPnJbeSuIDiKgZLjngrOn/1m6Ty8nSZhjdgkzSzFbIuDCLjrI+Tjp6XbKjWuJmvR2KvNEK3Ya5WUA687/6llnXedreXvRx3+4EEgFbhJDZI7iRdgPKIv9akWwnIT5Ow4CI1JqvzdR8kEz+C7bnppbgkwLE/h3qi8trSDoRb9ByIs7DWt3SU7r+dbgk9MigFoT9Mv92DOBMER6EBnWDmHrcH1XpPgaBJmcnK/QtIypILJidwHImgpNH5lGS6XI8D0GfNWOAO10e8CAHXPqo172xX3g2hIXYtczfksv384lPcfGvxxard528mw7AJA4C1l/hYCKQGw3igC6m7GoVCAsERkGMveYmATo+c5laLbth4vbxTiR7TU1rSL6dm8QrnwEzG54wbvuxpsczATtHwmAbKwUwrAIU6r7m6d5TX4RTIiNmWblXmIz+uGdIrYnMtaXycrU2KDiftKiMEUdMPf/ptTXH9faDgGtusCyvLJKckiLQS4ZaXud8CaMLWRUmDOabt0XmLtx/R57KIcbJ5gUwKPJ4WIPGmxu
 xJ1fDETQ
 oLbFGa3A82Wj5fKKiBUTYcPF5jcZK/rmzxgQGTY5TE4pY41ojLs8JOzlLGazx9G8sVkJfapZsn3KbIU00MaY6UiRTo2MAWIRzlsPlD6trg12yfArj130Opv57+pf7JTaLNoPDb7dibP2Geb3nmU4EuJ779XEnf1pZVGl2I2CzCd8B1JrAWN/YhpLX2n0+MeoS9uiWcJSXsEj/+a7Cvf1pRhRim4tKBINqr32oCnKvRaqOva8eoWXmA6xYsluKakvJ2nziWqxk8zknmb4Fxu0h2ASAZJ6RlsdhYXTykaUn+cL3ygi9NoOU0qQkU7td4q5YnNK2kyZVMVFS5OyLoTOzoe+F+5+cES1My1emv5+yY0cNeEPOPDAnucGjsCJpfO69C24t56bPlA6zjp+JTqWAgGtB9AYBDgSAS2Ae9KL9gqYlcjX5sFoQON+oVmX58PCv+BvcPvl0NaEg0O66xaWm6zaHtj3d6JhRNdTmA/Pka53ZMS95/Y8GoI0X/J4kzO/ltEqEWZQNq702SnUUh/+hjd3VHV/yqknXsXR0HoyefAadF+d9ChSMBIMZJBpl1dECbPNi8hEFj03VAW2vZfX1XUQ1YfwwiEkDJ1WnmsifyfgI6uXQECDPKID4FqR+63z5BMTVoSwhWCaHG2Q/uqgpFIyj3btBDyQbSfuTs2Nm7dLxxk17wAGwb9CnspqszctTTvsM0RCr/wu3fqnWZsfkYp24YqOFx/KazxgDs5C3eSLpth1QfuXrGXzUfXLS9Lxjz6EH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/2025 2:06 PM, Raghavendra K T wrote:
> 
> 
> On 9/18/2025 3:14 AM, Andrew Morton wrote:
>> On Wed, 17 Sep 2025 08:24:15 -0700 Ankur Arora 
>> <ankur.a.arora@oracle.com> wrote:
>>
>>> Change folio_zero_user() to clear contiguous page ranges instead of
>>> clearing using the current page-at-a-time approach. Exposing the largest
>>> feasible length can be useful in enabling processors to optimize based
>>> on extent.
>>
>> This patch is something which MM developers might care to take a closer
>> look at.
>>
>>> However, clearing in large chunks can have two problems:
>>>
>>>   - cache locality when clearing small folios (< MAX_ORDER_NR_PAGES)
>>>     (larger folios don't have any expectation of cache locality).
>>>
>>>   - preemption latency when clearing large folios.
>>>
>>> Handle the first by splitting the clearing in three parts: the
>>> faulting page and its immediate locality, its left and right
>>> regions; with the local neighbourhood cleared last.
>>
>> Has this optimization been shown to be beneficial?
>>
>> If so, are you able to share some measurements?
>>
>> If not, maybe it should be removed?
>>
> 
> I reverted the effect of this patch by hard coding
> 
> #define PAGE_CONTIG_NR 1
> 
> I see that benefit for voluntary kernel is lost without this change
> 
> (for rep stosb)
> 
> with PAGE_CONTIG_NR equivalent to 8MB
> 
> Preempt mode: voluntary
> 
> # Running 'mem/mmap' benchmark:
> # function 'demand' (Demand loaded mmap())
> # Copying 64GB bytes ...
> 
>        34.533414 GB/sec
> 
> 
> with PAGE_CONTIG_NR equivalent to 4KB
> 
> # Running 'mem/mmap' benchmark:
> # function 'demand' (Demand loaded mmap())
> # Copying 64GB bytes ...
> 
>        20.766059 GB/sec
> 
> For now (barring David's recommendations),
> feel free to add
> 
> Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
> 
> 

My reply was more towards the benefits of clearing multiple pages
for non-preempt and voluntary kernel, than the effect of clearing
neighborhood range at the end.

Sorry if that was confusing :)


