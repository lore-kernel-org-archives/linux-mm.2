Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AD37C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 10:19:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E7EB6B008A; Thu, 17 Sep 2026 06:19:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BF916B009D; Thu, 17 Sep 2026 06:19:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B71B6B009E; Thu, 17 Sep 2026 06:19:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 34FB76B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:19:31 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 772F8C02A9
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:19:30 +0000 (UTC)
X-FDA: 85222857300.21.29C64C1
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011033.outbound.protection.outlook.com [52.101.57.33])
	by imf14.hostedemail.com (Postfix) with ESMTP id 82514100004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:19:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IuChLmXH;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of noren@nvidia.com designates 52.101.57.33 as permitted sender) smtp.mailfrom=noren@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789640367;
	b=e7L/c6BldWc7JhxN8bkFVVl+ONV2noGTpuaLZw6JwfCs6y0vohxMx+PRvkZRYMjdxolGRN
	sONDk09prD7XOY0rtNhmLBEbiAyu2zAhSugJ+8BCTwvhta5XJRncLDUF42iH3mGfphpqNE
	eon2+lcwmeV/F87w+MkR59Xkn5HAN0k=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IuChLmXH;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of noren@nvidia.com designates 52.101.57.33 as permitted sender) smtp.mailfrom=noren@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789640367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nW8+IeKakByJAnyHDpTRaC4II2hpR5or8s9eUwu9ftg=;
	b=ClPXfiSH8TEMqNM4Y+e/gOuTsafK+AmLXpJ/d+Ahn5kYh8h14nhayAp5M9jJzZr5tqmqBY
	AVjmrZcqc4vHb8EFJdviBs/CqDDuQueb6B/NKAg8A2sNg6bADFLCTWhnJveElzfRt/9qrw
	+a5c0g0/FzVaYFt+lK/XaqSfatAyH7M=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oZLzzcYI4m6UhhO2zn1u+c9DHUIc505/F1MkX6lg9QhiqrlwVTngwH8HabeYddfJv8TfMTWWtlTQBXtNRxtCgqMAfIikCC/fewMffQrlMffUlq2YDQXxa7SoUP5wh6p3uW/SHCGbsMI3anRI/QHG2VilbE8eF7rXs+yw7OgAd9U4XtrUPJOcKOMnupxDHTIG1g10UGYo7fqqAUvFcF2/ldgCXJkavm7eAaP6jDrINRIY4RpIQQsVjBX60I00Q/urVjshxrVhOXpOPJm6BfOwma7QnQ4v5RD1yQmsV72Esl2WzeYoNHqbuxcZ2oWqFhLNRhh4tdDdmzNl3gPNaGb7rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nW8+IeKakByJAnyHDpTRaC4II2hpR5or8s9eUwu9ftg=;
 b=xexNKZiPipQ3uSkJHNC4nwM4YN2G/j76nzQsVoVaSi0oBXV0g1/ZIxqqFSBv8Dui+cvUaXuKADi7xkA5ve/yQq0XCrUmLfNCIBSczIez264GfbxxgVGgXVbKqxCnu6IixQonApCdF1UxTlvtF++Owq/z6HWTKHqlaHjNsXWlQRkuhbKlhcCzppUigOy4Lnz1revmDvYcO2xx8fJQPUN/dRO/QD6wgjcyiZGxNZMOSblO+JCMXrsUBMLd8x5PqR+BjX293uiKSX0k5QGSxjaaAjfW9V6vu/e8CQNCfVRNxJscjVnTDlYK4t85ujFGfeFUZ1T91g6GZg9uAqvkAuj8/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nW8+IeKakByJAnyHDpTRaC4II2hpR5or8s9eUwu9ftg=;
 b=IuChLmXHY7wQjiMzLaQE/xk4i8wtupqipw7gEgilS2p4WkFwE9MmDUO8XICznD+dTe0TaTRhFHScyLNiSxfEvlQii7o4Prl9lXcc2/19NGIpPWc++RY+zy0AO0tI3274c0BY0w8kecS21OFj5Di0ixqSxxmjYpnwJyuwfTdxnEGtI62fovE8yR1IvEzk8wmnhTIHRk55uefModbxFyWV62lLuEoRhg4UJifaKZqAl13cCf1ABG8ARk8iq9dxryGS4qjeXHRbFsS7JKFtoBP6jsCkmKEXosW4843UqeawFeO+2/DNPMymwsibW3+iEdYfFNkY0a9a20XzIdEDYFJ/fw==
Received: from MW4PR12MB6802.namprd12.prod.outlook.com (2603:10b6:303:20f::19)
 by BY5PR12MB4243.namprd12.prod.outlook.com (2603:10b6:a03:20f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.12; Thu, 17 Sep
 2026 10:19:21 +0000
Received: from MW4PR12MB6802.namprd12.prod.outlook.com
 ([fe80::51f4:a3d9:b44e:9587]) by MW4PR12MB6802.namprd12.prod.outlook.com
 ([fe80::51f4:a3d9:b44e:9587%4]) with mapi id 15.21.0406.007; Thu, 17 Sep 2026
 10:19:21 +0000
Message-ID: <a1f19a59-7dd5-4fb1-b5db-3efee8d249e7@nvidia.com>
Date: Thu, 17 Sep 2026 13:19:12 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
To: Johannes Weiner <hannes@cmpxchg.org>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Hugh Dickins
 <hughd@google.com>, Nirmoy Das <nirmoyd@nvidia.com>,
 Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260901190123.3511535-1-noren@nvidia.com>
 <20260902162323.GO3004@cmpxchg.org> <aphS2TancJAZLND7@gremlin>
 <20260902183752.GP3004@cmpxchg.org>
Content-Language: en-US
From: Nimrod Oren <noren@nvidia.com>
In-Reply-To: <20260902183752.GP3004@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR5P281CA0059.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f0::13) To MW4PR12MB6802.namprd12.prod.outlook.com
 (2603:10b6:303:20f::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR12MB6802:EE_|BY5PR12MB4243:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e825784-666a-4011-f3b5-08df14a523c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	gXKwncl/XHaFufBaAsahEev/cVbgRPOfdYuMymW0Ig2i40UP/qJheROBQbduwWyRoSiwGBfCTs3FZVshQ5hqZSFFRG6U48YPQ1fnrmaMTb8uAlff+tilfC4uqFpAarh8rfNdG0JicflSHGneSIzvM1rOSe1qfGI+zbCJL4G4qZa2DIUXqjaCMMhiZ+29fEDRBzTCE9rI6NgBLHUB1itDSydmifv9m8PYPfin9VICWCxjpXmIbo2lc0son/d3aj5F9szpoArkYKznZhNCzs/OHVMoBshb+XmRM1kOpT5hr1nXLJz7Saw5rLlPFfOJbofzaVAXXclL4CdZJqLHAxZAjsFY9K0u7Nvgl1MuOyyUbSFS//5blwD4HNLGFwSrpnAz38vPE9VZ34IABY7iiyl1onB7lwHIewILHsDTojQ2in5kUU8kt3b1AHlMMEXTGLO0ejKWyblfgnsPQX27PSLPnHcaX/9OcJYXNMYqXVtYLoLezlOyk5CDxthOXm+uBKYNypqzEnhP8ortksFaNj6bMxmosAl9hEHrOg5vOQisZclgIGHEhtlI2uXiCInY3OJx+VeHS5//wFdD0HgIk6+r2Ubq8xr79Kk0vSK+gY4EoL+wXiKHNopHM8FdoiQXgU/nfn9uwGLmLEaBxNiDdCR9Eo6cULAl49PqoQJNCV1+D3Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR12MB6802.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ODZHaGpQYXhLdVl0eXR5VmpIcldNUXJTU1lveE5CU2xVWDdDN1psL2VTMGJO?=
 =?utf-8?B?aFV4NWFLL0ZVVkE0blQzQ1F6N0hzRHV6R3ZtaExjaWkybmVZNVRoL3ZoRFhV?=
 =?utf-8?B?YWFDMXg3TGhsL29Vam9MQ0lsNmV1QWhqdmNVbjljcG9nWTZwaGc0RzZlT3B3?=
 =?utf-8?B?bmdhaE12RDY0dXFZTU1tdmZFaTBFUHowRHljUC81U1Qzd2RLMkp2QVpjS244?=
 =?utf-8?B?UFhnME1TamJ2MzJSVHJ6TkVuZC9GRGFVbFZXdGppc2xPVGZzTlUwQnhEWXBR?=
 =?utf-8?B?S2dDbi9OTENBbFhjMzdZZkRsZ2xhSXN5YlpRbmVPVUZ3dCtCRmhJNzcvYmdq?=
 =?utf-8?B?YmtnQmJkdUNCWTlSenRBN1gxVXZPVGVVdjZJWHhVUDRad2tPMnhGelFCLy9P?=
 =?utf-8?B?NmJlRkYzc0NuQUxOT2piTWZURHpUZ2Z1MEdOVmxyZDhuTllrbnpYSlJ6bXZN?=
 =?utf-8?B?Rml0VTR5VUFrUHpCeFEydEF5eHlCNmd5dEVacWpPVGN3dFBvZDE5ZHNLNFlR?=
 =?utf-8?B?RzZPN01IN3hKcmRIRnZrdEVCemtyWVVqTWtLWGpMQWUxYk80WEZwMFZtMkZQ?=
 =?utf-8?B?VEU2dDg3RU9zOEo1eEZjT2tCZDltbWplZ0lLREI3Mnd5WEhUQmdKTzg0Y1Jp?=
 =?utf-8?B?bWZQeFpudGlqcEViVnZMeGN0aURVL3B5K29IaysvWnV6LzA3dUFaWkVzcnRx?=
 =?utf-8?B?c2czYVJsWEpBcnRTR3NDbGd1eXVyNXJPMytyS1pkZlY4VytDVWovZlQza3Fy?=
 =?utf-8?B?d3lTT21nTUloWi9ESHRhQklERk9mOUNSTk5kcmtoOEFjOTgzdzVibUdtV2Iz?=
 =?utf-8?B?TEpTM2FnM1ZJZUVweVBIWUVvNU9mMHhLU0VvWlVmcDh4WmpmQkFzc2w0enYy?=
 =?utf-8?B?MS9KQ2R0R0NvVnhOZFg4ODNPVkcyTlJnelIrS0V4QjBLVm5wTEJUSGxIUUJx?=
 =?utf-8?B?S0I1blZIOEFFR2tiTDZUTHdpaXdQTldhN1FjUGFIYUNQenFubEpPWkx3Sjhx?=
 =?utf-8?B?dmtMOG1RNGo0WGJrM1RTcHlCaUlTNGFhNk1BNHZkYkFuRmN5Y0hvakVqcGdC?=
 =?utf-8?B?ZTFoT2kvNnAwS2tMajdjb3hLQjdpc1grRVJMRTFLazNzSEtNZVlGU3lzNjlM?=
 =?utf-8?B?dFlrNzkrYW9yZlZHSVhtVzJEeEw3Q0pWaDlxSzc0OUszWkRINU5idXRWNXZn?=
 =?utf-8?B?MElJRmQ1eFM5ZHArRDdwUjUrZWtmNUorYitEcU9oTkdTR253ejh4bElRa3p6?=
 =?utf-8?B?aEt5cUFUN0lOdlhIb1RSRjFPc1FnNGlzbGI4YVI4WGppR0RzOXhBczlhUExw?=
 =?utf-8?B?aTV1R09RYTJVZEhqcDhnalRDMGpFTWo2OGFuNkNHc2Uzd1kzODhsYS9OTHR5?=
 =?utf-8?B?Z1ZGQUNUeStmdGk4MGc5Y0NqdlAzditGQnZTRHBMV1RWaTlaZFlsUi9nMy8y?=
 =?utf-8?B?MFZGRnNkeGkxNjZJR0tXZEppeFF5QVJRdnRrRGlFRTJyeXg5N0dmY0NGRjlD?=
 =?utf-8?B?SzZEU3JTdS9sNyttMStRclpGenJ3NUxpOFpZM3FpR3d5YkxtVkFlb0pjcUxa?=
 =?utf-8?B?a2ViNlN1dUZWWWF1ckk4b0Vrc3N0OENzTktvc1l6TGhHaTVjUjF4dHZVZ1Z0?=
 =?utf-8?B?UHN1Y21sUDM2YVBZY2VIYjlpbjNiTVY0eGEzRUN2OEFDOTNybkV5MVY1WER3?=
 =?utf-8?B?bzFTQXJ3Nzh3T3gyYm9FQUw3VUdxWmdWMWl5Vm9ldHREcXVYWHdBandZOWU4?=
 =?utf-8?B?MzVhVTZKTjkwQnhPZ0ZtdUtteDgwMDRsaFRHVUd4WFVxaUZCbTNONVdaWnRq?=
 =?utf-8?B?UGZZNHFYdmRBYU41c2lOOTdWWlBhZ28rYTh3N0o5QzQwSTZXMXNEVVNXWnJt?=
 =?utf-8?B?WW9ldGc5WnE4MFBmNFdtVmxIbEpQYUxQU2Nic2sxS2JjT2NZYlJpTjZveG1l?=
 =?utf-8?B?c2JDMHlXS1BHVlN3YzlFZExHWHhRRDBFT3FyUnI4UlAyMU0yNmlMRHc3akRy?=
 =?utf-8?B?RWprd1dSdTlCU1l3NnB5WnZhenoxNGI2eHZmZzcwWkM5WHNMdzBLZW11c3Fn?=
 =?utf-8?B?amhTVHo5RkI5QkNBZEpsazFkVUloQXgydzFueEEzWFcwdjREZ2ZOUTVUL3c5?=
 =?utf-8?B?ckxoenZERnRURUd1SUZOUC9FWDgzdGQ5QXFyZzdaT1J0cjdEOWxIV0t6bTI1?=
 =?utf-8?B?N1BKbzRGc1JjWDhZcjZJMVVNSDZpNDB2elBYQ2x3ZHcyV2gvT0Naa0Yvbk8x?=
 =?utf-8?B?a1psVWE1MWt5NXdDc2xuNkxNQVd1d0VFSlR4cmpNb1hNMFZGb0NydkdDa2NM?=
 =?utf-8?Q?TdEAOFNjyM4kBDYLxy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e825784-666a-4011-f3b5-08df14a523c6
X-MS-Exchange-CrossTenant-AuthSource: MW4PR12MB6802.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 10:19:21.4597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EOBsgjZ5nNiHj5OIEh8Orro/by7N3rc5YGD52LCCSx4GUQHlOKhipukNdBZxPX4QHY24ZWtuO8zy/59tX4Sitg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4243
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 82514100004
X-Stat-Signature: m9tscu6u1bokgbt7q7oxbqhyrrurdyyh
X-Rspam-User: 
X-HE-Tag: 1789640367-101172
X-HE-Meta: U2FsdGVkX1/UMkJKH3VRjaq+7rgES35gIss+hlyTN4Q1JMt9JB5+Icdzf7j/8yFtWaUExf1gsnFORC85tHypuLV/Pwhx2mGgyMxH+xry8W5eRhinMH4G31Uoy3eohiZ4558KWsFpENfGbMP/Hq/y4cpzXRHF5sfd+jfYEhTgaAvnB0E3SCkD/Rv/6lEi0TMvtfCBbaJYJZhaKp9lJiS47D4fvMT2/mQRIaajJx+EnSnFk8EzobAMxzG5DoeCth2QsXdKYnr9YaMrdPZEndAdKb8++hBir9igueBAS9feTdeCCZNJaC7L3QL1gHGNT11ogWYYOBsBqtfqWhdBYeKBCVAzQ2Q6mRXrtKqVPP/vqX1cq6AewZMUEAYQ7ZOkN7XtuKl79LueGDMfwXmHVYvVsaqSFyk/syUZy3YAvBYJBuMenwpNwMH1F3RQmpsATOW1wirjHWymsEOYUv6lZCTWjZZwCk/4I3VNPv7kGVQDE2j6Xk5+yUrOAxcZsBgAnhlMS7KKSKkJIvSVJ4eegVEuqNuV9bSpt78Z1ELmpTklV15CcsuSZ+YII2PxvLTvLMfmOm4II/32gOXXJ+UGGhPq724oQRtO//S0O3D0bWyPDZC4+sHU5DlbeZJTJGvEpau20Omdl55n7epYfMyDiaHml2lA/wPjo6fv8BJ31/xhQ6MeuYOaEUpmpOmQmAEN/XbVgmGqAF1cKTRxp8tMLm3D4kRSlgZ/i97F7NcjyO21o5rzt1iPGwCOpVN4vvt9oIoIH40ZYozSGws8raBFIgEm41rKaW1uPah8nS8x4WTU7XjrKQtcxAmpQfa8zNwWUg4WABBp6eGxQA3hfiu/3pyTTLKWAP6vblG/xRiLJUS1U4LEPBJCby9Oarac9xT05JKQbEclFZeoQFhHCTtdIBw9p52elrCnf1iDIwYRn/0p249OmfRB5HKJHN90sEjVIy9Mrv4kjutNhbzDWssqTTQ
 IyYdWkcJ
 ml55/HZ525d2jlwJCLxqPh7z+dZYD7gTRIAdsw8k68sSDlki194e8iXjbCotELN2m/of8gGFvF+4mmxMWGFB1+XLwJl6PDxAYNHpjPjV2nTHy2yLpFVd9XXv1jmj4d5x+zUtyGGGkYcGnrSRFxEKxGSZqL3KdIzo1VawD4+FpmQlmFVNEf+6VtEEL85IxSKZVdLQPqMC8dioVujh6dN/WL04XpMgi0ZUVxYcEznag43rc8dXUxPLAa2nQraoY6+jjVHDg5ypk/WCU37dwoQMWuLumhpN52zKXim3YQ40+N5d6PaY+A4z050P+IC0GnkCDL6mzvgK+A3Gg1NmX2Z6VYwOuj3MSAOzZ16VKjzM/4Cg6PJmGSiHhfBvCsFeq7MRAXWt681H/Zivohsp0bXc+G1lF5WQDmNsf2miWEXbxvG4Q+tZIqgi/qe+dr3yTupb3jGO2vUcXimFo/jxIbvDgfmLLbRcKplIf6Uj2+whe2H109icq1hg4saA+2ga3+anCKK1u2EaWSBVjxXs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02/09/2026 21:37, Johannes Weiner wrote:
> On Wed, Sep 02, 2026 at 06:00:55PM +0100, Lorenzo Stoakes (ARM) wrote:
>> On Wed, Sep 02, 2026 at 12:23:23PM -0400, Johannes Weiner wrote:
>>> I'm not against carefully evaluating and testing out today's need for
>>> set_recommended_min_free_kbytes() in real world examples. But this is
>>> not that.
>>>
>>> Nacked-by: Johannes Weiner <hannes@cmpxchg.org>
>>
>> Isn't every possible change to address this kind of issue subject to
>> exactly the same kind of constraint?
>>
>> I'd like to know what not rolling that dice looks like :) or what
>> constitutes 'careful evaluation'.
> 
> Usama gave some great examples in his other email. I'm not really
> arguing to keep things out of tradition. But I think it's fair to say
> let's at least test the common 4k/2M THP setups under memory pressure
> before and after the change.

Hi,

I tested this on an x86-64 (4K/2M) virtual machine with one NUMA node
and 16 GiB online memory, using mmtests config-workload-thpchallenge-fio
with THPCHALLENGE_MADV_HUGEPAGE=yes.
min_free_kbytes was 16 MiB patched and 66 MiB unpatched.

I ran each kernel 30 times, rebooting before each run. The results did
not show a regression in THP fault success rate or latency:

Average THP fault success (Percentage Faults Huge) increased from
13.07% unpatched to 13.34% patched, and average fault latency
(Fault Latencies) decreased by 6.5%.

In contrast, compaction metrics were higher on average with the patch:

  Compaction stalls:          1,635 -> 1,713        (+4.7%)
  Compaction failures:        1,350 -> 1,416        (+4.9%)
  Compaction migrate scanned: 4,812,254 -> 5,587,587 (+16.1%)

Thanks,


