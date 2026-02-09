Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0E89EF06FF
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 06:15:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 406626B00A7; Mon,  9 Feb 2026 01:15:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DDA06B00A8; Mon,  9 Feb 2026 01:15:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 287026B00A9; Mon,  9 Feb 2026 01:15:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1272A6B00A7
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 01:15:05 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C4554140722
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 06:15:04 +0000 (UTC)
X-FDA: 84423905328.05.714DDA5
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012015.outbound.protection.outlook.com [40.93.195.15])
	by imf01.hostedemail.com (Postfix) with ESMTP id CD78240005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 06:15:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=lpmw3K0G;
	spf=pass (imf01.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.93.195.15 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770617702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3JzQa4vixQZoh052p7zChuyv8v5GkWGQOKG7p0CGLfM=;
	b=8AwV4tGwIhufd+HsFxgF+81aZHmp50OzPJUvXXu+Y2wsz70AD+e6rw8DBzowqxv8xQkWrz
	JIE8CeTvjm6rix5xChnqtmZSuDfCkTEhevC7CVoCgZ81JwJ1hE/0T5aNPPGfoSgLUjcDM+
	OEicr8LUH6gs7p4hLpU4A5nHIOe42jU=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=lpmw3K0G;
	spf=pass (imf01.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.93.195.15 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770617702; a=rsa-sha256;
	cv=pass;
	b=PoVMcfKMIZeOpnvenPnb4VoHbFVRozVsTnGbzp75R1rk061XsgoDnZEezK9giMYkmC5y+e
	utRk8TcYuCN6DOSzvUFH72BMH7NO95DxELQ2qwknIN/HWD4IdZ87F+ZqqOHqbZqQrFwC9Q
	jNvtjCt1kAKUHo2sJUdMeCSsQYv8Fyk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XayjUa+roZZcvTve2Z/OPXhdKa6NQ5dUWul9UgqvAmTsXfKGJYFcwemBFDAW9TWQT9bNh1cQpFJq/l5mggpuNFCnLDxW5vB+FIqnU1jBLTTpUCQOLkixGjtzCPL4QEB25IWeAZzqZcM/vzJo5z9C4ipan9ugEuQm36roFyo300xwfHM7rJ02tQtmy0DOQNQ0vtYgBBo4xcCsjaYUpvHcWtypdVa5GPqwl9nR8fyRYRy8ZZS5vd7E+bAF6W4eOAvo4hM1un6P6uxQG6RAUBY4jCnYsgm29XJDLWn5QiIkOW1Ju95PHrnk7swqvJMCmDe/53qB3q+Kq/LmcMkgCXuQfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3JzQa4vixQZoh052p7zChuyv8v5GkWGQOKG7p0CGLfM=;
 b=coc2YISuCAKv5Lz251xl+rTLMQNponsR4YC7JJsxr4lOzXrrd3I1Xsbu4xtTnHVSniDUew7F9l+5iHY8r7R8GwO8DIZdkrKuAKrj7rv/TEk0Rl/omc/5+8NW2uD9KBtP/JsfcrkXmqb2z0CnLMbG4ccLoWzwemPI4irTVOCjzpbB9XtlHO1jaWRr4JI02xeZXq4MYWg0wC2Ijw0H7swaqDT4J0ryyT8XThD+HVjXwJOLnmRET/Lsthpoxo3byORW2ivL6yLVyOrBRLgBIgrJjVhpSaxN3h2a13BvSlzMyoI5x+NqeIzD2OORWWrye8/o/yqnwfu7V6yWECqIvEmy1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3JzQa4vixQZoh052p7zChuyv8v5GkWGQOKG7p0CGLfM=;
 b=lpmw3K0GAetCAxTjf94aN3eFiTgdrdn6GFeKeJ9RUvpTLUrP9Vky3LlRRSzvUo4dNUFXa8EJoWMfB1c8ubuoc4VSJZTCCRLGo5fgdLv5KEX62FfG9dkeVUHjzROHZy7V6gccOkx9xoBjuRvbPqlOLVwHTitkrrtYT7GTsiWseQE=
Received: from IA1PR12MB6435.namprd12.prod.outlook.com (2603:10b6:208:3ad::10)
 by MW6PR12MB8705.namprd12.prod.outlook.com (2603:10b6:303:24c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Mon, 9 Feb
 2026 06:14:56 +0000
Received: from IA1PR12MB6435.namprd12.prod.outlook.com
 ([fe80::8b77:7cdb:b17a:a8e2]) by IA1PR12MB6435.namprd12.prod.outlook.com
 ([fe80::8b77:7cdb:b17a:a8e2%5]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 06:14:56 +0000
Message-ID: <8ba8e4f2-89f2-4968-a291-e36e6fc8ab9b@amd.com>
Date: Mon, 9 Feb 2026 14:14:47 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/8] drm/amdkfd: Add batch userptr allocation support
To: Felix.Kuehling@amd.com, =?UTF-8?Q?Christian_K=C3=B6nig?=
 <christian.koenig@amd.com>, alexander.deucher@amd.com, Philip.Yang@amd.com,
 Ray.Huang@amd.com
Cc: dmitry.osipenko@collabora.com, Xinhui.Pan@amd.com, airlied@gmail.com,
 daniel@ffwll.ch, amd-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, akpm@linux-foundation.org
References: <20260206062557.3718801-1-honglei1.huang@amd.com>
 <da75eadd-865e-41fe-a86b-ed9d9aa45e5a@amd.com>
Content-Language: en-US
From: Honglei Huang <honghuan@amd.com>
In-Reply-To: <da75eadd-865e-41fe-a86b-ed9d9aa45e5a@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1PR01CA0087.apcprd01.prod.exchangelabs.com
 (2603:1096:820:2::27) To IA1PR12MB6435.namprd12.prod.outlook.com
 (2603:10b6:208:3ad::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6435:EE_|MW6PR12MB8705:EE_
X-MS-Office365-Filtering-Correlation-Id: 32b5806a-8c1b-4aac-063f-08de67a28b7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dXVJZHlXNUR6K2s5R1Z4WWovYk5VbW45dmQvQ0dsaFF4NDU2NnpqZ0ptRzI3?=
 =?utf-8?B?eFRyT2k3NkRkWWw2dVhZdllwRTI2b3VpWFd1b0YvZ0xqZmpMU1lFSVdWUnRD?=
 =?utf-8?B?cE9pRUcyR0dERy9Vb09tVVR4a2dJWWlING93Ri9OVFpUSW1idXF6c0MxVmcz?=
 =?utf-8?B?M3hBcUlXZ2RqdzEzWTgyN0xuQVZaN2l3ZE43RXRLaVdESFp1RGhXWGFzZS8v?=
 =?utf-8?B?NWdITlhkNjFId1hyd3p0TFpkWUdRSXUwSjlXMjJyNDltMExXOGJZRGZydlgr?=
 =?utf-8?B?VlVKT3h2THI0cTZKbUdSakthWTJzc2gyaitrOTA2SWJUalg2OGx6Z1VVN01Z?=
 =?utf-8?B?QTNnaHBpbXMvaGhtaGJ3QjM1MjBiLzdwWmJzUlNocUdvT2h0OEcvRDY3WFd3?=
 =?utf-8?B?ZW83SVhvVHRsV0tnOFZQL1c5QUNGdFUyMFBOL1BuL0R5NkZ1QVowc1RtdnY1?=
 =?utf-8?B?RExNd2VoZnk1cEJkQzJHNXhMWXdHVE13KytxVThSdDdTS0RET0ZmSzBIbk9F?=
 =?utf-8?B?UzhaZEpicCs4VDljczV1TlFicHpDd1Zac0tQdDdxRDlxeUNLbytiNWIyd2RL?=
 =?utf-8?B?UDhBWE5tWk9PUFAxaUljYUlvNmx2TUQyRUNnS2ltcVpTb1BHTnp2MnJ3NDhT?=
 =?utf-8?B?TnU4WmQyWlNPcWp4c2cwSktnWkxlK09lQ3Bpa3ZSOVQxQTI0NlFjSUVyZllz?=
 =?utf-8?B?b1BOemp1MGMxUjliQ3ZjQ2RoZVVBWXVIT3BPL1JQU09sbklLVE5tSnJ6UU8y?=
 =?utf-8?B?ekZnVDJ1aERwL1dJVUE0Z0p5QzJDRmN2a3Q0WC9CaHN2bklZMk41UmY0NDhu?=
 =?utf-8?B?NXo2ZVE4cUN4NEdnUGRERnpFK3FVM1M4YUt5ZVYxTUpFVndsaTd1NTEzRnpK?=
 =?utf-8?B?SDdlOU1aVVlrSTlMeVRYTlAxTnA3dnI5Nk5NWmdIalpHWjVpZlhPTTJvOTFB?=
 =?utf-8?B?TEY4Q0VRcWVCY1UrSGdRdmtaSzJ4WG9BN2gwanJrSGJuUUhSeGtOK082VTVx?=
 =?utf-8?B?ZVlwMEMrVzhzZkZnaEhPRFRpcHF0UHFZTHIwMFV6cHI3MEs3UzlMZVdaMHI0?=
 =?utf-8?B?UDJrRFJWeDlGakZhSUU5dGozSmc2MmpUaVVuL243VHdoUjlsL0ovKyt1QlpP?=
 =?utf-8?B?MHliTEJjQTRHRkJ2UEJ5MEF2dk81L1UrVEFkWG50cEFCT25MUjNXcENSU1N3?=
 =?utf-8?B?aHNwek55Um13SDdIWGpiZlBRcTFJT1FUYndUQ3Nlc0RpSmdrVTkxQ09WSXNq?=
 =?utf-8?B?Rk96d0ZNbWcxQ0l5b1RjaFlFa2x6clNmbDl1eUp3UUtnTmd3Z1kzbkRCa1dN?=
 =?utf-8?B?VUJaV2VxYno5dmVLWi9XNm1LRDE2c2ZrQXhQUWFmOUhhaFVTbmYyS1FmQXVk?=
 =?utf-8?B?UU80MmdJUXhRMzBBcmNhUERBMTd6cDg1aldCRDRGMWZOR29FbmpMdjIxdG9M?=
 =?utf-8?B?aTMxSUdKamgrZHphOWQxN3RGY2ZTL210Wnl1VUhaTCthdG5MbWI4MytlSzU3?=
 =?utf-8?B?dmg1cFppREpCV1lDb0RvVVVEOVY5V3VZT1kwVkFmWndDTGpFRzkvcVJQRC9X?=
 =?utf-8?B?WWoyTkNGVTNTbjBLQVpXWHUyYnhBdXFJZGF2UnNVYlZtRnlxMlVXWXhCa25I?=
 =?utf-8?B?K0g1QTMxN3p3Z1RMcG42UWJxdmJJNUc3dUlFcUkwVTB1Mml0aElaREZ0RWRx?=
 =?utf-8?B?WDdVVmlHS1JSNXhxUy9WY0lRb2xRdWVJK2VETjVlTTRpeHgxRkw1eGYwMTVR?=
 =?utf-8?B?Ull0TlNMTTJ4dFFycTFaVTk1MnEzU3FFUFFZMmlOWWtjTnZOMGt1Y3ZXdnMr?=
 =?utf-8?B?QjVNU0w5QytQckJPRlRvZDlONnFoZmREdFpxSU9ROUtqZnFzOTg2VGJxSW02?=
 =?utf-8?B?dnplcjcwSGNIeVlTVksrQlM1NUdvVTVRWVBKWm40QXRxc2x5bjlNanhTR3hI?=
 =?utf-8?B?blZNUEp5b01Kd2dIRkxtOGdyMVB5TXBJbkdSWHJ5ZU1RZHIrNVZneEpQRFQ4?=
 =?utf-8?B?THZoVjFaeFUvUmlxOWtRQVVnN1l0YmZOTVVEMHZYMk9FeVhBRzZaZEVRdmZv?=
 =?utf-8?B?ZUxTYnN4aTM5VTVPOEJiWkNJeUNJWjhXUlpkeVZJVVRLVm5FaXVjSnliUk1S?=
 =?utf-8?Q?rang=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6435.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?LzZ1WTBjak1waG9HSGNWTmRWMVE0eUhnT3p4TVZuR2pnajEzWjY1dWlXako2?=
 =?utf-8?B?WVgwYjQ4T09rVjI2NWxYNytmNUxJMDVFUVZrNTIrWTVIczY4UGlDcTZ6NHYw?=
 =?utf-8?B?SlpTVzM5N0xFak14eW9ZL0VEbFM3VmM0eUFjMFJHdzM1d1J4eGU5dDJiSGJH?=
 =?utf-8?B?Y2p2aEdDWFJodDNmSklURkZUQ0E4Rm04ejlhWGUrK085emJKQlFaNnlObW5I?=
 =?utf-8?B?R0JMRElIZ3I5RW1FOTF0SC9DSHh1RDhkWXpDQnMyWmZMSTZVUjBhT1psZ3I2?=
 =?utf-8?B?ajdVdzZJVzdSYlNEMVU4RmlkRkVxampXSGdYcXNQWUhMb0NxUytTVTVuS3Z6?=
 =?utf-8?B?RVNQSmpFSHlTOXd4WUE4S3BlTTBZbW10MFJkQ0V1a043MWFSdDVyazNwMWl1?=
 =?utf-8?B?N2hFd2tud25TSEhjOEtwV0lXcDhtTzNPOUpMR01XdlNreEtqSVgvM2F3MnVB?=
 =?utf-8?B?VmVicGc5QzFpampSU3pMZitZZ0hRb0lvQVFhMUUzT1NxQmF1V0xSK3lVMENU?=
 =?utf-8?B?UVUzQ2Q3d3pYR1FqSkpWSHAya2ViZGV3L21ZWWVuUHhHTUZUcjMrWkFHWkJR?=
 =?utf-8?B?cE04T0E4Z2RJbTQ0RlVPdk91SFdJMEsvc3VkclZMN0dYcmNybjkxQ1pNeThu?=
 =?utf-8?B?SXB1Y1RrMU9hczlqaWZBZWF5bG5VMk1oVG45eWZTUGhOSTdsSnJGczJuTXJN?=
 =?utf-8?B?aUZXd0lrM05XMExnOTltWllDNTlNTGM3ZjVxUDFIU1R1Nm9CSExNOXJ0bzJx?=
 =?utf-8?B?bDViWnlTVHJyeU1YVVNhS0pEYkh4K0doTG5ROXl5TSsxYU8vc0FtWHdaNDdZ?=
 =?utf-8?B?WjA4R0xYYXBQbFVMTzJmR0k2Z0FrRG9yUDdRUkswME5RSy95Qi9OODRRU1hG?=
 =?utf-8?B?ZkxRSTRTQkhyRStIRTgxZVpkbUtzUWRGTjFHS2h0c0ZkVUZVT1grVStyeCt2?=
 =?utf-8?B?UXZDMHY2ZDBzNUlpUWU5cGlxL1cwaDZQZkVWNFNnS2JJTDIwWWZrSkxURDNm?=
 =?utf-8?B?cE54SVFlbVB6T1ZYTjRwYlVGZXVobnI0eHBlY2R6Z1ZQMTU1cEdDZjlwRHZC?=
 =?utf-8?B?Sm8vbDZzNmtLeHFGSkJqQ2Q2dXdwMHRaL1h1YmtXK2xiZWFEOXRKN1BhVTVy?=
 =?utf-8?B?aEErcHBHUVYrSFFpVXZiZXBQaDBYYXdxcVFLR2NiTHV3aU9YYWRydFVWbyt0?=
 =?utf-8?B?emJPelpWaDg0Nk4wVnBFUGp4c3E0RXl4a0Qwdk1PTXRYMEhPNUc0NS9zNWtm?=
 =?utf-8?B?cVFCTzRhMDgzWi9rVTRSWWJuRkUxRlJGQW9aOGI2VzJNQ3lVV1ljZTRBaTl2?=
 =?utf-8?B?R3lvWUlYOFFoeGVVTVg3UEt1VEdYcE9jUWxoR0hyMnlhRWEwYUpVYzA2U0xT?=
 =?utf-8?B?WlFhcWxGamNpRnVPMitTQ2ttbkZUWnZVZlNqU2RLR2RNdjE2NGtNSVlQM0Jy?=
 =?utf-8?B?dVBwTVBIcWJENVV2cUl5bEQzaUt2RVQ0TkRpRG00bERmUE4wRW90QVN1QlBG?=
 =?utf-8?B?djRmNzNQYWEwWFBMcVY2RDYwTGVGYThDY0tQdkgxcU4rQ3ZxV2Jwb2w0ZVJB?=
 =?utf-8?B?QnpLK3pmOUduMmdnWjZYVGhNOENnOHRrUlRBa0lDVno0aCtleTFCRDU0NGx5?=
 =?utf-8?B?TGRzdUFPa3lBSUNOa0h2cmdGNzd6cHhnK0tOdExwaUZzNXlOdUFPMHVINTF0?=
 =?utf-8?B?R1ZjSDNhekN0d3NURno4TXlKUVc1eXBDQnJha0VpM2JJTWlXNExiMWhFVnpH?=
 =?utf-8?B?U3VFZTVkaWowOG1yTWsxTFVwTjNES1ZicTZVb0V4Q2dWVVpZSGpiZXBTMjU0?=
 =?utf-8?B?WkMwN0tHTHFUVWJzaTFNVEI2ZzdVR3p0Qlc3YkpwbjNjUmpRNXlzU1NmQTVq?=
 =?utf-8?B?ODB5VTdYc25wMXZVWDRBOW94cXlXd3JhZFp5L1NBYWsrZXBkeXNIOHN3eHk3?=
 =?utf-8?B?cWN4UEc3VVNWallSdEVKZUZRSmx6MnV4dWJnbG1xV1JiZ0t2UVA1anhCTC9i?=
 =?utf-8?B?U2QyTGdKQ29valFZT2NPalRuWjk3bVlUSlVWQ3o5R1diRjREenNGcmJKaXM4?=
 =?utf-8?B?aStDb3JKUEhWaHdJRHRLc21tMjVXeFpJRFpkek40U2FTSDdwZTc2Yy9xSlRn?=
 =?utf-8?B?ZDJZYzVFemJhY1ZzdkhwbWlWbFdyZ200b3BZbHVyN1hoQ05xbE01Ull1U3Uy?=
 =?utf-8?B?SjQ2S0tIWHkrMEtGSGsxd2JGbU94MlcvbTVrRkxRbHZyT1kzNmJDYmNldzFT?=
 =?utf-8?B?QkN6Z1Y2cG9zUUUyZVE4bVRCYm03Tm5Bc2dXQmk5UU9TdG9hQ1JobU5zdmY5?=
 =?utf-8?Q?qQx2vP8mmsLmZz/RvC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32b5806a-8c1b-4aac-063f-08de67a28b7f
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6435.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 06:14:56.3267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zX43bT4aqdS0DBVdLDvegBxbTIEyupsPDKgB6XgQCnAmhmbscqLqi24e8QDUGvxAeflXy9JMxaqWVubSkDchkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8705
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CD78240005
X-Stat-Signature: 3cbrb79bmoexfmp9ar5r194g76r9qja7
X-Rspam-User: 
X-HE-Tag: 1770617701-907223
X-HE-Meta: U2FsdGVkX1+Ygroj7tgkYDMqtWXrsh5G4so/1I5lOeTdEi6TwsOPyX8FVvMdabc6pkhcHKO3TBsFbF3QUeuQSznxAYziogvi4S3pIYlS9/LEBk+vR145MB62hn2D1oGhTsQPbrExjgjee5qHAc0NRVxiIjZrAsFKKiOdi+mHdG2Qvuq02NDZKG0TF5tMJqXKM3Pj2fL/UKzPxJ56caPvsWG3Q09kx1ZN1uF1E+btXjgEZ/2sbi7i7T63QHX8BIwduC0lNfOczipgQdT9KY4DA1fi9140WeAkuAD8YHbr+xPq3YXmYfssygmt48z0DSa94SodzbKM1dHUncfXX151IfvAg0Y/D9zfsNNCIYYby+MPIH978K22O7JgjLsu8gnZ7ZaXAzHCW6QeAZOLNY+2wS6ZiCbPCLC78CnGoEDPF1qypoggmrrCoY1uXPE83NHbBvuqA325MSI0fXwQ2ITdiJlOVisnx1TkubJX5/XSWbndizno/Igso4glHCxWQFp9LI5TWLrniNaoXXwpqPjdzWCa6tYA+ITT8XlswLe+3GosIwpfTdBe8jjhd+9gHUIWkiGc+6kjO2kGx+sBxlQVWT9lkR8k2GyTS7x/X0rJu4TwJfNFN6lR/lnJ5B8LWSedZq5YEY6KEYdGfs6+RUBdE+WzUD9/shCx+l7gWj63orxlQYVc1THggthaFw3X63vkBiJABt2OfxejfyAVNUwZo7uuSltUgocG2ohm+Dd4GxoTxrjVXB4Bw8zSvucOqHLqLPVwYOI9yCD6DXlHUN/dy5B2xAe6Bunr2zvfFL2szJzv2I9g+UYSEfITzDn9NoNOfXIYLsqWlF00ygi/kwdUMQdPz3/TeSQE8pperbtL3DjWFXzfSUm9hBeQu2rpe5MJw4zmGSaRyoSQX398Sf79fge2OTNwOa7D2qDbS+eMdXQbxXQjpQKs6VhXQI/oc7LN8Evx9LOZaDpA9sSPxPe
 9SCtFnLs
 9Siu3TmhLP3vCiuqbVxtHTZY8NooGDfyXJXnL8k9/4IcXXhF24GIv0yt9DxEQY5JE2+0gvm8H6Pg+6BnuMBRnYAwoPqU5tYwdQti0hY3Ony3O8lJd9iMjA9ubokC9uIaWZoSmJGYA5sLGjoYWjwpbvDOvhofEriq+UBPtz4ILrNJNgF3fom71KrJLJUsEutdJ7YH3ERWC9zCIiouExDkmq2fCVGIDGb94kRt7Q3N9uQJd8m7kT2pl0rQrBJXcb4DJ47WLRw6RKj+nv+Yj2sxkXz+LukICrh0g1OgYpG3pFft4a03Xy6csLDSB2/h+dI5HpwvnGAAIrpICMiWNkjKveJoKGkQaesi5uON+j/aC7FIOHfwAFoBeRw8A3nOdRcnnnCv1OyNOnC/9zD5QFMsB1lb3Kkz11hjpD0Ds3CmPlEaiasBMOxEQsVrHcVvmZFpwT4rYC3KS1vUriWD7WBV6p8Ey+IMuAf3phZkXxRbNzQgaMDIitx08Ug/9hRY8MXAEjgOl763WzQAnOcFC1VXZZXdTUActsLXiFgkhVn6//bJXj6e85OJUH+0OlODMPnsMiZA9O1OJjMsQJofE5K+HIw8lmA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


I've reworked the implementation in v4. The fix is actually inspired
by the DRM GPU SVM framework (drivers/gpu/drm/drm_gpusvm.c).

DRM GPU SVM uses wide notifiers (recommended 512M or larger) to track
multiple user virtual address ranges under a single mmu_interval_notifier,
and these ranges can be non-contiguous which is essentially the same
problem that batch userptr needs to solve: one BO backed by multiple
non-contiguous CPU VA ranges sharing one notifier.

The wide notifier is created in drm_gpusvm_notifier_alloc:
   notifier->itree.start = ALIGN_DOWN(fault_addr, gpusvm->notifier_size);
   notifier->itree.last = ALIGN(fault_addr + 1, gpusvm->notifier_size) - 1;
The Xe driver passes
   xe_modparam.svm_notifier_size * SZ_1M in xe_svm_init
as the notifier_size, so one notifier can cover many of MB of VA space
containing multiple non-contiguous ranges.

And DRM GPU SVM solves the per-range validity problem with flag-based
validation instead of seq-based validation in:
   - drm_gpusvm_pages_valid() checks
       flags.has_dma_mapping
     not notifier_seq. The comment explicitly states:
       "This is akin to a notifier seqno check in the HMM documentation
        but due to wider notifiers (i.e., notifiers which span multiple
        ranges) this function is required for finer grained checking"
   - __drm_gpusvm_unmap_pages() clears
       flags.has_dma_mapping = false  under notifier_lock
   - drm_gpusvm_get_pages() sets
       flags.has_dma_mapping = true  under notifier_lock
I adopted the same approach.

DRM GPU SVM:
   drm_gpusvm_notifier_invalidate()
     down_write(&gpusvm->notifier_lock);
     mmu_interval_set_seq(mni, cur_seq);
     gpusvm->ops->invalidate()
       -> xe_svm_invalidate()
          drm_gpusvm_for_each_range()
            -> __drm_gpusvm_unmap_pages()
               WRITE_ONCE(flags.has_dma_mapping = false);  // clear flag
     up_write(&gpusvm->notifier_lock);

KFD batch userptr:
   amdgpu_amdkfd_evict_userptr_batch()
     mutex_lock(&process_info->notifier_lock);
     mmu_interval_set_seq(mni, cur_seq);
     discard_invalid_ranges()
       interval_tree_iter_first/next()
         range_info->valid = false;          // clear flag
     mutex_unlock(&process_info->notifier_lock);

Both implementations:
   - Acquire notifier_lock FIRST, before any flag changes
   - Call mmu_interval_set_seq() under the lock
   - Use interval tree to find affected ranges within the wide notifier
   - Mark per-range flag as invalid/valid under the lock

The page fault path and final validation path also follow the same
pattern as DRM GPU SVM: fault outside the lock, set/check per-range
flag under the lock.

Regards,
Honglei


On 2026/2/6 21:56, Christian König wrote:
> On 2/6/26 07:25, Honglei Huang wrote:
>> From: Honglei Huang <honghuan@amd.com>
>>
>> Hi all,
>>
>> This is v3 of the patch series to support allocating multiple non-contiguous
>> CPU virtual address ranges that map to a single contiguous GPU virtual address.
>>
>> v3:
>> 1. No new ioctl: Reuses existing AMDKFD_IOC_ALLOC_MEMORY_OF_GPU
>>     - Adds only one flag: KFD_IOC_ALLOC_MEM_FLAGS_USERPTR_BATCH
> 
> That is most likely not the best approach, but Felix or Philip need to comment here since I don't know such IOCTLs well either.
> 
>>     - When flag is set, mmap_offset field points to range array
>>     - Minimal API surface change
> 
> Why range of VA space for each entry?
> 
>> 2. Improved MMU notifier handling:
>>     - Single mmu_interval_notifier covering the VA span [va_min, va_max]
>>     - Interval tree for efficient lookup of affected ranges during invalidation
>>     - Avoids per-range notifier overhead mentioned in v2 review
> 
> That won't work unless you also modify hmm_range_fault() to take multiple VA addresses (or ranges) at the same time.
> 
> The problem is that we must rely on hmm_range.notifier_seq to detect changes to the page tables in question, but that in turn works only if you have one hmm_range structure and not multiple.
> 
> What might work is doing an XOR or CRC over all hmm_range.notifier_seq you have, but that is a bit flaky.
> 
> Regards,
> Christian.
> 
>>
>> 3. Better code organization: Split into 8 focused patches for easier review
>>
>> v2:
>>     - Each CPU VA range gets its own mmu_interval_notifier for invalidation
>>     - All ranges validated together and mapped to contiguous GPU VA
>>     - Single kgd_mem object with array of user_range_info structures
>>     - Unified eviction/restore path for all ranges in a batch
>>
>> Current Implementation Approach
>> ===============================
>>
>> This series implements a practical solution within existing kernel constraints:
>>
>> 1. Single MMU notifier for VA span: Register one notifier covering the
>>     entire range from lowest to highest address in the batch
>>
>> 2. Interval tree filtering: Use interval tree to efficiently identify
>>     which specific ranges are affected during invalidation callbacks,
>>     avoiding unnecessary processing for unrelated address changes
>>
>> 3. Unified eviction/restore: All ranges in a batch share eviction and
>>     restore paths, maintaining consistency with existing userptr handling
>>
>> Patch Series Overview
>> =====================
>>
>> Patch 1/8: Add userptr batch allocation UAPI structures
>>      - KFD_IOC_ALLOC_MEM_FLAGS_USERPTR_BATCH flag
>>      - kfd_ioctl_userptr_range and kfd_ioctl_userptr_ranges_data structures
>>
>> Patch 2/8: Add user_range_info infrastructure to kgd_mem
>>      - user_range_info structure for per-range tracking
>>      - Fields for batch allocation in kgd_mem
>>
>> Patch 3/8: Implement interval tree for userptr ranges
>>      - Interval tree for efficient range lookup during invalidation
>>      - mark_invalid_ranges() function
>>
>> Patch 4/8: Add batch MMU notifier support
>>      - Single notifier for entire VA span
>>      - Invalidation callback using interval tree filtering
>>
>> Patch 5/8: Implement batch userptr page management
>>      - get_user_pages_batch() and set_user_pages_batch()
>>      - Per-range page array management
>>
>> Patch 6/8: Add batch allocation function and export API
>>      - init_user_pages_batch() main initialization
>>      - amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu_batch() entry point
>>
>> Patch 7/8: Unify userptr cleanup and update paths
>>      - Shared eviction/restore handling for batch allocations
>>      - Integration with existing userptr validation flows
>>
>> Patch 8/8: Wire up batch allocation in ioctl handler
>>      - Input validation and range array parsing
>>      - Integration with existing alloc_memory_of_gpu path
>>
>> Testing
>> =======
>>
>> - Multiple scattered malloc() allocations (2-4000+ ranges)
>> - Various allocation sizes (4KB to 1G+ per range)
>> - Memory pressure scenarios and eviction/restore cycles
>> - OpenCL CTS and HIP catch tests in KVM guest environment
>> - AI workloads: Stable Diffusion, ComfyUI in virtualized environments
>> - Small LLM inference (3B-7B models)
>> - Benchmark score: 160,000 - 190,000 (80%-95% of bare metal)
>> - Performance improvement: 2x-2.4x faster than userspace approach
>>
>> Thank you for your review and feedback.
>>
>> Best regards,
>> Honglei Huang
>>
>> Honglei Huang (8):
>>    drm/amdkfd: Add userptr batch allocation UAPI structures
>>    drm/amdkfd: Add user_range_info infrastructure to kgd_mem
>>    drm/amdkfd: Implement interval tree for userptr ranges
>>    drm/amdkfd: Add batch MMU notifier support
>>    drm/amdkfd: Implement batch userptr page management
>>    drm/amdkfd: Add batch allocation function and export API
>>    drm/amdkfd: Unify userptr cleanup and update paths
>>    drm/amdkfd: Wire up batch allocation in ioctl handler
>>
>>   drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h    |  23 +
>>   .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 539 +++++++++++++++++-
>>   drivers/gpu/drm/amd/amdkfd/kfd_chardev.c      | 128 ++++-
>>   include/uapi/linux/kfd_ioctl.h                |  31 +-
>>   4 files changed, 697 insertions(+), 24 deletions(-)
>>
> 


