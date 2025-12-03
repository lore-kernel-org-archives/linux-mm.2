Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04641D1BDCC
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 18:26:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAF4D6B000A; Wed,  3 Dec 2025 13:26:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D87E46B0024; Wed,  3 Dec 2025 13:26:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C76E76B0028; Wed,  3 Dec 2025 13:26:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5C496B000A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 13:26:10 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6028B1606DE
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 18:26:10 +0000 (UTC)
X-FDA: 84178989300.12.BE867E0
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013045.outbound.protection.outlook.com [40.93.201.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id 65037180008
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 18:26:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ImbUlbmX;
	spf=pass (imf24.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.45 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764786367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i7kH5lnD1DCBT5bZzBnpoRatoMF7Uz8f+23okaMqCm4=;
	b=WyjQWA5yXufg0kVPxz/dsDNZDe6AfXw0q2qaQohP5/dgYg0ZJ6MbQPgdQZXalTWID91C9Q
	ZXMP3Yarf1NaEauHh/GrsMh6rBhLq3ebnAm51Yf/wGUvol7AuGdpwgeE4LiB6wEwbGIZ2J
	ItG/wf9dmRhhNetZUusp69sVUMzvjjc=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ImbUlbmX;
	spf=pass (imf24.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.45 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764786367; a=rsa-sha256;
	cv=pass;
	b=MRMx0T61mnim7zEc/FtLydFjdMyUJgXOHHKPbPiqUcxZ+7rOpGDIeWAAvqseJiMioS7ggx
	SyQKW+tHcOs7wV2tk1KG3bHI5j1Oz9rTJtN+jJTSaoGGH9CMsvjOoyAIyCry4rcBOlTofY
	rDAULS8w/CDFXiMlhRu9OgWgC2VCFYs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=chhKeYfAC/MRnO9WivLPEEyjCfdBE5qm276pNzRBqqzaAWkDhgcbaraC1UoGZgg6bPOxVGkYNsTUG3+TZBa+Htl/KYdJ2ZqPGq/vQnwY6q2Df9ASxaoYy+i7ZQc9huYBLi7E66hXKhS9UOmmsEruNCqRr2PXwEIiE4pl2hlQO0N0MAemYGgFkvqlLFvfF285p1YYKDvXE7+nLHpc6xf1at2C4ZeeNNpcQ88gxEv3K54WNktVLWqV8It3Ql1NSY2w3Ptwzct4I2wSBTEZ/SwfSDVT8QUrPI9DlHcT1XJhIgJ3lEqrAcCQOUGtqmj/tM+Q0Y1VZ3YQ2/+rr0UCeTIVeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i7kH5lnD1DCBT5bZzBnpoRatoMF7Uz8f+23okaMqCm4=;
 b=BZDBDbZ5IhYnyRy5rXdu/wzfetrxgqp9+BRpebyYPjHiA2C47lFK0QBRnAQPfGzMfQdfB8JHkniiwnrZHoKpaGJzuOcm+w/GaJSO9bbgUgV8jU7PvYMr4ZdaJBjcyd+pTx6XRbqPzk5HPZKg9Y3TU6CMtvpM9u87tLeUTay6cOcuZ7Ko0LAerTICBBTNlL5S5CdoS1yrif3og3kac/lgd/NxHvrB+01/Edbd5smmq2UN/3TOoHp3tfmTasEsPu9qkBKtI4z9SgN/wPEiFRqMQEDw4H+Y5BAM14JCGeVAzz+tuC05lXA+XpONfPknu4ogPzgyWx9qFkiIGDuL26NhLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i7kH5lnD1DCBT5bZzBnpoRatoMF7Uz8f+23okaMqCm4=;
 b=ImbUlbmXxoypPk0IdkSpEnnM1677drJuib/L1kl2Ekbwov0Rz+iS5UdTTJQL0yZP7/MTYn3JfF5ZC93GgweNI+6PglNIv0mt/LWzGfeDlAyx3rIZdijtJhmvB2Z0GqmEOFnSmXZCmzU7BdzHh6g/Z5qftl7QodW6tquJ8ufv9Zk=
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13)
 by SA1PR12MB8987.namprd12.prod.outlook.com (2603:10b6:806:386::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Wed, 3 Dec
 2025 18:26:04 +0000
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d]) by SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d%6]) with mapi id 15.20.9366.012; Wed, 3 Dec 2025
 18:26:04 +0000
Message-ID: <26e51398-02e1-4ca7-80f0-0cd76a966188@amd.com>
Date: Wed, 3 Dec 2025 23:55:53 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 2/2] mm/khugepaged: retry with sync writeback for
 MADV_COLLAPSE
To: Lance Yang <lance.yang@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Barry Song
 <baohua@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, Branden Moore <Branden.Moore@amd.com>
References: <20251201185604.210634-6-shivankg@amd.com>
 <20251201185604.210634-10-shivankg@amd.com>
 <a8cf9fd2-4521-4068-b436-9a251a6eb15b@linux.dev>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <a8cf9fd2-4521-4068-b436-9a251a6eb15b@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BM1P287CA0009.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:40::17) To SJ0PR12MB7458.namprd12.prod.outlook.com
 (2603:10b6:a03:48d::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB7458:EE_|SA1PR12MB8987:EE_
X-MS-Office365-Filtering-Correlation-Id: 06edb5b7-5482-454a-8a09-08de32996acb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K3R2Qlg5SEY5eGhRNTZiTUg3RGthUlNaSTc4YVRhMWtIT3VRM0tyTFVkSmlT?=
 =?utf-8?B?RUdrVjR2YUs4RDNSMlZHVG4wTGtZOVcwZXUrNnlrOFlqTGVPSFNxTElLTjdK?=
 =?utf-8?B?aG52QkFCd3YrMHNLb1NwbHIwamFUQjh6ZW9JSmlCaFl3T3NvOENtSHRCdHpH?=
 =?utf-8?B?YnFKb0g5YTRHYUZEaWxkQ1dTLytMNFUyQm04a3FjQUZ4QzdWRXB3T1BrVFBJ?=
 =?utf-8?B?UjZvMWlmT0wzNkVTQkowUERQa1lXRlNaRGt0NXBLcTR2VWJXZmU4V1huemVq?=
 =?utf-8?B?UTFpVmhYU0xSREtJM3NyK3JVSUN1S0o3T3ozK0VubFFHYlhvSFBFbllEcTJN?=
 =?utf-8?B?dWg1Wk1VdHJqcGZGMEgzYnlwS0lzeTl1end4MEo2NitPcm04UHRtUWdwMXdv?=
 =?utf-8?B?c3Rmb2dXV1B3MWtCOEZqVzFDS0NCb1FmQ0hxN3V1NkU2Yk1iaFB6VjA5R3Fv?=
 =?utf-8?B?Mlp6eG1XS3Vud2FwVEFTcUw4amllVU1jNVZOdG1ZWjIyNEhqTXVDdTI0V09F?=
 =?utf-8?B?cFNhV1RUVUt2eDBDVGV0eFNUZElWTWhVQVJ5aVRRcmVIYzIzeUFGUmZuM3Zq?=
 =?utf-8?B?MVpDRVljeGo4L0w5RDRkcmxsdUY1cnJlbnY2UjBwWWVDUGhkUmsxWUlVUzlZ?=
 =?utf-8?B?U1BUTUY4RWtncWlHczkwMVBDblRFTi9WNHVzSThZU0E2MVQrSTRnSnZ6ZW1F?=
 =?utf-8?B?Z2FlQ1o2ZXdOWlJCSFd0aHZMaVpGdW9HQ0pENWdQZEhKVEMzOUgwK1FFTmhB?=
 =?utf-8?B?YlpFeG0vZzNwWVd1ZHNUVTMyaUtIRm0wQjd3YlZSYUtyNUp5NG1IZm5JdStY?=
 =?utf-8?B?cFVBaUZLZjAydGJRYzVORUhwaitPdWJNVjNuSDc4aFdlNWgrQmhmMkluaVBT?=
 =?utf-8?B?SzZiNlIwcGhjbVNUL29YRjZjTW1yTVVYc0FpMVRJNWV6c0d4RnhsazFxNEd6?=
 =?utf-8?B?UFdYZDNHOVdjbTNyUHlMYnpBVGdjVzhueTFqblpIdzJ4VDVWWU1iZ1F3Ykxa?=
 =?utf-8?B?VENwbjRNNXpvNHhkaTJBdWtvUm5ZdzE0WEFUL2FXYlZmUzAyR1drZUsrZ29q?=
 =?utf-8?B?c3FQeDdZZkdkN1Q3VVVqMEhBSllOYzNVcWR5d3FhbVBXcnc3NWVzOEYwZEtv?=
 =?utf-8?B?RUNDRDd1cHlnK0crQWhSMEQ2ODRPMU50OTVnbWRmL29EOFdpcCtxVHQ5K2dS?=
 =?utf-8?B?MVNFellEYUU2dXQweHV3NzFyVk05WFE2UU1mNHd1cWFlSWY2OXppeGpiQ1cy?=
 =?utf-8?B?U051dk14VnJRUk8xc0lmWEJCTmdKdTVzVXpZN0FvbkgzUFZOMVZyOGJPbFh3?=
 =?utf-8?B?TGl2TjQ4VnUxbTJPQXdWU3B4bzM0OW9DZ1hSV2l6a2poY3E0NG1tNTl2M0hG?=
 =?utf-8?B?ZWxSanJrTW5PWTJ4UldUU0RqOVo0MWRZWmVwdGRMcGVhTjFQZlh5ZW5URzFD?=
 =?utf-8?B?TW9JK2crNjNBa01hdmlLaTlKM2tqOEVjS05Jb0hNcWlUY0k5L0ptT2VuY1Br?=
 =?utf-8?B?WTNPYWY1TWh2V3pFUWZ2OXJLSXJNK2pCQ3h5VVJPdElIbG55b1NSVXpMVnFP?=
 =?utf-8?B?NUMvU1I0R0tLcStLR1dFTWo4NWcxUmllVVZKL1JyY3dTSU96V1pvWmNualpw?=
 =?utf-8?B?WDVyR2lhK2NhVGMrMmpEQS80WnN3eVdqemszTmlmWnJFdE1MLzBpMS9VR1hS?=
 =?utf-8?B?M1U3VyszWG01bTNoSzNGT29rTzFaUXVtUG53KzhzdnNpTGlHeHdPUWxKWXNB?=
 =?utf-8?B?dndtQ0YwTmMrd0lRMndwOHd6ZWpDSTR3TWhtYU5IYWhXRitvUldONFc5MW0z?=
 =?utf-8?B?Wlh2WXR1NHYxekRlL0g2MzdWcXFseVBzakp2ZFpsaUZtalFPWm9UVEp5TUI4?=
 =?utf-8?B?UHh4WTdCL2RoVHFnUkl4UzFIbXl3bDQzSTJxTmNUTTh4ZS9uWURYazFYS2tm?=
 =?utf-8?B?RmpuQmN0ZmluZmlmNDUxVWM4VzJYbEFzWTdYWDROT1M3YURSaDNYYXFRUDRE?=
 =?utf-8?B?OVBWbi9uMTJnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB7458.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VmlLR21MSlZZcEVUc0MyM0V2K2k4K0NkTXdDbEF6NkhQRUQ1cGxyN1l1RW8r?=
 =?utf-8?B?VlVpZ1JDZlQ5TGVwN3ZTWmtrdlRZMlFkUFdRbmxoYUxiRlNEYlNrQ3lDbVV2?=
 =?utf-8?B?cWVpOURwdlVuak9XN0hMT0NHd2VWL2pmb0x3YmM5cG9oVW8yVlU3Mjhxb2pp?=
 =?utf-8?B?cHV0bTl1UDB4OVpsNzAvNWU3RzAwNDdqWnBGc1cyc1BZeEJ2TW9WNzkyZkhs?=
 =?utf-8?B?RGZZVFF6Tk5wamJhZFJCZjF6OHBhKzlER1A3ZjI5TkFsRmdTNTkzNVlFbUVj?=
 =?utf-8?B?eG1sdmJjeVJ6U3pMNmhiK2p1K2xFQ0RTS0hSL1pPb004dlVmdytkZTVyWW5B?=
 =?utf-8?B?cVIyTHFuV0svcmc3cDdKbFBONlM0ODRvdTRQN0hCMGlLT3VjeUtQQmhRUDR3?=
 =?utf-8?B?bm9nSWVJV0RVM0MyOEVQR2JnSkZ0czhDRm5JOXlrNXVsVldaZEtNZStaMUtr?=
 =?utf-8?B?RVhVNGtwWjlBVGdoMGRQSE1yT0syLzdjL2IyM3haNWM1YTZxeDZNU3krbjFC?=
 =?utf-8?B?ZzFkN0t3U2psem42VWc5bHgvZFVWQzdSYkppY1pxYmE4b1ZiNm9mb2ZNTlk2?=
 =?utf-8?B?VkxlcjJ2bC81cWMvVjUrKzd4Ry9FNk9TdnNDN1U1Y2NmRGZxV0taK1k3K3Zs?=
 =?utf-8?B?VCtxa3FvN1FIeS9IbzN0ZFpPSlBaN2VGbWRCZG43OG55dGtnM281SVBud2ow?=
 =?utf-8?B?TmhnNW9GMUQ4SnFKNDVsbUswNDR0Rit2S2RHMXgyUU1hdkRGNWdpZUpnOW9l?=
 =?utf-8?B?eG82eUc5eklkZjFkaGZhK0pZczJuTkRmZVMvTlY5VXkzV1UyOTgvdkU3R21n?=
 =?utf-8?B?YXFYc3dud0txQWcvaGk0L3BiYlV5WkN2Qldya05rdm5CeUZjWWUxSFY4UjM5?=
 =?utf-8?B?Ni9CdGNyV0FHUmRVL3c1dVB5L0JRTjVVblB0RVIyam41cWhzZ3hJRVh2amFS?=
 =?utf-8?B?MjZNUStNbUgyZUlYVmc1WkQxY05BYk1YbHBwd3ErZjNlaTlXU1B0ZkRMVEw1?=
 =?utf-8?B?bXBzb2FtNmRxbEtRNlZoQW1wWGY3dktkN0NWV2d3VkQzUno3QTVvUGNmRXRw?=
 =?utf-8?B?eHZhanl1d1ZXV0VSZ0h0ZmwxdVFxcWhRWVpSRlh1SjJWMlVkRi9XWm94M0RO?=
 =?utf-8?B?SEdjb2REN3VuTkZjTFdKRmZBU254OERqRlY2NmJ0djBhcExWM0M5NmdqNm43?=
 =?utf-8?B?ZDdYeFVpc1RLTGo3ZzkxRnY3UjI2eTltUkY5WlRiVTh5bFhhNHI2ZGVLZXNv?=
 =?utf-8?B?QmZkQVlZOWlyMmwrYVJoZ0Z0TkVJcG5pV0w5S2dUTnV0Ty9RcTM3WjRRdEh6?=
 =?utf-8?B?aDB2eGFjN1lLR3VXQU16Y0txaHlIWWJFVk1iTzVadG1NeDNnQmY5K1hwbi9M?=
 =?utf-8?B?eGpMd0JIYm1Sa29CaWt1TzZGT3BiU1ZVVTlUZm1lNTQzOU9QRE4rbmVrQjJy?=
 =?utf-8?B?ckpteHFUL214RVFCVjFMREsvei80bXUvcXZGUzVRbGxDQmhUUEZZYjY2d0Rs?=
 =?utf-8?B?ejk3Z2pXT3U5RGcwcGRPMFQxMXlIc01PVURDbVh3dHhQaGR4Qm05cngvTU4v?=
 =?utf-8?B?MitSTFpyZ1ZhRHFXR1Y1QTNvRlFVS3daaEVSV2JSTlhFWmlDcmhoZ21ERVE0?=
 =?utf-8?B?Zm0wMmtqbWREL0tPTE9Jdm9Pb0NDT2tFSlY0aHNNN2VhUkx4S0VId2ZzVzZG?=
 =?utf-8?B?c2NtT094b0hDeFZCQS9FNkpqZThGZUFkMmNZTlJSNmxyQnBaaDhobGdITk1R?=
 =?utf-8?B?SnVHcjhmOUx2N0Q5bnpOYjVsejNDeDF5dWo3M3BhNHBDOU9tK0RHV2RvS0Nw?=
 =?utf-8?B?YXZxclh3MWtXN1ZxNHFXQ254UW42OEJINEpPZGJsNEhGUnNRTTg5QkdDV3B5?=
 =?utf-8?B?YWdqRThMS1pHOXNBYitiY2tlS1E1dzJBUzBnTWcrdUh3b0Flclp1U0pkOXI2?=
 =?utf-8?B?ZEQzZlQzam9INTBlaGZVa0dQNU04TWNDVTAxQ1YxOWdoek52Mjl2MWJxUWtF?=
 =?utf-8?B?b2RaUUxCRUIrMU5pbzlOcW1nbUlFdnNSKzV5QnBwWk5lNUdBSEoydzQwS2o5?=
 =?utf-8?B?eFIzZ1NHd1BPcEFPbVl3Y0xHUlhzZVZVbVpXZ2htWjZjRTgwVEpFTXFkbjJi?=
 =?utf-8?Q?ZfoL126Ovhr8y9se9XfRN0eKy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06edb5b7-5482-454a-8a09-08de32996acb
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB7458.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 18:26:03.9870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dqrHxepffmveCjACyJmAKh7+ytSaWLuE49nG1YJ9LED154H5VHYkArruTw11RONQsh4Lq0KjgbfUgW0ZqKAoSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8987
X-Rspamd-Queue-Id: 65037180008
X-Rspamd-Server: rspam02
X-Stat-Signature: 93qsxopdb764jfqebgpx5ri7etm5mqd6
X-Rspam-User: 
X-HE-Tag: 1764786367-493123
X-HE-Meta: U2FsdGVkX18/YNPXiFOt05Z3/rK6THlJ4NHPgYAqBEk42jNF38zYET7vt5YGO1F6O4gT273l2OtBDYfxbpONhk64pC5d46Hf8NNHxibx+w92V0/04ADcrBuLBd4ERRojeeK4C9WYtlEILTdMX6L7RY34u0YckOUnkrMt2+OOeKUl25IZ29ovk3YU9x2mNR1ROM4edatsa0ed6Skrk5NnV+wMTBHRMhORxsZphQyI3zogj+NGYrkPxAZVuNv52fN+1WbT/GWg4FvL03VNCfijbNtD26tlipEnxULHBwYYdsHGFxgJKqu4cDWkeIojjNjEG0GhlsZA9bQDF1yhujKjkIlVxSbji/ALPtkQXsMNrlmygYFsTCs1mKQ4YVAbq2CWwSRABORkbYtP5tQkdfm9CYK1WIqhFe3UvX7cFebJUTfA1gXoLP3eAbix40wr3n0bCmhB+jd8PcvS2fi8jssYRMsnUYaRSjcr886iwSgx8d/c325E7rS/dJyVk6qEohnVQnTZLc8tTvSUWY4ST8BYl9uIYk8aLFTjp+llOh+BZ8uT+mF1zMLb6+dODtKlvBZpromSQTevzZnJrGqmBJ5m8Pc2cMoaF2XUgdeQ0ajWjqXQd9lKUdFECwgTpQNmz3Aj9v1vl+M7jC3sinUBafLAp/yC0eKr//cTtwdR66l/wZFTGI7vZ+egrOkgQx8V9XWjLmTyVmhPe0QiM0Ls1kog25gVNhYT82ZgWNMxo3zZPx2AJJLfdsl6eVKtOeMAJ3iy40D99QbUDMvOGs1hxWdaOt2VczmZ+6iHAGDDM0L4q1/lHtve/2HXEQ8R6hdcuaWAm3VvkAUmL2vGxW140emQNrcP+yVVWymSNBF+yzI5ZwU/ocXtNxiHeUqXClQFVwGh8VQzKLgnZ299Mk04DADkgoqdIddHup04it58AsWcNnMAnLseHz+DQxalImldvOkiwkVeMuFF9p2VkHGmYGv
 sOIwljkg
 gwXZuLSj6naYWIRQnyNkPxLIZUs9ePs0puD8xB/w+IMJcwzjjVtxWG7USGm9rMThvM71GVSMRnl0Glj1uvgurT8SDjribWQYA38OOEXgYt/vMst22KoPzfEcWGu0IhMdB33CPe6jYNZt4JxW53RhTCuWqfVA+nV2V9dw3SU4REH6+rHGgSsiBmbXFwwmk5HAUoYckmcMXjyKQVdhvDBsA+AIzWRAZ0RAOCFvQlsLmV8bAuIuBxVuSSqsCkBbTcs2S3gD6Rcvm+Q92l1nHm14BGcN+bFY5+A8uohcUZh85aUZLc1XE35JL8xr0r1WKkYODKFnNr/HAz9uJPuCULOFEXN5ntZJ3fKQ/VkOy3gauu/PFG/Wj1FzhqB6+A8e48GjL8eHFLltsE5Nq5Sq7yoGCdGIuyaqykobgompF4Ayx0Hb69F/4A3QYjLN6K/t3MfwGdsjP37Sn0wzFP8DFr3pFKcEhc0NhWzUoPU1yatj2beRfFoAv4c0XctHFNMB6B6PZJ9rBoy9+iS+QvYfUlX/SfJlfuMjl42KYiCOnXrGBsfRhXgY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/2/2025 10:20 AM, Lance Yang wrote:
> 
> 
> On 2025/12/2 02:56, Shivank Garg wrote:
>> When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
>> text sections), the pages may still be dirty from recent writes.
>> collapse_file() will trigger async writeback and fail with
>> SCAN_PAGE_DIRTY_OR_WRITEBACK (-EAGAIN).
>>
>> MADV_COLLAPSE is a synchronous operation where userspace expects
>> immediate results. If the collapse fails due to dirty pages, perform
>> synchronous writeback on the specific range and retry once.
>>
>> This avoids spurious failures for freshly written executables while
>> avoiding unnecessary synchronous I/O for mappings that are already clean.
>>
>> Reported-by: Branden Moore <Branden.Moore@amd.com>
>> Closes: https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com
>> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
>> Suggested-by: David Hildenbrand <david@kernel.org>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> ---
>>   mm/khugepaged.c | 41 +++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 41 insertions(+)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 219dfa2e523c..7a12e9ef30b4 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -22,6 +22,7 @@
>>   #include <linux/dax.h>
>>   #include <linux/ksm.h>
>>   #include <linux/pgalloc.h>
>> +#include <linux/backing-dev.h>
>>     #include <asm/tlb.h>
>>   #include "internal.h"
>> @@ -2787,9 +2788,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>       hend = end & HPAGE_PMD_MASK;
>>         for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>> +        bool retried = false;
>>           int result = SCAN_FAIL;
>>             if (!mmap_locked) {
>> +retry:
>>               cond_resched();
>>               mmap_read_lock(mm);
>>               mmap_locked = true;
>> @@ -2819,6 +2822,44 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>           if (!mmap_locked)
>>               *lock_dropped = true;
>>   +        /*
>> +         * If the file-backed VMA has dirty pages, the scan triggers
>> +         * async writeback and returns SCAN_PAGE_DIRTY_OR_WRITEBACK.
>> +         * Since MADV_COLLAPSE is sync, we force sync writeback and
>> +         * retry once.
>> +         */
>> +        if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !retried) {
>> +            /*
>> +             * File scan drops the lock. We must re-acquire it to
>> +             * safely inspect the VMA and hold the file reference.
>> +             */
>> +            if (!mmap_locked) {
>> +                cond_resched();
>> +                mmap_read_lock(mm);
>> +                mmap_locked = true;
>> +                result = hugepage_vma_revalidate(mm, addr, false, &vma, cc);
>> +                if (result != SCAN_SUCCEED)
>> +                    goto handle_result;
>> +            }
>> +
>> +            if (!vma_is_anonymous(vma) && vma->vm_file &&
>> +                mapping_can_writeback(vma->vm_file->f_mapping)) {
>> +                struct file *file = get_file(vma->vm_file);
>> +                pgoff_t pgoff = linear_page_index(vma, addr);
>> +                loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
>> +                loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
>> +
>> +                mmap_read_unlock(mm);
>> +                mmap_locked = false;
>> +                *lock_dropped = true;
>> +                filemap_write_and_wait_range(file->f_mapping, lstart, lend);
>> +                fput(file);
>> +                retried = true;
>> +                goto retry;
>> +            }
>> +        }
>> +
>> +
> 
> Nit: spurious blank line.

Ah, I completely missed this. I’ll fix it in the next version.
Hope the rest of the patch looks reasonable. Thanks for the review.

Thanks,
Shivank
> 
>>   handle_result:
>>           switch (result) {
>>           case SCAN_SUCCEED:
> 


