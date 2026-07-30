Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB1CAC55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 11:28:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFCA66B008C; Thu, 30 Jul 2026 07:28:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED4536B0092; Thu, 30 Jul 2026 07:28:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEAF46B0093; Thu, 30 Jul 2026 07:28:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B6CDC6B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:28:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 597E6160979
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:28:25 +0000 (UTC)
X-FDA: 85045219770.04.4EA8994
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010005.outbound.protection.outlook.com [52.101.46.5])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7DF3940005
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:28:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CQGs1dxO;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.5 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785410902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6JkJvUdOcTvOd0LUVvHFRE6mI6zxIAgOpwuhXcBBN30=;
	b=ZaoFsBYnZEAfIrHyfKWRwSFcR1aGTqdJI7+6GkuASEdXVehCXsKnH3+l1RcGpdN53nwpiz
	ICiUwy4Q9mAn3mHj6gXXrlfZjxo4qBhSe/CknO03398wDG8Aj/V0ruXt8owKr2M/XnP0Ac
	G8YSxDRyQHystSK6bCdDNNrUCqRnhdM=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CQGs1dxO;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.5 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785410902;
	b=WK3PhGPQnZQ8XeqfT/33RKxUBzX9cifv5zjDgsDb55a+lOC7JzwIS94hnq3pzjbJGXWA/a
	qoBqoZxEpsX8dFaUVJEch5b5md86Y9OXvRC+1Gj8x5ycxd02yBXFVOiFmnfJxVI1yaFyNS
	dEqQ3b6K+rfED9neKmEjnAfKoKgInWc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k+EOhhdz+hAUQ0b8Ayre8iG3wwscZfUL4AkBDlLAcbDYy5Pgl6RTvxbJpUuGDQyMcc+k8a2YPyT+6ICT1xzL9lr0ry9gf5RCaG+X4K81RmY9dzgJOCLPqGW4w8obTD5xvL0i0DyiyevizaBAAGmowplx4boYLKgW19M+cvBbH/1tz3pxpjYeh4S9KKH6zmSmtP3+K03uULS92y+R68hynZkf3QVQkW20NPhwh8hjiOyLsTZTbev/aPbl4a33lkxmp+m52Xtm5aSdluvS0/PxntwyShIZRhq/Dy0Gr7SVXfC0opBBWlb8AsPuTZgnPjePx5lh/8CRNlnyROv9/ef80w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6JkJvUdOcTvOd0LUVvHFRE6mI6zxIAgOpwuhXcBBN30=;
 b=dGFzQLKVPm6SuoemlKGOgIyAKnD4yUDaVcESNa7nGtEwfBy6PKsu/qqHfrFdOpciP4pml0Nw/Dz2KM8l3iGw2zYI6/KiGBvMPChAC5c9d0/yGuRvteEYJqWz0MoxEM9S+mLIvrpZDqMrdAVYZ3tjaf9muvXwyk05ogVeJIOcunff3GA8I6zcpnwChr3DwDwWsg2TjkKiUHfX6wPVERB9f/s/L603MM7Cf9VCWHg6Sip7pjZGmAMX5VshJDGWOSKj2eJZooPUWkb/J6JjmQEns7fxcTU68dmomRZAsWJoTGKdkelnUdF6Avf6j7EO20GF94kA/dUFOzksntvoUYiPVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6JkJvUdOcTvOd0LUVvHFRE6mI6zxIAgOpwuhXcBBN30=;
 b=CQGs1dxO3EXectNQP+PGWEx7f4slqzCK+yfD54/H2bxH1MUQh1v+7elHwbo2tAp5owPEOmBczf6tKs1VZY8G2yNn4FC3Jvb9L6aDqsaL/Cg7b+6kN7gV1speSdujS8lxfrSsjFE/dNbPjqscSy+vi3IrGNLLtCIbDNJVHnonKqqcZQ6htKDg1V06oY4MeNNfgt314PpHHnVMa/jlsj9L48vwWe+iDs6naNzClL9G56mV6V40GxiMANxSaEdolKsyWwOP9WHGiaiWZukYPw6IzDUYKtwkAXZRiou4kWEf5BUsubs2yfC8v7z3v/YszNpfhdh8/5IQ2uwJclZBVaw24g==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB5842.namprd12.prod.outlook.com (2603:10b6:8:65::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.14; Thu, 30 Jul
 2026 11:28:16 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0270.012; Thu, 30 Jul 2026
 11:28:16 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 30 Jul 2026 07:28:15 -0400
Message-Id: <DKBVCAAWYY3Q.30A7UB9E6PEZN@nvidia.com>
Subject: Re: [RFC PATCH v2 1/2] mm: allow smaller large folios to use
 lru_cache
Cc: <akpm@linux-foundation.org>, <baolin.wang@linux.alibaba.com>,
 <dev.jain@arm.com>, <lance.yang@linux.dev>, <liam@infradead.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <ljs@kernel.org>,
 <mhocko@suse.com>, <npache@redhat.com>, <rppt@kernel.org>,
 <ryan.roberts@arm.com>, <surenb@google.com>, <vbabka@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Barry Song (Xiaomi)"
 <baohua@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <229c3079-8fde-41b4-9d6c-f0e34f780555@kernel.org>
 <20260729222651.31321-1-baohua@kernel.org>
 <6a3bfdb9-7839-4f39-ba5c-5a0c55055aee@kernel.org>
In-Reply-To: <6a3bfdb9-7839-4f39-ba5c-5a0c55055aee@kernel.org>
X-ClientProxiedBy: MN2PR08CA0016.namprd08.prod.outlook.com
 (2603:10b6:208:239::21) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB5842:EE_
X-MS-Office365-Filtering-Correlation-Id: 4113b259-c018-4c0e-e28c-08deee2da63d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|56012099006|4143699003|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	w8Fs1kNzfQwvsyVGEnbxMov7Fb/l4NnSkrJgIvXgTrmLhGMgVny10FX3k0dazXMB9DCULWsH3jka6wdp642i2FI3QlfYoapT20lYepNyDJKDtVLIkPuZlnfQMre2YCslOZtQdpASjJW+6fusPWViQ/Ohyq2gJQyr7WAhrdgpRqE8uEhDPSlUVHLpwHOX/Ue8Gx29cT0TB/6s+p9Iz0DKw0GdvPP8fnK3aTRDY2wwH07HmP6LoChNdF738LtJdEUa8Hpq9BHEu0kBpl19kIArRbf3dR7kLEC3G2fu3anhobEqUlw6WgEvD1jI6N6uJViyHhfmcQCRAcEGmkGO/+fmnXiS4aCSTwnVSxGhG9t+jF7jw9JekLKeqhO01XZrwyhxI9d6OTcmTp/jRtB0UDlrae/8Nf+JKQq9rX3nSak9S1iITMMPRWCIchzUGnU2lnofaPlOFrGmDzQPdN4beKCJgtG6yjhjcV3jdTkrlzuWuHkmO8oDzud9PZJm0F09IlVTCGHUpXEAUm8Hf7TwTqxaV6SL9EJUWrITAKvq+7X2bNdaS3x3cgXpDh1CK+UzPtR1kLwLedOiKQZEepuaujw3/sybmGfCZxFIxv62s8g3I9npsnRXow01zzz9InbAzzY0JJgSByL+dkX2BjqJTYNQ1ve8aEO6rdokLss914j5T4M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(56012099006)(4143699003)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZFFZZVdNMlc2ZldvbUM2VXU2R2RvTlBXN0N4bGMxZzNLdHZvZEFoWjE0WkVL?=
 =?utf-8?B?MTJGYWQvQnF1WU1QNkdnd0xKbHJvcklDd2hLd3Q5S213bkZvckFnbGt1bUpS?=
 =?utf-8?B?TXJNbXM3eVhQKzE5MGdmSkZ4ZDhpUDI1TDYrdlhOQkY3RkhpK1Y2MXU5b1E3?=
 =?utf-8?B?VG1CdDlOaGZPWGlnVWQ3RUJGNnJ6UEZJVFRYcGZwMWR0YkYwMUFSZ0N3TFcv?=
 =?utf-8?B?RnNwNkloTmZ4K21mWm4ydkpiYkZxcFMwS3RBUGZ6Wi8rTG9aSytubExLaUox?=
 =?utf-8?B?OGlkbUZEeGdoMEtkbWN0NkNOWWRPQWJBd1NrSG52NzVwNTJXeGQ2UzU2ek8v?=
 =?utf-8?B?NHNybWhhMjEwSlQ1MzcySGY3MTVlY2xLVDF6MmdXR3hvUFNBeENLblZUcFdM?=
 =?utf-8?B?OXpUbGRwWE0vbUU0RVpRdnBQQmNGaGtxVjlNYlZLdWhId1J2aGZtS1QzaElP?=
 =?utf-8?B?OTdtaDYrbldSaCtZbEFkU2pVWVUvMExLMHdiQW9XQjZib1JDM0lqQmxEVE5K?=
 =?utf-8?B?c3BSb2hKNlk0QnpNTllFa2VSS21mR1g0cjJCTEhFT2hOWjNJTys1TkpPOGpC?=
 =?utf-8?B?T2c5V0tINldGY0dQRW5EZDRRb0dmUnY1ckhHcWJCSU1zdEFwMGw2ZGtYRGh5?=
 =?utf-8?B?UHRkbk0reE14MUtJaWVSVlEzNXN5aFJiUmxiMHJHZGVCTFFnaEQ3WHB4eHRC?=
 =?utf-8?B?QTJ4KzNUT2x6THJYZWFmS3hTbjAyRWNlYVdwdDNPWkNHTzhhZXlSRWc4dDE2?=
 =?utf-8?B?YWhESXppdEN0bmp6VlJVREo0TERWVk1UTWkzU25jckEvbXptVUJFTGpiWDJM?=
 =?utf-8?B?cEoyUEdINDg3NE54aURUUXZka1JPT21HREIyQkFmR3B3M1FyZVVMRW5uZGt5?=
 =?utf-8?B?MkxSb0M5R1dqZkVJdWNnNGhmV0FtY2ZWWEMweGd0ZU5rVDlHc1lUemVMYm15?=
 =?utf-8?B?OFRkUDNmMGFseHZDRTR2L0NySCtxRzBnb1gxeXlLNTI2REV6Z0srcVJybzM2?=
 =?utf-8?B?YlhMTmFsZ2lRQ3Rodnk5SXBrZ0k5K3JtbXhZTkpXb0E2UFp4TVFKanU5aXBj?=
 =?utf-8?B?bG9BM292Y1cvRkpYdk00V2w2T1BoV3NDN1BVT1JXVDRIeUk2T09xc3c5SnV5?=
 =?utf-8?B?bHhuMDI3Q1duUkdYRVNHS2RMQXU4OVhUWlExbS9ZTENyNTdmeVFYajNGRktm?=
 =?utf-8?B?RjJ0cld4SWxReWFLSGRmYTV3dm9Na290Wm40Qy85cC9XSkdhNlJXcTdVRjhS?=
 =?utf-8?B?T2JlamlteTdIUUpKeDNtNGVyL1B2VkRJT1B6Ulg0SGlSNnNNeWhZbmswRUM0?=
 =?utf-8?B?UWRiejkvRGEwOE1HcExXVG5TM1htY256T3F1UjhWODVQdjVqQTZsZS8vNlJI?=
 =?utf-8?B?empxNjlidVpJYzR1K1BoeE81ak5jR0R0RERvWEF5ejIwSGRHQ05ET2hnM1ZH?=
 =?utf-8?B?Y3pLQmdpM3BiQXp5TGRZUW1SWXFRYWdwVUpDYTRMVFFLODhyTndEUlJ1MEtw?=
 =?utf-8?B?TmhRVHRrNTBqOUMzZjgyb0JkTndzempCcGp5OXlnbStydDRVTkgvS3NDMDd6?=
 =?utf-8?B?N3ZkOFhuRCsvcXdVTW5BaU1RQU9qc1J2RmJvY0QvRUVic2tLU2p4eGxtNGlX?=
 =?utf-8?B?L0ZEaFIwdmRxUUV0bVRpTHc0RVpvRGVjVjl3TzYwZWVrOTVLUWV0K012WHFa?=
 =?utf-8?B?V1lhRm5ENWhvVzFwOUFoRkpMVFViNkVDQXcwaWhWaHd0OHJ1MUhkc1MrRXdR?=
 =?utf-8?B?QnhpZmJVUjFyOWdrWC9jRWxGbDh1OXNyMktoa242T3liUVBxVFBwQ2pIMjlp?=
 =?utf-8?B?WDRKQVNHUGlJUEJWWFRNNnJwQUozaDg0cmN3RDdmQitKQ0NONk5udUswcFJM?=
 =?utf-8?B?dUlpZXA2SXZyckI4ZVNxN3FWcFMvQllDOUt2bWttWGphVU9WcVhjU3A5Yzk3?=
 =?utf-8?B?WEUyU0pJbC9PdEFTSjNyR0tUY3VoVmJNamtHZFB2bzg2VEpNNEQ4bG1yTGFx?=
 =?utf-8?B?bHVpL3F0T1FRZnNhejZrM2g4WmI2c20vczFKQjVQVUI5M0RZOEhRLzRsSUdw?=
 =?utf-8?B?emlnL0NMTm5XWFRYYWhHWm5JU1pDa29zc3pxSitTLzM1bHU3V1EwdFNGT1dw?=
 =?utf-8?B?QmIrZzBUMzZHUkJ5VHc2dUE2cDJHZStyaTFJZHczb1RMRFFjYks4cXUwQ09U?=
 =?utf-8?B?SkJYQXdZNnB1UUY2ZTRUYkpLQVBnU21oaGFFTGFxZVRMV1lEQUgxcHB6di91?=
 =?utf-8?B?QTB0RHpweTB6T0Raa1dzLzRoMFY2VE53MUREVnY5dzFXRjFQYllEQWlZeks5?=
 =?utf-8?Q?GJPhlOy+FlweDoOJJO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4113b259-c018-4c0e-e28c-08deee2da63d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 11:28:16.4593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dura9X+tlS+BPHfgA+RQ4NKG1IXZ1V91vdcG/R2jd2Ijwm6uSacCceaZYTjFmicn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5842
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7DF3940005
X-Stat-Signature: jitshpwbduuf1zeyawojnjybkjubbz79
X-HE-Tag: 1785410902-164298
X-HE-Meta: U2FsdGVkX1/sZG7mB7EUo4TcWiPkt3qnOrNa1LN75gY7KvqFOfUxAS6xuGkxM/hNJLu2Xv4zYBhiyyVHz5qWB+EnJfggz1HdZbx4z6OlOowxsy45fbVW7zJ6ks7UzjT5PogdgM+fA+LgB/f6rGJbSpzkr1M7IHnsjAldPEvvyTtXzECsnwdphzXlZhho20mOHgvgixihq0SuUZY/7jQriaCBxT1E/S4paLTKbA5g28yykPF7zFJnmr3yrynNXwKoDHfr3dz5Gf5lfqjA/gurAtOGlpCoIdWdNDQZ2lDxl37O29/Iu4QaqrS2DByxu+JkQqGJkd7oNMOjplc6yMkeGPPdZuO6IJ6l6kmkQwaU/KVC/SLRPmdD/q1iY/ogxT+8tCbIPxtqZC3l6id3Gr/yEyyf7OjC7Qw6MtoRnXLO6Wmv6L5aoYv4z67xpTTbEQbxuhSOVyN9F8WM5BdkSQUjj9d80RnuJ/A8a15CVzCTqNsv0rEFGIihulfZf53m+s34yYCztJPXsYZOYiX7AvfeLEEcmNNLvl65AXu6BXPwfoqXIsenxqkBb4xYFr5ClUhaoMC66aKqoQomIaJgs2mC2rGQTyhTBI+KnSCBk1JmoO0J6o+8z/JtIjMMpS1n2i0/Q/2ZHL+q3mspDrK6MS1gaO2NpPr0uuOnXPJ5w8Jdyp0BiZ7fO11eO1Wv1qLvgHHaXYiNp3hzaC6pTaOIc96n266OnfYbX0owO/7mi7TeCbOggbvj8JV9Qwvi4ZOW0/0aVMQWHf2yg5rrkDLAFqZpJbccCQEE5NsC9IvWCMp+EOw9K7NWBRo+xu5mNrcsJNyTLmxWx6+3DoScq3imiQpKKvjSHolP2ybGoyL1jnaxnl6TOfAp+UCmwvJuWae/uVozGNRHdzaG8LQQwNog+k5WumkPnVgvlSjjRo7EQYJb8e9DJBWpB1YRPBVuzkuGMZl3I2WSiqAzMJoI+rtJ6M3
 SEcqY3hv
 vf1gREswqdfMHodRm4bXagiIoxNKLnXwH0yhaepw3aXRLfy5sO63DQjx8dm7rJoXt8J2zmhxsWp4+R9t3Ai1xMq4O8a0RkEc+abE6cz7FO2wRKNQQXNgKmLMF5VgfVqOuRibTnz5GJ/fk9jIPjKUv9RU5SqkPGg+T7TlvelLeBQdMKm1gLGFrKjaPHH2DKeOSVoNJVB/eALz+tW6jPyX7dthEUr6fWzixJaqv/dfNmFa0eTLRN1X3AsOy6L0QFbar+f6qkr7g76/yZ7mE9yfhotvc7xo2mxh/oUG+DJ22UyNJ5j98Rq+Jm1yIc36BEsEHkq2V8X/Pr9yBzdvmqjpUx7iN6NMdmGdVBKW89VxN1VyidKorLE0wJzEh/L/T3MbS++sEcVlaSSTJctPg2a4Cwen0LwLwHrmEQ/2gDYjTVvPm5BEAm1jWkMjwd/hwmuNC65Uq36Ydu7Bjj+3BxecFqMMqmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jul 30, 2026 at 5:28 AM EDT, David Hildenbrand (Arm) wrote:
> On 7/30/26 00:26, Barry Song (Xiaomi) wrote:
>> On Wed, Jul 29, 2026 at 8:13=E2=80=AFPM David Hildenbrand (Arm) <david@k=
ernel.org> wrote:
>> [...]
>>>> diff --git a/include/linux/swap.h b/include/linux/swap.h
>>>> index 8d19be675baf..9c5f7a11c7b0 100644
>>>> --- a/include/linux/swap.h
>>>> +++ b/include/linux/swap.h
>>>> @@ -316,9 +316,9 @@ static inline bool folio_may_be_lru_cached(struct =
folio *folio)
>>>>       /*
>>>>        * Holding PMD-sized folios in per-CPU LRU cache unbalances acco=
unting.
>>>>        * Holding small numbers of low-order mTHP folios in per-CPU LRU=
 cache
>>>> -      * will be sensible, but nobody has implemented and tested that =
yet.
>>>> +      * will be sensible.
>>>>        */
>>>> -     return !folio_test_large(folio);
>>>> +     return folio_order(folio) < PAGE_ALLOC_COSTLY_ORDER;
>>>>  }
>>>>
>>>>  extern atomic_t lru_disable_count;
>>>
>>> Sashiko rightfully raises that split_folio() can now fail more easily.
>>>
>>> So we might want to proactively drain (earlier?) on some more of the sp=
lit paths.
>>=20
>> Yes, this is a pain. I haven't tested it, but perhaps a
>> conceptual model could be something like this?
>>=20
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 04e8a6b55343..fcd449dec96b 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4069,6 +4069,8 @@ static int __folio_split(struct folio *folio, unsi=
gned int new_order,
>>  	struct folio *new_folio, *next;
>>  	int nr_shmem_dropped =3D 0;
>>  	enum ttu_flags ttu_flags =3D 0;
>> +	bool maybe_in_lru_cache;
>> +	int expected_ref_count;
>>  	int ret;
>>  	pgoff_t end =3D 0;
>> =20
>> @@ -4154,7 +4156,15 @@ static int __folio_split(struct folio *folio, uns=
igned int new_order,
>>  	 * Racy check if we can split the page, before unmap_folio() will
>>  	 * split PMDs
>>  	 */
>> -	if (folio_expected_ref_count(folio) !=3D folio_ref_count(folio) - 1) {
>> +	maybe_in_lru_cache =3D folio_may_be_lru_cached(folio) && !folio_test_l=
ru(folio);
>> +	expected_ref_count =3D folio_expected_ref_count(folio);
>> +	if (expected_ref_count + maybe_in_lru_cache < folio_ref_count(folio) -=
 1) {
>> +		ret =3D -EAGAIN;
>> +		goto out_unlock;
>> +	}
>> +	if (maybe_in_lru_cache)
>> +		lru_add_drain_all();
>
> The drain-all is nasty. In  collect_longterm_unpinnable_folios() we escal=
ate the
> drainining.
>
> I think we recently stumbled into a similar problem in guest_memfd.
>
> Ah, yes, there it is:
>
> https://lore.kernel.org/r/20260728-gmem-inplace-conversion-v9-14-35f9aec2=
aed2@google.com

Page migration has this issue for a long time.

I wonder if we can re-design per-CPU LRU cache so that we can remove a
folio from per-CPU LRU cache without drainining any to LRU lists.

Something like:
1. have a folio on per-CPU LRU cache to store a pointer to its
fb_batch's folio array position;

2. zero that position when we want to drain that specific folio.

But I have not looked into all the details to make sure that is feasible
yet.


--=20
Best Regards,
Yan, Zi


