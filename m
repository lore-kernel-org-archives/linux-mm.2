Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E679CD4F48
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 07:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CC056B0005; Mon, 18 May 2026 03:34:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17CEE6B0088; Mon, 18 May 2026 03:34:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 045556B008C; Mon, 18 May 2026 03:34:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E8EA76B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 03:34:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 57E7F16144F
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:34:25 +0000 (UTC)
X-FDA: 84779727690.11.79B15A2
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012059.outbound.protection.outlook.com [52.101.48.59])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5F6ED40009
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:34:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="uBIVhf/f";
	spf=pass (imf12.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.48.59 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779089662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oGK1Fc3IZVi27vk7jBfZylC+6MP/Pejak+VnOxftD/s=;
	b=EUSyZX3+DOum0jQaSVvYGL74WNdp8j61maXPS5q1g+O7y2esPlCnHomYLjkPpmsgXTLvUR
	zZtuhRDkBSw2pwt6QFDJ8TyiiDEMsFG7t6G1zwwwCGghv8nvehcMdiD1uOzmQOKww/zUZU
	tZPOaGlZOl24sDdctu0d/SECzfN4f2A=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="uBIVhf/f";
	spf=pass (imf12.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.48.59 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779089662; a=rsa-sha256;
	cv=fail;
	b=S4X0iSfqvO/og9o1DN2fNSrWZM+FrY71FYibRUD5lMu/7nDIE00OFMpwo+86HaagCNHhJm
	KBKixGe/k5xxAPTUH6C8slklTxSTshBjjOXRkITrYjrG7Qjx2fdhdVTonTi7xkmOXNVDJx
	0mzt9jwCQYf7YfKmsNRx6MgMMYK6gaM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k6jShW/h+ZKD6v5odz7fpHB2bXt0+WrwsafEIyoBSkElbEst7rkFi+PafGPFFJ5UeMwGJoaK0l4ZXWBwprmnMEUAbCXlnN+yyGWxLQH4zBBx/th1wElc7PABELauC7Fm8Y/73VfmzD9TztzheE62TicN/4dIFZTa1fwrHdXAiPWWpHh6hBFU+T5hxQw1PH1mBYRR7JCTJgcbO4PXwq7KSdWjdjVmlZiyx4mhSOY60deVXGRDjgQ/1G8pUdLcH+w31EgYDsnGVN6tdN8LzXoAsRUK8fl/dbv6x5GgnsqyS7ATucfOssrLN9h2gg11VLfYTrnGueqjVysVnHZQk5/Wpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oGK1Fc3IZVi27vk7jBfZylC+6MP/Pejak+VnOxftD/s=;
 b=KnCNPPqGk77rPsFRDt7FgF8XbnK+php/4O/Fs7ToF3fpS150qzmUQvxqqbzmHPtAXwqKXK6QpLh188F1CR7TvqTBnN9b71Bmq4rq6zDIiRq+NiudP0U1/HIQsYTC0yDpQoR02m4YdMBTg35BJA2xyCVQ7JoLNg6x5bykxswTwBQ2YyQG3j/g2llbG4wPTevI9g+tFDSrrtozrT8PGJc5944oIQ9qiPmnDuFTwUE1hzbaCSZfQXy/z1CDx4lZhUZCbVzaeCa+FYoAoydubEllEb4E3njoznDZhIElmWSwKTw8xMYI2gQjOp8JBQOmGqyLzLAHOy5JkPwZ8NVZYpmGLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oGK1Fc3IZVi27vk7jBfZylC+6MP/Pejak+VnOxftD/s=;
 b=uBIVhf/fvieTFEFZs2OVD6895O1RoTHheTs8tsTxulsReZ1Dh/LZOclWzSOV/hWZrKqflLyD0hCqcWGIdZ6DEd3v1b12uJvIEQRCgqKKQItgTu0lK0lwKCwJujnPnrP7IUDVbydFqZWWzLzjs7wUeXKtIx8FVZZa9zFMuluncMk=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by DM4PR12MB6327.namprd12.prod.outlook.com (2603:10b6:8:a2::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.23; Mon, 18 May 2026 07:34:17 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.21.0025.022; Mon, 18 May 2026
 07:34:17 +0000
Message-ID: <cb84c2ee-9de1-4565-b2e0-60984721228f@amd.com>
Date: Mon, 18 May 2026 09:34:08 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [Linaro-mm-sig] Re: [PATCH RFC 2/5] dma-heap: charge dma-buf
 memory via explicit memcg
To: Barry Song <baohua@kernel.org>, "T.J. Mercier" <tjmercier@google.com>
Cc: Albert Esteve <aesteve@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 Christian Brauner <brauner@kernel.org>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, Shuah Khan <shuah@kernel.org>,
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 dri- <devel@lists.freedesktop.org>, linaro-mm-sig@lists.linaro.org,
 linux-mm@kvack.org, linux-security-module@vger.kernel.org,
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org,
 mripard@kernel.org, echanude@redhat.com
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
 <8ef38815-6ae9-4359-86d4-042554357639@amd.com>
 <CABdmKX2uwZ12kYJYPJGfWxuMBOJS=64b1GRj72tfB5D=NKM22w@mail.gmail.com>
 <CADSE00Jq_uvNgvxgPze0mEdUd+hF4-DPZkHy0KroWHZzygf4WA@mail.gmail.com>
 <CABdmKX3DhejYBis9htLDnzPrG7vuF3R3URLVNEbnyd61SSsx=g@mail.gmail.com>
 <CAGsJ_4zyecY6E-=Tm4_couT7uoM9LMcFdTMUPkZAjj4zUKE-dQ@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <CAGsJ_4zyecY6E-=Tm4_couT7uoM9LMcFdTMUPkZAjj4zUKE-dQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0375.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f8::10) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|DM4PR12MB6327:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ba71726-fef0-487e-f64e-08deb4afde19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|18002099003|56012099003|4143699003|11063799003;
X-Microsoft-Antispam-Message-Info:
	Rz36V3JIkquESeE/DPFbosgntqxhqt/jDujZFBZDb1Ogtbj4OQgLJtz7mdlR0MxOIWkOqmgfPsgIdYqDlbubBariIyQ8R2hiHPfnEWeiA1D27vD/p53H5MorgRfXzx7U8tq/9gSQ7kW+xlOjOqV3lWeX7HPOEsPQSAW4ikR/bxFa4iBrqT++LedFyj2moTbKttnCN5ZB3gXLgWMqTgZqcBGy8GaU8rVpwxF8ZzP07gE33ZwcO9VWm9eYrPQ8LCYACE0gWNCwxZZA9XeNpz2Fmt+WTDB7/53UJAJDk+NPYMfd2LSlkB8vE4dCLQRmMNJxh5sZjbugmsqMK6NMsJw+CbD6mD2K7sRdsrkRRkrCL+Bc2GyN21ZJVuh4xIptIWlIGA5SD2iXVBJ9iDp12SttiupFOecfp5gmYwvdW/HWedT0GUdhLI6Cp2H5XZUt/js1WvDMUi04ZK41VPGHxS4X+Yx1daPSVec1+0rngORI+lzQo75PnL0vHvxwoMAZybtnrt5VmpvtSjEsB8nrhGC0iZ0l3br7WrpWDoc5xHX86LUtonTGY6u3+GdnADPQ/B2M5tixXduShHOpJu+zzgYT+lxRNuDwW2NmRZ2czjcgh1KA2X5DejpxRFZz57VF1oqMjLaMO7MxAhpcTdQwd4bvCKn5MS6rXJwIGYBktHP0GdzLmX6NKcjB2HVS4PeRqAu9
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(18002099003)(56012099003)(4143699003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YjN2QVN5WW4vRzViUFZ0dVhsT0Q3RnRvU3pVU1h5NWV2bnJST2pBbkxyNWo0?=
 =?utf-8?B?b05KZ0JjVnAwUzhXWnEva0hSVk1Db29JVmtqZlJhbDd3T2twd0FrYk1TZVQ0?=
 =?utf-8?B?NWxxbU1kci9qN1pnV0JEVjlKSzRuZWRpUHRLRDgzSjVoTENPVkp3YmhMNDBi?=
 =?utf-8?B?bWZJb3pMN2hsemE4TG9RRkZQMXVkWDE1OG9HRlBBS1lrZmthczhHa1dzWEVJ?=
 =?utf-8?B?NVZrdkhtYThVd0Z4Tkd3SXNPL3lwTEdwbkM2TSs1V3gvYS83N3U1eXF2NHh3?=
 =?utf-8?B?QTdHUFhaQnMwU0xmd2kyWnhxQlhsOWd5bkF5dXRqREVXMWdrdXY0Q2ViUlZu?=
 =?utf-8?B?QlRDdWtLUm1UQkdaL2RFV1kyNGQrUlRzS21RVS9XWUxzdy9vNlNMcTY1UnRq?=
 =?utf-8?B?b1RwcGFKQ1pmS0EzMkhVUUw0TWg5ZG84dllYczc5UmVvSHJUeExJTzFKaWxM?=
 =?utf-8?B?anViZDZUaldVNEIrYXhtUEdzUDRXK05LL1pncUdBVHFDWTNIUFlDaC9BNW8x?=
 =?utf-8?B?WU5ESTRRQVpQdkhNVzBQcVAyNUMrL3oyakNHT3dyV0YzQXI5Q0hzWWVzUjAy?=
 =?utf-8?B?NjFyQ1kybk1WNE9GY3Q5WGQ1VlJtejVINGUxaUxOeThkRlIwZk9ZWUwvVVky?=
 =?utf-8?B?bElhS2NqWHRYNkR3MzBYQzYvQnZZQldKTnJtR21OOUhHMlRDM1BPdHVSSXQx?=
 =?utf-8?B?NlNObERhTE1DckRmZkRJalFldm9GZk9NVFd0dXBhdnBvMUNxeWlNVS90d1gr?=
 =?utf-8?B?dFRYNmtxdlVXSkN1cnBHT1J1UDc3dXNnNkIrV01sazZFeVo3VVcvS2FlM1Jr?=
 =?utf-8?B?L2hWbCtHRU5WZy82aGx6OVVxTThLR1hRaURSNlo5MTNnOTdYVk5NUVI2WHR1?=
 =?utf-8?B?K0U1WE5xdGtMR0wzRTJ2STBQcXk4YkpqemJHU1J1M091Q3JlVk9yMVp0dDAv?=
 =?utf-8?B?S2FPcDVMd0lDYmhLU2RXVUM5ekZxWE9QWTFmeURaciszdllyUGpWVVl0Y3dl?=
 =?utf-8?B?aElnQlNJaTNwZmhnTlpDRXd3Q3QrVW9nQVFzKzhjYTZtc1NoSUFXeGxrd2pJ?=
 =?utf-8?B?cG9WQjUyencxSGRyclVhUHllYjFLc0kyd0UxTlRTZDlldnlyU1hkVkFCRjZJ?=
 =?utf-8?B?RC82VDlDaUY3VFVMb1JWS3h3eVBpcHpWQlZEcXBBcjQ0TmtzeGZJZnU4bHhH?=
 =?utf-8?B?UVBBa2ErWFh1R0xEaEpBZ0lxeTU2T2p0ZythenlPQXMvVlZkZm5rc3FUNXpB?=
 =?utf-8?B?VmRaazdTY2JoZ1NvL253eEdXVHR1K3RtQXZaUlcvZDlhaTdVbmI4WlJYVG1E?=
 =?utf-8?B?dDZ2d28zSStsYWpFVklOZVZmR2NnUDgzWVRTZHgxOUNoM2FlMzAxQjFJL293?=
 =?utf-8?B?SUtEZTRzcjhnd3MyZ1ErekpONWZZZ01aMXg5TThURWhiWmNXM3l5dHdvTzMx?=
 =?utf-8?B?OEJwd2xYaVJoWmdhTFYvVzEvV0YwNUdpUmdUVTVYZ28xaHgwZ1V2TzkvVlNX?=
 =?utf-8?B?TURZZXZjTURRa2dJKzdyeHRQejdzdktaM1dVZ3I0VnVvOXFBSHpNRWZGMURL?=
 =?utf-8?B?d0ZFYUpkOTJhQVhCMllwdEdYZ1NOc3NYOTh5RDRJUTJrMS9lNHN1VFZrb0hL?=
 =?utf-8?B?SXljSlFVL0d2ZGhJaDJxNVBYbVdRRzdaY1hhSTZ6ZGpzbGJjSC9VMldPUUpZ?=
 =?utf-8?B?UThJTnd4Tm02UE5lbVpkK0kyVWVPM2Nma2dTVk1kVmFDMWU5R1ZJem15bXNL?=
 =?utf-8?B?eWsrY2RyL2wxWUpiOVRoQ0RwdHZFYXRqMmFycHlhdjBvRlFtN0JJWDVsdTlV?=
 =?utf-8?B?aXY5em5GVnJuWHdDM0FJVE5lQkRTV0xuNXVkV1ZNczZTTk1QZ2ZCWmw2NFpz?=
 =?utf-8?B?SVJrTXlxYTNhMm9vSWR0bUdUeGwxa2x2NldLVEhBNDBFY0JmY3ZIeWZaM3dS?=
 =?utf-8?B?SkZHYW1RMXlzekVBU2diSE5CT1RKVzdzT0NGcUNkSm1tREVNVlJJNHdHckoz?=
 =?utf-8?B?NWhITFlLN01JQTBBdGpFM2lzUCt2bDRlUFltTzVMMnFqSjJFNEhuRllRRzBS?=
 =?utf-8?B?ejZDZ0pTZjZTUG9qdFRlcThGSUhFVU16NlFyRjRxeFY4NUovcDExSWxLQ1V2?=
 =?utf-8?B?ZGZtN3lTT3BtTnY4OHI0U3A3NEtUUDIxN1J2WmZSSTl0eFd1ZWdlZXpObE82?=
 =?utf-8?B?TjRoRUhpK3VXL0pHNDkrd3hrNlJrUW02MmxQRGlNYTRQK0dyL2l0QmlHekNJ?=
 =?utf-8?B?M2xEclNLNjNTVzNISXAzanZReHpEMGxxd2d6Q2dIOCtacWI4WWlacWFuR3l6?=
 =?utf-8?Q?izuDB4c3QEpID/cTUJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ba71726-fef0-487e-f64e-08deb4afde19
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 07:34:17.3042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dTYc+kXojVBuwAvXkRpJsgRPNSmUM5Y0Q5JghRCK9k9Y4iDqIe+OiSYcXx9z1Gqk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6327
X-Stat-Signature: agandirfnc8qx4k9up6munfqti3ox1a3
X-Rspamd-Queue-Id: 5F6ED40009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779089662-607302
X-HE-Meta: U2FsdGVkX1/dH3N1plNQ6Osmk8tXbcSItcNa59CacJQlpqhgjn6pMk0XMRgQ91ySYhUoleMLTYQxWPf8rB4WnBidlX5c15IB2xs3qhz+e34hc08V3qZS5lTue2+1RLCHNUAsp+TnRq+c/7M2Z+vnrDcGnXuu4fzFLVn5WL2APxO6LfMResBEEEp0lIvvIB16TAKq4uVdDKKyjqWCaE26PsH9eOXHzJ5qsgoPL9EUhuJRc1BKDr0/F/m2i9hlTgtfrX8iyY5kkZ//7maxj7hE7+dNFn0WmL3mLOHGAe75vOGfNzwyQcbC+3B4VCHKjrH8b+mUSMh09kWyXWn3GZ0uBKNpHI3TNGghR5OOSHkbOhcWbSnzsUoQpQ4nWyHWyIaHGKDg1F0LO5PGNsAOvIkzo7u5qJ+3ob8BHOfTvjv3hx31XSJJ4baiWRli3Ycxy/ymXddf7unqvVnQLgVSZgqcCdXdv98R2a58dwMdvf+y3GDZWr42PUfkxl+vTvnIl88Mui8eUu9JGzur1xcfMNQHx70rNPILx+VwQKinnsiQhCIZysXU4C0pjQ642uU4HtlIZEeO8L0tfBss2Chfk0zQqGESqMMj+3ZV9f24UQnTG3S6fHE5y+5BdShJc1gwwztiVQ9xFNKJZm1oTGTEuDN20bHr85ewvsLYVu+zdAmzd6+K8wbJCBHsWvtkyYXfUmfqQyLRwXd828mrZ01MRF4a9wy/fQbLPaCosxOgyo+XjcwEAEadqwHWc7Tym3vgVvDJ+8NWEqhWR8ZJCz0P/z7Yj5u0dIWYI6VOTgG9xXI5NARoav01h1LHBvBfiftY4cKK5yIVmf9g1DvljRajZuvN6o9HY47tMpPnsi9488XvL/OgLrF+FN4c/kBbmbhK+h+0TA8aaLbNwnBlRDD9clE4VmrHT14KpPeKzysam4sHzXDScE8V5nBEb2nBJuxYP2rMT+pIYg0+MDUKY6XIZ4U
 WVmsqYX9
 SfcoRF2wbBhqec0cB1rNn1+5NQU+Dy5S1rQsqAbs6MzM5vZq9+y2+xYFJ7LelEt0uDusHDVPKZCZkDxNkpjDWuZiovxf2xhuQJpp6LiPRuwQAw5UQjVwyDrH+2NMZ5jGQywz5E6hTwKUyFm54zSJHEG8jxPK6WqNDtC1MdkrLJMUbwZIts9yCqb6sMxPnsmZia/e6E7LqWnNCKqiLe/7sCQfmTN728sv1UC9JIKiToQ+LkOQ97d4ZBR440Rx/jGM0uyJfFwq3Ne8OqOyTYj47fUNt7YGYFFkR3GwkJNHmImIstSTQrVN/NOsX8276UtLZDlfQQqKFps2DKENfCtCvo8NGXLUFUMQmr7el9A+sUQwBGfVNV1iWrhBwagg1OySLypM6lbPiyatNJE5WEhXPD9FyOcUjuC0nusF+zuweUGb+eLPYIVNwkM5+T8DG2xf3HkdJWmb3MHY1LLnOWqQiFLlax///X7jDdWlTvVqIJQbtWu0UnNNgJvVC3mm501ddr0APVKdmJERf7FFBDdhTWxbn6Hf1WFrneT45CmDuIw+WJ5FVLgLsyFFgK5KsLw0PqOWQtpDJyePu9qg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/16/26 11:19, Barry Song wrote:
> On Thu, May 14, 2026 at 12:35 AM T.J. Mercier <tjmercier@google.com> wrote:
> [...]
>>>> I have a question about this part. Albert I guess you are interested
>>>> only in accounting dmabuf-heap allocations, or do you expect to add
>>>> __GFP_ACCOUNT or mem_cgroup_charge_dmabuf calls to other
>>>> non-dmabuf-heap exporters?
>>>
>>> We're scoping this to dma-buf heaps for now. CMA heaps and the dmem
>>> controller are on the radar for follow-up/parallel work (there will be
>>> dragons and will surely need discussion). For DRM and V4L2 the
>>> long-term intent is migration to heaps, which would make direct
>>> accounting on those paths unnecessary.
>>
>> Ah I see. GEM buffers exported to dmabufs are what I had in mind. I
>> guess this would only leave the odd non-DRM driver with the need to
>> add their own accounting calls, which I don't expect would be a big
>> problem.
>>
> 
> sounds like we still have a long way to go to correctly account for
> various v4l2, drm, GEM, CMA, etc. In patch 1, the charging is done in
> dma_buf_export(), so I guess it covers all dma-buf types except
> dma_heap, but the problem is that it has no remote charging support at
> all?

No, just the other way around

DMA-buf heaps can be handled here because we know that it is pure system memory and nothing special so memcg always applies.

dma_buf_export() on the other hand handles tons of different use cases, ranging from buffer accounted to dmem, over special resources which aren't even memory all the way to buffers which can migrate from dmem to memcg and back during their lifetime.

>>> udmabufs are already
>>> memcg-charged, so adding a separate MEMCG_DMABUF would double count.
>>> Are there any other exporters you had in mind that would benefit from
>>> this approach?

Well apart from DMA-buf memfd_create() is one of the things which as broken our neck in the past a couple of times.

But thinking more about it what if instead of making this DMA-buf heaps specific what if we have a general cgroups function which allows to change accounting of a buffer referenced by a file descriptor to a different process?

That would cover not only the DMA-buf heaps use case, but also all other DMA-buf with dmem and whatever we come up in the future as well.

The only drawback I can see is that DMA-buf heap allocations would be temporarily accounted to the memory allocation daemon, but I don't think that this would be a problem.

Regards,
Christian.

> 
> Thanks
> Barry


