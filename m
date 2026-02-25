Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E895F55434
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 02:15:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A6646B0088; Tue, 24 Feb 2026 21:15:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 754626B0089; Tue, 24 Feb 2026 21:15:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E1316B008A; Tue, 24 Feb 2026 21:15:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B42B6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 21:15:40 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F3E501A03FE
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:15:39 +0000 (UTC)
X-FDA: 84481362798.15.50C4608
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012051.outbound.protection.outlook.com [40.93.195.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id 186CDC0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:15:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=R7YrNO1y;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771985737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nO2mDJN2Hde2T/EVznUsoXL43PXu3gxCFVTCyg950p0=;
	b=ajh+HKtRzetbEamzyozsCsz1+/sPbQcd+BN3trCzw00+jSiif+/SZ3J1yi2IMjTtE6QQc1
	uLgdFQaf4hOGnseEJe4t3VCGGX4pIyiW28wW5Km2FAtRFBi40Rs6oEIVfL2FPX2d2yIi/x
	mjtZwe3Yu3pqPO7af6gMmOyyQOPNmGw=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=R7YrNO1y;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771985737; a=rsa-sha256;
	cv=pass;
	b=I+IOMPfE1iBg0GNsniCfaMSbzR1XZ4b+LiA9vI28C2VVWMhMdtpjyE04TRUDhAM5OIn3vU
	ETP6N30GbD5SIQWqL2kWYdcJBEWjZoqO7oXH8R+1an3aBLxVhFHV2jMyIjwFEFTX3QO7/Y
	R1ns3bMFyYXc3M4TLDzIlmEiR28Itq0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n7adorKfjCfKAO2S3+08w0fzgBh/07oQEt6A2mWEb74idOPJpTE6JrZMupfyp/+cEU886tsgU6022ZZNDeFMPoRjCadYVlGCkCPlb8WPXa8NDW52NS4n6lnpjNGxMmNbVM2b4Ai5xGmmrg8TWDOq/jXsycgGQT6JOEUY8mVFjDaLohzgvA55zMBUL40CeDh64liwQre6mQeFH41wHbH+28k3/u89ZZqzd/s9y0LrL1ogyS1zYVd5G+fvcXghliHgvwjLHtSwhODhBLEpdd2glMma+GDfnikvVFZaRLqDO+8DOAL+Ne28G/1kKDbSSnZ+kud4LFbvPEsJJXkiqqZrXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nO2mDJN2Hde2T/EVznUsoXL43PXu3gxCFVTCyg950p0=;
 b=POT5WnSaFUJyhj+Ps3DN23QPZQ/74znVAhpdodlDDvqJ9KWx5UllsUOABVO9bzM2wEd8kRxHjlDbjc4dvtWJ33YLQfvR7vMwvDdqDw9Bm1cJu4wqfTPkj0gHF2hsnIxuLcjtuT+2JaMY4RD6jiQWLpHZwQiMfkWf1MiLOMo9s2QJo2f9qkFqm25mbFO78+fhXhpC5wTBPGzp3GnqhVLOtKfp8gZCefRh59D3KWl5b1vk2EgjsvipZrbjGXk7DUVImr3LRUpJUebMdosK+dYPxjOvIJr46oiXIUgDTlpiIhhbNswkGGi+miybXcy7KT3BWi1I0E1OfRSf94mAQh+GVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nO2mDJN2Hde2T/EVznUsoXL43PXu3gxCFVTCyg950p0=;
 b=R7YrNO1y2iqLBXhg522lt8+dQbZ9KVOju5bQQ5rwH1jk9GCKylg5UNQx0QiSJqhqHXmor1GbIXqZcHP8MixtQz3qyOGMHpSGzPYRFWhxwpZwKa4RTCk4WLq4Cc7YbdbdHxZywxhei2prIwcdsc7sQhaXaY+ij+sie/7HgVx5ajHOEdHrwPwKn/Dlcu1az4XugEi526w8C2gHxmDr/uhaiqGdXnxl2cRgMBRPqBcwdUKYlY8AlH9ijy71eF+Anc5MTE4nXfi+Eki/p4RnOVpdXj32bIS/f1gpeze0kSky7jv01O66RgkP47ibOgCgg06d05HpdvEpiTMtOa8oaQV2aQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ0PR12MB6805.namprd12.prod.outlook.com (2603:10b6:a03:44f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.14; Wed, 25 Feb 2026 02:15:32 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 02:15:32 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Ron Economos <re@w6rz.net>, "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, jackmanb@google.com, jane.chu@oracle.com,
 hannes@cmpxchg.org, willy@infradead.org, muchun.song@linux.dev,
 osalvador@suse.de, sidhartha.kumar@oracle.com, vbabka@suse.cz,
 claudiu.beznea.uj@bp.renesas.com, Mark Brown <broonie@kernel.org>,
 akpm@linux-foundation.org, pjw@kernel.org
Subject: Re: mm: Regression with v7.0-rc1 on RISC-V
Date: Tue, 24 Feb 2026 21:15:30 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <04EC5689-3354-4139-9911-A3796C772B28@nvidia.com>
In-Reply-To: <4b219cd0-9391-4edb-83c0-b6a1c60d0790@huawei.com>
References: <1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net>
 <13b8d60d-1209-4650-9fa5-982381c53512@kernel.org>
 <1966378802.577797.1771952827516@app.mailbox.org>
 <78D36EC1-2596-448A-A939-0A1AC7B3D1BC@nvidia.com>
 <1AB3E96B-F4CA-4B00-9078-2AC20A1A60DC@nvidia.com>
 <272A58BA-445F-46F9-8DAB-D82E43D7771A@nvidia.com>
 <4b219cd0-9391-4edb-83c0-b6a1c60d0790@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAPR03CA0056.namprd03.prod.outlook.com
 (2603:10b6:208:32d::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ0PR12MB6805:EE_
X-MS-Office365-Filtering-Correlation-Id: e9de996e-a4c8-45ec-1247-08de7413c101
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RjBsZUFFNDhMTklpRXU3VXRnM1hicklsVmVuby93UEhUY1loUWtMTzJCZ3Zj?=
 =?utf-8?B?MnhDMVZlVHdmVTZDVWZVQ3RKWjFnMFNTcWhLSUZsQ1BMcDVUWEsremNEZ254?=
 =?utf-8?B?d3hMUTZoMVVmR1NBL1hWSVN5djErWGVaRldvZmtrRkk2LzRVeFFnaWhpR3ln?=
 =?utf-8?B?ZEJGVmNhV0hnQlgwQWI0NVhDVWx4UWJYU2JxOGNuMUh2YWxER1RYNUR6ZitR?=
 =?utf-8?B?MzJSMXROeUFBWWUyYjNWWVZRdnRwVy9scmE1RnRvMmdkTmVQOG1vVGZIK3I2?=
 =?utf-8?B?dTVNY2VudHFYNmhpRHM2MVozNUZrT2RiLzQ3TU5kQ2NVVUhVbEVkNVRvK1Yv?=
 =?utf-8?B?T2hnLzJVVGdXYXRRcFVra0pZQlA5ODQ3Tmp0am9kK2tuOUhZZXZoWFlCSnpt?=
 =?utf-8?B?U0c1TXBaNXFwaFc0amJBMThBYWMydzNVeVViZTBOVW0zL2dBWGlCdmNZV2dW?=
 =?utf-8?B?Z2RmMDZtVHc1U094SnNxS2ZhbGRtNkZOTnlyUFprREZsZjZMeDRXYXc1Kysv?=
 =?utf-8?B?YnVEaFIvT2UzdExjWlhIYXA4ZnJCV2ZQVW1BUlQ5Ukg2bWtBZmJMRXE4YTEz?=
 =?utf-8?B?MUU4R1psM1lmdVJzZUxnMzhCLzJHZDA0Sm9YMEhlMm4wbnljL0Nvd0RxSkUw?=
 =?utf-8?B?R3V0RFRBM3VxaStlWktsUTNoOTZ4T2dFYTBISDU3aWxlRklHai9EMjZka2Vz?=
 =?utf-8?B?NW1zS3MyT29qSDRReVF5T216eDh6cGNNRlgyL0wrbmF4SkJPMGpJVUdmNUdi?=
 =?utf-8?B?NEFiUnNHSXl5QVdPMnMwdzVheEVtby9QU3NIdkVxWDlCdy9hUURTaWRKcUpn?=
 =?utf-8?B?NDFUb1ZuZi8zWHJHRHBHMVdaS3R1RDJFTU9wWExsS3ZXTE9ra0Q2ZzExYmli?=
 =?utf-8?B?ME41cUdNV1pFd3dCTHJXaG9nbGl4SzJxRE83SWhlM2l5MnduQlFFV2FJcHVR?=
 =?utf-8?B?Vm01V09WWnIrdm83WEtrV0J4UVliWmF4aUoyNWVFZHFCZWJMN1RlTmxIWEJ1?=
 =?utf-8?B?UEtXWnBkOW9vTUZ0dGR3aHN2UC8yM3VRVDlwYno5dlkzSTRpbVhXaW5QYUZY?=
 =?utf-8?B?dWt3OGJCdzlNZU9UR3J1Sk4yWGROM3RYNUFieGNCUmhQQ3IySVJTQUhNVGtE?=
 =?utf-8?B?d0J6aUdtUDRGUG9va0RGNjZHOVNEUTI1ZzJzOVl1bWNLSEtDaUxjbWdFbnZL?=
 =?utf-8?B?c3RCWk9DY0ZLd1htSUZBQWw5THhETlVuT3NsampWT0J4dTBtaXpqVytJUGFY?=
 =?utf-8?B?R2hUMm9TOWozdVRrbzhEUnhob2NzRWRUdnoxRkY1VE1DNGttcHBzQjlQWlNu?=
 =?utf-8?B?ajVpY1ZTMjBOeVgzKzd2akdsQlhSektjaWppbmJ0WmxSdkFqTnM1c2xUVmpw?=
 =?utf-8?B?VWlBSzlrR3ZldkxoVW9BL0ZhM05oSnlUb0tZNzZJaVpkMHRsWklqb1lNWlI5?=
 =?utf-8?B?ZHQvVkRhVUFob0Rpb0EvUnpOMjQxYWZTK1laczA2aHRwM3FKUE5ZRjZDTVNt?=
 =?utf-8?B?UEZ1QUlpdVlhWG5nZ0UvUStWSlJmaDRMckszeWREVjFxTjd3dGJ4ZEJ0aE1z?=
 =?utf-8?B?SFo3ZS9NRzRpSmZSaDhJNk5PN2xJS2QyOExvWCtNbUhKcnVmYzlibHpVaHBq?=
 =?utf-8?B?YUxMR1FrbEZyZUx3RzRJNVYzWDg0OHU1Mk54bXN4cXhLQVlRQ1NEZnRmMUh6?=
 =?utf-8?B?d0VUdVF2b3ZwN1MzNjMzR2ZhUnJTdGNYS21VdU9CUTNvNGIxcXZBWWZtVVN5?=
 =?utf-8?B?SFFUL1VMK2YwNENiOWJQbSsxQjRMMW1DS2N5OEtkRC8yYzZYamRacE0yb1Vm?=
 =?utf-8?B?RHErSkRnOXlKVjdRZ2hSYkNUWW44cFh1T2NLZkN3SzcxZ3pycW1SblBGOURH?=
 =?utf-8?B?d0lHYm03eWMvdWdNZktaOHhkVHBWeDVJVWduMDd3YTBvLzAyeHNEbW5XdmxS?=
 =?utf-8?B?a2l5K1NEbmJ2elJrME5Ea3ZnTU1yRkdWVnp5WGtoY2hTMk50c2sxWklHSTl1?=
 =?utf-8?B?T2Q2ci9rblUxWll4UHYvVDhVTVNQUU9VTjBSM2xhakVRdC9TN2Jkc0o5ZVJY?=
 =?utf-8?B?MU5MOHR2TnhMTndyL2J3dVlkblFZTkpNN3JtTStiN3JFUWNTMCtQanpOUXF3?=
 =?utf-8?Q?cN/c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N1BHei84ZzNES3IzYTFRQnhGNW5CVzVLYTNQZTZiMWxUQVUzdDlwZE84S1k0?=
 =?utf-8?B?aUNFTnFZUmx3UUJEM2FCTUtSOXZteG9JOStVdXN2RUF3aWgxZDdPR1V6S1hl?=
 =?utf-8?B?akc0N1RwRG01VTUrejl3S3NSVmxCNFRSWW1WRkJvOHJUMVZpZUpURGxNamxl?=
 =?utf-8?B?a3kwUTJNa3k5SjFLQTcyUFVyYURKN3dBaFVpVWtMRVA0SXpUYklLMEdjY1Ft?=
 =?utf-8?B?dlhaSi9aUHdnVXA1WnpCTmNCUkFucDdKZzBiY0FJWXYxYU9qbk5EOTVjSFhx?=
 =?utf-8?B?Vm1NeXc4WGRmWkNMTXlYNnRhRFlreEsvQW8zRzN3SHM4ZXRQczBYR3NHcmpt?=
 =?utf-8?B?RHlXOUVWS3FGdWl1ZGNWK2Z4Y1ZpV0ZZRGppeHQvd2xYSTA1OUFiU2JDVkd0?=
 =?utf-8?B?RW9DaFYyVlRFcWszZWRCMUgxcE5CMDNBT0E5ZVJXYzNpNXJ4YkdsR1FZT3dJ?=
 =?utf-8?B?OFlBM0NJeE0wMUFIZVJYT0YwRzRjUVNOeVdHQm54QlE4b2U5MCtwc3E4K00z?=
 =?utf-8?B?VGlXaXV3Ynk3K3NtclE1WEpoU1BIUVRBcUx1TzdHWC9EbnVGT3ZCVWxabFMx?=
 =?utf-8?B?bnhxQjYzN3FmdyttTkx0WmhiM2U2QjhYdHM1MDB4Rit5YnRnMjNZUGhUbDZo?=
 =?utf-8?B?TncweFhhYi9QWVJpVlVkMVhka1UySW95SXFPNzlHenNSd2ttcjJhdkxaK1B5?=
 =?utf-8?B?SWZXUHdOSGxSZjA3amNxZVZGZy9tNUZ2T2R1NXliN2xKMitEdFpoMUpnM3Iv?=
 =?utf-8?B?OW1qd2t1ZE9ESUtCMEFWYnJzTUcwMVlKR3FQNGRHd1l1TmY3RGN4OUZ0aHVV?=
 =?utf-8?B?WFVWWk1qbkQ3RDhYUjRhUGtIbjJrREIweTkzQ0hQWXRZWUwyWDdIK1oycWd0?=
 =?utf-8?B?S3ljTHRVSHBYUHdZRlYvNXExSU9ybE1raEdhVHNZVGhXZUcrNGRhamp4RlBP?=
 =?utf-8?B?dHBaeHRaT0srekJmMWRBV3Z1M241UDJRSlB1RkZ1cGducWpvbDYwZVJ0bTE3?=
 =?utf-8?B?VDFzZDMvUDBJSG9yUWxPSjBXRFcwZzZMd0Y1cFdvQU9mYWFIeEhSS0pKS1h6?=
 =?utf-8?B?ZzkyQ3VuSlZOcDk2Szg2TjhQUmdRbkluMHh1WEhGd1FXY1g4TWpyQzgvMm9i?=
 =?utf-8?B?NEw4L0lzejc4djRIdUwzYXNCWFNUek1hMVdNU3FINXpvY2luMDdKaEkxeXRm?=
 =?utf-8?B?R3AzdUZzSjNEVzIwK1lHYllYbExQOW1yaWFwWjkwcG5wa0Z5NEcySDJScUVw?=
 =?utf-8?B?dnk0b0tLSmF4L3VGQXlvVkoyMjBGTXM0YlJEN20zcVJRV244TlNRd2hFQXZY?=
 =?utf-8?B?Q240c0EvSUxwN3I5b09ocklyWnZUQXZKSlBrbXhJcHFwZWlra1pkN3NVSkNF?=
 =?utf-8?B?bUpQZEhFTnVhOEZjTWJrMDFyc3Rhalg2UkNtdWxHNXZxdEYrUmh4cnAxZ1cy?=
 =?utf-8?B?ZnJpeGhJY2YvUExlM2dISWJWL01xQUxRckswR0E3SWdZaUlUaVg5M2dHU0FV?=
 =?utf-8?B?cjlVTnFsd0RKNUtweWZnTVlRVVlVWm9sY09ieFdGUWtJVGM4NmlPbTZpZEpk?=
 =?utf-8?B?WTVaU0RGMndNSHcvc1JKTlg2YmlReU9Md0RqOTEyN255cHROL2F4NkRKMkxi?=
 =?utf-8?B?dzlBRlFNVS82elpBZWg4U0tXWVllRmlLbE9zOW5nWHNKR0NEUHdLYjZhTmJV?=
 =?utf-8?B?QnNnUC9sQ1FKQm9DTWpYazg2eTFOa2pNd3kvL3k2VXRxSkFWdUt0Ty91OGpt?=
 =?utf-8?B?ZWdwTkpDQlJHUEdhK3Z2MWdHS3grZSs0VnM3TXZCaVRSMHBvZU1qMFhBekRS?=
 =?utf-8?B?U0VNVklXSVlPbGI3b2pxdEFoUkgvaE1JdklFeUUzdGF5eGg0RTBXYjFqa2w5?=
 =?utf-8?B?WE12UmZoRFRDc0pyZGhMYVJmM3dIdG44cGZGTjV0dEY3dFMvWEFzSThMMS9z?=
 =?utf-8?B?WFM1eVhEYXBZMDV3U0NYcmo1cFF6L0NZTDNFOWdlaVAwbVlSaFd3VGx2YlpN?=
 =?utf-8?B?VzBOZHBzeUhpMkJOTjZHSVF1NHpiZDBRaXQ2Wkk5QlNmeHg4bU1TcmQyQXBy?=
 =?utf-8?B?L29lK1FpendOUUJlb2pZYkRvWGlZUlVoZmUvN2grQ2tpMS94cHNQSkZ5V24x?=
 =?utf-8?B?VnZaNWhMWVdtSW5Oa0VrVmFZU1VmVmhqQWVYcklDT1p4NlVPNFBnLzZld2Q1?=
 =?utf-8?B?NlI1NFpvUVZONkdPcVhlVWFMU29vTGVHakFhNFdYb0tnTmNwand5MzlSdjhk?=
 =?utf-8?B?T3cycVF6OW1xMFVYNTB0bVlkWGRYMDg0cWxmWWZMSHdCVXA5K2g1VzZORnZW?=
 =?utf-8?Q?bqPZEdhi3WK3hOhO75?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9de996e-a4c8-45ec-1247-08de7413c101
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 02:15:32.5590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vV7f1/HsTJWrOtj0E2GKIXWclbIgd8gMK3KGnarG4p8LBngC0wftD414E0Q5R898
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6805
X-Rspam-User: 
X-Rspamd-Queue-Id: 186CDC0005
X-Rspamd-Server: rspam02
X-Stat-Signature: 1s417o77k6py8kyahur7zfc16frboopo
X-HE-Tag: 1771985736-519761
X-HE-Meta: U2FsdGVkX1/MlHPkDy7LS9JdzlwAU3tqaSJ7uo/MeDyosRS5qKowikdOyf4/NEbXi5r7mybC5jMzA2LMuAFtNZ6d2daHTEcwaHAxsX9zDzGlTrdlFLpTy6aPDX4l4BxMUccNhaw8k1l6zJPv5GG6hzPAn5WXGOQm8Jaq620BP2qyOwHNfMMWv3opdXhZ0Sd3NHsdYCEpzxiwemLPcm2KGI9o7Met2jPOGTcxSCGVx3nYiIZf1e0zk0/Y2dXcHODIYs09rcztF8+vadSYThlWuaLyDTjsjHq2qbL+JkExmZFK5Y0+uZ5AnvIiw3XSvp/AcIOluKfwot5+qXa7aoYlptYdl2COs7Ne8Bcsk50EUIB9BDGzku+389YwLu2+O2IeOfaq33HSbmd7ceMwNUrM7qnBM7v9uxJ97RX7PAeZ06DkjTPGD04Zn0Z3YOTM0joLOcCdLe0kMGdjClBk3+H9REldz4+cDlDt4FBQG+2S/pbUVfHr0ILaBW5YExkyoEDHiobIZCw9jGo9iZV8GHx8BIySvrhTckj7njvUy91VHA1P5FrijB+4pO0qvNCkf97NexGusajcDms7CqUhdFLajg3vwg8iDC7jaCatXs3VSff04pf52J7wu1cGl3RboKYlqnb5mvtti9taN2gSKEZUU2bnwTWD0Y0YRR8AdpWVsd/ctitL2n3JHwPJz20Rxx2VB6jv/kgUToXz/YmZfzl2thjbaxVWpJJu+dipSZRvKX0RmjsPYKsNfW8z5djsRLLtvgF68WWwDumgpfYPPDRYkLqPQRqFUsgjaTtgOwGDQQkFnwOPD07xQYYGbMtphhoRgmOhvK94mGmkBLXX+Ui5qfY3a/BuHE8x60lVeSrWq5muPF6vLHzzUct81JLZ2lf1IaaTMLgS/vqhv5pSDnjyifRsB/6IjopTq/KHQimW+uvuPVgn9BtupvkNojxlX1W2ITAF9x79PsgD7nSxgmu
 eREVIfc6
 zKiRrqPkP0gPIyCIo/wYUF4iIrwF2HQUGTavCn5PSXkWZm5lNJOWmqhGuzUaeGw96t62PhTkAkZ3+y3ubOOk2s2MJWlO9byEXYSt4y8/6D9MaktvU3wgj1f1tW565Olk5ZIFcL7CO3w1wEt6YDqt6E27oMX8IWFOzx/sSkj4kDonSdh8kK5j10K++c4ErJaOtVJNx0a6SwBvcJGvA4R2roHM5entO5/Gylj6RbgULvPwz1rB4g2UqcaDeF6ys896eyzWDUMcmX0CuOkSKEipvmtyKd70ykVRMhlpz1e+9hp+zWZ9xqlxQNfLOnYJB9Bjh0LPLRUG0pYC0+sLyJag6ROxx0o8OHHcATtfUsIeuL83CDpfhqJuunZMsDzfAS7mXGpIUW2Pckrlfq818pgU8X99w7JUl3JBNDu+iO2Q5h8zsjmJVnMhFszPd/cA32o5yHvpM4rftU9cjz4w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24 Feb 2026, at 20:58, Kefeng Wang wrote:

> On 2026/2/25 1:29, Zi Yan wrote:
>> On 24 Feb 2026, at 12:17, Zi Yan wrote:
>
> ...
>
>>>>>
>>>>> Thinking again without my computer at hand =E2=80=A6 isn=E2=80=98t th=
e call completely optimized out without CONFIG_DEBUG_VM?
>>>>>
>>>>>
>>>>>
>>>>> At least that=E2=80=99s what I remember.
>>>>
>>>> Right. Without CONFIG_DEBUG_VM=3Dy, VM_WARN_ON(!put_page_testzero(pfn_=
to_page(pfn)))
>>>> and is_check_pages_enabled(), which leads to free_page_is_bad()=E2=80=
=99s
>>>> =E2=80=9Cpage dumped because: nonzero _refcount=E2=80=9D, are disabled=
.
>>>>
>>>> It seems to me that someone else bump the page refcount between
>>>> VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn))) and free_page_is_bad(=
).
>>>>
>>>
>>> Merging Ron=E2=80=99s reply from another thread[1]:
>>>
>>> =E2=80=9CSomething strange is going on. I enabled CONFIG_DEBUG_VM by it=
self and
>>> the issue went away. Let me try CONFIG_DEBUG_PAGE_REF.=E2=80=9D
>>>
>>> Looks like something is racy, since it is reproducible reliably.
>>>
>>> [1] https://lore.kernel.org/all/30dd1efc-9bd9-4664-999e-610d181600f9@w6=
rz.net/
>>
>> VM_WARN_ON() is BUILD_BUG_ON_INVALID() when CONFIG_DEBUG_VM is off. Only
>> the validity of the expression is checked and no code is generated.
>> So that put_page_testzero() becomes a NOP.
>
> Indeed...
>
>>
>> Hi Ron,
>>
>> Can you check if the patch below fix the issue without CONFIG_DEBUG_VM?
>>
>> diff --git a/mm/cma.c b/mm/cma.c
>> index 94b5da468a7d..96be62eb3713 100644
>> --- a/mm/cma.c
>> +++ b/mm/cma.c
>> @@ -1020,8 +1020,11 @@ bool cma_release(struct cma *cma, const struct pa=
ge *pages,
>>   		return false;
>>
>>   	pfn =3D page_to_pfn(pages);
>> -	for (i =3D 0; i < count; i++, pfn++)
>> -		VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
>> +	for (i =3D 0; i < count; i++, pfn++) {
>> +		int __maybe_unused ret =3D put_page_testzero(pfn_to_page(pfn));
>> +
>> +		VM_WARN_ON(!ret);
>> +	}
>
> Maybe we only warn once by adding back the original check?
>
> diff --git a/mm/cma.c b/mm/cma.c
> index 94b5da468a7d..a73a22d34232 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -1014,14 +1014,17 @@ bool cma_release(struct cma *cma, const struct pa=
ge *pages,
>  {
>         struct cma_memrange *cmr;
>         unsigned long i, pfn;
> +       int ret =3D 0;
>
>         cmr =3D find_cma_memrange(cma, pages, count);
>         if (!cmr)
>                 return false;
>
>         pfn =3D page_to_pfn(pages);
> -       for (i =3D 0; i < count; i++, pfn++)
> -               VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
> +       for (i =3D 0; i < count; i++, pfn++) {
> +               ret + =3D put_page_testzero(pfn_to_page(pfn));
> +
> +       WARN(ret !=3D 0, "%lu pages are still in use!\n", ret);
>
>         __cma_release_frozen(cma, cmr, pages, count);

Sounds like a better solution. Let me use this as v2 fix.

Thanks.

>
>
>
>>
>>   	__cma_release_frozen(cma, cmr, pages, count);
>>
>>
>>
>> Best Regards,
>> Yan, Zi
>>


Best Regards,
Yan, Zi

