Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BDECC87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 10:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0156D8E0014; Wed,  6 Aug 2025 06:21:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2EA48E0001; Wed,  6 Aug 2025 06:21:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF5F58E0014; Wed,  6 Aug 2025 06:21:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF6B98E0001
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 06:21:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8E6E4160520
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:21:09 +0000 (UTC)
X-FDA: 83745939858.27.14FA6E6
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010038.outbound.protection.outlook.com [52.101.69.38])
	by imf16.hostedemail.com (Postfix) with ESMTP id E378918000E
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:21:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="Fe/6lZW2";
	dkim=pass header.d=arm.com header.s=selector1 header.b="Fe/6lZW2";
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf16.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.69.38 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1754475666; a=rsa-sha256;
	cv=pass;
	b=hsoevgiShwDxKCGgIezNulAeR0qAvQ1e5DeEkEAMQ8PHmT7uqd5jhnJIrEKXME5EWDaYRn
	/inbIxg/+Bz/MiRwjesfbKc5zcsMO04YaNFfxmUM2dhs1J/2ihz/BRay4t6GrTGw+q3RHf
	qLanF8IIq346YSodNJDXMOxxQhWAn+g=
ARC-Authentication-Results: i=3;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="Fe/6lZW2";
	dkim=pass header.d=arm.com header.s=selector1 header.b="Fe/6lZW2";
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf16.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.69.38 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754475666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e+nkFD3zrF6Pwy/WTBUVkzIG1Xpa1ORR7mGu5TZ0atc=;
	b=gbo7QqjJNhchYfOkF93LIo+OoWEO3vqw2zu0EmG8gGomKK278EubCsvy1c6ShzGwDhRARA
	z5EWUg8PfBiKte/o38YsP4cnvsV4to8whpsp2wYvg/vrh4MPU+LU/8V938MjDShCk/OwsF
	2uWCyiTyYKx6WKvDZxeoLmx5/uPYNOc=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=jBr+0mu1JcyNiQ2SxL2V4SrCzJUherwEVnoCQYAg0Nj11ygE5m1AteTDvh8BevjglIv0EMo/tisyJuBkjvZTHi6xUSiuWUTFVncE1fpHf2Ow/FEmBTvAPpvYDayBJpy6co9dyTzSfaHG/Gj384jUafMAhWImlJstrq+Fe9edV4I7SP1MBbPIUjnXzh1naFsM0h9S1Z+5869YXPe/jo8QTJ/33VGgjrAVLjMr+AUnnNOYEK+dTQPMB6JFlrIxf26Ve6KTXXgRIdf7ap/LBq7JEUBmIokjFVJ0eS5wFaZHhRiKl7aS57kDGwW8FdXpogqPr0pEbOBLReiEpWApvSUfRw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e+nkFD3zrF6Pwy/WTBUVkzIG1Xpa1ORR7mGu5TZ0atc=;
 b=Ax7s5FD6DRB+tnJIk1C8VEouEXKt7Gs3Jo3TH8qkfvb74bGagTfQ3ZTzEfYLCCF7Y3mSHX2t0R1SEaFfZ1tKYdv+euJtR7DZ9vnwizfpDZPJ97xgNW4TChQ7ux/DFd6bEJOaj0JDU2wLZ94TE9gfPie47H0gCUG2GIicQO1Q6l2UIk9tFyOOhU93gLSWFQvkxG9e6uGX2dpf3obwnnIopHw6gEzBA6oRqKsCyCkLczwACCkorvnyB3W21FhEtmMuU08VLO269sZz/9bARCG5+sBOitTtIFHLJR2nLsVNiy1dtVIk+iQirR8qLHqFdlCX19eXH76j6snlcwXCFvZg2w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=redhat.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e+nkFD3zrF6Pwy/WTBUVkzIG1Xpa1ORR7mGu5TZ0atc=;
 b=Fe/6lZW2kY40QJA5O6QO/tHfQgX1zjZKGf+xMLXSTx4Q+O0wlw2zCJXO/U5UO6cw/QDpwpdG2iGyG1KzTXXLDVWswML196en72aaPVq8aVmvLYmvM1bBdl1/OkQdTzuBMni+Dal5iZBDTE9oHp0SAJ/xjlyRktNruSNYvj8BYRQ=
Received: from DU2PR04CA0226.eurprd04.prod.outlook.com (2603:10a6:10:2b1::21)
 by AM8PR08MB6355.eurprd08.prod.outlook.com (2603:10a6:20b:363::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.15; Wed, 6 Aug
 2025 10:21:01 +0000
Received: from DU6PEPF00009528.eurprd02.prod.outlook.com
 (2603:10a6:10:2b1:cafe::27) by DU2PR04CA0226.outlook.office365.com
 (2603:10a6:10:2b1::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.15 via Frontend Transport; Wed,
 6 Aug 2025 10:21:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009528.mail.protection.outlook.com (10.167.8.9) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.8 via
 Frontend Transport; Wed, 6 Aug 2025 10:21:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PG6bqQhH+XRDH8TdP4deOe7w84Bbrm80j8Xx1VSe78sVOR8bxJ7YHj7qpCS7Z7ZDzEA06R+PMT/V8bmINE9AJroZFJoPlOg1ZNkoO5oP6kzhWZa8Y/wPYJZU6haPiAalGMGzfheribOb1q/R00XMx/3DZX5h2u/LLV+oi47+5ZeMWW5WbVRzkWhNtsAWbVeghqzlrdGJ9s7Q1yJFI+AaGPUBc+FxkwQXY2uICpmxz3caFkIYnpcKr8t9DHeBZU3/gvFNFSmmiqn8UiBPeNHvqB6obgYDoQmBCsA6q57qpkLXx3//6wRwTScI7/SvJkN5Lh8LsqiH5nkgw9LZtrrl5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e+nkFD3zrF6Pwy/WTBUVkzIG1Xpa1ORR7mGu5TZ0atc=;
 b=r92liqQlVK0DxHGOY8mikOFwaEWJfWB0rqYXnUKw1gCjzJDuUMESouPvUlq4Ow02poD25KHnJ4f4tJxJUzbFu682RckURoeaX1l5nxAsjP+YqArUzIJwra5vELB9TrU4XOFusFIh28BSBocpDrWoCsY2/aepi0EHma9AQ+gltbmpBwYoIXLvunwmfAffUPsscG+UbUdNgdv2KJka+REmDQab5GnNefnBp5wHhH5Il7qKu4UyS+Dn3h5f879rRBmffH3KA7Qk8VJ0UV7UbEMBGLHLi0MpHLOXwOsrASTzaZmHOiJ1RxBkRgEeOXL2OMmggCnKGUEFkHetG8kDHfV1QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e+nkFD3zrF6Pwy/WTBUVkzIG1Xpa1ORR7mGu5TZ0atc=;
 b=Fe/6lZW2kY40QJA5O6QO/tHfQgX1zjZKGf+xMLXSTx4Q+O0wlw2zCJXO/U5UO6cw/QDpwpdG2iGyG1KzTXXLDVWswML196en72aaPVq8aVmvLYmvM1bBdl1/OkQdTzuBMni+Dal5iZBDTE9oHp0SAJ/xjlyRktNruSNYvj8BYRQ=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by DB9PR08MB6555.eurprd08.prod.outlook.com (2603:10a6:10:257::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.21; Wed, 6 Aug
 2025 10:20:28 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 10:20:28 +0000
Message-ID: <2d0d58a4-bd27-41ac-9b25-1cd989c02383@arm.com>
Date: Wed, 6 Aug 2025 15:50:21 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/7] mm: Optimize mprotect() by PTE batching
To: David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, ryan.roberts@arm.com, willy@infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
 will@kernel.org, Liam.Howlett@oracle.com, vbabka@suse.cz, jannh@google.com,
 anshuman.khandual@arm.com, peterx@redhat.com, joey.gouly@arm.com,
 ioworker0@gmail.com, baohua@kernel.org, kevin.brodsky@arm.com,
 quic_zhenhuah@quicinc.com, christophe.leroy@csgroup.eu,
 yangyicong@hisilicon.com, linux-arm-kernel@lists.infradead.org,
 hughd@google.com, yang@os.amperecomputing.com, ziy@nvidia.com
References: <20250718090244.21092-1-dev.jain@arm.com>
 <20250718090244.21092-7-dev.jain@arm.com>
 <7567c594-7588-49e0-8b09-2a591181b24d@redhat.com>
 <9552ddff-d778-4934-9349-37c7237cbb78@lucifer.local>
 <54ee1971-d91a-4fe6-90b8-16212c8568d1@redhat.com>
 <0d52d680-f3d3-454f-8c12-602f650469ab@arm.com>
 <9cbe9c6a-0013-4239-9347-bf5d43021fe3@lucifer.local>
 <e3d13396-8408-49c0-9ec9-1b02790959aa@redhat.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <e3d13396-8408-49c0-9ec9-1b02790959aa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA5P287CA0016.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:179::6) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|DB9PR08MB6555:EE_|DU6PEPF00009528:EE_|AM8PR08MB6355:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c1f138e-f4fd-4257-5cb9-08ddd4d2f167
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?dlgrKzVoUlhNY1VMNnJnTUVJM2dUYmdINEdRUU5ZcC94Q3AwMDF4MEI2RHQr?=
 =?utf-8?B?ZGZxQUdCcXRXdWFEL01yanJKb2ZSU0k4VW1XRUdtSk5lUXRzcUI1YW5UTktj?=
 =?utf-8?B?dFJzb3RMSVNZNzl6cytmYklxSlBxRktDRFBnbXlCRkFkU0pvN0oxMDkycWtU?=
 =?utf-8?B?c2M2enRidW9VZEFGejVjSG1iUG0ydDcvclpQbThWSm5RNzBsMXhsU24vM3hz?=
 =?utf-8?B?blZIK1VBNnIydFRJcWdjSitkbEVzNGVUZGkxcGRLQ2k5SFBzVzFsaitjZzRE?=
 =?utf-8?B?UzZKbzNMQmNwdzJJakZLTFZBK1RTeHNHK2lrT0dZQUJteHhxdHliYXN1NUd2?=
 =?utf-8?B?SGsvMjFZNnJEUk10YlI4RzgyTU5wa3NxK1hlNHc4eGNLL0pSOFhmZkRpa2Ix?=
 =?utf-8?B?bzlxeTRWZ3M0QU5zVVBoSnNhZFhWb3d4WUVoQTEzUDRHamhVOWN2bXg4VWhK?=
 =?utf-8?B?dHRuQ3hrMnR4M3FJR1hYWjFxOGxUY2o5am1EbGk3ZThxM1VOdHo0bG5Cc1hu?=
 =?utf-8?B?cVlwYTl1MEJaNGlkRGtvaVJXN0laNnNsSDV3eFNWM2RLZGFyT0EyUW90a3dU?=
 =?utf-8?B?VnZlc2dZOGRaelhWa2x5QmU3TWRUYUlEak1YRmtxSVM2cE85QVNZNGE4Q3Bi?=
 =?utf-8?B?UjIrdzRMdDRYQXRsS25wRHhrSDZ2S1krOU1wSDZneml4K3o3akVzUWplUFdP?=
 =?utf-8?B?dTg3bGVBSG4vNkUvOUNua0VQNFArM2xhYk5aN0JlV0I4eVR1VDM2cE5wV2tn?=
 =?utf-8?B?QytsaG51eVRNWkZ0eG40cDA5SnJncTdmazBQY2xXQnhhUlNtdTZsMjRHQ1Ju?=
 =?utf-8?B?SW5mT09oTUpaZVMrNGNMby94WDE2QXRta2NsSUthamVFZjFOU1RaVlI1UTFI?=
 =?utf-8?B?UFNXRXJYR0k2Z0pFdU5iUUZKTXAxNnBORnpFbDZBcTVocEV1MlRlMk56K0FG?=
 =?utf-8?B?L0RMNG9PdEVVdmFxdUg1QTRydlR2SXh3TmVKZkZrMTMwUkdVSEhmL2ZVQSs4?=
 =?utf-8?B?MVB3UkI2UUlzTmY0MVBaVHgxNTVBV05NZkpWQU9adzYyc1BBeFM0bHQ0bGcz?=
 =?utf-8?B?dGJtRFQ1RGZuQlkwckhpOS8vdTNBU2FwMk1YMDdHeFd2MXFMZlFNMTMvTTkv?=
 =?utf-8?B?WHRaR3FwL3RKeW5LR3NZY3JqVktKWGRMZ1pWTWJFaHBxVWVZREluNFpFOXhH?=
 =?utf-8?B?MUdsVEIzdktvcHVmdnhSanh6QllvSnIwS3RyTXdMbWhiVWdzYmRHRVoxcUZU?=
 =?utf-8?B?QVc2TFVtSGp3U0ZOZnJZQUNJRFI2eFVIRjFWYnVBVGxFS0JHUVVzc3BsNUh5?=
 =?utf-8?B?L0x5STRGTEJZQzFoL1hXdW1pdXV6T3JNRDBoZ1c1OVc3cG54dEwzcHV4OXh5?=
 =?utf-8?B?RkYweEdVc3JhYUdURTVVZjJycGtHQUNRU2h3TXFqZVRvUHVjVkpYY2VYWXhZ?=
 =?utf-8?B?dnpGTlBFMG9KanZvcktJUW9tNXVjMmVUYWEzWE5pUFU0dFA4WXR5VTNpaEVh?=
 =?utf-8?B?SVRXWWs0UEZIZEF0TnhZVW1CZSt2VDRiaFhMcDV4dUlEMkRCYTZGWHRzSXJX?=
 =?utf-8?B?NzAzTVYwNkJqUmlwQnYwNXJBeGhNelIxYWFEL3pKNWhJeDE5T0xlMFBmejNE?=
 =?utf-8?B?ZGV0VXdvYXVITVc4MUpVRWtNQzdHMzg4Y0MrOXdMR2RXL216TnVlbkpCMGh6?=
 =?utf-8?B?QmtHSzBwNWV3TjRWSEliWnRVTlZTVUpvSGxHTkllODY4UGFRTS95TGhsUTls?=
 =?utf-8?B?aVdKZEFGTmZrZkVyelhOREl4cGxjYXNZb0Zvc0NFbHNFOU1tVUxkYzBtNW1M?=
 =?utf-8?B?YXhkY0RhbXpYeTV0V3Uzd1AzWWFURmtTaXg3MlhQMWpYS0V3ZFl2bXNVS3pl?=
 =?utf-8?B?ZSs4VXpma0hELytYRDF0ZlY4Z1diRldESjBJN1kxd2E0b0E9PQ==?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6555
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009528.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ffd81b27-2ba9-49d0-7ca5-08ddd4d2ddbb
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|36860700013|35042699022|376014|7416014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZUNkYzhjcFZIMStmZjZhQVBQekgwNE1hYjNQUHBEU2w4cTFiZmgzZEREempZ?=
 =?utf-8?B?Q3FmN2xwVW1CY0RNZ0t0NGtTSU9qWE1ITklVK0E0dStBdkhzZ051QVpLVndC?=
 =?utf-8?B?aEw1Nmk4Q0ZaQUpxZ0tOSTBHQUVVYTVUS0QrUHZaaUtSUEZYbU9NV3JnM2NB?=
 =?utf-8?B?dThaQTVvcmVHQXhGSTNsSUk3NWlWdHBxeDJmMnpQanBQMVJYQ29PRkxWTzdm?=
 =?utf-8?B?SFFYQ2hZRmJQd2FYWlNKaUFLSk5sWkRKK2l2SVBOdmI1dnhNWXRwbVljOGZr?=
 =?utf-8?B?MVFJdSszbWFFK1l6M2tRQWE1Yk9DZzVtcjE3aysycXFqaGRnajloUHExOEpV?=
 =?utf-8?B?Vzk1VXhFOGhCUTFGVXRhVzYrR2pBNHBvTzVzeHRLWTVDUlR0S3VFSFBoTEV3?=
 =?utf-8?B?UWJQbUJBM3JvRlh6Y0g5YWJjY3lsaFNtUS9YYmJoL1RyQ25hL1RJOUdhLy9Z?=
 =?utf-8?B?TXdZOHlHcExBNkg2US9TaitVcFR3OEt0UHZiOTZ5WHJPWExIR0hZQVpESXFv?=
 =?utf-8?B?UkNuZnlqSlN4QTdQSVh5VUhLT202eFJSZDJmMHZ2RWoyb1hyNGw2VUFYaVht?=
 =?utf-8?B?SFdaZlFWWWNtOUk0ZSt6UlBSMG5HRUVVUDZTQlVmTFNNb0Q0N09LK2IrRDcy?=
 =?utf-8?B?eWhVSEx5cWhYMVVySEJPZ2NtQXBoYUVnU1FBMnBuRWpuVW5NdGN3ckc4VW11?=
 =?utf-8?B?N2cwZEFuYkM1ZnN2MnBDQzE3NWVYdktiWEJGbDR4TzkrNFBkY0NJVmhwOXNw?=
 =?utf-8?B?LzFmaGtGaHh4MVo5Y3h2ZllER3U2K0pZb2ZOcXRwK0dTVW9hcTB5M0JxSDIw?=
 =?utf-8?B?cHhKZFhUZHNyb0ZLclFPRlhNUXUrSlpuOTRlU1AyZXhqNFhWM0oxZ2JhWmlh?=
 =?utf-8?B?d1B2WC9IUkRuVkd6eUtsNThubWE0OGRaS2F3ZnBva3czZjRmT0plbFZoSCtV?=
 =?utf-8?B?TnozT2hkM3RYNnNsRmVZZDcxMlJKZk1rdDlwNFVsM0htT0M0aUNmdmh0L1h1?=
 =?utf-8?B?VHRaUnV4cHc0bmdzclhla0JFWVpNc3pYQTQ5VXpDZUJaa0kzUFUrZCt4TTkz?=
 =?utf-8?B?dXpEWDJlelF2ZGMwTzh6ZTlFODM2WU11WWUwOUZqV2lUdk13Sm9OTkw0N0Rr?=
 =?utf-8?B?TVFUdmtrZmlpekd6eVRJSlQ5a3MwWXlFSlBzQXFXcjRwRjVLNi9vcDlmZkdu?=
 =?utf-8?B?T2tkeVV3cVZLVENXM09Na0dGMVRQNHlTb2N1Qm5wNnAzQktuU1BzV1gxVkV4?=
 =?utf-8?B?NTkxMW5qQ3VieDljRjFoZ1dsRXJrQWdTak16U1Y3QVljSWIvVkxHRkdlTmxk?=
 =?utf-8?B?RnZWZ2c2ZGtXRksrdEwvNVJUMGtjNTllbzFIUERmbnFkNmE1djhQWUdXbmRJ?=
 =?utf-8?B?YUs4VkN4bkpNV1pwMUhoUDdUQWErQVc4V1d5c1NRRUJYcjZXUUl4MndUcXpF?=
 =?utf-8?B?Y1VRbFJHWmthQmoyZnlLOUdpRWpENVRKNGQrQ1BDS2swSGZkRU1ReVBrcnNR?=
 =?utf-8?B?TnVleC9Fa29WVEdvaWdZS2VGTTBCM0E4c09SbUZOVEFwU3I2aGZnZWhOeGhZ?=
 =?utf-8?B?WVJ0eDdzQkZLd1M3RWxZdytiYXR1VEgyMURQeE5TeWxqRkFpbHlaRWdtTFE2?=
 =?utf-8?B?TFV2eUdodEJ5WmxDcE40Y2Z3RUhjbWFkdG9jTXNsZW1DMmVaemllSURPWFRE?=
 =?utf-8?B?YUVOdmhtb2EycVFpZlgwbUdNczc4TVlSU0lRTjErWDdVQldnVkNZMkhpREFj?=
 =?utf-8?B?RUhRY28vSE5ERjhUcmtjZXdNVldnN1hMZnR4dDR5NGFBWC9GWHBrL2lNekZI?=
 =?utf-8?B?Zms2Y0FYdVNjQjJ2aC9idVQxRTJFVC9FSjVMeWxqN2ZWM3pwYnk0NlNMaVZl?=
 =?utf-8?B?em1RTVpsTzJ0UENnQWtUWHF6VFpqaGlXQUlRQXlrSVZ0Zjh1anBkRXNmNyt3?=
 =?utf-8?B?T1Q5Y25uZ1RpbEpmRWc2N2NwdXVBU3NNVjFwWlIwMmlQVDczSG1XcU1ZaGhY?=
 =?utf-8?B?c1BvVWdncTNvcjkwdmU4Y2dOZWNHUVFGS3RKRWhwaVZvT1lNdFNRY3FkSDZo?=
 =?utf-8?Q?47Vubl?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(36860700013)(35042699022)(376014)(7416014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 10:21:01.3665
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c1f138e-f4fd-4257-5cb9-08ddd4d2f167
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009528.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6355
X-Stat-Signature: f9beyg1jhea3gesd74uikj9n39d6i4wi
X-Rspam-User: 
X-Rspamd-Queue-Id: E378918000E
X-Rspamd-Server: rspam02
X-HE-Tag: 1754475665-325903
X-HE-Meta: U2FsdGVkX1/u3hRAkCglsjOwpt/l4dA+FlM/WB1cVt3Oa0tmMjV1bOFuvR0jKqtTt7Y/UxJusADvwKQp/BoReVT+VtSeMpODbI10OSM7zvjJaU/i1doZvmOIvvoyAy2kw7jktZNCu1EosofNq62D6oz4cnDvLWrMJEO0uPEJvXDKsKzBvC4hdD+QeSCVgMMiF4VhRe/XoO7kxFzG7G1XdGRQVF2ZzW/+qKfyE49KE4r4DrAX3iZYOdwT5PEItgiJMeyRMqYJqAt9kL3tES//FHUuyfIwLJu9CIjTaHIABABceaWwOt060+RTVSlSX31mtb+Qhv7xxKUeRQuo5aJykrMEHgIFdAnQjp/DJ8CMghYSC4ReLuZykIjZ2UGMpdcKgrtFB+KpfNlkHey4aDvGHOkaQqcICAcQkBlsOCl1glancmrS0ZcRJafkwWoaUzWXD1Dr+DgBirnQxUTpcjRbT+sxMXDKZsxD+Ms4bBrsXsMXfxzrp5BLNoxb5RC21TMbS8Ks3fl0YY31IkuRVKBNJbIX8tHpF73o706fjA4JtMmV4TSjF1Kbzcp66QISwNiZqiZZ+l1vkhF2t9eQ+4kuq4kt8W46DbOPFb36UImkwz/6noylId/dMCg3/tQwRr9UuTVn0VlthlBbUskjrzLTZmgQOmObfTzXHPKKkdYP5+GR0dEDhom8YfjSpykhVJ1+QXmHW6qLUw51bNWAiGPXh97pVQ1mGWW0sqaZGm7ejesdYlw8yfGP8cTXYVqYUn8GwaqaynQh59G6zufS3WvzquzUBS4fn3rkXuP5YP0R7kHLd+DgjedIob0TXT/UDXnJYD1cpLLRidD94mnMPA2HrmF85Aext6ddQEgLl3joyxZ2UsZXzD5FR5ojgIQmv6mbJYie1ihoGIUvHskd6SwZ1nNvE5fw4ViaAf748XWvcXk0FlNFZqdgFowVWkLEG/f86tse2kedlfdKt6wM6Mo
 lpGpS3jR
 c1Zv/PHgI+5i2xFMvrGgdCdAUJJGO+mq1Nql9RfsjEl+iG5rqpQrg4ldHJ2kUmniB7nDLr4j9vX21bIfSFVv2JnqqKyh4hr49LN61OCj0dEcO2Xr+HZrDM8EiBlqkg2cTjHuakdCrHFBuuTaARlPJPZ2DJSSAe6JFX79HcrBZdQZzhNtf6D69Az+GMhWTjfEdE23ae5Lrxo8tKD6+133AmqMG9F8qc11WskkHnGe9hf4EMD1zE5XWWBtL5uDffApNGMmK/cNv3sK66UCig5z0utsQyf98pywGgFUdK8ngsmPDlhUlc2TabYFtLdqcgF3wlnotw06enNF2JvjmRCl0RZtkAfkpwxwKVlxrBfoKWTGMGevSH6WArPoq46K9CJQ1oidU6cKSFopWKQFwwv2GQ/RL6ukd8owPacZiuqs5wZu6Oml+xMwmCuarqah7iMlwF44df6+LUJyAPoh4x8ij/vCLKRRzzFSGRQcU/WfTJz3dbmIFyg0UdXdIv5SJyh5UqTlEJW2jF9RWxa6PLLiVm6vlvhdfj1II7+ctixeOHh+LNgnvMJVfS4sCTnzDZy7SKp3I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 06/08/25 3:41 pm, David Hildenbrand wrote:
> On 06.08.25 11:50, Lorenzo Stoakes wrote:
>> On Wed, Aug 06, 2025 at 03:07:49PM +0530, Dev Jain wrote:
>>>>>
>>>>> You mean in _this_ PTE of the batch right? As we're invoking these
>>>>> on each part
>>>>> of the PTE table.
>>>>>
>>>>> I mean I guess we can simply do:
>>>>>
>>>>>      struct page *first_page = pte_page(ptent);
>>>>>
>>>>> Right?
>>>>
>>>> Yes, but we should forward the result from vm_normal_page(), which 
>>>> does
>>>> exactly that for you, and increment the page accordingly as required,
>>>> just like with the pte we are processing.
>>>
>>> Makes sense, so I guess I will have to change the signature of
>>> prot_numa_skip()
>>>
>>> to pass a double ptr to a page instead of folio and derive the folio 
>>> in the
>>> caller,
>>>
>>> and pass down both the folio and the page to
>>> set_write_prot_commit_flush_ptes.
>>
>> I already don't love how we psas the folio back from there for very 
>> dubious
>> benefit. I really hate the idea of having a struct **page parameter...
>>
>> I wonder if we should just have a quick fixup for hotfix, and refine 
>> this more
>> later?
>
> This is not an issue in any released kernel, so we can do this properly.
>
> We should just remove that nested vm_normal_folio().
>
> Untested, but should give an idea what we can do.

This puts the overhead of vm_normal_folio() unconditionally into the 
pte_present path.

Although I am guessing that is already happening assuming prot_numa case 
is not the

hot path. This is fine by me. So I guess I shouldn't have done that 
"reuse the folio

from prot_numa case if possible" thingy at all :)


>
>
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 78bded7acf795..4e0a22f7db495 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -120,7 +120,7 @@ static int mprotect_folio_pte_batch(struct folio 
> *folio, pte_t *ptep,
>
>  static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long 
> addr,
>                 pte_t oldpte, pte_t *pte, int target_node,
> -               struct folio **foliop)
> +               struct folio *folio)
>  {
>      struct folio *folio = NULL;
>      bool ret = true;
> @@ -131,7 +131,6 @@ static bool prot_numa_skip(struct vm_area_struct 
> *vma, unsigned long addr,
>      if (pte_protnone(oldpte))
>          goto skip;
>
> -    folio = vm_normal_folio(vma, addr, oldpte);
>      if (!folio)
>          goto skip;
>
> @@ -172,8 +171,6 @@ static bool prot_numa_skip(struct vm_area_struct 
> *vma, unsigned long addr,
>      if (folio_use_access_time(folio))
>          folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
>
> -skip:
> -    *foliop = folio;
>      return ret;
>  }
>
> @@ -231,10 +228,9 @@ static int page_anon_exclusive_sub_batch(int 
> start_idx, int max_len,
>   * retrieve sub-batches.
>   */
>  static void commit_anon_folio_batch(struct vm_area_struct *vma,
> -        struct folio *folio, unsigned long addr, pte_t *ptep,
> +        struct folio *folio, struct page *first_page, unsigned long 
> addr, pte_t *ptep,
>          pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
>  {
> -    struct page *first_page = folio_page(folio, 0);
>      bool expected_anon_exclusive;
>      int sub_batch_idx = 0;
>      int len;
> @@ -243,7 +239,7 @@ static void commit_anon_folio_batch(struct 
> vm_area_struct *vma,
>          expected_anon_exclusive = PageAnonExclusive(first_page + 
> sub_batch_idx);
>          len = page_anon_exclusive_sub_batch(sub_batch_idx, nr_ptes,
>                      first_page, expected_anon_exclusive);
> -        prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, len,
> +        prot_commit_flush_ptes(vma, addr, ptep, page, oldpte, ptent, 
> len,
>                         sub_batch_idx, expected_anon_exclusive, tlb);
>          sub_batch_idx += len;
>          nr_ptes -= len;
> @@ -251,7 +247,7 @@ static void commit_anon_folio_batch(struct 
> vm_area_struct *vma,
>  }
>
>  static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
> -        struct folio *folio, unsigned long addr, pte_t *ptep,
> +        struct folio *folio, struct page *page, unsigned long addr, 
> pte_t *ptep,
>          pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
>  {
>      bool set_write;
> @@ -270,7 +266,7 @@ static void 
> set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
>                         /* idx = */ 0, set_write, tlb);
>          return;
>      }
> -    commit_anon_folio_batch(vma, folio, addr, ptep, oldpte, ptent, 
> nr_ptes, tlb);
> +    commit_anon_folio_batch(vma, folio, page, addr, ptep, oldpte, 
> ptent, nr_ptes, tlb);
>  }
>
>  static long change_pte_range(struct mmu_gather *tlb,
> @@ -305,15 +301,20 @@ static long change_pte_range(struct mmu_gather 
> *tlb,
>              const fpb_t flags = FPB_RESPECT_SOFT_DIRTY | 
> FPB_RESPECT_WRITE;
>              int max_nr_ptes = (end - addr) >> PAGE_SHIFT;
>              struct folio *folio = NULL;
> +            struct page *page;
>              pte_t ptent;
>
> +            page = vm_normal_folio(vma, addr, oldpte);
> +            if (page)
> +                folio = page_folio(page);
> +
>              /*
>               * Avoid trapping faults against the zero or KSM
>               * pages. See similar comment in change_huge_pmd.
>               */
>              if (prot_numa) {
>                  int ret = prot_numa_skip(vma, addr, oldpte, pte,
> -                             target_node, &folio);
> +                             target_node, folio);
>                  if (ret) {
>
>                      /* determine batch to skip */
> @@ -323,9 +324,6 @@ static long change_pte_range(struct mmu_gather *tlb,
>                  }
>              }
>
> -            if (!folio)
> -                folio = vm_normal_folio(vma, addr, oldpte);
> -
>              nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, 
> max_nr_ptes, flags);
>
>              oldpte = modify_prot_start_ptes(vma, addr, pte, nr_ptes);
> @@ -351,7 +349,7 @@ static long change_pte_range(struct mmu_gather *tlb,
>               */
>              if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) &&
>                   !pte_write(ptent))
> -                set_write_prot_commit_flush_ptes(vma, folio,
> +                set_write_prot_commit_flush_ptes(vma, folio, page,
>                  addr, pte, oldpte, ptent, nr_ptes, tlb);
>              else
>                  prot_commit_flush_ptes(vma, addr, pte, oldpte, ptent,

