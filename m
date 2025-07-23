Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E41C9C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 04:05:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6207B6B009C; Wed, 23 Jul 2025 00:05:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E0E96B009E; Wed, 23 Jul 2025 00:05:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A8AC6B009F; Wed, 23 Jul 2025 00:05:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 396CC6B009C
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 00:05:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E33EF1DB065
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:05:24 +0000 (UTC)
X-FDA: 83694189768.20.50C000B
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010046.outbound.protection.outlook.com [52.101.69.46])
	by imf20.hostedemail.com (Postfix) with ESMTP id 399D81C0005
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:05:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=C+02vtYf;
	dkim=pass header.d=arm.com header.s=selector1 header.b=C+02vtYf;
	spf=pass (imf20.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.69.46 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753243521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WLHoaanH3bWkGscM5T0eSdDy0GFKMpMAKdLZ4yBr1gk=;
	b=oZ+Y926dL3ifuFLAYetNDM6rfhiXq/Bi/rat5glbFNNwp34LizfN3r8Y+9iZyR1NQkd5Ud
	tbctSTQWqkBzuFMdYaKK6Fx0B+1j0YyCY+LBTrM4RbJ2XP/8n+F7wSiEFmHumxu2v1nbzo
	1kQKyiFPjrrIyVafEyWfzvhJoX+k2ts=
ARC-Authentication-Results: i=3;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=C+02vtYf;
	dkim=pass header.d=arm.com header.s=selector1 header.b=C+02vtYf;
	spf=pass (imf20.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.69.46 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1753243521; a=rsa-sha256;
	cv=pass;
	b=HQsLuJfKY0g2yUBRcZifqY+fo/wdo3oiK1/AMX1e09r5Nhwl8ud4c8mdcPptSlzBo468R8
	F0B5t3jrWgUAdMrEOUEeCC5+74aiKxii23CpxRcSV0KWL/n6y08KDzH7eXIraEhDOLB268
	eYvQyk9on8VbYll4PrADD4Gz4Z/1qG8=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=dJlNQ+6C3byRv9shC61wtbkgi6MfA+Xt8ZUeVOCuWpaPscokN+gn+pzc5EP8WYr7Vu6nSG/dfIDrGgKTh9ASiY69ReJ3Lq8VO4u6LtBXdbA7P86yJxaAdrMwuNjMLzoCeBiIcvgxowQJ4Vod1ta3x71qFnl0NY+BwGarsV+bMy/FSKrAOo487BMhM7bKSP2vsOuC8j3DyyaQoW5Lt3OvwgGOhKSbCDtiaDUmeKdRpeKqWrbSWQ1Mf7VcjIofwxPVzTKmEGHfn8wX+ruL+77RhvFVmWN1qWzoX3CufiGQKwR7jjP9Av7TFjYux5h4BzqJtdiM2bOsrwUFOKdVZqD6YQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WLHoaanH3bWkGscM5T0eSdDy0GFKMpMAKdLZ4yBr1gk=;
 b=dE5krbd/6XR2vDD/a8noxG3SFagrVLunaaW88cVNqoLxsRkJVbaRdFgpHHFTDposg2IQpakZA7224Gs+phluQMHpjkOYHRiO7Q0ZluOM9n2nYklLJQ1mq1MsC1Ha74BjquWqEzQBL3TODCMyZ3xIKrrnUZGafu5mXwKFsOBcyJ5lfJ3X3TpLEL8SHFsyTYGmibIhD6OfAhSWBWKdtGJq/NXElphKWqSikIKrU+PnivMW8xOQCTfyLgBWuXj8/UTNufxIyMMX9LffSxfEFcnvgJEbxDfS/r2SsXSbIKFjkQLbwIUDEarZF+RuIPGMF7M1o4pAXvlyn+TIv+775HxdYw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=redhat.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WLHoaanH3bWkGscM5T0eSdDy0GFKMpMAKdLZ4yBr1gk=;
 b=C+02vtYfW2j64FnP9sIuzgVcXhLZTHnihMZyh74rIkLluRNMHScmK0qHHb4Kfw/5xDaFmmSUu+jSzezxthLm7BtDn5NqeNL2QcWiB72ZQBUO62tlbXi/VhgoqZShfrL6aR6XEgYESWdw1OlVjgumyX2fx14m+Q/pUAnxdj5oJ4I=
Received: from DUZPR01CA0128.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bc::21) by DB9PR08MB6668.eurprd08.prod.outlook.com
 (2603:10a6:10:2a9::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Wed, 23 Jul
 2025 04:05:16 +0000
Received: from DB5PEPF00014B8A.eurprd02.prod.outlook.com
 (2603:10a6:10:4bc:cafe::27) by DUZPR01CA0128.outlook.office365.com
 (2603:10a6:10:4bc::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.21 via Frontend Transport; Wed,
 23 Jul 2025 04:05:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B8A.mail.protection.outlook.com (10.167.8.198) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.20
 via Frontend Transport; Wed, 23 Jul 2025 04:05:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S9oDciZJIAOyvShnb0cgw0V9kkHxd/WrCxGRBDg5swBKarwuHD4xY/mjYCugMvBlKl5cn2Vi+Q5yr80EEd341lTxsnX3SuRt++XICUCfmUDettoaDKYplWdDm0CUYoKaqgwUV1wkdArvhOFMELE/QnyuzGdOqqwYXhydsKHQGisjfQe30Vi/LWPuscafgE/eV7rXClIE3J2AwESBn7aDF11+GXj2RThe74W91pRvQPDRB4tggaR4wXFVL5w8kSZWEvhmxnpyiM1fY6QcWrqlK1/WfB7Q6RAI/F76vCAdbNlxzSGxK3Y/WrL+YW6bP453AcIKOVBw4hNbqBefXxTLJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WLHoaanH3bWkGscM5T0eSdDy0GFKMpMAKdLZ4yBr1gk=;
 b=hzDz4+DAtoe2biXMqRW2IMSlKqbXOR/ock8us9dbchCts5sEERV9oNDGD7udAZArZzK6grzdOdA9p45DUqL6x4exmPTpU/OXne6Q/sjLvaYjVPyjwqk5FccxXdb6WMyuknXh4MRnWFPLINwOGn3JzWDTZa6Jmh/jJlnMzQKXNIve1uE3DWoyhNtwEpa0qSzizMOby5v8EdFzn8Jpo0oF0NAqZJiIY6E+np6KLZ9OHhabuRK7LtKim32/U2tDlK2HcuGU3YAjdewJklINaJqMLAvF24bAW5WbyQTppnmb0DU4AeXqi7FqatfhQIxw3TF7nx3x15u+pTpmuukDY63VGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WLHoaanH3bWkGscM5T0eSdDy0GFKMpMAKdLZ4yBr1gk=;
 b=C+02vtYfW2j64FnP9sIuzgVcXhLZTHnihMZyh74rIkLluRNMHScmK0qHHb4Kfw/5xDaFmmSUu+jSzezxthLm7BtDn5NqeNL2QcWiB72ZQBUO62tlbXi/VhgoqZShfrL6aR6XEgYESWdw1OlVjgumyX2fx14m+Q/pUAnxdj5oJ4I=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by AS8PR08MB6406.eurprd08.prod.outlook.com (2603:10a6:20b:33c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Wed, 23 Jul
 2025 04:04:42 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.8964.019; Wed, 23 Jul 2025
 04:04:42 +0000
Message-ID: <8022363e-fd50-4cdb-85ae-dc83865b5884@arm.com>
Date: Wed, 23 Jul 2025 09:34:37 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] khugepaged: Optimize
 __collapse_huge_page_copy_succeeded() by PTE batching
To: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250722150559.96465-1-dev.jain@arm.com>
 <20250722150559.96465-3-dev.jain@arm.com>
 <2765db16-431d-4c77-8091-889a45c18e35@redhat.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <2765db16-431d-4c77-8091-889a45c18e35@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA0PR01CA0073.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ad::12) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|AS8PR08MB6406:EE_|DB5PEPF00014B8A:EE_|DB9PR08MB6668:EE_
X-MS-Office365-Filtering-Correlation-Id: e1795d36-777b-4571-ec6f-08ddc99e20c0
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?STVxNnZYdmFwS0ZncDFHNUFYOFpiZStiNGlvNDJzUCt4VHRRQ21ONTFFWnZN?=
 =?utf-8?B?UWczUzYxdi9MaUl3SHBuN1dHS2RYMHk0blNRTFV5R1N0VzBjM09XQVljNU1T?=
 =?utf-8?B?NTcvUGpnVlZPWUM5YW9ickl1THQ1S2FqelhlbTJDby9HWnc0d1BmbndKY0xj?=
 =?utf-8?B?TTJKci9hUGxJRnRRc1ZOelBmU0lhSmk1d1owMWszcHU0NG1OQTVzMmZCRGdN?=
 =?utf-8?B?bDhlYStWOEJFeEtwUDNhdlkvY1k4ZzQ5TUJrYW9hbWlWbXZMZGp6bGFrRnZB?=
 =?utf-8?B?OVVCYm5EODFMb1VTdGVXZ1dDbndHMzd4Y3ZYR2g0MGhPdXZDMVVOUzRGT0VN?=
 =?utf-8?B?M2xHYkhsVnhOWjNpL0tPNWdvdGRiTVFHMHJWK0hSYXVOalo0b1hjRUtjQ2I2?=
 =?utf-8?B?c2lRdHlIbk84OFhHTVQ4UFhRVU1ER1B5VnUrNy9zWm5jQmxpcjJHYnB0MjVJ?=
 =?utf-8?B?cThkVk9KZ25LMUJkQUlZMytSN1NlNXcxd29xR1FuS1FmbGNOYVFhMnVTcjVJ?=
 =?utf-8?B?eDl3K0MvSDRFc0lNZGNFQ1ljSFh2ekRFemNLNEdQSUxKMDRaQk8vc2hsZ2Q1?=
 =?utf-8?B?ajJqUGZ6WVZVWHZES3oxNlhTQW1MQnAyYk1jOWRaZVYvTGlKaW5JajJSck5m?=
 =?utf-8?B?MDd0Y0F5WHcvaWlzM0o0dGlPWHZFRkZ6WWZsVWM3ZFM2ZjNNZG95Mmcvd2x2?=
 =?utf-8?B?OFp5cUZoN0lvWUw1SHBkUzJKWDRiZDJBK3VSeDdOa1gyeU84ZzRrOVc4cHY3?=
 =?utf-8?B?ZndCY0MySFJnbEJRUHJYWEVMZ1hpa2dmSDUyMEJ3ZXZJVlplWXlWN2lFMDBl?=
 =?utf-8?B?Rmp4dW0vUGVydHh4VERHbUNnclFMMWtEYzNYN1lKSWxjUi9xMldVcTJDNEwz?=
 =?utf-8?B?ejE5L0sxMklOSElWdmY1TTkwQ1RweHIrVTQzTEMxLzNQbEdvVDltVVl1WEda?=
 =?utf-8?B?VmpmTUFTMzFMMGlHcS9wTGplbUpCMXVWTldJdEFCbmxiNDRkM0tTdGxwdEFX?=
 =?utf-8?B?UDBITU9uOFlESEJHZXJ1Q1NhZkM5UTFyKzNmd3BHaFFGUVhrRkpZU0NhbWRh?=
 =?utf-8?B?K2RKZ1R5d1M1YUdKUXJNaHVQcTA4SGk1ZGE2M1lzU2Vkanl5Y3ZtRWw3Qk93?=
 =?utf-8?B?R3hFbm4rNVhKOGRsZ3piVlhoZE1SRXU0NWJYVU1YWnRhSGhaMEJWVWNUZjA4?=
 =?utf-8?B?Y0pFa0VremFzcHFyYWlGc1hqMENIL1ZUN0l6TzYyNjlpeUsyQk5YSkpTemNw?=
 =?utf-8?B?VTVWNVE4V0RQbXVsT1YrSzdqTHJvSWRvYmc4eVdhUTQzdG9WdkRBczRFcUNR?=
 =?utf-8?B?VnJwTStVMEt0RFVBZmptQkwrWWNRZ1hPeUMyQnd5eVFpZDI1VFJMTUpQeU1M?=
 =?utf-8?B?ekZ2bGh0TlFRcU1kTXV2b28yOXUxVUwvRC94b25rS2MrRXlyNlRKNE0xM0Jt?=
 =?utf-8?B?YlYzNlFXSDJYVUhRcEJsb1JCNS9yTkxveU5DQmZOVEhDOWt5bnhpSUx2UHE0?=
 =?utf-8?B?bWJ4Y3dXNGJKY25pc1FmTUNTOFBsRFNXeURKRytieE9XYUNxSlNQaURHdE93?=
 =?utf-8?B?MGwwSVE2VE5TYktZN1FsRmVUOUFvNUVZU0JIck9kTkxLWkc1TzN3SHFabmg3?=
 =?utf-8?B?alFOVkpFZXpoWUxHbktGS3VCK1dPVkdMT3lkWHR0WUsxUGNNTGYxd2U4a0VB?=
 =?utf-8?B?dVVubnFCMXArKzFLSnZQNGV1QkwybkgzTmFBSmFtV1B2cTB6SUNrNjNDZ1RE?=
 =?utf-8?B?dTQycUsvZTVaVWlySHNmWjBLVWdxam5wU01qR3JyY1FkMklQdlovdEdDVk1j?=
 =?utf-8?B?MjJqRHJjQnRoSGdkWTdlWXVJdlZJamFmNHRzTlVwemtxR2FCUFRpZHNqU2Jr?=
 =?utf-8?B?dFpqbm1XVTNndng4NmNXZFNuUWhESnNacnY4d0JqT3RIWWc9PQ==?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6406
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B8A.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d945c993-de1e-4f2c-8626-08ddc99e0d68
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|14060799003|35042699022|82310400026|1800799024|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ekFQeXk0MSthSlhXSkduQTVUeXBrdTNUbWdWUVovL1hFL3IvZ1YyQ2I5VHlI?=
 =?utf-8?B?bnRjRnBVdVZjcDROV1Y1LzRJaWFpUnBrb1JUZjVyWlZRMWJQMS9kNmo3OTB6?=
 =?utf-8?B?YnVYcHJQUnltRXZKVXBVQTJPVXN1bmRPaFVQODFMZTY3ak5Md2twcmo5ZTFG?=
 =?utf-8?B?dFUvbzNuc201ZzZpZk1HMFYvbS9Id1VSaHowN3RzdnAvOEFrbnhRNWhNL2VT?=
 =?utf-8?B?aXRQU1d1M0hhSitCWlFPUndFWUd3a1BKV29mdVhmUVphUHBMTlBvR1N5Skcz?=
 =?utf-8?B?R1hERXF3T2FXK0VmRUM2ZnQzVGNRbE5HSXBvbDUyUHVSWUpqK1NzTU9WcFFk?=
 =?utf-8?B?YzBwZFBHVmpxQnN5aU8wdjgzN3lMNWMzdzR1NW5PaktNWTdLakFyNjdFSVRP?=
 =?utf-8?B?bEtOdGlkaWhJMERUcGRUYXVlS3JZRGNieDEwc015UHN3WTZMR0cxRmM1VkFY?=
 =?utf-8?B?ZndOd1prelFodG81dnpCR0duZVpCMTk5T0E0MHBaeU1ETFdrLzBQYjlpUEJU?=
 =?utf-8?B?RENqdjY0cUNGc1I4VDUwZjdvZTB2RkdRL2trNUZVZ3BPNFlJU25Lb3BYbFRG?=
 =?utf-8?B?VXE2ZTZteitlanBKdW51aEZDc2tJb0tXTXFvb3NmajBsS29FWnU1azBFVkM4?=
 =?utf-8?B?VGt6Zy81dCtGQmpVVzV4OTFTTk93WTZydkl5NHdoQkRKUlpDN3hJdnM5eUdG?=
 =?utf-8?B?Kzl0VjZZL3orNC9lSklHdkhMVFFGbmJsTTBkaFllbWkwSGVxdEtSSFYvaEgw?=
 =?utf-8?B?MkNKblU4eHZhVkZRY1dhbG5VTnllN09MLzhDaHlkV1hocTFjbk1CVGtuc0RW?=
 =?utf-8?B?TWd0TmpTTjR2dGhGWFJKQXdUZVgwTVlJSGEvb2oxTFBaNVZ3MHBwYndJMUR1?=
 =?utf-8?B?T3lIZFF2WWowbTZ4ejVZWGlzNWo0WXlRS1hYeW5xYVhVVDN0SUJ2anFmeVR2?=
 =?utf-8?B?ak83ekZya29jMnlMQWI2U0huZ0hyZ2o3aUtna3h5TnErWitPb0lMdVJDOTds?=
 =?utf-8?B?bFg0WnVsa0U5ZnJuOU9KVFVjZ3dzUDYyM2w0OWc0UnBXUUxWMVp4MEsxYkdW?=
 =?utf-8?B?ZGRSWE5zaVVVQXlJdU5KT0svb0ZyZFo5d2FBUGFOUnZpUXp1Ylh2OGlxeldm?=
 =?utf-8?B?UnhiYTZKNXBNVTF0aklabFBVeVIvR0Q1MFo1Vk9OQ21rRHNJMDF1N0pVd25h?=
 =?utf-8?B?eEp6d2dBcHRWcGlWWVlIODVtYjhpTElNY3ZKTGFmQWhmdzF3MlBJVWJPeWJk?=
 =?utf-8?B?bmNVci81TU5TcGtab0VUYXNnUVllblVWY1R4RDhQZ0tXTExReGZtdHpMWFZJ?=
 =?utf-8?B?QnlJeE5SV0dueXFlaVlRRW9ZdUxvcFF4MjFYMm16aTNWVUs4MHBDbzZicld3?=
 =?utf-8?B?UHoxVG55cC9kUy9RenhPMVIxdGRYWXRtZTZnbVJyQkNpQUpSb0pMb2FmV2pa?=
 =?utf-8?B?UEZza0lmbTltNzF5anRPV2FNMDJQbHUzdUFFOENBdXIzWm84RkU1UnZndFpy?=
 =?utf-8?B?YlhMVE01S0hGQkFMSVFLbWtxWmc1Y0huWjdYeGEzQVVGZDVIem5oMnhsVWxk?=
 =?utf-8?B?UXcxWVJ2Tno2VzFJMk5uamVXcDQwckE4T242T3JReVp3RTJXbEw1K2xXbFBh?=
 =?utf-8?B?VWlKSmdnUmpTMlRyYlk1cFhMa3I3QXBFM2ZFaGFaNDMyajVBbDF1SytyYmtX?=
 =?utf-8?B?MUtmME9DZWJSd1IrUVlwdVVqNldEdkFJb3lCbnBsTjgwOGlrSTgyWXFQcm5h?=
 =?utf-8?B?N2hTaFNIQTBuc1JyR1QvVmZ3TGJKS05nc2tiLzdqQWE1YVZVc3pGVGhlRzJC?=
 =?utf-8?B?TTBMck1OS0ZxUm9hTEZLcnFVQytFbm5CNGZxYVMxN0wrUDdiS1REQWNJaUVS?=
 =?utf-8?B?Z1pheitWenBoZFhTZ0Vzbk5SaUorV0NMa3plWHlUM1BYV1lJK05rTUNoN2tq?=
 =?utf-8?B?YUxSMXNUL3kvQjdhdUZ6aVpHdEN1bGU2ejlxNlVoZzVXRldrZVZ5M0NIdVFF?=
 =?utf-8?B?dHZLOEE0d0tGSm1mWEFjWm5CL0JXQ1BUakt4dFo0ZXlLQ2t5dHh4K1YrNGZj?=
 =?utf-8?Q?+Cpaba?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(14060799003)(35042699022)(82310400026)(1800799024)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 04:05:14.7000
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1795d36-777b-4571-ec6f-08ddc99e20c0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B8A.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6668
X-Stat-Signature: bjikmfybq5u1dzmw9584k6q9oa7aopas
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 399D81C0005
X-Rspam-User: 
X-HE-Tag: 1753243520-810112
X-HE-Meta: U2FsdGVkX19tbfIv1mdbQecLi7T++esoyNzptbTZYRlkfUURWSSKRv/8dmCtVHSOCNLsl099oTjYSucR4PxtqNMSzKJ53a90jlCtXw1HrKrLBUF/Lp/gVn08hJqAUQiW1VNYp5mP00umOwiFgFtROVzk25iUQ10V+s5+GXq3CwdUJ1xQZXFlP8HqyRvgjQ0G3aY7LZ63sH+ix8BVqlcGLv6zZNBe3UopT2+gh4H3PDHfopuIE/IJthpUKZ74pjZgpEyyrrnsUkOGVgTkrDsuMip4Li35+ftmEblQE9x+t2QyXRAmgDLxTu25+Ry0Jj4qT6bELhmFnLQyQB0XNhfji6b1214jI/h98KE0CoMuZfNqzFQqHtVgcNvz51VLgeNd9XrwPCrPfOBeZ6rPsOHu53iXhiA/R4pVG0jzXcnmu0/2p7wNbZ5Bq2YKV/3jtpbd9MMzAMt85/rEN7Ew4F6VzzLhvjCRPVuXa7AI3kXnAB5gj5iVkhkjIdnH1zrdB2gMRJ4faT/P0oIRaMPMf/rWpsBK/WcdVui4sxhQzEhtErjl2skKbL+VflOb78wPisSyGQllKWFUdBBTvmHyzfCcMgtQ+V9zs46peD4TLAQimzEEAKpj5adk83E+WWbdeUfW7iajwo0bgz4SjbO914ASMTInegfwBFOzCK/u/MYTnWKsx/kkoQAa79BMUGekCBYcBCyaH0Z5idI1rEiHiFaW3nm2w/QkGMIlL7bsjHRF0s+3QzwxTvtVGggfHFRfZ1EElV1DcNY9Rk0qCsI7oC6iOd3p6BmD+raZI6mOc9MR3TidXjFEUAG1ArG/XZfge3v/zXugXQnuI6NfxLp7fIB413uiSNjKKzpCQzGpeDnUIsxH/zrsZULMIIC5XqQwi+Z1/5auUA83jZh2vJ1lVyBq4RnOlZ/GSUJsVOJ8fCW0unXw+Fi7Uk074IumZwONH02p4NVq6DUVjFrOsj/661t
 uTKe04cU
 hK5t2HGhr6sHSti/F4s9BB3NMrVxZOFRVA6A7KJREmJWtZD8Q8iMh7Du7eHqn8WlGof12fNSIFxHT5SS0WsSEDn0E83KgrfWa7ZHcWLsmiIXtdsAsWLdvqh+uCHOxv2zd4gh5f+zDEMJvHo/e30u5lQtPFRDveW3BfZbXA8AxVMy8IcMpHKCcUc/B/s2dnz/xamc5NUBiATW3XCu5rIpVDvE4y3HPF5TJFDLitLlPTjThYbKr87s+oPYYX+ISgccT3HdHtQVigtokZ1tub7ryyBc1GeXrTurKp3nT++rCXoTQ4jOFpfVQZB+kruxs8EQpj9r5fiGi/WJVZqw8lapFe+OO42dNbFre9QID7gNbl5RPKz5XLkKXHTuUC7tyQOXKcSOtFkukIiQKjJNCv3L7jPQ8xelaqAG9zCXO0myAnWxlj8/aJyYZIowP7BRlTZAZGu0JBnFyKK0nu/qQEeko0L5r2b9vDYZG8jZLS7zH/CuZr01/YDY1wL1uGK4UDFvulS6KFpZmgMa84Bw96z5kOnJ6PEKruA0d72BU1xIPcvrTpQ8pRYULPt4RJAtpiiS9loRIFHvCY9GeViQU4aJC0xs6c7gOf7Uv7+VIPZzh18GBNFWFLVGGcRaL0C0PwywfEJohvjQNxIKlBqWllsYd7N5/HEbWhmonSyRA9k3TzBnAplbFeBmthE1sNsYJsj2wQrn4nJznd20hNo0rxpXT6Ki898+Cz2OD8Z6W
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 22/07/25 9:33 pm, David Hildenbrand wrote:
> On 22.07.25 17:05, Dev Jain wrote:
>> Use PTE batching to optimize __collapse_huge_page_copy_succeeded().
>>
>> On arm64, suppose khugepaged is scanning a pte-mapped 2MB THP for 
>> collapse.
>> Then, calling ptep_clear() for every pte will cause a TLB flush for 
>> every
>> contpte block. Instead, clear_ptes() does a contpte_try_unfold_partial()
>> which will flush the TLB only for the (if any) starting and ending 
>> contpte
>> block, if they partially overlap with the range khugepaged is looking 
>> at.
>
> I suggest not talking so much about arm specifics.
>
> Simply say that batching reduced the number of TLB flushes, especially 
> on architectures that support cont-pte optimizations.
Makes sense.
>
>>
>> For all arches, there should be a benefit due to batching atomic 
>> operations
>> on mapcounts due to folio_remove_rmap_ptes() and saving some calls.
>
> I would rephrase that to "Independent of that, batching PTE unmapping 
> has known performance benfits (i.e., less refcount and mapcount 
> updates)".
Thanks.
>
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>   mm/khugepaged.c | 25 ++++++++++++++++++-------
>>   1 file changed, 18 insertions(+), 7 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index a55fb1dcd224..63517ef7eafb 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -700,12 +700,15 @@ static void 
>> __collapse_huge_page_copy_succeeded(pte_t *pte,
>>                           spinlock_t *ptl,
>>                           struct list_head *compound_pagelist)
>>   {
>> +    unsigned long end = address + HPAGE_PMD_SIZE;
>>       struct folio *src, *tmp;
>> -    pte_t *_pte;
>>       pte_t pteval;
>> +    pte_t *_pte;
>> +    int nr_ptes;
>
> Nit: I guess we should switch to "unsigned int" here now for 
> consistency with folio_pte_batch().
Okay.
>
>>   -    for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
>> -         _pte++, address += PAGE_SIZE) {
>> +    for (_pte = pte; _pte < pte + HPAGE_PMD_NR; _pte += nr_ptes,
>> +         address += nr_ptes * PAGE_SIZE) {
>> +        nr_ptes = 1;
>>           pteval = ptep_get(_pte);
>>           if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>>               add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
>> @@ -722,18 +725,26 @@ static void 
>> __collapse_huge_page_copy_succeeded(pte_t *pte,
>>               struct page *src_page = pte_page(pteval);
>>                 src = page_folio(src_page);
>> -            if (!folio_test_large(src))
>> +
>> +            if (folio_test_large(src)) {
>> +                int max_nr_ptes = (end - address) >> PAGE_SHIFT;
>
> Dito.
>
>> +
>> +                nr_ptes = folio_pte_batch(src, _pte, pteval, 
>> max_nr_ptes);
>> +            } else {
>>                   release_pte_folio(src);
>> +            }
>> +
>
> Acked-by: David Hildenbrand <david@redhat.com>
Thanks.

