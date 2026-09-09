Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A28D5C79FB5
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 02:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7937A6B0093; Tue,  8 Sep 2026 22:20:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76A936B0095; Tue,  8 Sep 2026 22:20:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6812D6B0096; Tue,  8 Sep 2026 22:20:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EEC8F6B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 22:20:11 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8A6EA1C2A74
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 02:20:11 +0000 (UTC)
X-FDA: 85192619022.18.CA62ECB
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012059.outbound.protection.outlook.com [40.107.209.59])
	by imf07.hostedemail.com (Postfix) with ESMTP id A295C40004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 02:20:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pbyP7cda;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788920408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T69VvYUxtr137+yRGOnm1ETUTnORkJfnvX0lh6b9Rec=;
	b=7dIEQzKv4MWjVTOgLNYHh0CdFUamZ70wpnlkcsmKcTAkaCCi16kD3q/SpRAGg+IiUDGEOU
	BIrB1d3gf8jmpgxRE/u30rwxS2EH/wX0rLt4SvXLF3rxYj2IcjPyh7mSB7WC15KlzzrrbO
	ImhTFt7Pp4awC8dgbFa+HL2gtuM0Ay4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788920408;
	b=ZWtXS430jZ33d17m6QT0gd84lEUwRnnxUpbu3RAWTmQp5EDxti7DVzGGqZjCSLjH6/6CJH
	y9KnvcQRK1QektMh66MGA1yAenDpTepjDHyotieBKDE34czBr4gLu67SK6vD4e0Fkhfo2P
	2cVjrdpkNBLex4/GmM7ocVdPCQocp98=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pbyP7cda;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AXcHtgZ1b/7hlcDoMISKvMoLflBGsvuHpY4QjsvuhkLRz65wNZpkE9F4BzocFvL9iuDsGFGCLW+WvNNonxHzgu2Nl2mTdofojyL7JniH/R2//3iLxydJC0x5WrP6keZq2qOF2b/zgDXVRASRHOAuo7iPN0FGvkAtGHTcW4zBgCsiUUawLjmmAon97OcKKmBHuRoeHIiPI+ydJ5/QiZz948N+mqOc7y+Obpx1GI8fomsXA4cX4qOJVnNrfwnWtxLZB6QxFqAxJvOVMsj+oOmLANNylgvmdgLxxYuFfsOQBC38mtc0DZgj9UKCUWQhtwZ+Os9HjG+IyWeOPZGFd88jaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T69VvYUxtr137+yRGOnm1ETUTnORkJfnvX0lh6b9Rec=;
 b=C4LzRVBTtIM9ySKJ6URM6G1e0ARczCgtPMC+bg06VJ1WXyteHxg7p6F3PjPIFYFHQ62CNzqmi5LjuP2KlqlxD8rP4Am72c+G0tmfEQasP2SJefSXCJKVoFXP870FVxdl2BvJpIQXXUIV5Gn6PTWNYBACwzafDidhpLiLp24RUixy4es40z3o8acYME8B4wYWMM6irJ1sxW9d9sgCtrsAMsgARxhGTCctqCw5c+RLocOPUfkFEeWvyh/DB1NhVNoAUBFO9UkZeZXJlNn3ASJA5XYeTJ4xfPe1p4b1f7xK9Y75IsZZiXlTWHu8vZ8fynMX59s4QsUkw2e442iRkBWjLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T69VvYUxtr137+yRGOnm1ETUTnORkJfnvX0lh6b9Rec=;
 b=pbyP7cdarNC2S68k8OkjYHfydnfO6LU52yVZWY6s8mk55uZ0pyXcubBJbiVMzTTXT8AKoboy/lNolCu7Bbdt3RdssTys/lJtJ+ekCDKIjiB3D5naIvBIhZLL1zED5z/UnrNv62OtcuYd8EMnsm3aDBHdp2kdJQ+Oez27Aow9dGWOjayKPUwW3zWjzGVpWr+cWbbDpbI+MKnZkKKl2+rccC5kTictpb1kn9SphdnyvASZ8ziDebgbVghpno3diXYAaE/2a1q6Pq0JCbgvwdYoBXtexoBL6iM3JYrVVPxXdTb1azFX8hgSzCyBi2d85Xs1S7wv9z/GPKcDc++q9H3q+Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH1PPF4CBE7339A.namprd12.prod.outlook.com (2603:10b6:61f:fc00::60e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Wed, 9 Sep 2026
 02:20:02 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.005; Wed, 9 Sep 2026
 02:20:02 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 08 Sep 2026 22:20:01 -0400
Message-Id: <DLAFCUWXD6VN.30HHX0AGG0ZRN@nvidia.com>
Subject: Re: [PATCH v4] mm: page_alloc: add missing hooks to bulk allocation
 path
Cc: <surenb@google.com>, <mhocko@suse.com>, <brendan.jackman@linux.dev>,
 <hannes@cmpxchg.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <gourry@gourry.net>
To: "Qiqi Liu" <liuqiqi@kylinos.cn>, <akpm@linux-foundation.org>,
 <vbabka@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260907120949.418450-1-liuqiqi@kylinos.cn>
 <20260908102356.344075-1-liuqiqi@kylinos.cn>
In-Reply-To: <20260908102356.344075-1-liuqiqi@kylinos.cn>
X-ClientProxiedBy: YQBPR0101CA0209.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:67::9) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH1PPF4CBE7339A:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f4b523c-a22b-4f61-1ef6-08df0e18dae0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|7416014|1800799024|22082099003|18002099003|56012099006|4143699003|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	gwWu7qTYzwZm9blfYzqy5nNoJ2jxSDU7f/VUeQLYXWAXJ2IfohWHAWqcyA2x9Wj0RHHvoQQJbuvVAFl1J1QlX8aVZLTd48gJVctelx82zxLqoR6FBGWNUljLl56kr2i11io9jEtWXcuKVVQYVX9fxIHsIe4Z4KTWW5716FbTf2fzZfsSHLgJBGrMIwm4Y+bqbUgPCqs/Tc+A5gonGP/CK+dNvj5LBar7YbU/kMWa1Ui52R/1oSLSHgeuYhjokGczhdkVNYz5Vm/Xuhfb6XzxCeSuVXgiVKXqMD1SPVELsdN2wJf+wjkLHfatQ2YRzDIYsoJXJDJorMD22NMjMu7mhLasQsSCU6+FSVPllWsuhpSl+b2Qe3P01+BXckVgugExgymgz46pPHhEiIEjxM/oeyL3OyPasn+4S3B2Sy8AaNVeeYMcTCoewQPKyaC/eKDD0OnwqwUaTlv8tadbDxjCqno+mIxTZ8OaqAYe2oWJHUjv/MmQU+jv3g+WuhRbehKtoPWvvHJfWEpov6uVrhAQGvSCnFmrSeQHjyTzW2wPvRsTedNVxCcaVQq/VN3RJPWMfqEGilXCLA4i8loRx3vi+W/Rr8GLUuSCv0SWxGl39ODZmJPlV7pxn6Tqfzpgal2FrcpdOBc8K/G+RrmTdtnFAsITJGVgbKSAH7LSIRFSXk8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(7416014)(1800799024)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Sk55RlIrSzc2ZlkxbWtEUDgyL3kwNC85R1VWbnIvK29UUElYS2NyenJzTktF?=
 =?utf-8?B?WU9zcGxyYjNFTU8rR3lqVXR2R283ai94YjFudjBrZks5akxIVGNqS1Jxb2ZQ?=
 =?utf-8?B?VDhuT0szd2RGa2NwSjF2dTIxc0UrNEFBVHhKTXRpVUN4bEExOS9aOTlXRjk3?=
 =?utf-8?B?VTQ5ZE81WWgzS0VPZzhaNlk0SEpXK3N1NTFCN3M1Qjh0NVVPVDJFV1VYbW5a?=
 =?utf-8?B?czhQQWZUalNqeFhLVWdWK2R6RnNsWWNPM241cEIxQVh2TnY2ZXBzUld2SEVF?=
 =?utf-8?B?VDJjY2ViTWo1TXZPdncvK3dVN3AvU3B3VThSTWtEQUVrU3BJK0pDVy9GczVF?=
 =?utf-8?B?VTlXUXJ3TXdxWEphU2t1K3I2SzhxbVpmNHRmUnBiQk1TS1N2T1JZMVpUR1A2?=
 =?utf-8?B?d2VoSW92akVKcGd1RVptazBOS3JhckJjdWd4OUdoSC9jNlAzWWNnTjhGSEdz?=
 =?utf-8?B?OXE1K1BSbytpOVhTQWh3RTVOM09uWm5OZjN5TlBoUWt6d0JaUVdkK1lTTlBx?=
 =?utf-8?B?Um5xY05QenVjWVYrdVEwaUNrZnUyN0lIVTY1dFg5NUpMeXA3OWxMUG1ES1Uy?=
 =?utf-8?B?Z0JkdndoTTlIMHJzQmMxakhiU083NXJ6dGhnV1dnQ2NRUStzaUdZd21zcHFF?=
 =?utf-8?B?M2dIM1VJSFBQZ0pCRTFTZGt4amxxVUt4OS9YV0xuRHBmZWsyN2ZRWnBLZGhV?=
 =?utf-8?B?QVozZVU1TENMMVZKRDBkUithcGU3YWgrVWc2T3JFdGRYbWlNcFY4U0MzenJk?=
 =?utf-8?B?TnZWTnNDTk1kK2M0ZWRJZTZPVG9yeVgrdEM0SXVXNi9kWjY4RnNZb0RNanlC?=
 =?utf-8?B?VFY1ekwrZXpqUkxnODB2K09aTlIrVUVmeXVxRit3Wm96VW9nME00WEY1d1JB?=
 =?utf-8?B?YW1aWHR1U2ozNGpXOFl3RTVWN2ZrZGlQa2RoM2FZc2hXL0Q1TnJ2WHhURVJ5?=
 =?utf-8?B?K0RzK0xmcUFwbmdoZUwrL3RuczZkTHQwd0Y4WDgrTVo5T1krdmZ3TDlrTm1C?=
 =?utf-8?B?UFgwQ0JxanpoaFpGSVo4UjRzWFI5RDM5bEhOMXUrRDdOeGVxeEhqRUJmVjUy?=
 =?utf-8?B?N3A0eDJxMGVZWVAveHZzSU9BeHNnaWhKTFRRaG5tZlJ4aFRKcy82cStTalJ4?=
 =?utf-8?B?SllSTVlmMm1PYnpwQTZRUWRZY0Z0MHN4SUN4T0pEVEw1d0drK2FadlcvS2J0?=
 =?utf-8?B?U0hEb29GVzJWTTdOZktjeUc5dER2N1JSNnZjVVFJWWtCa01mdkgwY0FjZHRC?=
 =?utf-8?B?OEhQL3hPMjBYZlRDQ3VWeVEwRVZMdWJuNUVuN0JqZDdyT285UGdieHFmc1RC?=
 =?utf-8?B?SkZHQ2xTN3JBL2xKUXhHY3VqMXJEUUZ1VEVnWXVrdkJyS2lwY3FMT1I3dWtt?=
 =?utf-8?B?VnJSMldQT1c1R1M4cmdIZlFkT1pwTGZhOVRiczhZM3Y2R1RCbWNDSklXYUhL?=
 =?utf-8?B?T1pVWFpUTWZHNlpsdlR4S1AwNnZrTUZFeFl5SnE0V1lwQnloRmZUSWJHNk9K?=
 =?utf-8?B?ZGhLK0p6bGFmTE1oN2VqeGlCb1o4YlViazNDMUtwWE9mZW9iZWZQVzdpdVZS?=
 =?utf-8?B?OVpzVzNqS1dhYkN5VFhiNk9Jdmczcnk5ZVRnak44S3FYMHBkcFFBVjhwSCtn?=
 =?utf-8?B?RFc4cHVRd2JUM2VQMGQ3TVZSQzllTkhrRnNEdjlJTXppb1lqeHFnSDlxcDFH?=
 =?utf-8?B?UXlZdVJKR1BKWFduZnFYazJjdFZzTkZRc2JBaUtnWGpCd24xVDU3YVpjWERD?=
 =?utf-8?B?TklDWDIxVTlNMGNsL1NUUWV6dEc5TUQ3ckczQjJsOFhOaklWcE5Da1lRQXlG?=
 =?utf-8?B?VERNNXBIL2dlcXBxeGd2eVNnZzhiYUFFMkk4RWxKZVZrd0ZQYVh5YU1pZ0F3?=
 =?utf-8?B?VUNLUUQ0MzkxRW5PUlZETXpqN3E4bG9VaFJzYzlZSWQrUzFxSlB0SlhZQTE4?=
 =?utf-8?B?YTMyMnI5SWhieUpMMGkyS2w2Z2d2ci8zLzBzdTZxUzFrSXNvS2ZTQzN0eUdS?=
 =?utf-8?B?V0tsaXZyVGhDdnRpQU4vQ20wZHJuVi9OK2pjSVpBczlLK0RmbW9oZkxCWTJs?=
 =?utf-8?B?dEVwNlBPRStjTXU4czEvVFVoU084cThTZlZBK0NFVExaQkxLdHM5Nm5TeGY4?=
 =?utf-8?B?TEROUGRFL2VzMXJtTTYrNGNLd1hJTVNPTXZoVmxIeHF4WGR5Sk1PSFVQVnAz?=
 =?utf-8?B?ZTdlU2R2dysvaDNlNlpHeUt0b0swMmlWNXJ4ellIakNIaDV0VEIyRzFaRXo0?=
 =?utf-8?B?OWxhbUFzOUZxRENuQ052YlFodldJekpZcG0zSjFCL1JNTzlWSlRJOVBKU0tl?=
 =?utf-8?Q?HKbaLwT0gNHacPa4jG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f4b523c-a22b-4f61-1ef6-08df0e18dae0
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 02:20:02.5433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yJznUxq2gvjObM0DAO9UDX3F4f/V7gU6QzOYp7ZcGgZ62Qqzm+c1wzLVREmTmkEd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF4CBE7339A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A295C40004
X-Stat-Signature: ykar7gw445z5f4816xpa9kgcwzg7ni5c
X-Rspam-User: 
X-HE-Tag: 1788920408-436773
X-HE-Meta: U2FsdGVkX1/TKjerc1N0O5qAuv7uWnLdeVg6x4FzeMJPae/uHnNrZdlYw/w/Y+SVYqucS1Skbvrg6zzumRFq/ybNyHC4R7m3ivQK07BBALWQf3MM/+4sp/J5JYX6hwLVEY6g3qH2CzJn4/1RQwknhFS4DMWHHF95kL4xQV00laiXhDDqNx+7zy40mDwoX9OdhuOGgU3HfIs1cJu7jeMe/IEAU5DgQMpbBlqInj20iVeAJZP4rc7a6rI4BVmov3kxVe1BWekUHLyIB/3wlcrrwYYlSZwpcKZUaJRTOjivUnTmBYLDByJ7YnK78cXIz9lchn7bxtpnt7TfMINQsKh2gmLb/dJT+WV47/4OSOKxFNKzipW8COdK2t/k+QZWpcxCGcdU1lw0dZWZsMppPA1BeP4H0R4zPTZagflGF6TbqUXWTRu/39TTldHDE/OBOI0R0VH9vGfAe4IJu3KZSwKzBzKpHyelEIK94mnaxN72WqSgvPQRSKJrJ9xzFeSw6U98d6YaqFEC6JXgD1zHFx0UpajI47iME3TtwvqGwwM/O3N5ZUyvqrN8suwj0kHBrvpUCDWABAQHCOxaHLohm5sG8lrRYRYlpDuNVIiGt5I9PvEo7wLNg2iYVYl9SROEGXaHvKDoQIB/L2SHnjAe3Z7ayNSmTevgpXrtx75axPtq6oBLpNYIme+0vVXApDlrRQ7Kxa9GdxvYCqsvatOdIbSVG63mZprmRmgg2a8+7afBry0SbNhaX76cufPc6zSI2B3G2G/KMxcNflzCqBy4XUxmPsP1XKlgBbK5qgXW0IqtFt5ZDccvVisqgNEAIq7oRohlS9lG8Sa4R7awYF7VDnarpmfeoOMlEF4AhIWwUutBtmC0QnpaIhlHI35srlb4B+fD/uyT4O0ejnxG1zlG+waOWa6rwz96rDVtBTMY1ObRGfPOS3/SH83SCX4egrHmP6KD5wITqw9t6v76nfFFA2d
 eITfXOtP
 UFQkAErGJqCdI54fgdDPsNEKXWgmZ8yzZyAwu4w+HowQBHn2bEtBouff/9iX5k1YiENTo40paCuK8XkQDA1QLZWMRgIwopjhbsli5D9HUBPpJkxtLSU6yEI+KXsY5HuDQvTqx37BSiQBSx3eBjVmYb98lRg9PbtPgbdGpyb0BvJnvOLO5lJU8sZcUe7VtJ0xuSni6iteTzJIPD30A4qQOV4iVSl1UaILeGlayP8nA6pQamhyDpV8TfKXtt6PqaM9wmvCFy8SMkD0HUsf7bsoTxRwBAKtkCmYhD/fYx57E4GGuFtgPGw40nmb8aAiNJxrZw+WI5cu4LAyqJ84bDBW1y2mdCoxuS//28pqwEngQfNjlCt+llTOEGsRL1odeMXk4vbGaP3qA/2Fddcled1rXBwHTsaoSpY03mDacqdW97LII4NHGVP7e/jvwqzVUV/6eexBhOP6Bn07Cy1cR5KI7ecHgA0yfw+qz3UQNDUSG0NHoLIyC+at+4b6jfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Sep 8, 2026 at 6:23 AM EDT, Qiqi Liu wrote:
> The bulk allocation path in alloc_pages_bulk_noprof() currently misses
> trace_mm_page_alloc() and kmsan_alloc_page() calls, leaving bulk-allocate=
d
> pages invisible to ftrace/BPF/perf and leaving KMSAN shadow memory stale.
>
> Add both calls in the bulk loop to match the standard allocation path,
> placing them before set_page_refcounted() for consistency. The gfp mask
> passed to kmsan_alloc_page() is stripped of __GFP_RECLAIM because the
> bulk loop runs under the PCP spinlock, and KMSAN's stack depot allocation
> must not sleep.
>
> Both are no-ops when their respective features are disabled, so there
> is no overhead in production kernels.
>
> Suggested-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
> ---
>  mm/page_alloc.c | 2 ++
>  1 file changed, 2 insertions(+)
>

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

BTW, please send new versions in a new thread instead of replying to the
old one. Thanks.

--=20
Best Regards,
Yan, Zi


