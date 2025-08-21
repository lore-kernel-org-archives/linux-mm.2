Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3535CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 04:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D1906B00B8; Thu, 21 Aug 2025 00:30:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87BA76B00B9; Thu, 21 Aug 2025 00:30:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71C336B00BB; Thu, 21 Aug 2025 00:30:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56D436B00B8
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 00:30:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E9CC117050
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 04:30:29 +0000 (UTC)
X-FDA: 83799488178.12.F39E3A7
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2069.outbound.protection.outlook.com [40.107.94.69])
	by imf26.hostedemail.com (Postfix) with ESMTP id 19B38140008
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 04:30:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Q73M8dee;
	spf=pass (imf26.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.94.69 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755750626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4GjHFZm0WtCIWGeMkm0UJmIon4rdwWPkY6N8Lmhz2n4=;
	b=hDYMf4wB5zmbKM/xLPXdp8ORO+a+z3HkKU5VeBDQ2GJ5MZE+JA0zSIh4WSK5HWUQCKbt91
	83zbNAb2KitvnVng0vtBvUEHlX3qTv1nWxjX94nGiW6T3k1Ik1hJFLbeDUiUvQoB4vqdou
	fn3h/FxA4rbqVztEC5SngV+0u+2aXxU=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Q73M8dee;
	spf=pass (imf26.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.94.69 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755750626; a=rsa-sha256;
	cv=pass;
	b=IoS1o+re93DtelH73/t1d4LsaYLpT8xaWJH0Yiy93I801Zh6T8tA+WrG6exeh73I7y5cY0
	L0IgiX9fVQFQ9Sr4SKxb6QBVGKb9FbuGrSbOmc2JaYcO5thSj4USkhAJq28Ypp1k25ZjRS
	D8rbF8NfP4g5MhudWjMoaElCmQWgmEc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LLOrYYDpiHQaYAlFOGc3epusAwcpcKAqJyITlfIJBeYHUAeLEWVU8zQBlkPiKEtTk2h+6CptGg4lvLt2MEXTjHulKXOOnUr8KEHlGvAOUn5O8+KdSKwSvqirpnShy0cXWzixaGc/HZcphzWfnpVXMzzOOQoLdBkTOVPwdk+r1fmd6IcWW16nntj+6koedIN6etKsdMJTFFLLaf8NGk2MlAo2TK+6te4oN3ZnMM3VYhnGC5rGWBoJDw6yDbXDrYFAM3JGWUi+WLMrZxdY1aTq4A0Y3lqPT7KO99L/yK5lrT94zpUDB4PplJF0i2SlfOkUFULyuCsQo3TKRbthlGJRIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4GjHFZm0WtCIWGeMkm0UJmIon4rdwWPkY6N8Lmhz2n4=;
 b=VOX7VLzZi4Gsdd+cLQ83HGVswh0VkYr+fYQKTuYrU/kvNYTopDVVeZh0KilqetkVofRB3NDIXeRSMwvbOIROAoqQ7nPQZMmwiQWqSk8UmEN/iV0PTLTl1ckSm6hmOwdiLvEsG0UGfkZ6jNeWHGnA/YX38Ur0Sg8AN79Z3Yqr2cX+82bqfJxDuyJetJgj9qLKJPKnySUiUrguItBOXCpq1MKk6dmx2MgOZ9ovTrPnHJWk8J4nQwS8SXfaLKEykMzXcm58fVi7KF8lFYqmQRWguvfOsWlDno26CfIfooVwSxyScRv8DI9mBEvb2mPzLnWc5lZcVAxHhSX3PTA73NFdPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4GjHFZm0WtCIWGeMkm0UJmIon4rdwWPkY6N8Lmhz2n4=;
 b=Q73M8deeJV3RrHOH6dT1li7bWePwCkVoQ2HsQpUE2QE4PSOiHMBiqZ8fYzcNw4ibAABmlRb2bxgUdXaV2PITm9f62FVauL/PCHMyKYs9ckciItTfuo6ARQthBLRUSvAbLdYdNVgJoQw7d8jHtAMhg+go05D9h4wbTmLEPKmVlxRiSXYk+XYU+Pr7kNRHZnd+aA4xBRuCAQIsa2zOzDy6hYBSBoocA/xKyY6qcg1yn02uZGyLaZV3glyaaRJj3T7mWRQpPk1sLHzqP/o2Nyc5d+lGuQu4zollOUBZDfKvq+hgQg90WjlF/yV8YowpsrF/gcWXT0xahHb/j6Leyx9kSw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by CY5PR12MB9056.namprd12.prod.outlook.com (2603:10b6:930:34::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.16; Thu, 21 Aug
 2025 04:30:18 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%5]) with mapi id 15.20.9031.018; Thu, 21 Aug 2025
 04:30:14 +0000
Message-ID: <099ffad3-489b-4325-b5dc-90fa002132f7@nvidia.com>
Date: Thu, 21 Aug 2025 14:30:09 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/4] mm: unified fault and migrate device page paths
To: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>
References: <20250814072045.3637192-1-mpenttil@redhat.com>
 <20250814072045.3637192-4-mpenttil@redhat.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20250814072045.3637192-4-mpenttil@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0078.namprd05.prod.outlook.com
 (2603:10b6:a03:332::23) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|CY5PR12MB9056:EE_
X-MS-Office365-Filtering-Correlation-Id: caadcbae-524c-497c-9024-08dde06b6bab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T1VjeGtJVGVkRnlpNVNQeVdIZVQxRC92SFg1Yk1PL1NPNzJjZEx5T2Juek9S?=
 =?utf-8?B?dDk3R3J0dXJlalVVbEpoM0ZaTFpIWDJ4STQzdnJ4c2d3UThFR3VhSDlwYmFK?=
 =?utf-8?B?NWR5c0ZZQStCOVNpczVQMUZNTGd0L1ZkNGloQ1hDaUxpUkdGb0ovdjVUTWN4?=
 =?utf-8?B?QWNMcy8zNW5iYU5yQXFjV1Z6SVNVNFVDckhqTDNmOEg4Y1phQm9SL1hWVFNL?=
 =?utf-8?B?SmJtN1BtL3R5a0tnM2tZNkFTekJ2NmlvL3NlSFhnOGxjUU5GMjlnZHRhZGk3?=
 =?utf-8?B?TVNVQUtvRURVRkxudUh6eGZiek1ETzgrbUVsemh5eGowV2hEM0FPc20ya29L?=
 =?utf-8?B?WFFCRUtEb3l1UGMvWWZOckxDblR0ZHViblNscS9MTzBBZDFLQUhYejNMcXZq?=
 =?utf-8?B?UlRLbnFqcG4vQVdvMzRCZS9vcUNkTFFlNlVaWWxCNG8zREFkTWNYU21LZWZG?=
 =?utf-8?B?bFhhcUN4d3pIUnV6WE9lNUlyRFBMcnpKK3g2d1NhamVlcjNMWTVMWDFMVVJ6?=
 =?utf-8?B?cStzSEZaUXZHdzZ0L0VqL1d1QkRic0xjRWw1Wm9nZ28vNXVqcGJyaHhUYWth?=
 =?utf-8?B?QklnYldJMVRGVTQwR0VyS2UybnRwUWVJNXlaT0pQTnhBR2svak5ab0tWMDcr?=
 =?utf-8?B?T0puOWhlL3hhUFFoL3J0ZGlncWQyVFV5Wk5tUmYycVhycWYrdlNvODB1QTJE?=
 =?utf-8?B?ZnhML0VmSmdnWGF3MWRxSHNnTlZjZmV6Tmkrc2lTdHhlbW9OQ1hCRVNMcDFE?=
 =?utf-8?B?UHVCRFRHaDhhd0UyRTVSYkdQa2wxTlpzemY4TlJSdTEvTUxBbExZQVA3bTBU?=
 =?utf-8?B?cVhqNnNTUjFJSis1Z29tQU1ua3FIN21ZLzk0TFhRTEE5NzJGYmhMUVFSQ3RN?=
 =?utf-8?B?dTVBRy9mMUJoK1ZBSWNRTkpyem9uRzkvc05heFQzenJxR0FoWC92MVNVcjZl?=
 =?utf-8?B?TTJFNmU2QUZRSm9QbmdwM2JnRmN1cFBrM0d3Yk4wR293ZUxCWXdVaDNXSkRv?=
 =?utf-8?B?RCtaUmNMbmQ5RkZ2VzRHZWtCZnpFcFB5cUJIWEZaQ3ZYSnF2bVB2cnA1YlJW?=
 =?utf-8?B?cVE1bG80M3dkTUlnVVNXcW5tRDNTVGxGa1ROdjc1Rlg0QXdkWGEwdDBYdE9l?=
 =?utf-8?B?aURKL1N2VWQyTXlYcENFQ1pVOXROZHcwRmFDOG5VQTVFOFFiaERYUmljMzh0?=
 =?utf-8?B?UmV3amY5aGRUL29XVWF6N2VTSUtweTFra0ZaTnN3UjIyVkFTaVQ4bzhFQW51?=
 =?utf-8?B?TVJPeHFpZWorS2NCTHl2V2MycHplTk1jeVBsZDhIWFlGZGpoSWJ4dzQvSHRy?=
 =?utf-8?B?TG5yY09RU09TZm90UXkybUtWcHdHb2dkSlo5LzdSWDRaNWxocU1PM2pOV1FY?=
 =?utf-8?B?bXJTRTQvaHVhNmJBZVNBVVpIR21LM2txOVpjSmtLMFR0RG5VNEU2SnR6Wm8x?=
 =?utf-8?B?VDd4dXpFTzJvYlBhN0wxQXRFa0dITTJnUnArTEdleW5vSVZ2RXFaOFJueVps?=
 =?utf-8?B?ajI2MjhJa2tzWkR6SlR4bEduMlcxWkhZcXZBSnZHdUQ3RWFlM0ZRYlVPbVBL?=
 =?utf-8?B?RW80Um02QVFub1I1ZGZUMTR2Vm9HelVKWGNyVUk3R1lGRmptTWhTcFJYNFdi?=
 =?utf-8?B?RURFR290VEU0dHU3NDFDZUNma2xRNndZSFZoZ3FQNUxpQmw3NU9OUHpScTRH?=
 =?utf-8?B?YVJhTmpVaHNVNDJscXoyUE9TZ1ZpalhjQVB5YVErVWo5RjltWlU4OWFyKzZU?=
 =?utf-8?B?d0IzaDZmSEVVMmVtaXloSDlsSHZpMWtlRlkzRlRwUWRtcjlXNUZta3RYNER4?=
 =?utf-8?B?eVNKWmtVYTZ0dnJ4MWY0RHFBZ1J4K1B0WnkwYko0eEM2bDVWWjlERlh3a1E0?=
 =?utf-8?B?Qk5BU0J5TldDdXEweWE4SEJBNVpOOW40TzFKTHArQ3JqclVtbmM3ZXVFQjcr?=
 =?utf-8?Q?vvAXODL36t4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Vkp0VUZQWG9GdlRRVlRlNGFjN0xRaGV6UXEvTzY3V2dYbEtDamNMRjMzUHEr?=
 =?utf-8?B?bUZGRWJ5ZUdpSHBIS0Znbk9Edm1wa2Ztc09ISG41czRQbVpXTnJCVzI2SFdE?=
 =?utf-8?B?UmNVU0pOeWZCd2JLblM3M0lyVGlzZzRibk40QWYzY2NiV1RacXhudm5hc3Ru?=
 =?utf-8?B?MFBrbWFwNG8rK2xCaUFvcCtlSmVkZGFCaWE3c3pxaVg1K3AwbGxNR2NiNm9I?=
 =?utf-8?B?ME0xdXV4UFd3eVpxREJJZFcwWG16U081SDZRRm1ydEhwNWR6OGdxSVg1TWJp?=
 =?utf-8?B?MXRKTW1MbWtrNThiWEVvV3l6dDJpN2cyUGZMb3ZxQmFqbjVHZWhXQnREZ1hB?=
 =?utf-8?B?S0c2OW40SlBNb0ZIcTF1YTlvb0gzVmYvbW04U1p6dGNJcmdtOEI0eFZ1Y0JY?=
 =?utf-8?B?NkJxRjBYQStpRlhZL2pjajlmRGlMdUQ4Z1V4U1o4czNPZHZPZTJhT2EvVWdj?=
 =?utf-8?B?Skx1b2UwYi9LdU0wUU9pN2VkVXVHY1k5SmlLWXBJVlloa1dLYUxuTkJoN1J1?=
 =?utf-8?B?aGNNanF2cjVWaWo0RzNqZDBKejZTZnE0QTZuVDhSb005VnFPcGdKbnlZaEVt?=
 =?utf-8?B?SXltdGNTcFYxU1NBYXdXWUt0azdOWUw3eGNkSk9iVklEcTJ6WEp1YjhNYWN5?=
 =?utf-8?B?V2xleHh3blFtckdrU1IwVnFBcDZ1ZXJBR3N0UzZkWG0rdEVRWXNlczJHQmJm?=
 =?utf-8?B?MjUrVXlkVGlOek8zVGhJa0orbmdNa3A1UUpHUmhCZXlrTG1uNnZseEY5VUhO?=
 =?utf-8?B?azJkYUpId21zdDh5c2kyZzRaclJHZzBiMWFObVVWTXduZ2svZmVYQUdFYWpX?=
 =?utf-8?B?bGwzQXJROHNVdjgxM0E4c0NUUFhQWHRpM0ZxV1JRMU4veHBRYS9NdlBDVm9n?=
 =?utf-8?B?UzVLNWlhWUJyZEpsbmhOWmhNdzJNWE9rb0gzOFp5b1pORDMzNzlIM2pVMUZM?=
 =?utf-8?B?U3pzQSt2M0RYYkcvN0p5UUd3MERYTkRhdnJVRFVEZjFhSHZvaGh1eWhNOW53?=
 =?utf-8?B?bEFCZGZnS2JUeDdtQ1djYVEwWmE2Ny9RM3J3NlRDT2lXVlZXRlJPN3M2emtK?=
 =?utf-8?B?K0hOK1V0UkhaUXJSQzRJUGpsemh3dGNIblVVcy9xY0MydU1BcUxuSUpFb0hp?=
 =?utf-8?B?VmdGOHIvbUxVQ3JwTXduY0U0YkVLNHdqZFpFQzRaWDlFdmVCdjl3bUVrWko3?=
 =?utf-8?B?SVNoaGN6UkFhTXk4bDQ2NE4wKzB0bnNiWlNab0hnN0xPanpBVG1QYmNCRXhh?=
 =?utf-8?B?c1hrcGw1TXh2cjJHQjJJR3JRZW1oZ1ltRDZxbUYxaEN6Qy8wMFdHS1BuaXUz?=
 =?utf-8?B?NTdqNCt1YlQ5VmcrQ3V2M3ZMQVhyWE1vcysrNkRMenpvRlU2bTZSSzNxRXpy?=
 =?utf-8?B?S2E4UUNrckFSWm1XM1FRazJTR3VEb2pjeThvemV0SGZ5eTR6Ti9YN2ZDZjUz?=
 =?utf-8?B?Mzh1V2ZnMGhpS01KRGV5M3dDVm5PNkxEc0NMdTZrSmJyWk83RU4yK1Rtd0Jj?=
 =?utf-8?B?bVp2dFhOZDIyZjVXajVRcHF3TXFqby82ZXRza3AvbzgrOVRDQ0ozR0F3NUxJ?=
 =?utf-8?B?Uk1iUkc1czFPT2I0dWFrSUhOTTlsajBmdHJMN3A3dEI3U095cXhrRWUvZjFp?=
 =?utf-8?B?Y0crZUdZcng5Vks4cktQcFIyanNVUmhYdVJ0TVByVVFmZGZaS2tINklTU3NK?=
 =?utf-8?B?R1dzb2FSV1gzUHVkOWdtZmZYNXZ4c2VBTGxtZC9xZ0tuUTlzMGxHcGVXMkZH?=
 =?utf-8?B?dkcwVlFEWlZndTNnaTdjdFdKVndLZGZ3TWZvdWhNY3NGSmdQSUQ5Q3lWTzVD?=
 =?utf-8?B?djI1YzM0bnI1VXhXUUh1Y3ZRNjBxSzh2SGZzaDU0SVdDb1VNbmhON1l1NHVN?=
 =?utf-8?B?bTRmMHNQNUNZc3FhdGQ3d2NZUVJISUdxTzZZRE5ZMGxkWjNVYkd6SmY2S3NK?=
 =?utf-8?B?UmlPVzlEWnU1TlR0UlNLaTVyLzVXeE5JaUdiTjVxQkZOY2UreUkwMGhlajVL?=
 =?utf-8?B?NE9TcjErRS9TTFFVMENWb29MbVBrcGx2S0FjTzc1clBRbTBEOWhxUXlEZXh5?=
 =?utf-8?B?NUtzN01TUEJSZXRIVUhlQWJoenJxeXpOVkFRRHBxS3pKd2N3NjZKdUpibGht?=
 =?utf-8?Q?uzspLABHVr2Zyd0oxLcOMwfzu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caadcbae-524c-497c-9024-08dde06b6bab
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 04:30:13.0602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /YINymPCzH6LFs6l+7neSlGrQB8yVOE5mn4gAajgZA7qXHpVCtapwPY2vFDNQeplf8NLZ1ZLi/TCFQSsU9TEWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB9056
X-Stat-Signature: 6hn8biya6ph76qa54y64qji7gyagkag4
X-Rspam-User: 
X-Rspamd-Queue-Id: 19B38140008
X-Rspamd-Server: rspam01
X-HE-Tag: 1755750625-682661
X-HE-Meta: U2FsdGVkX1/GGGapg+8fVE7Pitix5m6TBNkXnWdJzCWuwZmU5yQLDOxOnegpN/R96oMFisPPqqrK/ZzN8OyMiPFkIjlFrod8utr0GYe9PkiZ66ue6OBoA5zzrUk/PhMb4fNmYgJXmfSjrENRpRPDH6If1wPB2F9oEpTIf0Zb5qDEVHJAoQ3oPZ74aDyziUcyrWAG3qhf3goDNce0mEWx0OiBdQReynrZ2e/Zg9IbA/osqI+81Dk0Qxve5L4Tc2scC8R2lKjlrLXd79rASEh6TTMAD97TQXmziNuhc7Jv1PYysoRIxTf2PFXFss+5xTntrZdHq0jpW112j2pCBIwT8yWzHuPQoG8PUiHuO9icHdRoo1RaVFEEeJmGttjc2WEFZFOcnqxdw+BFwiutaUrNJOTvcEZAXQgPFOBC9s+M4b6DYnTTOtZUGdfZd40HNZFbZLb7Cv/4Kz7CmlcV2adiDBMNz+I0CiZCq6ESfkGe/u3ZWA0msI1z4XiikSOEnpfR0itIoJdNWrlpY7uLYzENDCGzAZSIwte7RkxNK5GRD95uLlfRBppyOWfb3YKrUKyXoBnfPbqVoNDJ72CM4TSsLbLkTsCTui6z0n45B7nkp41+VvGeJFZd/ZNAEC/57M8GR6+Z+rE5JLG6qoyg7BdaFe0U9+ifs+p2vSsJRHFj0h4YCVYi4pEMBWon/XflNujUmrD0kX3lBSAXN5KFFDuEF3JgG1tiOTjp3qT1A/bi2h02/suVRgt8wDwnXtLrYSFbkn56uTXl/P/02JBUz5XGRBguaPUAcZpCwDAsUQT6Dyzy+cVwPDBe74NNvht5t07+dhGF98w/UY4SVoApsNQIww/g5NgGEvcZ630fOMF08t0hOwOkA8CfPiHEl5IdMd0+K61pDlBidrKSkHVbbyimqU5f7oQ7zPKFhQVU2Yy9kaSklPPtnux6rX4TOWdSNw8SmeeXjSOe0MzbgJV3KeH
 QZYSBWSI
 F5d5iYCGQQE5tbr+zrUwuFPzEHoGVaPSeTbZQWIyKjZsm6qm1TC6/4g1J7+OTfdidRUKSxlVDrZt0gN77oquLaai265grTqoPS7W0WS1DmZIkRNaSGcZVpO0bkicVk10szfj3T3ijgdsqK5jWFWASH24BaSAfIUhq8/jOTpIOnTPPMi5nmjj8mcbNtwubwffWvQnrkPQwcRG9VbgClmmYp0OA5Mk069wVs6UWGu3hBeLJg0jclcPKOfswyRiuXXiAiXT8h1T6XzQHGf7KgKeOJY1Ga+rfbBLg/MgKjHZGBoU9q/RbFnCT3gEqXDZVvqAMbM+jXRFdp5CIYp0703W3r/HHLT63sLICxqjfQQwvMvexYBeLT+yci9qIA0odnmwKnTGTokiWnYXNx2qWuPFrC7VnwpULEOMMJ8OGinWH6eRG80T6neGeJg4VpmCL/Pj0WCWXSvVvqiU0exU+/QRXqQ9h0LYmXc7T9V8peyyd1rWsfUEmp4s4VPQYIR30DMgBwd2AA4WryjsfHflTR5ju5DC/2GALFlVjCx4SPX9JV92vi0tmUEHc+1VijpQrYXsbBuXn3JT+co+hbeLp/7rsyRIuThpWI6OHIXSu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/14/25 17:19, Mika Penttilä wrote:
> As of this writing, the way device page faulting and migration works
> is not optimal, if you want to do both fault handling and
> migration at once.
> 
> Being able to migrate not present pages (or pages mapped with incorrect
> permissions, eg. COW) to the GPU requires doing either of the
> following sequences:
> 
> 1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
> 2. migrate_vma_*() - migrate the pages
> 
> Or:
> 
> 1. migrate_vma_*() - migrate present pages
> 2. If non-present pages detected by migrate_vma_*():
>    a) call hmm_range_fault() to fault pages in
>    b) call migrate_vma_*() again to migrate now present pages
> 
> The problem with the first sequence is that you always have to do two
> page walks even when most of the time the pages are present or zero page
> mappings so the common case takes a performance hit.
> 
> The second sequence is better for the common case, but far worse if
> pages aren't present because now you have to walk the page tables three
> times (once to find the page is not present, once so hmm_range_fault()
> can find a non-present page to fault in and once again to setup the
> migration). It also tricky to code correctly.
> 
> We should be able to walk the page table once, faulting
> pages in as required and replacing them with migration entries if
> requested.
> 
> Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
> which tells to prepare for migration also during fault handling.
> Also, for the migrate_vma_setup() call paths, a flags, MIGRATE_VMA_FAULT,
> is added to tell to add fault handling to migrate.
> 
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Leon Romanovsky <leonro@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Balbir Singh <balbirs@nvidia.com>
> 
> Suggested-by: Alistair Popple <apopple@nvidia.com>
> Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
> ---
>  include/linux/hmm.h     |  10 +-
>  include/linux/migrate.h |   6 +-
>  mm/hmm.c                | 351 ++++++++++++++++++++++++++++++++++++++--
>  mm/migrate_device.c     |  72 ++++++++-
>  4 files changed, 420 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/hmm.h b/include/linux/hmm.h
> index db75ffc949a7..7485e549c675 100644
> --- a/include/linux/hmm.h
> +++ b/include/linux/hmm.h
> @@ -12,7 +12,7 @@
>  #include <linux/mm.h>
>  
>  struct mmu_interval_notifier;
> -
> +struct migrate_vma;
>  /*
>   * On output:
>   * 0             - The page is faultable and a future call with 
> @@ -48,11 +48,14 @@ enum hmm_pfn_flags {
>  	HMM_PFN_P2PDMA     = 1UL << (BITS_PER_LONG - 5),
>  	HMM_PFN_P2PDMA_BUS = 1UL << (BITS_PER_LONG - 6),
>  
> -	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 11),
> +	/* Migrate request */
> +	HMM_PFN_MIGRATE    = 1UL << (BITS_PER_LONG - 7),
> +	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 12),
>  
>  	/* Input flags */
>  	HMM_PFN_REQ_FAULT = HMM_PFN_VALID,
>  	HMM_PFN_REQ_WRITE = HMM_PFN_WRITE,
> +	HMM_PFN_REQ_MIGRATE = HMM_PFN_MIGRATE,
>  
>  	HMM_PFN_FLAGS = ~((1UL << HMM_PFN_ORDER_SHIFT) - 1),
>  };
> @@ -107,6 +110,7 @@ static inline unsigned int hmm_pfn_to_map_order(unsigned long hmm_pfn)
>   * @default_flags: default flags for the range (write, read, ... see hmm doc)
>   * @pfn_flags_mask: allows to mask pfn flags so that only default_flags matter
>   * @dev_private_owner: owner of device private pages
> + * @migrate: structure for migrating the associated vma
>   */
>  struct hmm_range {
>  	struct mmu_interval_notifier *notifier;
> @@ -117,12 +121,14 @@ struct hmm_range {
>  	unsigned long		default_flags;
>  	unsigned long		pfn_flags_mask;
>  	void			*dev_private_owner;
> +	struct migrate_vma      *migrate;
>  };
>  
>  /*
>   * Please see Documentation/mm/hmm.rst for how to use the range API.
>   */
>  int hmm_range_fault(struct hmm_range *range);
> +int hmm_range_migrate_prepare(struct hmm_range *range, struct migrate_vma **pargs);
>  
>  /*
>   * HMM_RANGE_DEFAULT_TIMEOUT - default timeout (ms) when waiting for a range
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index acadd41e0b5c..ab35d0f1f65d 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -3,6 +3,7 @@
>  #define _LINUX_MIGRATE_H
>  
>  #include <linux/mm.h>
> +#include <linux/hmm.h>
>  #include <linux/mempolicy.h>
>  #include <linux/migrate_mode.h>
>  #include <linux/hugetlb.h>
> @@ -143,10 +144,11 @@ static inline unsigned long migrate_pfn(unsigned long pfn)
>  	return (pfn << MIGRATE_PFN_SHIFT) | MIGRATE_PFN_VALID;
>  }
>  
> -enum migrate_vma_direction {
> +enum migrate_vma_info {
>  	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
>  	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
>  	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
> +	MIGRATE_VMA_FAULT = 1 << 3,
>  };
>  

I suspect there are some points of conflict with my series that can be resolved

>  struct migrate_vma {
> @@ -194,7 +196,7 @@ void migrate_device_pages(unsigned long *src_pfns, unsigned long *dst_pfns,
>  			unsigned long npages);
>  void migrate_device_finalize(unsigned long *src_pfns,
>  			unsigned long *dst_pfns, unsigned long npages);
> -
> +void migrate_hmm_range_setup(struct hmm_range *range);
>  #endif /* CONFIG_MIGRATION */
>  
>  #endif /* _LINUX_MIGRATE_H */
> diff --git a/mm/hmm.c b/mm/hmm.c
> index d545e2494994..8cb2b325fa9f 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -20,6 +20,7 @@
>  #include <linux/pagemap.h>
>  #include <linux/swapops.h>
>  #include <linux/hugetlb.h>
> +#include <linux/migrate.h>
>  #include <linux/memremap.h>
>  #include <linux/sched/mm.h>
>  #include <linux/jump_label.h>
> @@ -33,6 +34,10 @@
>  struct hmm_vma_walk {
>  	struct hmm_range	*range;
>  	unsigned long		last;
> +	struct mmu_notifier_range mmu_range;
> +	struct vm_area_struct 	*vma;
> +	unsigned long 		start;
> +	unsigned long 		end;
>  };
>  
>  enum {
> @@ -47,15 +52,33 @@ enum {
>  			      HMM_PFN_P2PDMA_BUS,
>  };
>  
> +static enum migrate_vma_info hmm_want_migrate(struct hmm_range *range)

hmm_want_migrate -> hmm_select_and_migrate?

> +{
> +	enum migrate_vma_info minfo;
> +
> +	minfo = range->migrate ? range->migrate->flags : 0;
> +	minfo |= (range->default_flags & HMM_PFN_REQ_MIGRATE) ?
> +		MIGRATE_VMA_SELECT_SYSTEM : 0;
> +

Just to understand, this selects just system pages

> +	return minfo;
> +}
> +
>  static int hmm_pfns_fill(unsigned long addr, unsigned long end,
> -			 struct hmm_range *range, unsigned long cpu_flags)
> +			 struct hmm_vma_walk *hmm_vma_walk, unsigned long cpu_flags)
>  {
> +	struct hmm_range *range = hmm_vma_walk->range;
>  	unsigned long i = (addr - range->start) >> PAGE_SHIFT;
>  
> +	if (cpu_flags != HMM_PFN_ERROR)
> +		if (hmm_want_migrate(range) &&
> +		    (vma_is_anonymous(hmm_vma_walk->vma)))
> +			cpu_flags |= (HMM_PFN_VALID | HMM_PFN_MIGRATE);
> +
>  	for (; addr < end; addr += PAGE_SIZE, i++) {
>  		range->hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
>  		range->hmm_pfns[i] |= cpu_flags;
>  	}
> +
>  	return 0;
>  }
>  
> @@ -171,11 +194,11 @@ static int hmm_vma_walk_hole(unsigned long addr, unsigned long end,
>  	if (!walk->vma) {
>  		if (required_fault)
>  			return -EFAULT;
> -		return hmm_pfns_fill(addr, end, range, HMM_PFN_ERROR);
> +		return hmm_pfns_fill(addr, end, hmm_vma_walk, HMM_PFN_ERROR);
>  	}
>  	if (required_fault)
>  		return hmm_vma_fault(addr, end, required_fault, walk);
> -	return hmm_pfns_fill(addr, end, range, 0);
> +	return hmm_pfns_fill(addr, end, hmm_vma_walk, 0);
>  }
>  
>  static inline unsigned long hmm_pfn_flags_order(unsigned long order)
> @@ -326,6 +349,257 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>  	return hmm_vma_fault(addr, end, required_fault, walk);
>  }
>  
> +/*
> + * Install migration entries if migration requested, either from fault
> + * or migrate paths.
> + *
> + */
> +static void hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
> +					   pmd_t *pmdp,
> +					   unsigned long addr,
> +					   unsigned long *hmm_pfn)
> +{
> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
> +	struct hmm_range *range = hmm_vma_walk->range;
> +	struct migrate_vma *migrate = range->migrate;
> +	struct mm_struct *mm = walk->vma->vm_mm;
> +	struct folio *fault_folio = NULL;
> +	enum migrate_vma_info minfo;
> +	struct dev_pagemap *pgmap;
> +	bool anon_exclusive;
> +	struct folio *folio;
> +	unsigned long pfn;
> +	struct page *page;
> +	swp_entry_t entry;
> +	pte_t pte, swp_pte;
> +	spinlock_t *ptl;
> +	bool writable = false;
> +	pte_t *ptep;
> +
> +
> +	// Do we want to migrate at all?
> +	minfo = hmm_want_migrate(range);
> +	if (!minfo)
> +		return;
> +
> +	fault_folio = (migrate && migrate->fault_page) ?
> +		page_folio(migrate->fault_page) : NULL;
> +
> +	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
> +	if (!ptep)
> +		return;
> +
> +	pte = ptep_get(ptep);
> +
> +	if (pte_none(pte)) {
> +		// migrate without faulting case
> +		if (vma_is_anonymous(walk->vma))
> +			*hmm_pfn = HMM_PFN_MIGRATE|HMM_PFN_VALID;
> +		goto out;
> +	}
> +
> +	if (!(*hmm_pfn & HMM_PFN_VALID))
> +		goto out;
> +
> +	if (!pte_present(pte)) {
> +		/*
> +		 * Only care about unaddressable device page special
> +		 * page table entry. Other special swap entries are not
> +		 * migratable, and we ignore regular swapped page.
> +		 */
> +		entry = pte_to_swp_entry(pte);
> +		if (!is_device_private_entry(entry))
> +			goto out;
> +
> +		// We have already checked that are the pgmap owners
> +		if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
> +			goto out;
> +
> +		page = pfn_swap_entry_to_page(entry);
> +		pfn = page_to_pfn(page);
> +		if (is_writable_device_private_entry(entry))
> +			writable = true;
> +	} else {
> +		pfn = pte_pfn(pte);
> +		if (is_zero_pfn(pfn) &&
> +		    (minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
> +			*hmm_pfn = HMM_PFN_MIGRATE|HMM_PFN_VALID;
> +			goto out;
> +		}
> +		page = vm_normal_page(walk->vma, addr, pte);
> +		if (page && !is_zone_device_page(page) &&
> +		    !(minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
> +			goto out;
> +		} else if (page && is_device_coherent_page(page)) {
> +			pgmap = page_pgmap(page);
> +
> +			if (!(minfo &
> +			      MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
> +			    pgmap->owner != migrate->pgmap_owner)
> +				goto out;
> +		}
> +		writable = pte_write(pte);
> +	}
> +
> +	/* FIXME support THP */
> +	if (!page || !page->mapping || PageTransCompound(page))
> +		goto out;
> +
> +	/*
> +	 * By getting a reference on the folio we pin it and that blocks
> +	 * any kind of migration. Side effect is that it "freezes" the
> +	 * pte.
> +	 *
> +	 * We drop this reference after isolating the folio from the lru
> +	 * for non device folio (device folio are not on the lru and thus
> +	 * can't be dropped from it).
> +	 */
> +	folio = page_folio(page);
> +	folio_get(folio);
> +
> +	/*
> +	 * We rely on folio_trylock() to avoid deadlock between
> +	 * concurrent migrations where each is waiting on the others
> +	 * folio lock. If we can't immediately lock the folio we fail this
> +	 * migration as it is only best effort anyway.
> +	 *
> +	 * If we can lock the folio it's safe to set up a migration entry
> +	 * now. In the common case where the folio is mapped once in a
> +	 * single process setting up the migration entry now is an
> +	 * optimisation to avoid walking the rmap later with
> +	 * try_to_migrate().
> +	 */
> +
> +	if (fault_folio == folio || folio_trylock(folio)) {
> +		anon_exclusive = folio_test_anon(folio) &&
> +			PageAnonExclusive(page);
> +
> +		flush_cache_page(walk->vma, addr, pfn);
> +
> +		if (anon_exclusive) {
> +			pte = ptep_clear_flush(walk->vma, addr, ptep);
> +
> +			if (folio_try_share_anon_rmap_pte(folio, page)) {
> +				set_pte_at(mm, addr, ptep, pte);
> +				folio_unlock(folio);
> +				folio_put(folio);
> +				goto out;
> +			}
> +		} else {
> +			pte = ptep_get_and_clear(mm, addr, ptep);
> +		}
> +
> +		/* Setup special migration page table entry */
> +		if (writable)
> +			entry = make_writable_migration_entry(pfn);
> +		else if (anon_exclusive)
> +			entry = make_readable_exclusive_migration_entry(pfn);
> +		else
> +			entry = make_readable_migration_entry(pfn);
> +
> +		swp_pte = swp_entry_to_pte(entry);
> +		if (pte_present(pte)) {
> +			if (pte_soft_dirty(pte))
> +				swp_pte = pte_swp_mksoft_dirty(swp_pte);
> +			if (pte_uffd_wp(pte))
> +				swp_pte = pte_swp_mkuffd_wp(swp_pte);
> +		} else {
> +			if (pte_swp_soft_dirty(pte))
> +				swp_pte = pte_swp_mksoft_dirty(swp_pte);
> +			if (pte_swp_uffd_wp(pte))
> +				swp_pte = pte_swp_mkuffd_wp(swp_pte);
> +		}
> +
> +		set_pte_at(mm, addr, ptep, swp_pte);
> +		folio_remove_rmap_pte(folio, page, walk->vma);
> +		folio_put(folio);
> +		*hmm_pfn |= HMM_PFN_MIGRATE;
> +
> +		if (pte_present(pte))
> +			flush_tlb_range(walk->vma, addr, addr + PAGE_SIZE);
> +	} else
> +		folio_put(folio);
> +out:
> +	pte_unmap_unlock(ptep, ptl);
> +
> +}
> +
> +static int hmm_vma_walk_split(pmd_t *pmdp,
> +			      unsigned long addr,
> +			      struct mm_walk *walk)
> +{
> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
> +	struct hmm_range *range = hmm_vma_walk->range;
> +	struct migrate_vma *migrate = range->migrate;
> +	struct folio *folio, *fault_folio;
> +	spinlock_t *ptl;
> +	int ret = 0;
> +
> +	fault_folio = (migrate && migrate->fault_page) ?
> +		page_folio(migrate->fault_page) : NULL;
> +
> +	ptl = pmd_lock(walk->mm, pmdp);
> +	if (unlikely(!pmd_trans_huge(*pmdp))) {
> +		spin_unlock(ptl);
> +		goto out;
> +	}
> +
> +	folio = pmd_folio(*pmdp);
> +	if (is_huge_zero_folio(folio)) {
> +		spin_unlock(ptl);
> +		split_huge_pmd(walk->vma, pmdp, addr);
> +	} else {
> +		folio_get(folio);
> +		spin_unlock(ptl);
> +		/* FIXME: we don't expect THP for fault_folio */
> +		if (WARN_ON_ONCE(fault_folio == folio)) {
> +			folio_put(folio);
> +			ret = -EBUSY;
> +			goto out;
> +		}
> +		if (unlikely(!folio_trylock(folio))) {
> +			folio_put(folio);
> +			ret = -EBUSY;
> +			goto out;
> +		}
> +		ret = split_folio(folio);
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	}
> +out:
> +	return ret;
> +}
> +
> +static int hmm_vma_capture_migrate_range(unsigned long start,
> +					 unsigned long end,
> +					 struct mm_walk *walk)
> +{
> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
> +	struct hmm_range *range = hmm_vma_walk->range;
> +
> +	if (!hmm_want_migrate(range))
> +		return 0;
> +
> +	if (hmm_vma_walk->vma && (hmm_vma_walk->vma != walk->vma))
> +		return -ERANGE;
> +
> +	hmm_vma_walk->vma = walk->vma;
> +	hmm_vma_walk->start = start;
> +	hmm_vma_walk->end = end;
> +
> +	if (end - start > range->end - range->start)
> +		return -ERANGE;
> +
> +	if (!hmm_vma_walk->mmu_range.owner) {
> +		mmu_notifier_range_init_owner(&hmm_vma_walk->mmu_range, MMU_NOTIFY_MIGRATE, 0,
> +					      walk->vma->vm_mm, start, end,
> +					      range->dev_private_owner);
> +		mmu_notifier_invalidate_range_start(&hmm_vma_walk->mmu_range);
> +	}
> +
> +	return 0;
> +}
> +
>  static int hmm_vma_walk_pmd(pmd_t *pmdp,
>  			    unsigned long start,
>  			    unsigned long end,
> @@ -351,13 +625,28 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>  			pmd_migration_entry_wait(walk->mm, pmdp);
>  			return -EBUSY;
>  		}
> -		return hmm_pfns_fill(start, end, range, 0);
> +		return hmm_pfns_fill(start, end, hmm_vma_walk, 0);
>  	}
>  
>  	if (!pmd_present(pmd)) {
>  		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
>  			return -EFAULT;
> -		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> +		return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
> +	}
> +
> +	if (hmm_want_migrate(range) &&
> +	    pmd_trans_huge(pmd)) {
> +		int r;
> +
> +		r = hmm_vma_walk_split(pmdp, addr, walk);
> +		if (r) {
> +			/* Split not successful, skip */
> +			return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
> +		}
> +
> +		/* Split successful or "again", reloop */
> +		hmm_vma_walk->last = addr;
> +		return -EBUSY;
>  	}
>  
>  	if (pmd_trans_huge(pmd)) {
> @@ -386,7 +675,7 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>  	if (pmd_bad(pmd)) {
>  		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
>  			return -EFAULT;
> -		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> +		return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>  	}
>  
>  	ptep = pte_offset_map(pmdp, addr);
> @@ -400,8 +689,11 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>  			/* hmm_vma_handle_pte() did pte_unmap() */
>  			return r;
>  		}
> +
> +		hmm_vma_handle_migrate_prepare(walk, pmdp, addr, hmm_pfns);
>  	}
>  	pte_unmap(ptep - 1);
> +
>  	return 0;
>  }
>  
> @@ -535,6 +827,11 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
>  	struct hmm_vma_walk *hmm_vma_walk = walk->private;
>  	struct hmm_range *range = hmm_vma_walk->range;
>  	struct vm_area_struct *vma = walk->vma;
> +	int r;
> +
> +	r = hmm_vma_capture_migrate_range(start, end, walk);
> +	if (r)
> +		return r;
>  
>  	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
>  	    vma->vm_flags & VM_READ)
> @@ -557,7 +854,7 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
>  				 (end - start) >> PAGE_SHIFT, 0))
>  		return -EFAULT;
>  
> -	hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> +	hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>  
>  	/* Skip this vma and continue processing the next vma. */
>  	return 1;
> @@ -587,9 +884,17 @@ static const struct mm_walk_ops hmm_walk_ops = {
>   *		the invalidation to finish.
>   * -EFAULT:     A page was requested to be valid and could not be made valid
>   *              ie it has no backing VMA or it is illegal to access
> + * -ERANGE:     The range crosses multiple VMAs, or space for hmm_pfns array
> + *              is too low.
>   *
>   * This is similar to get_user_pages(), except that it can read the page tables
>   * without mutating them (ie causing faults).
> + *
> + * If want to do migrate after faultin, call hmm_range_fault() with
> + * HMM_PFN_REQ_MIGRATE and initialize range.migrate field.
> + * After hmm_range_fault() call migrate_hmm_range_setup() instead of
> + * migrate_vma_setup() and after that follow normal migrate calls path.
> + *
>   */
>  int hmm_range_fault(struct hmm_range *range)
>  {
> @@ -597,16 +902,28 @@ int hmm_range_fault(struct hmm_range *range)
>  		.range = range,
>  		.last = range->start,
>  	};
> -	struct mm_struct *mm = range->notifier->mm;
> +	bool is_fault_path = !!range->notifier;
> +	struct mm_struct *mm;
>  	int ret;
>  
> +	/*
> +	 *
> +	 *  Could be serving a device fault or come from migrate
> +	 *  entry point. For the former we have not resolved the vma
> +	 *  yet, and the latter we don't have a notifier (but have a vma).
> +	 *
> +	 */
> +	mm = is_fault_path ? range->notifier->mm : range->migrate->vma->vm_mm;
>  	mmap_assert_locked(mm);
>  
>  	do {
>  		/* If range is no longer valid force retry. */
> -		if (mmu_interval_check_retry(range->notifier,
> -					     range->notifier_seq))
> -			return -EBUSY;
> +		if (is_fault_path && mmu_interval_check_retry(range->notifier,
> +					     range->notifier_seq)) {
> +			ret = -EBUSY;
> +			break;
> +		}
> +
>  		ret = walk_page_range(mm, hmm_vma_walk.last, range->end,
>  				      &hmm_walk_ops, &hmm_vma_walk);
>  		/*
> @@ -616,6 +933,18 @@ int hmm_range_fault(struct hmm_range *range)
>  		 * output, and all >= are still at their input values.
>  		 */
>  	} while (ret == -EBUSY);
> +
> +	if (hmm_want_migrate(range) && range->migrate &&
> +	    hmm_vma_walk.mmu_range.owner) {
> +		// The migrate_vma path has the following initialized
> +		if (is_fault_path) {
> +			range->migrate->vma   = hmm_vma_walk.vma;
> +			range->migrate->start = range->start;
> +			range->migrate->end   = hmm_vma_walk.end;
> +		}
> +		mmu_notifier_invalidate_range_end(&hmm_vma_walk.mmu_range);
> +	}
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL(hmm_range_fault);
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index e05e14d6eacd..87ddc0353165 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -535,7 +535,18 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
>   */
>  int migrate_vma_setup(struct migrate_vma *args)
>  {
> +	int ret;
>  	long nr_pages = (args->end - args->start) >> PAGE_SHIFT;
> +	struct hmm_range range = {
> +		.notifier = NULL,
> +		.start = args->start,
> +		.end = args->end,
> +		.migrate = args,
> +		.hmm_pfns = args->src,
> +		.default_flags = HMM_PFN_REQ_MIGRATE,
> +		.dev_private_owner = args->pgmap_owner,
> +		.migrate = args
> +	};
>  
>  	args->start &= PAGE_MASK;
>  	args->end &= PAGE_MASK;
> @@ -560,17 +571,19 @@ int migrate_vma_setup(struct migrate_vma *args)
>  	args->cpages = 0;
>  	args->npages = 0;
>  
> -	migrate_vma_collect(args);
> +	if (args->flags & MIGRATE_VMA_FAULT)
> +		range.default_flags |= HMM_PFN_REQ_FAULT;
>  
> -	if (args->cpages)
> -		migrate_vma_unmap(args);
> +	ret = hmm_range_fault(&range);
> +
> +	migrate_hmm_range_setup(&range);
>  
>  	/*
>  	 * At this point pages are locked and unmapped, and thus they have
>  	 * stable content and can safely be copied to destination memory that
>  	 * is allocated by the drivers.
>  	 */
> -	return 0;
> +	return ret;
>  
>  }
>  EXPORT_SYMBOL(migrate_vma_setup);
> @@ -1014,3 +1027,54 @@ int migrate_device_coherent_folio(struct folio *folio)
>  		return 0;
>  	return -EBUSY;
>  }
> +
> +void migrate_hmm_range_setup(struct hmm_range *range)
> +{
> +
> +	struct migrate_vma *migrate = range->migrate;
> +
> +	if (!migrate)
> +		return;
> +
> +	migrate->npages = (migrate->end - migrate->start) >> PAGE_SHIFT;
> +	migrate->cpages = 0;
> +
> +	for (unsigned long i = 0; i < migrate->npages; i++) {
> +
> +		unsigned long pfn = range->hmm_pfns[i];
> +
> +		/*
> +		 *
> +		 *  Don't do migration if valid and migrate flags are not both set.
> +		 *
> +		 */
> +		if ((pfn & (HMM_PFN_VALID | HMM_PFN_MIGRATE)) !=
> +		    (HMM_PFN_VALID | HMM_PFN_MIGRATE)) {
> +			migrate->src[i] = 0;
> +			migrate->dst[i] = 0;
> +			continue;
> +		}
> +
> +		migrate->cpages++;
> +
> +		/*
> +		 *
> +		 * The zero page is encoded in a special way, valid and migrate is
> +		 * set, and pfn part is zero. Encode specially for migrate also.
> +		 *
> +		 */
> +		if (pfn == (HMM_PFN_VALID|HMM_PFN_MIGRATE)) {
> +			migrate->src[i] = MIGRATE_PFN_MIGRATE;
> +			continue;
> +		}
> +
> +		migrate->src[i] = migrate_pfn(page_to_pfn(hmm_pfn_to_page(pfn)))
> +			| MIGRATE_PFN_MIGRATE;
> +		migrate->src[i] |= (pfn & HMM_PFN_WRITE) ? MIGRATE_PFN_WRITE : 0;
> +	}
> +
> +	if (migrate->cpages)
> +		migrate_vma_unmap(migrate);
> +
> +}
> +EXPORT_SYMBOL(migrate_hmm_range_setup);


I've not had a chance to test the code, do you have any numbers with the changes
to show the advantages of doing both fault and migrate together?

Balbir

