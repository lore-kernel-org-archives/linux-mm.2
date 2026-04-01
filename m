Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14C5F10F6FDB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 22:56:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B27A6B0088; Wed,  1 Apr 2026 18:56:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3634B6B0089; Wed,  1 Apr 2026 18:56:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22AE56B008A; Wed,  1 Apr 2026 18:56:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1067D6B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 18:56:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 99912E025F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 22:56:02 +0000 (UTC)
X-FDA: 84611496564.03.22ABF4E
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011040.outbound.protection.outlook.com [52.101.52.40])
	by imf24.hostedemail.com (Postfix) with ESMTP id CAF71180009
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 22:55:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fVuUrIPe;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775084159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p4sdG36mH8CLg9pv4R58NxzgI1o02gP91jknWf4NrbU=;
	b=qJbbcpQnzRsTEvD1TDer7LZvR9yRFeuE/TLkmdfaWM8/0ugOypA1wZJGS2N+2XLebZZGte
	M9BST9XmdrzjNIZhQ4W/7kP7rhy85PEE7hsQA1BaEwRKeRiHstpACm9lcyKjdifdOf+exO
	xuWU5c7kYynZN2daEHFgNpNPef9Blj4=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fVuUrIPe;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775084159; a=rsa-sha256;
	cv=pass;
	b=k25rlyU9ijJdWIYx03eWpBRs1eEBjxKveG/fxw2cdhRI54K2oARt0D/Y7iI4kbpgL6n4T6
	yjikgQpYrazCmO/K6UzKst2H05cq6II8FQW8qDyS4J4PPdsQKp4YCyV9QLWzB3PbPZb58Y
	WthY+AsKT9U16c/viNvYO+onEcr7Nik=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Etw+jswkLgkRSEyE/W1W4mpXR5PjB0gUxE5DlY8TPvgR6binPJsGEr1tUE5oQpvsQADrdmErgVWIxVZq7BIBGkiQCQN9KtgkgkSQrk3juVfilWQrW3qKzmQgWzkCpbsBrLDvVTzTVWX4IOvnfL+9LjN+RoZHlIEYAkAc/oSECZsRIGtKyJfoXkqWhEUWKpow5KRFhhCY0yF2b3O1FzTToSWwsrXoezLXzHB1C3Q71zBE2P/2mWpb9V2VU6ACdiCvZnf+yoY2CyxU/reM/+xs1zWm4lzoVd5oSL24HOnLo5lyQSV5hjMZ3udADrjGV6JxEddB61ed9yBX+7N/8EHT6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p4sdG36mH8CLg9pv4R58NxzgI1o02gP91jknWf4NrbU=;
 b=AbIDoMU6AzHGK+1BuJr7zWwPzOYRn52RUfhKwp5lM7rB87a19zQ8H98Q4JxJpT5G8xmqDpWDpKhpapyYUCqGtbPe9XrFJpQocffkQIteg6lDVbNj3i95KbEXbMBtUPRQHpWnBWhL4nAB9+dTIqRbUFz0yBQ3LBSqUdbSb9ONVdQaEbyrK3qDxGxRgwByFozV+aHTve+isrG8hb4IRxID3pEH7bQFCVYeDcUbvEaHaPyGjgA8vhPyoN35G3TTaLiOVOY012WT51PvLmCV8Ux1qPKLGgQHNC3KCFzYoJgWCvgoP0/NWIRFmcrCX9jC4kq1NbJXs6RMyUjux+cmG/wCiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p4sdG36mH8CLg9pv4R58NxzgI1o02gP91jknWf4NrbU=;
 b=fVuUrIPeA1HxuEKT8XlFq957C01Cce54o68C9s8ypR9x/cjW0HZQfBtiGt2Zh8WWwTX6okZEBww5/YmbNuCOjP28xH6kUciZtg/KvD1greudv6Ky8iS97BtPkl0keaHm0+0Qp7Sg7KB+Wa11WPEMqFVZdUFHHZkOhhDTq53HBWo7lPl56Z5ak8Ek1WDqbXSViP6Q0/9W21zk1cq9yI+mnqXd2FxHx5QPBP+cKnIdjXrv1OBpuF/cwr1WypCUBasihjo9BfGpLYnoIzS4u5N+SZXJTh1orfYzuk4tlLEIz/oE4Q3QjXLHknNpjYiMDr19MO+XE/zN2z2C+qjuOtbkzw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.15; Wed, 1 Apr 2026 22:55:53 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Wed, 1 Apr 2026
 22:55:53 +0000
From: Zi Yan <ziy@nvidia.com>
To: akpm@linux-foundation.org, Lance Yang <lance.yang@linux.dev>
Cc: david@kernel.org, ljs@kernel.org, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 richard.weiyang@gmail.com, usama.arif@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kartikey406@gmail.com,
 syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com, stable@vger.kernel.org
Subject: Re: [PATCH mm-unstable 1/1] mm: fix deferred split queue races during
 migration
Date: Wed, 01 Apr 2026 18:55:48 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <FB71A764-0F10-4E5A-B4A0-BA4C7F138408@nvidia.com>
In-Reply-To: <C4A8301D-C76B-430B-A6A6-8B642B80FE2E@nvidia.com>
References: <20260401131032.13011-1-lance.yang@linux.dev>
 <C4A8301D-C76B-430B-A6A6-8B642B80FE2E@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR02CA0015.namprd02.prod.outlook.com
 (2603:10b6:208:fc::28) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM3PR12MB9416:EE_
X-MS-Office365-Filtering-Correlation-Id: 53a8a39d-2a6d-4ebb-f207-08de9041d3a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	mPMyM4l8IMGOCGeRDaHzMooaHp5Q69IAgZ7iYYxzqXTMgxFe6TUOq1OfEOqgW+ECNn0iX/uKvA/x0ub0NySgaZoJjolh5Tslzsm0IpwZS+/x9SYCf6BXYozOIYaHsdRKT4IlrEfX/E735pkdgm/cRsVxZ4QH/FOaINQAg3ltP1V992eOqoXkYmvguqVVXNx3CpM74FYYimHYLUx8MzHjhv4AzG2y31bLb2Tv7L24GL8ZCj2zy6zmfvmz21bw3/lEogujWoXMBpjfeVS3jMk7VTA3ADzmJ6wIgTdwlmeXsoQqlU3rSTIvQHaYn7QX7nRwOYW5BgICP2f4pulYCgHVyYxb3UJyrD/ypBr2F2qYG4Geg36A2t38smLeOxYEKZ15PpiiqKzSvKU26cHCeLUr1P5OZykMx6HknjbHU1EUdTOaLJKtwupEm9Z4i7ENmHaGcxw4ArLsqqJoMKS67uT39vN4U/KmZ4NLnsg9/aDBelV8c0wxLyELOlocha8C+hPy8oHuOV3lxjVTQuafRhM4cH6IpL+WyZPQ5/4WFIw9fVYnGn0g2Ru8guGr7snFuza5gYUj/vnceDj94vqxekLK8vaCQo44vRYRZATtpubvcjPxzu0vXD1sPSBHAOHVIAHKvDp7yblXU3A+OdaTy3GnBt2UoLq3nDUcZIy6eu9u9wtgYwS2FkxhIyKmaZP6d4wpQiYfz8MHKWj6XxWPXXGMtalrF03xoZ10SWYGfnTPmpo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TDNTeVhoQTZaL0pUSG5RTk15STdjbHVUM2FrVkZkNHZUbzc3dnVEVXg1TVYx?=
 =?utf-8?B?a09GcEZiUHgrV0dZSDYxdVVPY2JKNTJQNGdoeU1TVXVQY0FROGJvVnpmcTRH?=
 =?utf-8?B?M2RWTWdkZVRISDFwNFU1Y2pYOVJCdUV2OE04U1VrY3B3RVI4dTlNREtMcTM0?=
 =?utf-8?B?eDZyeHZYb3hvK1ZQNEdBd01zZndpNjFzT3Z0VXRWcFNuajBxVFNRaXlqMS9U?=
 =?utf-8?B?d2RtTi9CaWlFMW1IWHd6UVdKdW9OR0MwMm5JcU93NUxlbXhPVWxXekhSMXUy?=
 =?utf-8?B?Si83bldkWDhHTWhEL1ZVWXU3by9BRVFNT3Z2K1FNR3R4RTB0U25JZTd4MElZ?=
 =?utf-8?B?c3VPcE1ybFpnZk9lKzhUU0lsRG1mcUF1NUxlSWtxT0dRdUd3Y0pJQ21BZlpY?=
 =?utf-8?B?T2Q5emZwVGhKaHFnMDh5dWJMNS9nOExSZWhiR2tLbWpvbUEwK2JlNnI4bi9Z?=
 =?utf-8?B?a0N1KzJnalcrRGY3R0EyNnR3SVgrVXk2QVF5UGJ6UkdkZ2NoOFN2Ukc0UDE4?=
 =?utf-8?B?V29BWTY4elNhQ0hLbmZjVGdDZlk2L2hxZVFyZGNQQzZMQlFGK1MzM0ZaakY0?=
 =?utf-8?B?MDNQeWJ1MGRQMjB1Rk95TjJiTUNjcmNWYklsUUdIMGVDZ2N3dzVNbVNGT3ow?=
 =?utf-8?B?cjBUWFVyWSs2WElMbmljOTk5MmFVRTFnSXBraC9sVWE0M1IrMmtzdHF0UW5p?=
 =?utf-8?B?L0xBRmI2OG8raHlxd0xENFAxakwzS3RiaTY1cWJWRk5vZGpvcXJrME1JK25N?=
 =?utf-8?B?ajMxbzhSRXYwT0tSQVltdFBSOE4vblJKejFKdGV6Y1VJYUhpbHB4bWc0dWIy?=
 =?utf-8?B?YXN2Y0RBMzNLUlBnZUx5TS9xRldkdU9LUmJHalJTV0FwaksrWkFPNWxPb3NY?=
 =?utf-8?B?aFQrUjJQc1lOV2VlN3h4MnVNYTVRd0pwMnlPUEFiRko3Y1dLMTQ4MlRZNnJ0?=
 =?utf-8?B?dXA3bG5Ta1V2RExjdUg0RHhHNmxiM2s2L0hPZEVua1FXMDdGT2pZbzVWcS9N?=
 =?utf-8?B?THdHS2pvNE5jWHJBL1VndXMvemg3dDk2Qnhham95dHdYT3ZxVkRxRWRKUFdK?=
 =?utf-8?B?WTNhbm0xSmk5ZjBUSEg5aHZKZWExVVpjejhvQ1RRdkc3VFBRZmFrMGNQMmUz?=
 =?utf-8?B?cGMyT2NIZnhSNnM2MXVJcmwxSGx3azVtODBFb2YramMzd1BDVlpQQmtoNGR6?=
 =?utf-8?B?T0pKOHJmV01BeXZBeDZrSStKbWFHZlo5bnBBeXhxR1FnenhzTlF6WjllcEQ3?=
 =?utf-8?B?MXcrU1ZrcHR3MW5HZkxJNE5KeVkxcFlncjhOcWVldmV1UFR3ZUpJNHNONURS?=
 =?utf-8?B?eW1jZWMvRlBNMUk4ZzZiSGhldVJDbytFWWc4ODBVRUxTNktzTEliK2Y1OXhX?=
 =?utf-8?B?TTVHejBTR0VmU3VTL0Z0ZnZRZVhYUXlxUnJWMW1hNVloQk9sSmRaRXVTeFFw?=
 =?utf-8?B?OGJWTmx4WEFOQzVzUUpJa282SEJGVTFaNEN5Q0FzMDJSUjljbWlHNzhGajN5?=
 =?utf-8?B?azdsMW5CaW9NUkNNb05PT043b1lSZEJuRGhEdk13MUNSZmQ1NUF2Mnc5ci9t?=
 =?utf-8?B?ME1ITis2TmFjVDlId2lYWXBaejhoYnlocEZJanpISlVUU3psOGtyci9vRDRM?=
 =?utf-8?B?SUxPTy9BTGIxY2lCR3gxUFhKQmNwbXA4MitSY0R6dnd0bXloVDNGYmFZcXo0?=
 =?utf-8?B?bDNyblcyRVJBYW5DVmluWXlBZGhmL0FTMEdqL3NWRy9yZVU3ZU9IUXlENWps?=
 =?utf-8?B?TS9jaTNxWWE3cjNTaXo2Skp6YnU1RTB6L2lZYXA4TDBJeFVKUU9BYnVMcGtG?=
 =?utf-8?B?NDZaN2MxYTdHb3dMUUtvZTlpS2Z6NDZlWENWYUE4SDVlN2d2N2M1K1VGamtL?=
 =?utf-8?B?T0RPdm9reWFnOTFMSWdmNUZIMkUxR25zS1p3dGpYSkN5ams5L3VDY2VOdlEz?=
 =?utf-8?B?MnZndXhqZ1hhSlJiRTlEd0wxRld3b2JPdVFmUTFsYU1ZdjBsTVNhSDVaMzdE?=
 =?utf-8?B?NUtSV1pwSDU5YnBTWnhXSWJKMVBIenFxMHp6ZGhkTWNrY09YTjJJUktPZUx4?=
 =?utf-8?B?WnZIcTRhTThkS2xXS3ltRmpRTWNuVTNuZGtmVFhxMERaQzhYVitCdURzVW85?=
 =?utf-8?B?UG1aQ2FqaloyTExYaVZNV3JmZC9xM3dNVzMrRDByUVFvWUZhVzBBdTZWMWNV?=
 =?utf-8?B?eXVaaGpGd1JVdkVXSTBmbDlIWlV6Qm9VRUF6RkE4RFNpd0FPZFBndGJSd3ZQ?=
 =?utf-8?B?N3dzYk05ZUNaUVdrK2UwcE82aDV4SVo5SnU1S3VzNXVqdGNzYXVnNnlXc1hL?=
 =?utf-8?Q?hWYqmWdJX6WUBSOiGK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53a8a39d-2a6d-4ebb-f207-08de9041d3a0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 22:55:53.2268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CMvQ7xJfecuM2pauqSH519m3acwQFCW+EYzuDCK1cNldMCmRCeEyvJOoVytfDbB8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9416
X-Rspamd-Queue-Id: CAF71180009
X-Stat-Signature: nk8rdj7tytekxnkhsagc1sq4jpkf4pkq
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775084159-845969
X-HE-Meta: U2FsdGVkX1/eANjAHXbX4klZqAYYdzK2gV0jGC3VsStdDOpggEKwyFbpV9pylstqVQYEV7+/JMZCtJiWDW5SD+BKn9YJGkuh6IaCDxLa2tAaM8EiMell4T/t3MIZLum+aK0smS1nvIY4OY44g0dgPf5Fw6+9nNz5bSa/LntuMEMHzPpGcVtJgf5lu3ql4JsCZI54k5EBo6H4yRrrsegjId64tyqqDCc2zbiRJN7svvQnOGoyaAb4blfn7nHbwTONVcuX4tG72Xf0g5yfpSR6aLMlA1XzDNX1DugSKUH2LAj9aAFt/Kzmz7hhLfj1u39sMWyw6sxKG0H2IiH0bxNO8V5tfWuGq7zCEGHbFq42k/gdYMX7J+45gqLaFVOGzB/ZeWiKNex+x0ZuQ2IKfvDM8X9slxHjw7O9TUwAkgvv6gUJKSQ5AGxPATldsdCe95wbp7jZaS/SEw7lvljR0ZJcX/7nzNgOpt9DkeJwYFUCk3pAFv6JUKU2FbKdnOPRcM32SUuSbYTxR0U9RRxe7+07SIGwosUCxJd3IepBjnQKxt8OdRYnDmtJ/lXVFtNQitB4RfgAngKaFqfdXtPdZOXtklKDPbOb5w/V8ICimX/1KpYM7ea+kFwE2JOqlrn6GuNE+/KFQFEF8R34smeciGiD5hEB1LHw8ncJq7yErDxUzOfz+yOnWltG9yNADh2aDbmiUg9Ec4QYhRVwXYfGO8uIUSnloxOsQDSUKd0L9KRk2TbGBtHTBoDHGRt983NzV0u0OMSvDY58MWOdF3QM1z/rDEwDlijhG5m+PSf9SSgjVq8jJr1xK1Y8pgQTzIeVHVjWdpdKEGPwMsmOgqQryzl1hr6ewIMm/mSTALTp1eNRvFmubpyJ4/L8JhqKKntgt3wD6Gx6NPOh+fRPHw4sJFvqOemhe9AWiJMLPHLI5S+RVDBM5s5GXYxZRgdJdaJVJ+KvfWReCFmDMV4Ro20iGi/
 sSwh/E5+
 C3pvCCowGPkHhtWRq83tQiTmevZt7M7RaX40URclXOBOaDyc+C8frc5mVECgADc+JpbP0UDIX228Sv/y3tXj/EDVOsYum+nVFMeAXmv5Q8Kl0OVx7K+0cz6fci4oK5anL3X2o82M1lgariv9trFb9X1Vbc4u8JznlRDi7I6dQ5rCvRRFGFrvPhMku2QQ87zFGQmNjrjxIJP89kbsIM4y+9IJ8pO6XqCugIBDel7aeE7XNRPLuU8i9LTHizAtPpDhHYGkimLW5hzL5A4hssENqyRXM4Y7Z6lLxgv5xImHdaaBQ9ROn40MFbngau6hMXFajFOUc16zhgBDFJDKSKFQCnUEvbMk/PfbkhqBeHEbo8KUGsX82mUonW+e6fyLyGWHoMgZxp9S4K40RvMg1vwWCmMz8izRWbomjWfdtLePOKY3j94QW+gIjiOJw+QBcvn1K1qXCg6p3Li4WbKFXMbWfvkxzKElxUq/aU42OIQ6e93ZiVGKClq7eki9toKcd+ihNwH3Tw/4HD/q6HHa1+yt5KKhG1Das9KysBX8YUYZ57hZFUf782v3CU6NLIsrgu2pJZJvXRrIv1LVX/j1Q94mYfK3NeMe0CzU1oASXGgwKhLVXAJpNpOq9pgGm7S1HxlfWhgUjzdR6BfCqI03gLV8LeS33nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1 Apr 2026, at 15:21, Zi Yan wrote:

> On 1 Apr 2026, at 9:10, Lance Yang wrote:
>
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> migrate_folio_move() records the deferred split queue state from src and
>> replays it on dst. Replaying it after remove_migration_ptes(src, dst, 0)
>> makes dst visible before it is requeued, so a concurrent rmap-removal pa=
th
>> can mark dst partially mapped and trip the WARN in deferred_split_folio(=
).
>>
>> Move the requeue before remove_migration_ptes() so dst is back on the
>> deferred split queue before it becomes visible again.
>>
>> Because migration still holds dst locked at that point, teach
>> deferred_split_scan() to requeue a folio when folio_trylock() fails.
>> Otherwise a fully mapped underused folio can be dequeued by the shrinker
>> and silently lost from split_queue.
>>
>> Link: https://syzkaller.appspot.com/bug?extid=3Da7067a757858ac8eb085
>> Fixes: 8a8ca142a488 ("mm: migrate: requeue destination folio on deferred=
 split queue")
>> Reported-by: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com
>> Closes: https://lore.kernel.org/linux-mm/69ccb65b.050a0220.183828.003a.G=
AE@google.com/
>> Cc: <stable@vger.kernel.org>
>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>
>> [ Backport note ]
>> This patch is a follow-up fix for 8a8ca142a488 ("mm: migrate: requeue
>> destination folio on deferred split queue"), which is currently only in
>> mm-stable, and should be backported together with it.
>>
>> Credit for this fix goes to David, thanks!
>>
>>  mm/huge_memory.c | 12 +++++++-----
>>  mm/migrate.c     | 18 +++++++++---------
>>  2 files changed, 16 insertions(+), 14 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index ff9a42abd1b6..ac6d823e351f 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4558,7 +4558,7 @@ static unsigned long deferred_split_scan(struct sh=
rinker *shrink,
>>  				goto next;
>>  		}
>>  		if (!folio_trylock(folio))
>> -			goto next;
>> +			goto requeue;
>>  		if (!split_folio(folio)) {
>>  			did_split =3D true;
>>  			if (underused)
>> @@ -4569,11 +4569,13 @@ static unsigned long deferred_split_scan(struct =
shrinker *shrink,
>>  next:
>>  		if (did_split || !folio_test_partially_mapped(folio))
>>  			continue;
>> +requeue:
>>  		/*
>> -		 * Only add back to the queue if folio is partially mapped.
>> -		 * If thp_underused returns false, or if split_folio fails
>> -		 * in the case it was underused, then consider it used and
>> -		 * don't add it back to split_queue.
>> +		 * Add back partially mapped folios, or underused folios
>> +		 * that we could not lock this round.  If thp_underused()
>> +		 * returns false, or if split_folio() succeeds, or if
>> +		 * split_folio() fails in the case it was underused, then
>> +		 * consider it used and don't add it back to split_queue.
>>  		 */
>
> Should the sentence
> =E2=80=9CIf thp_underused() returns false, or if split_folio() succeeds, =
or if
> split_folio() fails in the case it was underused, then
> consider it used and don't add it back to split_queue.=E2=80=9D
> be moved to below label next?
>
> Since =E2=80=9Cthp_underused() returns false=E2=80=9D is describing =E2=
=80=9Cif (!underused) goto next=E2=80=9D,
> =E2=80=9Csplit_folio() succeeds=E2=80=9D is describing =E2=80=9Cdid_split=
 =3D=3D true in the if=E2=80=9D,
> =E2=80=9Csplit_folio() fails in the case it was underused=E2=80=9D is des=
cribing
> =E2=80=9Cdid_split =3D=3D false and !folio_test_partially_mapped(folio) i=
n the if=E2=80=9D.
>
> The first sentence matches the goto requeue for folio_trylock().

Hi Andrew,

Can you apply the fixup below to move the comment? Lance told me he
would be away for a while, so he could not send a fixup to move
the comment.

Thanks.


From 6ebeca9f7215cb91905d3f49385dbbafce5a80c2 Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Wed, 1 Apr 2026 18:52:43 -0400
Subject: [PATCH] move the comment.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ac6d823e351ff..970e077019b75 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4567,15 +4567,18 @@ static unsigned long deferred_split_scan(struct shr=
inker *shrink,
 		}
 		folio_unlock(folio);
 next:
+		/*
+		 * If thp_underused() returns false, or if split_folio()
+		 * succeeds, or if split_folio() fails in the case it was
+		 * underused, then consider it used and don't add it back to
+		 * split_queue.
+		 */
 		if (did_split || !folio_test_partially_mapped(folio))
 			continue;
 requeue:
 		/*
-		 * Add back partially mapped folios, or underused folios
-		 * that we could not lock this round.  If thp_underused()
-		 * returns false, or if split_folio() succeeds, or if
-		 * split_folio() fails in the case it was underused, then
-		 * consider it used and don't add it back to split_queue.
+		 * Add back partially mapped folios, or underused folios that
+		 * we could not lock this round.
 		 */
 		fqueue =3D folio_split_queue_lock_irqsave(folio, &flags);
 		if (list_empty(&folio->_deferred_list)) {
--=20
2.53.0



>
> Otherwise, LGTM.
>
> Acked-by: Zi Yan <ziy@nvidia.com>
>
>>  		fqueue =3D folio_split_queue_lock_irqsave(folio, &flags);
>>  		if (list_empty(&folio->_deferred_list)) {
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index 05cb408846f2..8a64291ab5b4 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -1385,6 +1385,15 @@ static int migrate_folio_move(free_folio_t put_ne=
w_folio, unsigned long private,
>>  	if (rc)
>>  		goto out;
>>
>> +	/*
>> +	 * Requeue the destination folio on the deferred split queue if
>> +	 * the source was on the queue.  The source is unqueued in
>> +	 * __folio_migrate_mapping(), so we recorded the state from
>> +	 * before move_to_new_folio().
>> +	 */
>> +	if (src_deferred_split)
>> +		deferred_split_folio(dst, src_partially_mapped);
>> +
>>  	/*
>>  	 * When successful, push dst to LRU immediately: so that if it
>>  	 * turns out to be an mlocked page, remove_migration_ptes() will
>> @@ -1401,15 +1410,6 @@ static int migrate_folio_move(free_folio_t put_ne=
w_folio, unsigned long private,
>>  	if (old_page_state & PAGE_WAS_MAPPED)
>>  		remove_migration_ptes(src, dst, 0);
>>
>> -	/*
>> -	 * Requeue the destination folio on the deferred split queue if
>> -	 * the source was on the queue.  The source is unqueued in
>> -	 * __folio_migrate_mapping(), so we recorded the state from
>> -	 * before move_to_new_folio().
>> -	 */
>> -	if (src_deferred_split)
>> -		deferred_split_folio(dst, src_partially_mapped);
>> -
>>  out_unlock_both:
>>  	folio_unlock(dst);
>>  	folio_set_owner_migrate_reason(dst, reason);
>> --=20
>> 2.49.0
>
>
> Best Regards,
> Yan, Zi


Best Regards,
Yan, Zi

