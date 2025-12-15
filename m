Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01630D5B16F
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 13:31:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEF936B0006; Mon, 15 Dec 2025 08:31:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0D46B0007; Mon, 15 Dec 2025 08:31:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D67ED6B0008; Mon, 15 Dec 2025 08:31:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C2C576B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 08:31:02 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6CF5C160222
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 13:31:02 +0000 (UTC)
X-FDA: 84221791164.12.70BB513
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010012.outbound.protection.outlook.com [52.101.46.12])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2549B20014
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 13:30:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=u4DyCTP9;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf13.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.46.12 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765805459; a=rsa-sha256;
	cv=pass;
	b=I09F1xIUbPcIVsLezz6E2tS9iBjBYOL7kiM04/Ip0FakXcXHkEXZoulwHNfLMr+F8q0fk3
	wg2I44kprso8Xf2KdxENLkLD5Jdz1GTDQjk6GE86NDiBcRQLpRlC/50JA4e14pcVmSVhI9
	1c9V+4RawQS6SQ9EgB3y52V63T2F/q8=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=u4DyCTP9;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf13.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.46.12 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765805459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dq7+kbXQkX8gpVf9I4I1oRW723Ia/Zm5HMiHILEP7nI=;
	b=8Nzxgbq3+gA9dL/g4iOgS2nCPbemf/RWNfToG+PqKN+g+J3jBpLWBhrKAGKcYUeSA2257j
	epZQhAuWHYnjyqiAMD4/rOAB39KRDju2wSLH6rPJSpPBV1c1JtBDFFIVVp4v+YLZxurraR
	EMxgV4jTYnWu0MSmun+PAmthW6lLmjg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E1VtRKedImpj4Z2Mrc4y8GyZOGuulFh9srNU9Lx6icMm//7oY1S3jus9c4by72XHVnqjLKbGMJOm2Z0XEhXdbsCiY3DAoRGhI83dv5XLOHTslR72/JFc2UyzxBNj60Rd11u8uUjteRbNduBtQxMsKgIfbNIh5K/n8ibdpsOibvt4u81JRrGDg2rkSUkbCElI7bAIs4vJvhHN10yCHG3wiou9C7M775slnJ8fu/NV6NtzU3IsWkqao1hB37c/SDQN6XJpymRZhoCBBa9D/bQuV4D+8Sv1rl1yiaxIwxll9/ufuaLcQRcUuKOxEHGYyypWVPMee30sVENpcDtVwVovNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dq7+kbXQkX8gpVf9I4I1oRW723Ia/Zm5HMiHILEP7nI=;
 b=hfzvPMEwspg73KDfu5pDbhcJ6pw9cbJoxL5+ZhcMGcialiBrAL1tnMi0LcC77fNAw2ipnz0fQoXQx+RBth374NAnwNQBuQlVfwEAyd0ItkLN7JXIK39dN6daJSUhvqzsbmUKpGCKZ8du4oyrcJZEEwOVGrZGY47pOUsJ1HOsTf5NZXujOoulItP9nlXNIPNvh7GLM/S3U7zALEhPUyNlLG+dQ44FvmNZDKLonmRiXcT+AVNU8IN05DMd0ye7IZ9J/hk5u6hA+Haao74QAD0VEB0o2+p90j+vSSYDyj+iaZ5dqLNVC/FrswGh1mWoJpVtC7sohhVLfKWrzPKxEEe28w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dq7+kbXQkX8gpVf9I4I1oRW723Ia/Zm5HMiHILEP7nI=;
 b=u4DyCTP9OkkJjMs7hdeZ8LQRL4Qr5uYo1hLpkpmR+8cNvvjV7d0LcpoQ8Awpjd0eJT9xc5wwtcaAHTpnFH192Fhl8IxBOcYol9To3KYUOQZB1ezejh9hE76C5cAtzprdx5H9yu+Qt8pOjCMs1jMPoSobOWhlM5H40cyCGk+ak1s=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by DS7PR12MB8348.namprd12.prod.outlook.com (2603:10b6:8:e5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 13:30:54 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5%4]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 13:30:54 +0000
Message-ID: <07cdcce2-7724-4fe9-8032-258f6161e71d@amd.com>
Date: Mon, 15 Dec 2025 14:30:47 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dma-buf: system_heap: account for system heap allocation
 in memcg
To: Maxime Ripard <mripard@redhat.com>, "T.J. Mercier" <tjmercier@google.com>
Cc: Eric Chanudet <echanude@redhat.com>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
 "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>
References: <20251211193106.755485-2-echanude@redhat.com>
 <CABdmKX2MPhw121ZG8V+f-XoOReUsCdmcug-cWDg=3WZcJ=NHHA@mail.gmail.com>
 <20251215-sepia-husky-of-eternity-ecf0ce@penduick>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20251215-sepia-husky-of-eternity-ecf0ce@penduick>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YT4PR01CA0312.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10e::24) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|DS7PR12MB8348:EE_
X-MS-Office365-Filtering-Correlation-Id: de2416a3-a395-4d42-998e-08de3bde2c35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UVJKSU9pVm1scWFzNHlBak4rd2hiRG9vcUtxUWdvZ0c0RDJsbDNpZHhzdmlv?=
 =?utf-8?B?emdHZFBjNHBRakFWRDhuYmpKV280MHp0Q1dOTjNFeFZ2dGhQVW1wODMzZVdv?=
 =?utf-8?B?MUpSV0V0SzFyNStZejJSM2txUUhkclB5TmJZbTROMGJBOUVGYXJZWlZleEFo?=
 =?utf-8?B?Z1ZLUm1yVnB0RWRNaUJTUGNMOU9Fb2ltVFh4dnlWcjlCT0xtbnJEUzdsQjh3?=
 =?utf-8?B?WmNVbi92T3NGbGFqbDN4NExlSWw4TnJsZDZxRXFmdC90bVFDZlZBaE1lN1dI?=
 =?utf-8?B?RHJGa0FIb0ZSMldxdUdwSFQ1QW1sWlRTaXFpa1NNRUl4YmNBQ1NZVjhHbEFJ?=
 =?utf-8?B?SVNTT2NKb2V2cTU5SWl1ZXovbnRCVzN6b2VMR1crUmljRFpISW5UNHNzb3hM?=
 =?utf-8?B?QXdkeDRYSGdlcVZyM1RRaVM0ekEvdnhSUTUxQkRRa0lhTkJFVklKMFhibTh3?=
 =?utf-8?B?N2dqbUJDUDJDc0FHeTlXM3FmNDJ5dkVLeDJObHROWVBVcXBtM2RGK1J3RlNm?=
 =?utf-8?B?WVB1TFRjVjdrZnpEVXpCZXAxcGFiQUU0ejFCQitDZE14cGRYTG1yam9HVCtk?=
 =?utf-8?B?ZytuMVhMSjJBYUVzenRyNlZTdkNndGdlVEhLR2JUcDhzNzhyUU1BMTlnMERr?=
 =?utf-8?B?OGJVT3BYeHI2ZWVlTVFOckxVaG0xRCtOblBTRWNUMDRaN1lUM2RWR1RKVEdE?=
 =?utf-8?B?YnVSY3hOSXVPTFp4Q0haUUVSd0k4aG1uME1HK0xJY1ZlOWtTbHpVSlpEWlhE?=
 =?utf-8?B?QmMrMUEyRk5ZLzN3RmYyTU9wNWdGSDRiZytlT3c2OXI0aWJhbWZ5R0dDOS9x?=
 =?utf-8?B?VDFJdmNUK0RYME03RTdtaEIvV3dOR0UrVWhQSVdyZE1Jd09UUnNPdjQ4THlz?=
 =?utf-8?B?eFRoQ0l4KytTUVlrWlFTZnJpY3hENVZBYmQxNGxJZnpMU0RYWTQ0U05YcHlu?=
 =?utf-8?B?dVE0bGdSblplQXMweXZNamVndURIQ1BkTHYzT2ZCVDRKcUhJcS92L1h4c0dG?=
 =?utf-8?B?MGV0QTZ1djY3M3dRczNyUTNUT0hMVHplUFZVanVqZGRxN3NoV2lKZTVnS3Ny?=
 =?utf-8?B?bkZhaEpYRStpVU1MZmQwTW91b1o4ZWt3L1NhVXpqMUFiRXlWaU1wdGFYdWl6?=
 =?utf-8?B?STZPK1JHRHhha1VQTFluQ2puczJQdWRMRkcva0JlaVNxYkE1Y2xJOHJsdjZx?=
 =?utf-8?B?eDVhelZMbWtkSjJ6MFVyYzh6V2pSOW9MQ2VPZERncUFZVTRkYmlaYXhYSnBE?=
 =?utf-8?B?SFhoSG4wbnFYQ1VWYTFlZW5namJaWnZ3RDl5S255azVKMGV0MUl0NXdXcyt1?=
 =?utf-8?B?SGtuNGhKcSs5bFF5Q2FxajhLaEJuUzY0RVlySTZTVVd2eFc2RUlXUHljR3Bw?=
 =?utf-8?B?bGF1WkIxdnRPdkkwNXFZVXhFTmpSN0RUL1YzcXFIZG9nakJDZEpxOThGak95?=
 =?utf-8?B?SDlNaC9NaURGM3NWK28wRjFKR0c4SGRIdkxGY3poelpWQ3oyQ2JpdThTS1Rt?=
 =?utf-8?B?Z2N5d1NWQk1HandOWHRPK0E3N0JpM3dzbTRUM2w5cGgrUnRSeCtTOFE0Y0hJ?=
 =?utf-8?B?TUdpczNTZy9rdmdMNGZSWVZ2bmZvRmp2T3puV3dGOXMvajg4RktadStnRko4?=
 =?utf-8?B?TzNIQXIvZGk4VmhkOXgweUpURFA3VENYdTI5UzZiZFpFN1BWcTdCcU9IUTl4?=
 =?utf-8?B?R2JTS3VyS1UwbWlFVXp6LytrM2hNNitRTXhGVmNVZEFleCtwOVpxdUlNbWsr?=
 =?utf-8?B?cmIxdkE4QXBhQStna0lzc0wvc0NVSS9lNG16V1c3bHpzZ0lVNUFDb2F3dU9N?=
 =?utf-8?B?d0V5ZFRnU1gzWFZZcURoQ0kwbDN5dEY3L0JJNnhwWnBHYWpHVkVuWVZBRjRm?=
 =?utf-8?B?SS9lMm1lR0k2S1B0N0VjalBWcTRldlMwaHR1NDZtVllBUXkyZGR6eThYQUlK?=
 =?utf-8?Q?oQv9nTbaLBNpegn+0OENMOadEySKiTsT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aHRXeDFCQndOTmV2SHdJRjUxOG9xMnh1S29CdWF1SlZkdi9SbUozTEluY2xT?=
 =?utf-8?B?ZkRJckxWb1pzQTVSLy9aWmU5Zk9QUE0wWGpRU1NhUi9obVpmSHJmOHp1QVRk?=
 =?utf-8?B?TzZLaTZXT3hwKytKT3hvMXF0bjFaVzh2UFkvbEF4Mkw0TzRrMlJROWR3QVNT?=
 =?utf-8?B?R2dRSk9hWTNQUUxSUDJmTjlKTkpPTGtkNGlYV1VQaWQ1RVpja1JmanEzK1ZK?=
 =?utf-8?B?MFFaN3dCT2lTOGhiZm1GYWpFeWlLeGlFQU1GSnBkaDBGRlV1TGM1dFJpV1Yr?=
 =?utf-8?B?azN0TFN2TUdIdHlaTzIybjhyVHlkQUdwQ0cxb3Z1aWdHZ2QrVXlXS2R2UjVY?=
 =?utf-8?B?UVNncm9QR3dVOThSdkJ0QUhYa2lkUHh4SXlFMzYrQ3kwd1FoTTRNQmgyNmVQ?=
 =?utf-8?B?TTEweEVlRnNBaWE2YUs1b3ViNU43OGxzVFgrVThnSUs3Mkc5eGhab0FyMlJS?=
 =?utf-8?B?MEFmZWdTb2QzRDRaazd1OFlua3FDOEphdnpxU0JkKy92SVhSeUp2N2RkK3Uy?=
 =?utf-8?B?QTE4NjFoaTc5NGg4WC8wbEIxMGtKSy9jT1ZTakxwSXVDNis2ZlU2aTA1ZmlD?=
 =?utf-8?B?dmtzY2drcmRUVlhDUUMwZ3hreTVsVXRBMlpBNGpaWVFhV3cvVzkvTS9WRC9X?=
 =?utf-8?B?ODFhYUYzdkpwK0p4aEpEa045UmpUS1ljWDNmNi9vWEsweXhPWDVIR1VTbi9H?=
 =?utf-8?B?dmxXdEFqT3BXWGlETGxlL0NVQkN1RWxILzhNcEEwN0JlemNTR1BlbEJJcWFE?=
 =?utf-8?B?SGRuN0RKMkNrK051R2IyK2plT013bmkvdWFUbWtqL2g1MnJZb29LUFJHNnZx?=
 =?utf-8?B?ZFJ1Y3hNM0V6czAxQmlicFVOemVPVy9YN0dIVnpuYzBSSEtiQ0crSTUrcW1w?=
 =?utf-8?B?M2FISW5NMWRKc0tJcTI0ak9uMWpNYlBOS0tHaDA3dTF6b3dQWWE4V3k5Nkpm?=
 =?utf-8?B?aGVjYmlhaHV5cjBXSDh6K2QvWmxKeXFEVXR0Qk5XQ0ROV1QxY1Nwd0lOWldU?=
 =?utf-8?B?dFNyc2MxeDFsQXVHc3lZUHMyMXlZN0ZXZk9aMDZYSHQ2QU95VW9yWUhmaDlB?=
 =?utf-8?B?d0JtcDQxbllvdmEzS1d0a21XblpjcmxIWkNoOFgwcDZCTWtpUldTcUN5dU1m?=
 =?utf-8?B?Q0hjWlFiMkRRcXc2R0dFTzhRZU9TVWpKMmY3TDUwOWRCTE4xTlRwVFBpc2hM?=
 =?utf-8?B?dFNGU01IMTl6UVpOZW9QRHAzeWZwZ1ZITzRlVlpONmZvZkxmUVp2QVNJNHlv?=
 =?utf-8?B?b3BVZ1FMU2hXVS9OQ3J4TThQeEg5SExwL2JUaHJycUJQQm5WaVQ3R2ZBQzBr?=
 =?utf-8?B?QWNmUU9rbzY3c0ppOEJIay8zRTBId0JCa2UwQldkVWsybk5xaElZdFhDcytD?=
 =?utf-8?B?V24yWXE3c1RJVTFwQ1FTNWJZVFlKcDYzOXdpcXEzdUlQUmNPZTR0UFlJRkg2?=
 =?utf-8?B?c0pkeEc0aDcyVGRoVVIrY3lCUkM3MUo0VFBnRUhXNC9HUGZuYXVldHJkdHly?=
 =?utf-8?B?S0FkdDdCdGVFcjBZOFRrNXR5MHlqWEJVOUZJdTZaaHVUOWFlSisrQS9uKzdv?=
 =?utf-8?B?SlZCMHhPdFQvcDh2ellkTGVHQ1djejByLzR1OVh2Wk5Ud3NmZ0k1Y0JWT2pn?=
 =?utf-8?B?ZFBhVHFqQ0RIZTRFMCsrM3RiQ2czZlpUaXdnS2tMN1hPU0dRdGNJTC9rQkpI?=
 =?utf-8?B?QktYTnBIaC9RSm9NeXR0MnAzV3VCVXI3QnMxN29qMkdwMHFKV1ZKYUJoQk4w?=
 =?utf-8?B?aW5WQ2c4UWFybVFPZC9YV0pTWS8vNHFBbEFCNGNMSVJjSUcweXVzWThCbFE0?=
 =?utf-8?B?RWN6dEw5OWhGcmh5dk5tVXF0clZ3Z2hNS2JjU0NjeTY1Y2I2V3Z2NnhwbWpU?=
 =?utf-8?B?cURic0dUN0NZeEE0NzIwU1psM3BDTHZaY2daM0pYTm5PTWd1U0lGWlJCRnRr?=
 =?utf-8?B?UTdZR3JucXY3V0lRajJOQkwzSFZWd1lHSXludm1RcUQ5OU5RNFNQeTFGVmxq?=
 =?utf-8?B?clZYcHdINFd4NVpJdG5sNkhFcEFnZm84UHBFbmsrT25PbGdRbVBuUUV1d0dB?=
 =?utf-8?B?aXMvNkdDbHZxWjBtT3Y3eW10ZlBtVTlCZ09QakJ2NTBYcmxaZnZPM2htNFlQ?=
 =?utf-8?Q?6dLozCAlkchmSjaKegr6yNOK6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de2416a3-a395-4d42-998e-08de3bde2c35
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 13:30:54.5072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RRFwi/IFQdd1YKK4TIvskkryvA51ehqL6or7su0PfkGRUJmIf6rlee1fpmY7mvbw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8348
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2549B20014
X-Stat-Signature: qi7b16sa3toguy9f8y97kqbr4rjyjgxb
X-Rspam-User: 
X-HE-Tag: 1765805458-107251
X-HE-Meta: U2FsdGVkX1/3MJGol1NGuYxU5w1T/M+B7mqtg8DP/pTcqEKINNtjmlP2sADR/nJG7P1La4JbHebkdxuZqW/Suks8awUq4E8ppFOc/wOLgV2bt4xnOIvbDuUilG6tLeNjDZPTvi7UT0z2Y4cIFKeDMBphESq2aN9xoQ8d/BmEElebMySUtD5W/OS2uZcemamWQHhuRYM34+7Ti9uS1f1qfIO97hN/o1Rt9PShvwIe7pCo+xCTKm1EnEWEOXrgvTpfpAwjs/51qTQxkuJO93c/C7JyaIu1oCzQDQ5BhsTZGRnhQ35Vr/KYNaVrlqA3VPZLxyjmoJNOJLRzqyb0j6u9suktJQNTGVhm9Zc5yIylZaLEd/bmnnvzCJ0ZZx/TyfRBTEr0JeLzYEHsIjQC/Mlcu4zV3+fEdJ3cFHdnSZ9khgVE4lO1hMihbGs0Df4uSOpiwRszUA2MUbQoT1YVM+2Dl1Yh4elur4stdCoBTmcburrrTg1vNo8Wq4HeC0QUgA/nQWwjwItU2LqbUkx5VoTWJGAZABcbohoTBg/a6E5GT6fG7IXLzzp8hNB7Y+h+tA7BfRsZ2FQHqNMlnwuhUKfXwgBO94XJX58tHILw4Y4rTejoMeY1enEthMnW67mUsIA/uB0JtfGczaPiv3cPaLiAvZsAmpP02G+QGePCdkP9TsvhzJGd/PVHn2foV0kf1GPPpA25DX0owoP91XEjSs+IuIW+bKUUUQ8gbbs+bTwzO55rM0hmpGmMb5wZnWtgGeS6nF5zyFSXhyaGgRHj8aHHIsArajutUGsme/n9Sh7uWdwDkbaDxIvMG27SCdY2Jo8P0HEPd3A9+1TYh0FLAz3jbIefwQtMvah/AESewYu5rRBAklwYNme24r4GCX4NDiWDGVuh4vpvum0cmNwTVutzvr/TaqQBzVNzac/H0QtqhkUZxrTqahUGbGFNJtd4twrQI4nSNqEV3BCdYxxXkth
 QrUdfHRy
 POhm0X1Y7qck5zoZELidFJhdRXofDdggQI9hGV5opP9C11QBZ8Gtkbj8gRFjt8vbjnG9fsB8IyPqv74h9lk9jMmuWjwBfkWYqZ68bSQGEf2Cnjo3CzjXdOORzQL+zhCYontmVm+wQvEE++9XWjDcoiokeahP0PTs1wcPKneitzheB5CrZhyQwbtCR36VPiL29GVXsrdLehNg5WLRai0uE+zF/4418tzbDopvBV8BpJVIn9tLzzGL78vJWDyjZAKU2hA+Tvf6VcrOnp67INBkfcUYeqg31cwxHXl1XCTvAMFv6nBEUfBNEwbalb+0PqM5+p40keZyAp3TwwVe3S1aMTCeuRwfkama19gynqJOnDrOgnDJMH6zjLIZMKHofGQcrN0CjmF43KxZ2baASZ6sFmxQdCqJABwVdFWFSl0xii+EsLxQeNYdrNa+D4PGn7FfvH3PPbFYCHdzaNI+DBBq88/VeZKuXKXdR7+dasE/3WbhdVI7X1/Kc0Jd2dIgagWojXVWk433vYnnsL3DqbyH/5Rg7Sg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/15/25 11:51, Maxime Ripard wrote:
> Hi TJ,
> 
> On Fri, Dec 12, 2025 at 08:25:19AM +0900, T.J. Mercier wrote:
>> On Fri, Dec 12, 2025 at 4:31 AM Eric Chanudet <echanude@redhat.com> wrote:
>>>
>>> The system dma-buf heap lets userspace allocate buffers from the page
>>> allocator. However, these allocations are not accounted for in memcg,
>>> allowing processes to escape limits that may be configured.
>>>
>>> Pass the __GFP_ACCOUNT for our allocations to account them into memcg.
>>
>> We had a discussion just last night in the MM track at LPC about how
>> shared memory accounted in memcg is pretty broken. Without a way to
>> identify (and possibly transfer) ownership of a shared buffer, this
>> makes the accounting of shared memory, and zombie memcg problems
>> worse. :\
> 
> Are there notes or a report from that discussion anywhere?
> 
> The way I see it, the dma-buf heaps *trivial* case is non-existent at
> the moment and that's definitely broken. Any application can bypass its
> cgroups limits trivially, and that's a pretty big hole in the system.

Well, that is just the tip of the iceberg.

Pretty much all driver interfaces doesn't account to memcg at the moment, all the way from alsa, over GPUs (both TTM and SHM-GEM) to V4L2.

> The shared ownership is indeed broken, but it's not more or less broken
> than, say, memfd + udmabuf, and I'm sure plenty of others.
> 
> So we really improve the common case, but only make the "advanced"
> slightly more broken than it already is.
> 
> Would you disagree?

I strongly disagree. As far as I can see there is a huge chance we break existing use cases with that.

There has been some work on TTM by Dave but I still haven't found time to wrap my head around all possible side effects such a change can have.

The fundamental problem is that neither memcg nor the classic resource tracking (e.g. the OOM killer) has a good understanding of shared resources.

For example you can use memfd to basically kill any process in the system because the OOM killer can't identify the process which holds the reference to the memory in question. And that is a *MUCH* bigger problem than just inaccurate memcg accounting.

Regards,
Christian.

> 
> Maxime


