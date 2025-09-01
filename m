Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE0F5CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:51:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 132228E001D; Mon,  1 Sep 2025 04:51:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E3008E0012; Mon,  1 Sep 2025 04:51:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EECB38E001D; Mon,  1 Sep 2025 04:51:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D7B5B8E0012
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:51:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7D4FB1A072E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:51:01 +0000 (UTC)
X-FDA: 83840061522.28.2CA94BC
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012020.outbound.protection.outlook.com [52.101.66.20])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5F3BB140003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:50:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=AHtqrsSM;
	dkim=pass header.d=arm.com header.s=selector1 header.b=AHtqrsSM;
	spf=pass (imf26.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.66.20 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756716658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KZgMrKxNkEsz/Lao0vRq8EciSn51eOVhyf9sLuv2Dpc=;
	b=mj3SITfIpIxQm72sjJZQnX65fVGYrbPQiPgHD/yp/5KQn1+aNSU4n3Zn/xXkVma/GtYtHc
	D9qsPi24RJVmi7nwX3E7S62Rc45Ka1TE5kMw/ewn1A6bUm9IS7KOmqwLk/GQJURs0/r6Z8
	/6neG4YkuTsVWFogqIJon4dAknqImhA=
ARC-Authentication-Results: i=3;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=AHtqrsSM;
	dkim=pass header.d=arm.com header.s=selector1 header.b=AHtqrsSM;
	spf=pass (imf26.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.66.20 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1756716658; a=rsa-sha256;
	cv=pass;
	b=B5l7eKu8AUVmhej+I3zIpwYiCNAIDbRixkkVqJp373V/I96BWn0bDQZJ12GXAOVLZ49Tdx
	PH2ze0c6QHGg475PFOpySobdmCDNv1Dxs5/36auwdRFCYPAFvJdrhZ8rIoAAa6Jk47ADRe
	kUxUvjAmhBqmfa07195mDJ27r6CsJNQ=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=H5jkNoI0Shojwzm3guTZVd2Yar8S+yY+IAnJE1uBi4tYq1kpUdbfHeoIo2+jSh/UjWHq6aS8R1Ol6msYDZAnFD6AnidIIpZm6GJnVWwQm0e/uqaIH9bjP9VNdAVuhot2b0tJ8DaHhBYOmN3hkId7FRz6K4A943BOCLXkNPmfH6g7ueRQTRBThYWlk6K3FU3pXEB8syO/HzbOfdEb9D29BzDw5mvuptGcRWprn96WQijwUF1GYULyNfTxeD7Kl/JyE6OAlfeUOKnr/ldfqKHIkLEyV5bs16TUVuqZrsq/MaMVbhmtESO/hjDhpEjOAh/scQ1/Ac01DoecF7O4jN9BzA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KZgMrKxNkEsz/Lao0vRq8EciSn51eOVhyf9sLuv2Dpc=;
 b=q9RG9PQ47BwUgZ0LzKOEtaF1/S2PXUtTTrO9seKV0Ffs5Lj7WOl2M+JRBbQA5f5345Su2hvPy0iUZ67fbCudhSlj3Jwp3oc7jnnvy9/Z/0cAdsdWWAwOPLaU4aLBNjWychkKMaU8aq7NVtXPCG7w0Hw+3OTPjBvjkrG4e6FEh8PYOSGCY0rNC7Xdc+hbZbR/c0Cacd0O19WsgXuhg0veY7p8+cgZdRxBHYYewnIuepvXyBfEwbd/ttjW3kacGu+nHlNKassVK+J5z4L0+cObzRFe1qWHBuk1fOBeiSpf8mqHz8jC5zURLlUX+qRGeuSmZxPr7+mpyzawhYjQ5VuP4A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=redhat.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KZgMrKxNkEsz/Lao0vRq8EciSn51eOVhyf9sLuv2Dpc=;
 b=AHtqrsSMFuiu0IT4eX9wa4hEzCR/mKL1/04YmqgtOprLWvsB/Kb0+GMSATyvvWAB2mwcRB2q7MwjCJYG+4efVwCkgePq8UrOFLOzpUlVKhef4qUzSmgFKUZjnfYVP5ZTBInrHnM6waLDKGA/5dtXf8+6yF4dgz0JQGnJiZ3FR6g=
Received: from AS4P189CA0028.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5db::18)
 by VE1PR08MB5631.eurprd08.prod.outlook.com (2603:10a6:800:1ab::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 1 Sep
 2025 08:50:53 +0000
Received: from AM2PEPF0001C709.eurprd05.prod.outlook.com
 (2603:10a6:20b:5db:cafe::bf) by AS4P189CA0028.outlook.office365.com
 (2603:10a6:20b:5db::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.27 via Frontend Transport; Mon,
 1 Sep 2025 08:50:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C709.mail.protection.outlook.com (10.167.16.197) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.14
 via Frontend Transport; Mon, 1 Sep 2025 08:50:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wBjcJyTkAAGJpHGw61xuC4JgfswDCol6tnECc83/iQhdKJ8c8PVyIEztMSD0YrtFI8g28/ghILP8YklS5/pIvZR6ujePvsC9VN+1Ol12uy0K6vG9INW54I6TkUdDWCnBFv7aj89BP3S0aZx+lB4Xko1IwysWxEF3AOLo8d9v4Or8FmAAwIGmfyU181Y5OdbRLcO5+UJ6mdYiX5uqOVrzQj4zJt+c8u/msk8+5EcrvlrdKqj+hlk3oKN8Fw6LussGXlocPwotV7Gi5W8NqXixeVcfRkYOJPjHbD10b76PPN4MTrnGpg5sj9Ie9NiN+hOC22pH/jG6fvuE5I0P9rP9YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KZgMrKxNkEsz/Lao0vRq8EciSn51eOVhyf9sLuv2Dpc=;
 b=nKkORJu0ZbWzOOxUDUyty23yMe4DgfyWxOm7/YAdYrG2yqKd870e4VNL3YYPfOyF+M3dlJg7ptubDZpHnz1wvud1Lu+9sJrwGgkZsf+W7pzY73u5FvZy1jbtG7mgse0IwUnUs5Blmnhr1tMhOZo1a0A29RK6zT/XGtpfxoz31/WY67iR55Kr4CjScso0V+Y7AhHOCW54ygQleBzqAUtWZuo1rpS5/5snWZYOEFZ0mJUzlwvunx0mofTe0hlJiziN4Pnd+iVpA7s0wxcB66BZoFcoyW2cpoKD1KRgiCn48QL+wFON4XetFP4N+g4yKbcTTWajbe5UwjAeO8FwQ8+fHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KZgMrKxNkEsz/Lao0vRq8EciSn51eOVhyf9sLuv2Dpc=;
 b=AHtqrsSMFuiu0IT4eX9wa4hEzCR/mKL1/04YmqgtOprLWvsB/Kb0+GMSATyvvWAB2mwcRB2q7MwjCJYG+4efVwCkgePq8UrOFLOzpUlVKhef4qUzSmgFKUZjnfYVP5ZTBInrHnM6waLDKGA/5dtXf8+6yF4dgz0JQGnJiZ3FR6g=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB7111.eurprd08.prod.outlook.com (2603:10a6:20b:402::22)
 by AS8PR08MB8133.eurprd08.prod.outlook.com (2603:10a6:20b:54e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.26; Mon, 1 Sep
 2025 08:50:13 +0000
Received: from AS8PR08MB7111.eurprd08.prod.outlook.com
 ([fe80::4ea7:7e71:7dd3:3b45]) by AS8PR08MB7111.eurprd08.prod.outlook.com
 ([fe80::4ea7:7e71:7dd3:3b45%4]) with mapi id 15.20.9073.026; Mon, 1 Sep 2025
 08:50:12 +0000
Message-ID: <5ef6df9b-f4a7-43d1-9de7-19ad2d82bbff@arm.com>
Date: Mon, 1 Sep 2025 14:20:07 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: Enable khugepaged to operate on non-writable VMAs
To: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
 kas@kernel.org, willy@infradead.org, hughd@google.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250901074817.73012-1-dev.jain@arm.com>
 <620f01b4-8a6c-4dac-bcdd-7c48f5cd87f2@redhat.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <620f01b4-8a6c-4dac-bcdd-7c48f5cd87f2@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA0PR01CA0096.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:af::12) To AS8PR08MB7111.eurprd08.prod.outlook.com
 (2603:10a6:20b:402::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AS8PR08MB7111:EE_|AS8PR08MB8133:EE_|AM2PEPF0001C709:EE_|VE1PR08MB5631:EE_
X-MS-Office365-Filtering-Correlation-Id: 65ca9eaf-4210-4d8f-a48e-08dde934a8a3
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?bDVRbTZvSlpkaG5tbHhxSm1uZXhGbjVwMjA4WkhwT1BYUzgzWGoraEc1UlFD?=
 =?utf-8?B?ZTBwUWhzNWhjOWZMdHlYOTEzWC9zOTJnRmgzbzA1Sk10L2VyckhEanNxRmd4?=
 =?utf-8?B?TXAyVjF1d0lpTHBGQWRVOUp0T0hhWU1mSnlHZ0NyaVdIeTM0dEwrWEtBK3Ir?=
 =?utf-8?B?Zi80UUVtbndObnYzQlg4TEVNTyt1LzZQcEIvbjVkWDEyeEUxVW9MdDN6NUpB?=
 =?utf-8?B?SVpockhmbmdsNDFsV3VDOEZ2aFJWaWMxL3hKdnhDeFNVakI5d0s4L0w5L2No?=
 =?utf-8?B?UEUzMG1ZWEJiWnZTZ1pDYzk0SVdleTZiV2thTUVKWGxqTDJNZC9MNXVxMXgw?=
 =?utf-8?B?UGszZkZaQ1lHUkQrYm9hbmc1VTBuZVNrejF4bmFjU25lUlZYTEtWYktVekhh?=
 =?utf-8?B?VW9sRGpHakowYzhBZlJrWWRKWjZTY2VVUUFPa3Z0REx3THFoeDB2QXdJbndW?=
 =?utf-8?B?SzR1MHhqelNham1NSktMZk9SWTBqWFE4V3BMeEVDVE5qNWtnOXNNRGhiR21q?=
 =?utf-8?B?bk5sNkovbHc1L0VDdnAxWi9BakJuV2hOa1RtellzNzlOY3ZNcklVMlliTnBR?=
 =?utf-8?B?Tjlhc0pjblBPOXc0OUQ0RmIxK09FcGx2Q2pLZlRzSWFBWG5INUczQTJ0NHZW?=
 =?utf-8?B?YWI0MzJ3eFdTMjVQaFVteDZEZVlaTDJsMGN2dkVWWHBpY2QwZHBDbnk3MTVE?=
 =?utf-8?B?RjJvd1N0VTV2MHp5VDNJN3pBclN4Tm9kZTMwd2x2bkVza3RMejZSWno5SUdz?=
 =?utf-8?B?V2dEK01uZnc1K1hBeXJWcTI3ck40VUFDbnNEeVplbGN1RC85aHVqUzVNZCsv?=
 =?utf-8?B?UGZpNlRFZ0pSL1diQUplR3VsWHZuNlRXRVVOS0c4VStPUTJzR09hQ25kb1RL?=
 =?utf-8?B?cXo2LytaQlIzR0JNMWprTUhZWGhTdUYxWmhaeU5VM2o5aDlPcG85VmdMODd3?=
 =?utf-8?B?dGtHMFY0Yko4QkxOSDg5cnRMSkVFVXpRWDJBL29rRUVSQ2NTTkNsRTYxaEha?=
 =?utf-8?B?SlBWTnQ3NVJQQTRZaHI3cWl5eEk3QW56ZDR4cFFOVktacFJIdmk2eEFOdUc0?=
 =?utf-8?B?L2NXaitVQ2NORW5uejVBY1BLbitVczEyM05weGdPOUJUcTRRdUhDRlVpNndm?=
 =?utf-8?B?ck5ISFk3a0FxeFJDd0NZS0czRVl5Y050R1lLRnhFbEFkcVQ1ME51WHFyaUtR?=
 =?utf-8?B?UmIwWWxpaWhiOXBNVnlRVjB2Q3p0WG9mLzl0MTR3Zk1oUEh6NTVDaE13Y1NE?=
 =?utf-8?B?QW42VzNmMDBmVmd3cnQ2MUlEdzVReS95dTYvU3Z4R0VPWTFXeHJPSXFpTkZr?=
 =?utf-8?B?Q2xReGVhaXFXSHdmRWQ4a3NEZU10eUVoSVJuV3FsUFhvU0dHYVV6ZDRPMGhR?=
 =?utf-8?B?SS9IUllqNVNTQWJpbHpBeVVCSEpkNXRSRTdHZitJWGRyeVBReG12bFZlbDRP?=
 =?utf-8?B?eVpMaHViMW5GcG5qQkhOdWFWY1pZKzlYK1QvSUp2SnZUUjRESzhrelQxdXZa?=
 =?utf-8?B?b2dDZGVHL0FXUHNuc28rclpVZldvSnBDa3F0ejhZZHU1TFZHeDZNOHhDZGYx?=
 =?utf-8?B?aERmN0RrUVlZVzE0OUNEeHdET0RWRnhVK2szalRVN0RiSmV2UjVrSElRdFZt?=
 =?utf-8?B?WVFvV0N4YS9lNjNSZFpNWVN5L3UreHVMMjNRaGxtSngzRVBWTWp6S2J5UlNP?=
 =?utf-8?B?SGZZUUJSSDFjeThzRWh1bGNEbE95N2NieWhKRXBoMmNSaTVGZlR3K1JQc2k2?=
 =?utf-8?B?Wk16bjU1STRSQkdQdWVUZmVwSmZkZy92eGtOTm1lSWdRY3E4a0JLVVNrMGEx?=
 =?utf-8?B?VHFnaHJ4N21hcTdmbEZpaU9UR1RYNnhRMDdOSzliWmVSL096MWl6RFQwckIr?=
 =?utf-8?B?ZDhZTzdnZWczbW1Ed2NNUjVaSE9VNTRibHBMOWlkaWFscEhVV0tlWmd1QkY2?=
 =?utf-8?Q?GGPifec38PQ=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB7111.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8133
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C709.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9cdae7b4-f7b5-4941-6523-08dde9349049
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700013|82310400026|14060799003|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YmpBTWVvc1BoRkhoWFBSbENOekt4dWU2amR1OGsweUoxS1AyNGhVSENrekxZ?=
 =?utf-8?B?UFV1Wm5xaUpNV29mSll6QXdOSXBIMjgvUEZONnhoN0ZodzFuajIxU1d1Ty8x?=
 =?utf-8?B?cUkwS0hPUzV3V0pYd3ZJd21kSmJxb2pXTkxMaERaVjZyMHRReFdWR0pDd1Jj?=
 =?utf-8?B?bVNwUWROSCtPVzQycXpxZjJaU0ZqbDhSUGZjYmVEeE9UdHB6RWljQkUvajFZ?=
 =?utf-8?B?YVdoc2NtSzFEOEtIV2xOMkdJdlhGMGZtOE04MFArOU9XcDBvcFdWK29KQVRN?=
 =?utf-8?B?dU5uQzdsWFJrcEQ2eE43bTFIaGl6UDhtWGppMC9EZzRrK0o0RDNuZVVBb09U?=
 =?utf-8?B?MkQ4d0VwNGZ1Q01aWXhCc0xYb0xtYmtJQmJRYUxkelhCRm9KSUMrT2xadmZp?=
 =?utf-8?B?QmVMaVd1dUtnMzJCOWUwZ3pJbExrOUdhS0hPM1VzMDltMmlPSEt4Tk5PMnJH?=
 =?utf-8?B?NEFpVEZIVjlGNXhPRXRSaEdDUlpsUGE5R3F1dmdRT2ppc29EYVgvWGIwdS9v?=
 =?utf-8?B?L01ST2Mvc1dpbERCY3pNMXk0bWNaYVhndmwybDRNWi9pQ0xPU1lqdzAvanRq?=
 =?utf-8?B?QjJhbnFhamlZK0VhelBFbWNQK0dCTWE3TXp0NXU1QWtRVlBRZm1SZXFycE5s?=
 =?utf-8?B?c092VllHN3NZR3RVRGdxT2poTnpaZTkrbWo0LzVWR0dtRGdISnNMU3VjZlFu?=
 =?utf-8?B?dUE3YkxHQlMrZkVFWGJGSldrSEV0Q2VCb3p5WjFtc2NUMTl1UElieHg0QWN6?=
 =?utf-8?B?NDhuenlmeDMyVTFYTHk1eGpyNG04VFk4eFczTC85ZzZLcGJzaWZZRFVXYTVQ?=
 =?utf-8?B?Z212Wk55YXlOdEJyL2ltSzFubHZVMFBkMmhqbk4xZ2ZEc2lJK1BmYmdwTC9Q?=
 =?utf-8?B?RCtKVXQ2dHYwSXJtV3p2cVQ1SGt0SE40bTNoM1J6a24zU3VWMkMydjlGK1dt?=
 =?utf-8?B?alU5WkNEc2RaUU0wcFZvbVdrL01CcGs2RldGYVh0ZDdKRHdvNGdpcUhKNFhk?=
 =?utf-8?B?dFJUNEtmSHZnUE9FMTNZN3AxYWt2MWwzMDd2V2hxTXlNVDlkMk13RzJ5RlEy?=
 =?utf-8?B?TU5IbEE2N2ZnY0JmenBqT0tqYy9yTFk0ZHNTWERCZ01wUGxvWTlwU1U5eGlO?=
 =?utf-8?B?YUdJL1lHUWthY3JPZkdwTXl4cHNOK1dBODA2d043YW1ablVRS0dQZ241WXVi?=
 =?utf-8?B?QnBIZFB2Z1NWMjRFdmFaMU5hbmpuTERjaUpFb2xZVG82NEJYSXIwTitBS2lX?=
 =?utf-8?B?YjVWZXRuenVvay9Lc1M5UU1pbjBwQ01RbWJaUEVyM3k3N2dlSW56NUNLOHRG?=
 =?utf-8?B?VHh5Yit0TER5RXBvRnI2bGJJcE9UYUpNa014V2pERmxVNUxEWVM0N291bzhL?=
 =?utf-8?B?OGREMFJlb29kWURSeXkzQmdzRW1IanpsUE5xMnpIRTJyU1MwSlF2SytZbEY4?=
 =?utf-8?B?M203NXVvSXFXMC94NmZvRkxHVnNRcTJkMlQxWU9DbG9NWURoVzZOb3BFL1Z4?=
 =?utf-8?B?am1ZOGk2MVVHbzBPNFpQNHdLaEJPN25maG9jdWdOUkhwRGxtRVBnU3g1RUZS?=
 =?utf-8?B?U2kreENUVkRFNFJkWWFlY2NRK3E0TWpLL1ZBOGcyTEUrUFAzSFQyZS9rNFUy?=
 =?utf-8?B?Q0JaUzVQZDgrU25qYVdqSjZmYnJSeFoxemNPSzc1b3F0c2l6bXNaZEE5dW9O?=
 =?utf-8?B?U211eWt2d0pwSVZlRGRnd1JvdWlPcmlpL3JkbVR3YVpDSzZDQzBYSElGeVo0?=
 =?utf-8?B?NzU3S3R0V3BRM3ZmWFhLK0hMZGFGZ1M5dm9oeFJPeUxIUzhHTjYwNHdtRG94?=
 =?utf-8?B?VmFVaFdwSldZcWFOcEFnTkVrd3RDMkhLRWhGbmRIMjgwLzg5Mm4vaFVRMXZw?=
 =?utf-8?B?MlV4aUloWlg0VFBtbHU5S1hGYndYcGxjNFlzdmRySXlVMjBUamVRUjZUaGF2?=
 =?utf-8?B?ZWYzcVJDV0lGRktzcDhFVVlOd0gvNm9MVXBRam5UMHJjMXVPRUliWWUzR2J6?=
 =?utf-8?B?YU1xMVBWTXE3YmNScHlodk9rQ1VvenpqREtFWUlxbDlsbWZXd3pLbThxTnFq?=
 =?utf-8?B?OWFyRDNyL3FQTU10RGFQMmhIZWNKTnBPcXl3QT09?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700013)(82310400026)(14060799003)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 08:50:53.1840
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65ca9eaf-4210-4d8f-a48e-08dde934a8a3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C709.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5631
X-Stat-Signature: jgqoo3khb3e4q8atcefc7y36i6csken4
X-Rspam-User: 
X-Rspamd-Queue-Id: 5F3BB140003
X-Rspamd-Server: rspam01
X-HE-Tag: 1756716657-179998
X-HE-Meta: U2FsdGVkX1+CzLQekrRB4PCA6+Zx0qvSZD3appFF9PEZkZX8cgIXTmYArYCjRfgMG7n/sLPHNDiWHI3VVeYSJAVcpS5JEmj8zTnHlvYa+is4UhmLjdU5ilSwMj55AFXweosfTj41d+/zf48wJL6z/HiRaxy81K9IFJ4ch8gVdYl8ZU648jQy0TPy7ksrYmGXZ1He5OGiJc/JU1ERNXO9TKQ6yiqirobZy5OMkOP5apIR7oB58pk1y2s6Innh/Q7bk5avPTcnbfVlhkAcKO76pK6J0dQfXBO7q3UqI2OiwR68Tb7YnawdBf3DrfUi8NYMxHZ8RCfMGDPx/6YNnGes5vEZ2Zd2XVGojmClKKxdrSK9Vso223/pPXXGVPBkG640cLXAoAAA39hJz+v8tmag5n888Qa8tJ/3nERo+P9cvxBJY1MmxrqYzGUCpu3qECv/w6cuPCxj4olab3BOONchEiHc9MV5sWH0tAdZjMjaB3LFCxtbmaLZAkUbTYtBBPmJHTJWaZS/nF+vP2eWBgsv+xI2NTtLbBqQklG4OQ3Tax0QoHo7LzXrVVt63dPfA7CQFqvMxEFqoUfjVO0nb58yTGWurUGXPzbsf8VD86DL+ltRQjklAhmRM30NOBXRTygtJ8Pz7QqolP2WCBR5GdyJNN0225NaBTvhc97XVrXhxTQsolHERyIdN4pYP8EmqZSQvOL4FIW5TS3o0e807i2z124tPZLfgjrKIzv3m1Qvot7ffrDuxfhx3bhzZfO3YT5dLNJYzhxXM2fyR2kVQQDKfjxTAjCMNoSni6PfV5l5LzRgVqL6kCL6dPfMgmQZfUeLMJY/M4gP2iw0AaqdTx3GxSfMQveQrvYnbXJhTTSr7lgJLwOO7ZRZ0Gkz3lX8KGXy9Y7NCzWBtjtnkhEwZ9CfJFV+XuG/nkedIU/pQ9IwZShbBxhRHxQCRupe58961bHgWpj1aw+roIVK1XgK70y
 I5y9GHja
 dOTYM8J7Yd1a5zZx5zf6Qt4AK99ya4btWveq8I4Q3ts0IvSwbujlOrtSkZxmKf45JYR2Md4LLn1ecBLEPTVj0+L/yjuZWTDbs+X5g5UkxSAvGUMq4iiRnufftesV9utcIUNDZr35qycQW533L3DOxhWstOHRzQVeJyctmb1S+zKRReO3h7DzfYxTsbI3NBx7HT1KdSqmJL7Za2UqeZ9meBqByAbjSyNWeREK4RDH0yuwk7YClmW2Fipbeaovlida09Clci8G7vFKYVSMewM8jVnn/u9wz3LCC2Z/ivTd4yq/LHRim9nxRmhfaW7WkecaMP0U8vmWqmVA4x23MJrqXnNo3OOBQ1OBVrRXKcXMuUY+F8eDveAu9ab1nY8BEHKS0kXi13xqBKog4Zexu6KdRmsd9nd70nDNU/UND3hlfQmHx4Y5UxVXswZHD2VB9XS/wtIAIljLjsqTTLxVTNEiW1iYDerM1ChV3qN4O3t2LeiRonfg0t9EEiPDrMHuav6xUH0KYwtaj8BmHAi2LzT3DMbRN9JPPIUTPsSFFcMJAfD2Sc4fOnn70SNrGODgKv45KdJcIxzjfwQXfJeDQJs1Ce5b24QujomRqofwn3TNlUI0ig5Gz8C6PJBUEsxvDE6/TI8MY/7ysqG3eqjYygd21JqvPj9w1WB4MBs14uvNzcNjc6EJU2qKeR/+b/J37qQ7jFjY6GCF9YzDNk/uJKUMnJyhTztot95nGRHGb3haL3sGNBosG5lp+4mKrtQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 01/09/25 2:02 pm, David Hildenbrand wrote:
> On 01.09.25 09:48, Dev Jain wrote:
>> Currently khugepaged does not collapse a region which does not have a
>> single writable page. This is wasteful since, apart from any 
>> non-writable
>> memory mapped by the application, there are a lot of non-writable VMAs
>> which will benefit from collapsing - the VMAs of the executable, those
>> of the glibc, vvar and vdso, which won't be unmapped during the lifetime
>> of the process, as opposed to other VMAs which maybe unmapped.
>
> Are these anonymous folios? ("VMAs of the executable"), or is you 
> description
> misleading?

Oops. I dropped writable everywhere and failed to notice that the 
callsites are

all for anon collapse. So I'll only mention vvar, vdso and other 
non-writable

VMAs in the description.

>
>> Therefore,
>> remove this restriction and allow khugepaged to collapse a VMA with
>> arbitrary protections.
>>
>> Along with this, currently MADV_COLLAPSE does not perform a collapse 
>> on a
>> non-writable VMA, and this restriction is nowhere to be found on the
>> manpage - the restriction itself sounds wrong to me since the user knows
>> the protection of the memory it has mapped, so collapsing read-only
>> memory via madvise() should be a choice of the user which shouldn't
>> be overriden by the kernel.
>>
>> I dug into the history of this and couldn't find any concrete reason of
>> the current behaviour - [1] is the v1 of the original khugepaged patch
>> which required all ptes to be writable. [2] is the v1 of the patch which
>> changed this behaviour to require at least one pte to be writable. The
>> closest thing I could find was: in response to [2], Kirill says in [3] -
>> "As a side effect it will effectively allow collapse in PROT_READ vmas,
>> right? I'm not convinced it's a good idea." (Although Kirill realizes in
>> [4] that this was not the intention of the patch).
>>
>> I can see performance improvements on mmtests run on an arm64 machine
>> comparing with 6.17-rc2. (I) denotes statistically significant 
>> improvement,
>> (R) denotes statistically significant regression (Please ignore the
>> numbers in the middle column):
>
> I once dug into that myself as well as part of
>
> commit 1bafe96e89f056cb6e25d47451fb16aee2c7c4d0
> Author: David Hildenbrand <david@redhat.com>
> Date:   Wed Apr 24 14:26:30 2024 +0200
>
>     mm/khugepaged: replace page_mapcount() check by 
> folio_likely_mapped_shared()
>
> where I noted:
>
>     Interestingly, khugepaged will only collapse an anonymous THP if 
> at least
>     one PTE is writable.  After fork(), that means that something 
> (usually a
>     page fault) populated at least a single exclusive anonymous THP in 
> that
>     PMD range.
>     The problem I was concerned with (also documented in that patch) 
> should no
> longer apply ever since we changed how folio_maybe_mapped_shared() 
> operates.
>
> So yes, I don't see a good reason to fail on R/O PTEs
>
>>
>> +------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+ 
>>
>> | mmtests/hackbench                  | process-pipes-1 
>> (seconds)                                |                 0.145 
>> |                   -0.06% |
>> |                                    | process-pipes-4 
>> (seconds)                                |                0.4335 
>> |                   -0.27% |
>> |                                    | process-pipes-7 
>> (seconds)                                |                 0.823 
>> |              (I) -12.13% |
>> |                                    | process-pipes-12 
>> (seconds)                               |    1.3538333333333334 
>> |               (I) -5.32% |
>> |                                    | process-pipes-21 
>> (seconds)                               |    1.8971666666666664 
>> |               (I) -2.87% |
>> |                                    | process-pipes-30 
>> (seconds)                               |    2.5023333333333335 
>> |               (I) -3.39% |
>> |                                    | process-pipes-48 
>> (seconds)                               |                3.4305 
>> |               (I) -5.65% |
>> |                                    | process-pipes-79 
>> (seconds)                               |     4.245833333333334 
>> |               (I) -6.74% |
>> |                                    | process-pipes-110 
>> (seconds)                              |     5.114833333333333 
>> |               (I) -6.26% |
>> |                                    | process-pipes-141 
>> (seconds)                              |                6.1885 
>> |               (I) -4.99% |
>> |                                    | process-pipes-172 
>> (seconds)                              |     7.231833333333334 
>> |               (I) -4.45% |
>> |                                    | process-pipes-203 
>> (seconds)                              |     8.393166666666668 
>> |               (I) -3.65% |
>> |                                    | process-pipes-234 
>> (seconds)                              |     9.487499999999999 
>> |               (I) -3.45% |
>> |                                    | process-pipes-256 
>> (seconds)                              |    10.316166666666666 
>> |               (I) -3.47% |
>> |                                    | process-sockets-1 
>> (seconds)                              |                 0.289 
>> |                    2.13% |
>> |                                    | process-sockets-4 
>> (seconds)                              |    0.7596666666666666 
>> |                    1.02% |
>> |                                    | process-sockets-7 
>> (seconds)                              |    1.1663333333333334 
>> |                   -0.26% |
>> |                                    | process-sockets-12 
>> (seconds)                             |    1.8641666666666665 
>> |                   -1.24% |
>> |                                    | process-sockets-21 
>> (seconds)                             |    3.0773333333333333 
>> |                    0.01% |
>> |                                    | process-sockets-30 
>> (seconds)                             |                4.2405 
>> |                   -0.15% |
>> |                                    | process-sockets-48 
>> (seconds)                             |     6.459666666666666 
>> |                    0.15% |
>> |                                    | process-sockets-79 
>> (seconds)                             |    10.156833333333333 
>> |                    1.45% |
>> |                                    | process-sockets-110 
>> (seconds)                            |    14.317833333333333 
>> |                   -1.64% |
>> |                                    | process-sockets-141 
>> (seconds)                            |               20.8735 
>> |               (I) -4.27% |
>> |                                    | process-sockets-172 
>> (seconds)                            |    26.205333333333332 
>> |                    0.30% |
>> |                                    | process-sockets-203 
>> (seconds)                            |    31.298000000000002 
>> |                   -1.71% |
>> |                                    | process-sockets-234 
>> (seconds)                            |    36.104000000000006 
>> |                   -1.94% |
>> |                                    | process-sockets-256 
>> (seconds)                            |     39.44016666666667 
>> |                   -0.71% |
>> |                                    | thread-pipes-1 
>> (seconds)                                 | 0.17550000000000002 
>> |                    0.66% |
>> |                                    | thread-pipes-4 
>> (seconds)                                 | 0.44716666666666666 
>> |                    1.66% |
>> |                                    | thread-pipes-7 
>> (seconds)                                 | 0.7345 
>> |                   -0.17% |
>> |                                    | thread-pipes-12 
>> (seconds)                                |     1.405833333333333 
>> |               (I) -4.12% |
>> |                                    | thread-pipes-21 
>> (seconds)                                |    2.0113333333333334 
>> |               (I) -2.13% |
>> |                                    | thread-pipes-30 
>> (seconds)                                |    2.6648333333333336 
>> |               (I) -3.78% |
>> |                                    | thread-pipes-48 
>> (seconds)                                |    3.6341666666666668 
>> |               (I) -5.77% |
>> |                                    | thread-pipes-79 
>> (seconds)                                |                4.4085 
>> |               (I) -5.31% |
>> |                                    | thread-pipes-110 
>> (seconds)                               |     5.374666666666666 
>> |               (I) -6.12% |
>> |                                    | thread-pipes-141 
>> (seconds)                               |     6.385666666666666 
>> |               (I) -4.00% |
>> |                                    | thread-pipes-172 
>> (seconds)                               |     7.403000000000001 
>> |               (I) -3.01% |
>> |                                    | thread-pipes-203 
>> (seconds)                               |     8.570333333333332 
>> |               (I) -2.62% |
>> |                                    | thread-pipes-234 
>> (seconds)                               |     9.719166666666666 
>> |               (I) -2.00% |
>> |                                    | thread-pipes-256 
>> (seconds)                               |    10.552833333333334 
>> |               (I) -2.30% |
>> |                                    | thread-sockets-1 
>> (seconds)                               |                0.3065 
>> |                (R) 2.39% |
>> +------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+ 
>>
>>
>> +------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+ 
>>
>> | mmtests/sysbench-mutex             | sysbenchmutex-1 
>> (usec)                                   |    194.38333333333333 
>> |                   -0.02% |
>> |                                    | sysbenchmutex-4 
>> (usec)                                   |               200.875 
>> |                   -0.02% |
>> |                                    | sysbenchmutex-7 
>> (usec)                                   |    201.23000000000002 
>> |                    0.00% |
>> |                                    | sysbenchmutex-12 
>> (usec)                                  |    201.77666666666664 
>> |                    0.12% |
>> |                                    | sysbenchmutex-21 
>> (usec)                                  |                203.03 
>> |                   -0.40% |
>> |                                    | sysbenchmutex-30 
>> (usec)                                  |               203.285 
>> |                    0.08% |
>> |                                    | sysbenchmutex-48 
>> (usec)                                  |    231.30000000000004 
>> |                    2.59% |
>> |                                    | sysbenchmutex-79 
>> (usec)                                  |               362.075 
>> |                   -0.80% |
>> |                                    | sysbenchmutex-110 
>> (usec)                                 |     516.8233333333334 
>> |                   -3.87% |
>> |                                    | sysbenchmutex-128 
>> (usec)                                 |     593.3533333333334 
>> |               (I) -4.46% |
>> +------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+ 
>>
>>
>> No regressions were observed with mm-selftests.
>>
>> [1] 
>> https://lore.kernel.org/all/679861e2e81b32a0ae08.1264054854@v2.random/
>> [2] 
>> https://lore.kernel.org/all/1421999256-3881-1-git-send-email-ebru.akagunduz@gmail.com/
>> [3] https://lore.kernel.org/all/20150123113701.GB5975@node.dhcp.inet.fi/
>> [4] https://lore.kernel.org/all/20150123155802.GA7011@node.dhcp.inet.fi/
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>> Based on mm-new.
>>
>> Not very sure of the tracing parts which this patch changes. I have kept
>> the writable portion for the tracing to maintain backward compat, just
>> dropped it as a collapse condition.
>>
>>   include/trace/events/huge_memory.h |  2 +-
>>   mm/khugepaged.c                    | 11 +++--------
>>   2 files changed, 4 insertions(+), 9 deletions(-)
>>
>> diff --git a/include/trace/events/huge_memory.h 
>> b/include/trace/events/huge_memory.h
>> index 2305df6cb485..f2472c1c132a 100644
>> --- a/include/trace/events/huge_memory.h
>> +++ b/include/trace/events/huge_memory.h
>> @@ -19,7 +19,7 @@
>>       EM( SCAN_PTE_NON_PRESENT,    "pte_non_present")        \
>>       EM( SCAN_PTE_UFFD_WP,        "pte_uffd_wp")            \
>>       EM( SCAN_PTE_MAPPED_HUGEPAGE, "pte_mapped_hugepage")        \
>> -    EM( SCAN_PAGE_RO,        "no_writable_page")        \
>> +    EM( SCAN_PAGE_RO,        "no_writable_page") /* deprecated */    \
>>       EM( SCAN_LACK_REFERENCED_PAGE, "lack_referenced_page")        \
>>       EM( SCAN_PAGE_NULL,        "page_null")            \
>>       EM( SCAN_SCAN_ABORT,        "scan_aborted")            \
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 4ec324a4c1fe..5ef8482597a9 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -39,7 +39,7 @@ enum scan_result {
>>       SCAN_PTE_NON_PRESENT,
>>       SCAN_PTE_UFFD_WP,
>>       SCAN_PTE_MAPPED_HUGEPAGE,
>> -    SCAN_PAGE_RO,
>> +    SCAN_PAGE_RO,    /* deprecated */
>
> Why can't we remove that completely.
>
>

