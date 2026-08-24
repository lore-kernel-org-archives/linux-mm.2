Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B6F1C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 08:59:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 075206B0095; Mon, 24 Aug 2026 04:59:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04CAD6B009B; Mon, 24 Aug 2026 04:59:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7D4E6B009D; Mon, 24 Aug 2026 04:59:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFC8A6B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 04:59:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A23311C1A93
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:59:39 +0000 (UTC)
X-FDA: 85135564878.11.52FC07D
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012040.outbound.protection.outlook.com [52.101.53.40])
	by imf08.hostedemail.com (Postfix) with ESMTP id C7C81160006
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:59:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GFHreHO8;
	spf=pass (imf08.hostedemail.com: domain of dtatulea@nvidia.com designates 52.101.53.40 as permitted sender) smtp.mailfrom=dtatulea@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787561976;
	b=8q1UCzcrNiAWBrKl+Y7N1lzts9ApLKtqsgzmiYtfXahZA5lwI9QSo7FguCTFQyqlbB1SaH
	Y+e6Ue+IRzmG9Oc39ijC8bJ/Og4/8yx8r5H+sOjHJsYYnb2LUGsuLQJg3Zxnp+d1mfMoC+
	EiZiHNWBtaRRk9KPu1J0tfWbLPA8SLI=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GFHreHO8;
	spf=pass (imf08.hostedemail.com: domain of dtatulea@nvidia.com designates 52.101.53.40 as permitted sender) smtp.mailfrom=dtatulea@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787561976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xPEpNYwQnxN8HF6+IFuiUxFUZ0y5F6aFP/mGUW1MQ7c=;
	b=fRyfoqThqjDExxsACx2ZJyRetInfQBPW7Leukg6LM7xxrw+lOg03rhXcHvvWId5eS2T0a7
	uneDzG655x0ukT8koXvNJfCmmhxzZrBCK24N/9qvo14oZ5dGiQMPh/Idx8roO2LTx8OdFr
	Lqgr7zebY1xyMlFFrg6LvastgVWVqQU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bzeAnegkqzSJaSFZBAzpGRv6fbruO/JMHUOnt3zGQlxnKkeqtcTLHzyhKzGs868G6yHQcdfEA+zhyuEmqWtAxjAJQHJoga6RZ7HiNawqcM4Dhc9TEOpGJbhtDqZQj7ztU4yH6fPZleGp/dxdVBxAFgp00QjLqGs2wYTIx7KUZX4TRYJ/Qh2KnfqCj8a7v0wS8yEP3pRBxRxUFbbgXWOUHd/yTJTENIIllvBxlOj1cL6bA4ZsPD/76VLWyvHfHXtfQ66puDUBrPRwkpUUN+/TrUzYWAIi/xVKd1n2FomRvYVlYYwINdpszxP7eqV2hLq1jZEhgx7EbUislYrmEqFiIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xPEpNYwQnxN8HF6+IFuiUxFUZ0y5F6aFP/mGUW1MQ7c=;
 b=aikvevWEBaj3LVjhHo7o2Rew/+rGPtsweCLX3KPqtpP/j68slX9HcjrtSZz1+7+kYnqaKzRnjFGVESUIIMCp4/Cd2Xe4rBiGbe0pbmT4/opS3ZLAY5mnz7Nvcx7PTtkVhCMhzP0zsGRS6YQzyFAtck0X4OM74jnv5rMza0gg5Z3HCmyNGDkdn1m8Nwodc9yfLSzi6tjbwOxqoHIWqUGKSWPmsAOi1ZGf6DSRkog9nvDXIEpaIUU3bPSGYf/aNj+iAU6GxGx3HYaVlv7elJxwedVEJeKsEjseP4Pu93zoiu5VHdc2SHzbaXsVF8/7Gw/SOACsoyc/bj0PoCPsOgJScw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xPEpNYwQnxN8HF6+IFuiUxFUZ0y5F6aFP/mGUW1MQ7c=;
 b=GFHreHO8RNHeHvGUwCWGuoDQk1xGX5Ye04x7zy+VA3/sVqnpmFOYmvT8oTccES35Cfd0ghg7pJuUDHmn0PZjN68HItqiJQKZuiewtYP62IX+R0pFRghTL/6R9qvny6/rUIgSc6zLgFKZLWdg34RZSH2L1liCYLLpWB/kSm4PgSVzS2IC5/K0ZVqCwzh29iP8B7UQmlfUh+/YTyU+Xqvzzt7qjbBffVVsNJbFKu8flGQpqFdGoBVShR86WCHpmOHG41lKOZ7semaDojhC//xjU5HLbh1ZNSZ5Nm7ZqmhQ4rsmPYXosG/q4o97TEDy7Wk3lOXsPhZSbwDolBtfJR5QUw==
Received: from CH3PR12MB8728.namprd12.prod.outlook.com (2603:10b6:610:171::12)
 by DM4PR12MB5963.namprd12.prod.outlook.com (2603:10b6:8:6a::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.12; Mon, 24 Aug 2026 08:59:28 +0000
Received: from CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7]) by CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7%6]) with mapi id 15.21.0339.012; Mon, 24 Aug 2026
 08:59:28 +0000
Message-ID: <ac473a83-c77f-4a41-bc86-8a857d2d6e36@nvidia.com>
Date: Mon, 24 Aug 2026 10:59:21 +0200
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH] swiotlb: avoid double copy with swiotlb on tx socket
To: Mostafa Saleh <smostafa@google.com>, Luigi Rizzo <lrizzo@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>, rizzo.unipi@gmail.com,
 m.szyprowski@samsung.com, robin.murphy@arm.com, willemb@google.com,
 kuniyu@google.com, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, gregkh@linuxfoundation.org, rafael@kernel.org,
 akpm@linux-foundation.org, david@kernel.org, netdev@vger.kernel.org,
 linux-mm@kvack.org, iommu@lists.linux.dev, driver-core@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260615234220.3946885-1-lrizzo@google.com>
 <20260615172535.080cf94f@kernel.org>
 <CAMOZA0KAHKsvA9yRcdrjG13S+=rJhw-Cvnw2WdLjGGY0azG0kw@mail.gmail.com>
 <ajEuUZMgS_NRmDcp@google.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <ajEuUZMgS_NRmDcp@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR5P281CA0023.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f1::15) To CH3PR12MB8728.namprd12.prod.outlook.com
 (2603:10b6:610:171::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8728:EE_|DM4PR12MB5963:EE_
X-MS-Office365-Filtering-Correlation-Id: 82d2c0e8-e66b-40c1-01e3-08df01be00ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|10067099003|22082099003|18002099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	m+6mXDsx1UNSgbgdtXYOc3ilXKI4SHa/1M4cxDCnAtK/YoYSnmhsO1TUH7COi7U183MerbU+SlJrE7sRJ4oAYwQwIPNC9nKF1oQmd87vGNLBaLuDvVx+iBSF7dPbquT+w0d7QaBPQ2MCRrWipIQNMhqA5WhqSu49IXo/JKnlIxOZb16RXOXG2IPzT3UnrpBPqIn3PDnzobokP6rVAKm3AEQ3Wg13jpoPEddnj9TB7xUEBY0NU9IMjiM2QDb4TO/y5KfKOL2Evnp2PqGl+r4A3j3qE889kCkv8Hhf2X5/UFbgmk56gJN/qNxsBf18XjmTpiIjd+6Do3D5V0YpPEr+n8gI5urTkebmNlPITZhumvPbZoCL/HMz5HRecU3hPaKHSLI/a8FqNMOv/LX7aeSMofIF8MRjbRw1zUbtCUoBS5RKbuHgPli26U+ipoMijohkaopooso8PCKGlwwzHd8+cHiuabxWQHZ0nuQ4bONY6Gn1BXj94eqNO2rQDtNgfpyypDXYR+Nylwaj3VfOrkg3wbOkaCH5EBkFQCrqMzyorT8d++BhbRmHTNXS/90fFGR9QZWCiK4tK/bKwPeAYNTL+9Ssof90X9igwr0ASKlMbCH5nRO9gBecaHvUS1LdzdMa5pRgp526qvs6uJgCtKoMrRirruM7k5B/oHTHThDvNd0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8728.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(10067099003)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NDNML0x2Z0pZbzNSSStqbnhJMnk5bC9tU29NSzYyRWxSMWVYaHhEUElyTWRz?=
 =?utf-8?B?ZW9xcHZkNXJ3ZjYrdWozMVRGQ1pnLzNmWU9EMTFrZVhQcGxjU1Y0RWRrTk5C?=
 =?utf-8?B?V005aGRkaXNoMzdFRmhzU2QreTNjM0R1RzlITy9tUDVCQUROSlJxaUdWRmo3?=
 =?utf-8?B?d1lIM0ZJWmQzOGtCd3lycFlpTktHVTJ0THZPTmpQU2Y1dHFKbUdYQkk4allr?=
 =?utf-8?B?bmVpckJDQzBjZDZkb0lhdFV5R1JQaUkyc1pRWXJ1RW93VDFBVVhHK01XdVpy?=
 =?utf-8?B?YjVHUHd2V1lOM0R1c0tGS3JTaW04Z3hBZWxRZlM2bm1lTXBHM3dETVlUa3Vu?=
 =?utf-8?B?NXNaUmtRRy8xdXZEZCtIQmQ1aFVhK2x1N2ZlZTJDZFhYY1JWTWVBdXBMZ0xH?=
 =?utf-8?B?Vnh5QTkwWHk1UjFpY05HVEtjaDJkd2tMdmtEdElENWRkZjhlUVhCeGRyR1li?=
 =?utf-8?B?NXYyOHFIUGo1ZEFKalY5dVZGSitpN0NQeXBvUU00L0gwWHp1WlZZMlpjaXdM?=
 =?utf-8?B?Yk10dldmTi9MNzBadjhRVkxPVUMyT3F4MkExbUF3QzY3OEFPU0hQdTU0bzhZ?=
 =?utf-8?B?U1FnNWJZTVhLNmFnQ0hKODArV2c2MUNRSURwb2tXZGJjOExoUTFYNFNZVmRB?=
 =?utf-8?B?UlJpVnV6WTNsdFlXeTFISnQ2WFdZOGVJWmRPcEJ6dUdpaGFCckVPcG03eEFw?=
 =?utf-8?B?N0hUVjVnNXdCc25VUXVlVWF1ZTBBNWR2cnRwN2JQYXFGS2k1Qkw1TzdHM1B0?=
 =?utf-8?B?QUZqN29QOXRlam9nSzVvRWlFc2EvK0gxS0FRU1VVME9HdG9GKzh0eVpTMUY5?=
 =?utf-8?B?a01yNmllOEIrb0liRlVMN0w2K1BJejlPL1RmcmRqSk5kNVEyZXBiTHQ5Mk9L?=
 =?utf-8?B?SG90U1lNdmw5ZTJsZW50ek9MRHdITFVTQTNjQkMwUys5SEtBQkVpMForNDha?=
 =?utf-8?B?TW04ZGFCbGt2TFYrWkozUm5CWFl5bFJzcXZ3Q2IyWlF6UzFhbzBDcFhlVHVo?=
 =?utf-8?B?WCtRVVdweEFxa1o4eEErN2pKc1duMUcvTGVLWlB1ZjdKN3ltenN5MVFZTEUz?=
 =?utf-8?B?Y1lQdVI3dW5TNFlXNEpjUVJxLzhGT3QwK0VVcWJKTU9VNHVWRy9LQ3BQRDgz?=
 =?utf-8?B?Ykw3R2s0V2NiTHUzdDMzdEpsdXBaTjd0NDdlREYrZ3BwZm5INFBrWUtNMDdB?=
 =?utf-8?B?WktzdXlrREZHQzNzeCtoeitkK2FsVFZMcUJldG9CU0xEK2JOV0VCTUR5UVlo?=
 =?utf-8?B?MTZWM3VPbXgzMFQwUGhDVUFyOGdvYmlNMDQyUm5tUUh5U053VFdzUjRyakJJ?=
 =?utf-8?B?UW9ZOXBvdEZvaTU3YWVIRUZnVy8zVEZXdUFyWk1SV0VBMVRNRXljNVhtaG5W?=
 =?utf-8?B?R3ZaV3ZTNFpkM01DY0doaE5sc0ZVTkVWcGRZOWVOZUJGTnpnd01sSUpmN1F4?=
 =?utf-8?B?RVd3ZkgwZk1obnljZTVWdGZ2Y2hNYUlRNUFhai82aWxVd3ZqZzR5MnhtbGRu?=
 =?utf-8?B?ZFJZVzNPOW5PUUdBUTZOelNOS0UyWUdwSHUvUFByRm5BSEp3ZGU4M0cvK2Rs?=
 =?utf-8?B?VW93VTEvbk1nZG84enFUa3VNQ3lLQytFQjRhd2hXcC9GMFB6aW9xV3l5YzNM?=
 =?utf-8?B?Z0I1bFVnbGoxT0kvdW16Y1NmR2EzaEVRNjZyT2JvQWd6ZEordEdaaGtyV0U2?=
 =?utf-8?B?dTF5eUxlemJObHJ2UU1ldFhWdFRwNXFNazk0aVNqSlJlSzRqbSt6SzI3bm9v?=
 =?utf-8?B?cUlMTGh4MDcwb3pKVW9ZQnNPRU5aZnVvL0hOdEVVUWc4RUVkYldnVmQwTVlw?=
 =?utf-8?B?Vm9oSG5JUSsxWDhidjVMOVVtL0dZSy94Ky9JMzZodG1Ya2htVXBQN25RaXpD?=
 =?utf-8?B?RW1wWW9SK2o4Y3JsWm1Fa3Zxb1M2b0JWSlFUSzlTaXRDVVVNNWphd2wydy9Q?=
 =?utf-8?B?TXZ2emlDUU9uNm1iWk9PVGZWYmN3T2VSK1NNWjNoOGxUR2NwN09sc0hzdmRv?=
 =?utf-8?B?K2M1VWlUTFdmcDJQM1pkQlZCUlowaUNEb2tTNlhBdENZQVQxRW5FZndWZHRw?=
 =?utf-8?B?ZXhicXNwci9vV3hYc1ZXZWR5Yy9jbDdJRjdyRlpBaTBGR05nY3pyS1ZlWmpE?=
 =?utf-8?B?Mmg2a1lIa09uR09Hd3hna2h1cHhkQkdzdFhublpVNG9veG1vcFdQYkVwZ1Vp?=
 =?utf-8?B?TlBKV29iRW5QZ1Z5a2NPL3hEN1NFWHVnMkh2aGhZVWJvQStwR0FtN2ZRRExt?=
 =?utf-8?B?clBlbUNjTGpiS3FtYWxzZ2pFU3pRb1QrOVlwV2hmQ3llSUlNblA3aXdmMmRu?=
 =?utf-8?B?R1pCM3BWYk11TTFpL1gzWUtWWDdhd0FyaDFFV2ZyTFl3dGRtUWM4dz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82d2c0e8-e66b-40c1-01e3-08df01be00ae
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8728.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2026 08:59:27.8848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zlzcQabuMvaj8wr/heSkooWEGHoFCt3kOvsHsd177Z+zE3zIEbgFzAj0youpMDpTiTn/KrYGEMZ3KW+t797v9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5963
X-Rspamd-Queue-Id: C7C81160006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: e3k9ne9fgq1i3cqjfnfyej3x51idnumu
X-HE-Tag: 1787561976-492811
X-HE-Meta: U2FsdGVkX1/3Whph5MFtaGzmPmh8MpyX6P9+unv/18YFKCbxWbL3BTyEGBbMAWwvBXaTMp/XtcNHHi/90VhJDCKnA4btUErkDxznandFKdwcL8+D4YeLEovqjPpyk8GPNvEIgkamtzpViJfqdJLJxrrKR+Q9GVDcYbW3OohSDjQhmV8QKCcPzcStCJpxX9XO4WmQIbCdPotTGMZPAv7K/dtrGq9GEJuHnICEE32tNAcOEzWi2qjWbaNOzPxfoMJEYMCHJCC15AY3fyRHmqN3YM50TJZIRTP8q/9WkAIl6ZuJ/BrkEXKC3V4EzFtWAGQqiY1vicwpLjT79iuVbNTVcmgiGOmCLgoAnzDHVFHrkftS8P48VKt1PrJ6KHPUUmDcNQkb9fv5mf/m6Vgru9f5O451a6E85W9Zb7V+C5kugrh7L3rAZSw2TTc6ELnahh+UbMdoFycOSAVL2J4ZptRZ0HrGBzTc+jD3ChdvEHnFqgAD4KszPQgUGF08IJgsmlD4MIGiKtJ5zrD7bXUBT03/87o6EgXjT5tCASPfo9y4rRCHVwQAYAzTcHh1n0K71ZXOJoKv1BF2htM3O3B1cQYb2L1mO+iwp3ajYc2udP7UFz6oZl9DVtDnjNw4RkQwrMyZ7YEHmiNh7YhCAWiqg/jx2V7lFkC9lRYpeaS3qPIXlYopIsEE9JE8FNc0oPnVFBTe84eoaR0J6X+ZJb+6Ah0ydVJcamwhl2WriYrQu6ySpez3uiWOnqeBGS3TKyqHz/3GgqXenx0G/1TB991G69Em9CGKVmgJIPAeSGxANs+IDgB63U/WXNBL1MWWK2d/4n+VXSL4LvrDZfE5rimLZAWTprU4oAxfNjhZOr/Svik5OARNXp7GqXNMVLBC+vB2ExqqFPaWVwEieNXPfUVbnJcHXuu4dUkvH2EEGaw7TTERTpzbIw1tlEFG5gscVJx3TojIrPCmAK5w10qfJdOsMUF
 NoiJebGi
 ov4eXqWWVHfXkK6+Yj7SmKKUwpaaNVbTF+EWgpwZ4LwaanBzMRxiXyNeNw7CTEF7x2g3wkM/+tJoZzKCxWJM9yAUpFn11fpkoMc0xU6HDyJj+4LNgvAeJH0QKvzK9kuNOtfwefN2AsebAo8BMcmlgfj7zFteEK06I67ELXa8wKY/FlTcoJMIoIvK4mdE9GfzRiDGgjyi7j4Jt+pxDwxBAS1zOwnvpf3XtUWUlomfimdsbkgOT1uy0YSS9J5iiIk7OueqZyTzYtQliXmR9p9K9RvagJHBvKTkaNolTao4K64uFkfMZGbJZKKf5H6BVcUBs3S7DEJusBDQHATmljWISd9QIBwmq41ZFiYRUAXu3PqHkxt1rMgKt94X7S/38KwYOJd+QrQ/6u6lBrU568c1UFqnFQgBDIsF8O+rrb4BpFd0Dq9G9wd8F0h88HxIufq3rQh5skjGQ9yx1ZKEWjjD/im3/CXb0s736jnA7dDd51bTuh+h+NXfYkw5sj5hT83CRV56jApimhlhGjRks+LVGB+H8x9Jk9S69QgneWpvf3++0ANPYku0mFbioDkiz5IqRU/X/zf0yurM1rLqueOUvyhcK2C3SXsV0Cp3Ce0Hnbg5Fl7bMKQqSar3uCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 16.06.26 13:06, Mostafa Saleh wrote:
> On Tue, Jun 16, 2026 at 02:33:52AM +0200, Luigi Rizzo wrote:
>> On Tue, Jun 16, 2026 at 2:25 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>>
>>> On Mon, 15 Jun 2026 23:42:20 +0000 Luigi Rizzo wrote:
>>>> The use of swiotlb causes an extra data copy on I/O.  For tx sockets,
>>>> especially with greedy senders, this has a high chance of happening in
>>>> the softirq handler for tx network interrupts, creating a significant
>>>> performance bottleneck.
>>>
>>> What's the use case? I associate swiotlb with debug / testing mostly,
>>> so it'd be useful for people like me to explain why you care.
>>
>> Ah sorry, I forgot to mention.
>> swiotlb is used in guest kernels for confidential computing VMs.
>> Ordinary memory pages are encrypted and the host or devices
>> have no way to decrypt them, so the kernel must use
>> unencrypted bounce buffers to exchange data with I/O devices.
> 
> I started looking into the same problem recently, to reduce the
> bouncing in protected KVM (pKVM) confidential guests.
> My first attempt was to update dma_direct_map_phys() to skip
> bouncing and do inline memory decryption (for pKVM that is a hypercall
> which updates the stage-2 page tables), however, that was really slow
> compared to the memcpy in bouncing even for massive pages.
> My conclusion was similar that we need to solve this at construction
> by making this memory allocated from a pre-decrypted pool (which
> does not have to be part of the SWIOTLB)
> My initial idea was to teach some of the kernel subsystems (SKB,
> BLK, SLAB) about "CoCo allocators" that allocate decrypted memory,
> as this is not a net specific problem.
> 
An example of this is Jiri's system_cc_shared heap which is a dma-buf
heap with decrypted memory for userspace.

> I am still looking into this, I was planning to bring this up in the
> upcoming LPC.
> I will give this patch a try. However, I believe that we need a more
> generalised concept for CoCo pre-decrypted allocators in the kernel.
> 
There is a talk at LPC in the networking track about this [2]. This is
exactly the type of discussion that I was hoping to have there.

Besides the issues mentioned in this thread we've also found that a lot
of overhead can come only from swiotlb allocations when running many queues.

I will add information about this series in my talk. Hopefully I will also
have time to add some numbers for comparison.

Sorry for the late reply but I spotted this thread only now by
accident.

[1] https://lore.kernel.org/all/20260325192352.437608-3-jiri@resnulli.us/
[2] https://lpc.events/event/20/contributions/2464

Thanks,
Dragos

