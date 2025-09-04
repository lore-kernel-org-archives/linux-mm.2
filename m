Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCFE6CA1014
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 03:57:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4165B8E0001; Wed,  3 Sep 2025 23:57:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EE5E6B0008; Wed,  3 Sep 2025 23:57:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B5978E0001; Wed,  3 Sep 2025 23:57:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1D86F6B0007
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 23:57:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D615686883
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 03:57:09 +0000 (UTC)
X-FDA: 83850207378.17.60F8D45
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010024.outbound.protection.outlook.com [52.101.69.24])
	by imf08.hostedemail.com (Postfix) with ESMTP id B483C160012
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 03:57:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=S96iMxVB;
	dkim=pass header.d=arm.com header.s=selector1 header.b=S96iMxVB;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.69.24 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1756958226; a=rsa-sha256;
	cv=pass;
	b=fQqizPDcWffQgHVdgrVBNPGGRwasj/mQ+4o5oFYICMQblHSvPRu7ZFDNpyP6K+ZYQZL7SY
	BnKU5pdMjZvP6y7O6dN/hcN6qUrOF6Eeen0GH5xdz+XYrk8qkRy3lrXc6NsrjP0tXFBBPs
	8I6L72SyYpEMrbZd6DCo6xR07eJ9F+o=
ARC-Authentication-Results: i=3;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=S96iMxVB;
	dkim=pass header.d=arm.com header.s=selector1 header.b=S96iMxVB;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.69.24 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756958226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y3DRF+EHYdWm6tkYcBs3J2TZPgwPUATB77CDyLnOPJ0=;
	b=7fwfCdlIuogtjop5rqJXcIIwQgM5vokQjCZC9hsM29RAmyIxI/uVF5f2m1wRFZMOB/fHTK
	J2X5yM82ShaBbQorC/I9PfGT6KPxcC55e0dovQaxo5cnpXewHezUUPGHjzduNZiK3fH9Tz
	tEsb8QzJwURHvo96AbCgBpjPC1cnAWg=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=CkjvcRD6qSF29/0215UIv3Di0Bpxu2unJonZChPJ3VKX3YmRY+BfkZ4sHhHgeOCD2lxS6XLAW3RKc9m9fVlCJp/zFZ93KqY3YRU6nNpOGu9qHtzL/cD5CoTOPF9/WoVXVMYBmUSchKto1087TLSL48SOsKhMXPvJATr/lQLv7pophZK9+VH7k2Dw/tkClKj15wU1DLgQsI/mFoPc1NGIn+UC8D4qzMwhyDFgGK6CJDlk9NfLbVIsDKwHCpM9TK93ZNcIAF2yGsqL/n5Q+ZOAzvhJLTnTsrrR7CwXH4UpPXiZiEQDDmWQOwjSDnPVVUAs0mRJGAfgxemp16MbwRgASA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y3DRF+EHYdWm6tkYcBs3J2TZPgwPUATB77CDyLnOPJ0=;
 b=NVbXY0z94Ad8kgiz5G2zawX1iTSxihlOQs9RY9HwmU0AGwHWjznFExCCzHUoTgNOgNdFaZBxtu647MQYvYyEn1J7KFyo2mbM61PbraZcG5NROXj0vuhu16tajOZHshXsTGLTUTxK4Vn5TvDQXmHdQIFbElYS1Bg6bNcUphH2Rz33yx7jISBfNhtODvL0dfHwsnA/ObCqGUrSM/DXJ0vTzBMlK7LLzmiMuxCuKEQjPV8QolAGfxtGO4D1ZmlYHzGnCkQw9RICL7AwfceeOd4IG4i0oA1EBM0y7COoB8Xve0jEK4sbEUbuBiVqPU/snKB57Oen4H2GFPrYhmAcXm7q7g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=oracle.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y3DRF+EHYdWm6tkYcBs3J2TZPgwPUATB77CDyLnOPJ0=;
 b=S96iMxVBge2e43x4MyzsRtZJsl3Ppzzn3Spae+VlZtlrRtFBt4fCCpESrzFoUdaIuTSfDAmLo5Mn/zID1kVuvoRNomdbOpqwavanLEtrradoWL3apKR1wPgnJG92Z6yHTwzOEjAZtAWEv1a3/LWtp3mP+TieitPyJqvwCJiR6lE=
Received: from DU6P191CA0016.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:540::10)
 by PAXPR08MB6654.eurprd08.prod.outlook.com (2603:10a6:102:15e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Thu, 4 Sep
 2025 03:57:00 +0000
Received: from DU6PEPF00009524.eurprd02.prod.outlook.com
 (2603:10a6:10:540:cafe::18) by DU6P191CA0016.outlook.office365.com
 (2603:10a6:10:540::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.18 via Frontend Transport; Thu,
 4 Sep 2025 03:57:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009524.mail.protection.outlook.com (10.167.8.5) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.11 via
 Frontend Transport; Thu, 4 Sep 2025 03:56:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iutddq5uU4K7wzv4lZ2wLhX+7G9+ZK2SZgKdmT924bgR30QPEZWUWpG0atYfzfqSX9WSZ6VzXnWe8gSBRrLBXoayP39omqWkHm713GMYe+hknvBI5qavbSOxf3ThWv0Go9SECS7D3OpWDmLJGVt1zxvUYCqRrBQhvnK61PHsxwDrYdC2EAEgupSniRzGyH9ZMygVc8cUbG3sLQVsz0HCpXaC2LS8xrt03zUkC1oUw+dWRRP+yPrGYAoyGJHt/5ZYcF/C+VQuVF3imaas1fhPdJFaTvlVI1TV0fNYWTCW653CO1D+/2KR5a+AkKg8ynKoWIurKJDS4KMchNSzLaLLMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y3DRF+EHYdWm6tkYcBs3J2TZPgwPUATB77CDyLnOPJ0=;
 b=DKw9KvZnvbIxYuIjaohvSP7/pzajxX7c6wuMLmUUgE2PpARtKJdQKMn5LW4PY4t9AYZ5z5q/324R3TyxW0m+wmSzjAWofI2AcDVt5yupC3YYq2FiGk0N/wzn9fB7CQ2XOzIx6IEIV+joGMJLcrp4I69DeesPiz2GTjHA469QaC6A2Y3mzdSCJsDLbUwD5Hqz3Pwa0f9jMLM+w4YEhe6vQPweXJHn4ozdlW+cFKJwVXhuMVwX0J4qtrb+BTb4nbWpV+Z/QVmvZra8h0nRfC5M5ifd4Yld1hN2XtnjMEzkNsRjFheGc1SzMciJXG7SbXOduRqDmHBd2vG+P0dgU20mxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y3DRF+EHYdWm6tkYcBs3J2TZPgwPUATB77CDyLnOPJ0=;
 b=S96iMxVBge2e43x4MyzsRtZJsl3Ppzzn3Spae+VlZtlrRtFBt4fCCpESrzFoUdaIuTSfDAmLo5Mn/zID1kVuvoRNomdbOpqwavanLEtrradoWL3apKR1wPgnJG92Z6yHTwzOEjAZtAWEv1a3/LWtp3mP+TieitPyJqvwCJiR6lE=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by DU0PR08MB7946.eurprd08.prod.outlook.com (2603:10a6:10:3ca::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Thu, 4 Sep
 2025 03:56:26 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9094.016; Thu, 4 Sep 2025
 03:56:26 +0000
Message-ID: <2dec8949-51e1-47ec-b484-d3e7c640ab89@arm.com>
Date: Thu, 4 Sep 2025 09:26:20 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: Enable khugepaged to operate on non-writable VMAs
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 kas@kernel.org, willy@infradead.org, hughd@google.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250903054635.19949-1-dev.jain@arm.com>
 <20250903080839.wuivg2u7smyuxo5e@master>
 <0a52cb54-5633-4374-baa5-199194dfc2e1@arm.com>
 <3bd9ff5d-de8a-469f-a7b0-41c192b23993@arm.com>
 <99f8cb5e-828a-444c-b207-2a12e13a45f5@redhat.com>
 <6f5db204-d606-4f7e-9075-29ccabbf927e@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <6f5db204-d606-4f7e-9075-29ccabbf927e@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0061.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ac::18) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|DU0PR08MB7946:EE_|DU6PEPF00009524:EE_|PAXPR08MB6654:EE_
X-MS-Office365-Filtering-Correlation-Id: e94524e1-dd02-4a3b-e492-08ddeb67199e
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?eGx2VXJwV0Yxblc5NTNLZU9oZ29SQk16OFpaazRXQ0hXMFk3dkFKRjhVVW5l?=
 =?utf-8?B?Z3M4ZnAxUFl5VndGWXhGMmJQcDhxK09TbW93cHVsNHRCMHQ0RWtpRjRJMmZ5?=
 =?utf-8?B?YmpGei9QN1dEMFJjcTBMSWZjVVRlREZJU1VRbjA0d0V5b2dJbE8wNzRObElR?=
 =?utf-8?B?SWdiVFVhS0JMQUtPb2dQMlRQOU1ZbkZMbFpjSU9GeDVoemFwanVLdXZMNGl0?=
 =?utf-8?B?YWZ4MXZGdjluTjFjQnFlT1Vlay9FTzlSeW9VS05SNVJGSDJvUmhqTFNiWVJl?=
 =?utf-8?B?SnVWWmIzdHVoa1ZEcFpwVmViTzFCeWYyVENJaFV5clVTT1haM0x1Wk82Wjhy?=
 =?utf-8?B?c3o5L0g3eGRiSzVZR1dWNEpkZHF2ZTl1eGp3U1pRVlVIdERKeHdPd1N2WndH?=
 =?utf-8?B?a25YSG5zcEtoMVdlNmp4UW5QOXZTSG5Lei9xcjR1NnlTc3VOaW5EOFh6M3FB?=
 =?utf-8?B?UjVxa2FNd0sxSU03M2tteWdZeUpGS0pncXhzVHVqT3ZwRWVLK1p3cFpOVTB2?=
 =?utf-8?B?ZnMydVh4MEpyOWNNUzNOLzdJS1pyM0VxZ1N1Y25ReU8xc09YVUxCZ05iajNT?=
 =?utf-8?B?S0F1Y1Q0bWtYVXJYSzNNWkpGV2hLTFFTL2RjRXZWMUdJOFlkMms3eHpVcGE5?=
 =?utf-8?B?WmMwaVluMW4zTk8zb0FRbjgrSUkvS1dkZytMbDVKQVBZNUlQbSt0WlRySXJC?=
 =?utf-8?B?blpTQnVEcENuZ0prTWhtNytLNko0TEdxS2xKSW9TWUpGU1JHaVVoajRJRlc5?=
 =?utf-8?B?TFA0ZHRvckd6QjVyWEZjOFVHaHdGbDUxTkdqMlArM1FYRE1iK0RRY1I0eUJv?=
 =?utf-8?B?SDhEbzZwMmZLRnpmSFB6T2JqVVZNd2tTZjcxc1lxMUFaODFjbDJudWk0MCtW?=
 =?utf-8?B?ZlJaWDVUanErRU1nL1FRcGh5UW1Ja1VweERpdW9mOWZyMENiZXI3T3o4WVA4?=
 =?utf-8?B?Z0xjdkV4SGxpem9sSldFVkRBRjFaazZwM0svYjV4M0c2QUVyYlc3d2tvWU9i?=
 =?utf-8?B?bGV6VnBLRDhQa2dYZ00rcWFUK3hSOERQSm03OWorby9CaDhnQzZadyt3VEdR?=
 =?utf-8?B?RzhMMmNlR0pQbGVxcGFGMzM2Mk9KalpRMGR6NnFtWHY4UDdTdmk1SnlMYUpz?=
 =?utf-8?B?UDJQUXFQUDNvUlg4RHBvTFZQVzNaSFNaQWRRVjZkSjVXUWdGdlArVmZndHZy?=
 =?utf-8?B?VXIzSmJ2TCs4TWpid0p4ZlFYaFh3aGZvV1RzVTJNcW5jd0x1c0VPdXFhRXhk?=
 =?utf-8?B?YjJ2bCtXOVhLRlVuNTZOSkZJRnF2dEpjckNIMzVBN3B0K0R1NHd5d3FsdGJZ?=
 =?utf-8?B?Qyt0TjNML0sxUjZ5Qm1hbFdQd3kwK2w1a0UyQVBSdno1b0J4NThwQlIzU3BK?=
 =?utf-8?B?SG5BWW5BTDlJZkZpbVBtKzJqYmR0TFZ1UGZtNFdidi9FbFljOVNYU05jSnZi?=
 =?utf-8?B?VTQxaEQ4RFBaeXJ3TXNjZElXeHdTTHM0S2ZwK0E4ejJvTDRIWkM0UmZQbFIr?=
 =?utf-8?B?ZFo0S0l2TWxNMStpL3RRQklKaVNGWmRvaUs3Q3JZdmp4U2hyOHNrVWVKZk5w?=
 =?utf-8?B?UE8rc1grVDZuaDRveEQ3SHp0WFIxbG1WbGZjSjc4K2NacjFUY1MwWkQwVzd6?=
 =?utf-8?B?b0ZoMmtkYnJNMVZxTDV6bVpEQ3pzSFRWL2w2cERlOCtscWU5bWJHbHgzL2Rl?=
 =?utf-8?B?N3NSb3NGNFdPYlE5ZTZDTDIzZExOemhnekhCdnJERUtoaFVzQmZxVzNPelRl?=
 =?utf-8?B?amNKTUd6VDU2MXJDNTIzN3MxRHRlempFZVFvT0lVWEtwWUxLMStWYkdpMmZM?=
 =?utf-8?B?UG5kK0hldGovUmhwR3JEbzZDR21UTDFKRUw4VnE4S0tpYTYwVm5lTDlGQVFM?=
 =?utf-8?B?V2hLQ3JzdXVnRk9HRGk5M2xrTDJiVmRxcS9NSXVYMkhsQnc9PQ==?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7946
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009524.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c6ee6b65-7e47-48af-1bb7-08ddeb670582
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|376014|35042699022|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?REwwRElSbnFWVVVpYlprS2Zxb3B6b1d3Z2QyeUd0azM5Y2pnSFFwUG02SkZ6?=
 =?utf-8?B?U2pmYjN2MDJua2lCOWhpcmhGMzhtMHBDTEd6ZytqR0o2THhaQ3ltZm1wSCtV?=
 =?utf-8?B?Q1dLc2xBcFNsSUhKc05JNTMwbmNpVHJEdGFZVnZ5SDJOdDVETFBBUDBEeWJM?=
 =?utf-8?B?anRTZUplSStyc0lNSkIxMmpYYWdJbUN3dk1pakpRQktxUmFYU3MvNkJVZWhL?=
 =?utf-8?B?dm5PT3ZTeEQrWWJlRlNCdDQvVG5aVXpYZ2owRTk2WE54TTkzdHJqWVBkVlFX?=
 =?utf-8?B?Sjl5S1NDemM5ajEvTlZKZXpGTFFUWDc1WXFTc2xVWXB3bENZMHM4dWVraXl5?=
 =?utf-8?B?T0dpWVdpeWRidjhMS3ZTS3VzdFBFRE52a0VlTnZ1L3JhRG00VHdyK1E4a3VK?=
 =?utf-8?B?cjFYd0twQTZRVzBQKzZOSlRRa0xXMDhxc2VNNUkrU2c1c0ZhQUFKR21JQmR6?=
 =?utf-8?B?YUZWRWVKZEZiRVZnNEp6QUx0bm56ZHQvWWhkY0l4U00wdlY2TXRzSFZjS1ZL?=
 =?utf-8?B?R3dlOUUyUmRjL2p1ZHozRzFqL0lYcHF5cUVTclJ4Yk9xVGxydTNpUlFrcjcr?=
 =?utf-8?B?MWE2bE5FUG5NdE51dWNXM29VNGNNbDl4TkZEaSsvSGNQMlNNM0Q1b0Y2R0Jw?=
 =?utf-8?B?QUhvbUxoME9LQXRKUlhOenlqSGNNMWZIaUtydXJheFJhWVNkZXNGQXlidVAw?=
 =?utf-8?B?SWw4aGlEd3B6S0VPekpVK3hxbk11SWRXWTl3azNxQmdOWUxjMW5BU3RaNC8v?=
 =?utf-8?B?K2FTNXJ4TlFKR2o1NnY2SE5SL0FOSzdaQ0Z0cVhTbDBKT2s1bk1QSUFnOUFQ?=
 =?utf-8?B?ZjFlQ3E5SkNwVm8rbmFaWE9ycm9PWXVVelNzVlBkZDBFUVVIaTVKS0pqZlhy?=
 =?utf-8?B?N3VIRVh6TXdEUEl6a1I0UlNWWVFjSWZjK3ltSkk2OFJHbVF5TUg1eEpncnI0?=
 =?utf-8?B?L0VHWm5OQmNoVENTSGRIekZjRUdwcVAvWndDLzQvVFVKVTRTbW9uMHpLMFZs?=
 =?utf-8?B?bExXTkVsRTZnVnh2eVZIQXIrcEs2N1FxL3JkN2dkZTF4NFZQWGI3M2UzaG5l?=
 =?utf-8?B?L2VRS014NENKcjlVZTlBUFNwU05KMjlrN3dBL1VBMzZPMUkzQVBoNHhZSVpH?=
 =?utf-8?B?LzkxajlSK2lRS1RFSVFwMy92S1ljbDg5MHNWV1JFQVJJL2YvRlViTXRiNFVt?=
 =?utf-8?B?NU5lSHNnNytjZFNZWC9KZEZwV3ZFajJZaVIxeWthaVJFZnFXUSt5N3BPWE8w?=
 =?utf-8?B?dzFsb3dQMWxpRUw0amwyd1lBYWpqTTJDMHdWSW5xU2paelNvZFkyTzlWeWZz?=
 =?utf-8?B?cUIwcmZPWGY1NFhhVjZSMm5CTTVDN0VkWUpSdnY1K1lLWXdPZkhVcnFzaHRP?=
 =?utf-8?B?dkx4S1lWenJTN3Z2aVd1ampKK0pocmVFZEdsN21DNFFjdzg2cTVkWEY1MzFq?=
 =?utf-8?B?VkJrRmxqc0xIdXd5V2o4SVFtVjNFVTFUMi9wS29nZUFXb2VzMFdFeWRESUNE?=
 =?utf-8?B?dThGNDFJZ21DWmp1cnVDUmQwRDlUaHRSeDhKMmJRRERFeTNOSnNTazdjZ0N6?=
 =?utf-8?B?cmJmVjdCcHo0OU9yb1c1ZTBxQ2R0cWNPM0oxMmF6QVpwODMyeldBVXkxOTlT?=
 =?utf-8?B?VmVNWHE2OXI4THNVRjJ1T2FHRlFiSEptYTNSdXJLR3YyR2F4NXhRSHZQbkZH?=
 =?utf-8?B?Nk1KNFhYZU80YTVOQ2t1Vk1LMFVWYUswaWUxWnlOOEwzSWhnL0tMZ1NkbllN?=
 =?utf-8?B?bmw4Z2lvcXFTbWFXWXFWTUFhNEltcWdVTTd0anlJU2pBZkJ5VTVLTlNWODRq?=
 =?utf-8?B?QzhtT0c3RGVidS9aZ0JpWjF3VzNETEU4VXduelFmcGRzeW9wY0ZUYTltSk1w?=
 =?utf-8?B?MU5SRnFDUVZXVWdZVmJrQk5WNktVVjZBNkphdFAvcUtVOUpqZmt4bUc5RDR4?=
 =?utf-8?B?UXdWUm91Q0tGNVdEZnc2YnZ2VG1rNnYzTWcwRk1XK1ZYWkZHczh5Slp3RHpi?=
 =?utf-8?B?Q2NoanVFMGJDVUdjNVdrUktJdXlyK0ZPVllIYW9SMnVYdGVsQ3RjUGU0ODMw?=
 =?utf-8?Q?t3BbI2?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(376014)(35042699022)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 03:56:59.9495
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e94524e1-dd02-4a3b-e492-08ddeb67199e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009524.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6654
X-Rspamd-Queue-Id: B483C160012
X-Stat-Signature: bahssuzpms7xdgnz6deybf7d6onrofti
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756958225-127140
X-HE-Meta: U2FsdGVkX19pqw6qc8brqkzfjqaA22gPsPpg2qVXudoOFUCfBy9D7U+/Xw0UaTuDKVnHqnVWv2P2T/+SlhBIQKTFw/svuqfqtRcg/aOa5W++ncw4BBOfritTOvIeG+h9fJ8us9XYf6PCxseVt5oww4WVQ7FrihYuKowg7sJsXvmYKLX7Jc6d80N/5LhodX1S6gtTVvDsgG6lilT5fI0sFz9uxo/Q7pBabqeOu7eRwIR5sRJvjgedfLCzygOo+hYus/DjMhG6HYci1rNrUbO91V47ikIzAP6HJBp7X67BQSL9km1ww1YmC84Kg0jzm2ireYmt03Xb912EBmERKI027ThsxlFLy+K2+CBrzQeZBcyBNOawPBCE1u5hNlAPwyJMunBPDXTe7rv/iRba74FgPofs6vNAt+ilTO+n9I9C/4idtaNLU5YqHDj89A85SJRJIES1clhgQQQwdiH5C4Fd76e4pogLVXziz2PAosZPfB7kUMnyj/DiTAifHlKvg3r/8y9R58lD7Om9quHziMuhdah1EVFNAhWWcxK1HkMlkDq10Fia+q/ud+wQQqITKKyX6E2q5poYJCjEHW6g1dALtc4joWFkQvQo+FF4ocluIGJsy5252Dp7n1OuIEtPthIhSAMbjWVLb1BBZBAsUzZ4XfsH845mRrhXkEskw3+LjE3BgWas6PM6J55q/QMgFTeJGst7rm/7n88FlPOUpWFf6ZFNUn9VvW08kq/l1Ish2qW0MyYpXK3nm6zUNsxuf+IVoKkw/Jp8Fg+hPtC4gvjykJIgo/8juYkFvFtHKus9HHIbI8x24RrbbcdxLDZ12QDuLoPUoqDC1IvVEBlDZ83j62ihPV7zaA9vCsdBNP85ZPxhSfEvN4nnnfEyS21iiEZ7LgnG0ip2i8dW428ACE1DsoCNQ+lcS0DClOERebKqLn6hndXOXJ9H5Sh2usEhbjp4CGu6ERItLK0KEMXBKpj
 Bd6nw2+r
 TADfQaA29WZRJUxB3zHfw/Tgy3B3203IUUvftb60J/yUkxqYjVRSNdlHgbHuUCy/x6z72eHvhMqG1DqVf3s0b1f+gbXAhyG7bhebGARyCK1yNylsPdfyDi+CP+Mkn4CVDLrfNjmQXN031j0Dm4poSHGeSmxEGG3qvXVnk+l60NHBTPqwmej0tdhsmaMsPQJ5EmhhMS5QjbeL/Vs6elFSK6LOExGtlfO3viM66rImvPm4AWOfzhsLgoN3cRpyKGlhPVqg1muqIK4ja4sYYAbv310AsOEGwKi5frjg8bvUWU6hfknomBcgj8Ks/OqlSU3s6iqpbtby2FbsjXB+iaMVNs3Gtencn5gSuGut4ymjjVxPus04f3uEuDj/o6gI5vQ9Lmjdu7KBdbWpwWuGtTO3T654xwPxJvftg8eOH/8CzczYgfV97cTt+XxhXbRL9ijL7PsX/FY+9QIWkBw0v23wGkhyf6t7zTBX3Md3J9YofCllRVmKhtpbJclkGGFxh0YvJJj9JRIIouwLa52jFqmIPfWFkMoX1nK3MRsgjQUIC+Abcaq9UB7FcE5k1R5lJi8rt32lddpY/Q/yyKRSw4isHxAh9GFNgTg2LRXlEoNdHwsdNpPTPvOdllxYlq38r+R8fVGnH+UUuZUcXNlwPGvNZ/074NktcdSYdb0Tq2fPBcyPZm323oFK8suinvLlocMDFnMwy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 03/09/25 11:55 pm, Lorenzo Stoakes wrote:
> On Wed, Sep 03, 2025 at 11:22:09AM +0200, David Hildenbrand wrote:
>> On 03.09.25 11:18, Dev Jain wrote:
>>> I meant to say, writable VMAs with wrprotected ptes. Maybe after this
>>> patch, people
> So, I think you really need to update the commit message here to reflect
> that!
>
> And of course, do a cover letter :P
>
> The test results would probably work better as a cover letter as will be
> put in the first commit by Andrew in any case.

Alright if that is the concensus then I will soon post v2 with cover letter.

>
>>> can finally make some real use of the max_ptes_shared tunable :)
>> I hope not, because it should be burned with fire, lol :)
> +1 :)
>
>> --
>> Cheers
>>
>> David / dhildenb
>>

