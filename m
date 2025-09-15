Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD092CA101F
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 04:06:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FF4A8E000A; Mon, 15 Sep 2025 00:06:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D73A8E0001; Mon, 15 Sep 2025 00:06:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE09A8E000A; Mon, 15 Sep 2025 00:06:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC0D78E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 00:06:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 891EFB97C8
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 04:06:03 +0000 (UTC)
X-FDA: 83890146606.29.B42551E
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012054.outbound.protection.outlook.com [52.101.66.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2BCDB40003
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 04:05:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=WAHK8RMq;
	dkim=pass header.d=arm.com header.s=selector1 header.b=WAHK8RMq;
	spf=pass (imf01.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.66.54 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757909160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4McCdrUehQ8z+d2CuK5jT+Ill5N/6hfsJ14hKO4US8w=;
	b=a8UvTdfFkrX0U9xfoW6sk28q4kY3PH0kSd1qVP7iP7jhaS8qSyG2rpe/aoOvFSEO/e7XsH
	iacBj+/1UTtvze8tp+sUuuATc6tZ5kHuBpXRYvJPyZrHyfUUXV3XRatE+g3s+3wbaajZw8
	2rcBvyErolSNFUDX0SJGlvscZ34uNCA=
ARC-Authentication-Results: i=3;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=WAHK8RMq;
	dkim=pass header.d=arm.com header.s=selector1 header.b=WAHK8RMq;
	spf=pass (imf01.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.66.54 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1757909160; a=rsa-sha256;
	cv=pass;
	b=emER1MgVMXHGnBCQ7+gSjgofgTfZxmWrApB1cqrRP0Qu/4UbSlGx7DvAnWUfh+c1YVTELp
	DuNw47K9PM+7BMnCxogDONn5oc/kPpYol0sLc7mvcrL/Ox6SSJCn/VEttyM9SlygS3nMhS
	PGWBd9QN56fDWBlekLYdF8I/MQsJjJ8=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=cRJ2LSo+8WnosnGSiPRb4spl0lr/bUaXJUwQ9i4u6+DoMzzlhbHRbLJdBRQdAnLr5UB8QfY03fZgfv6fiNUEbGwNXGz2OTDOjJTrjaxcfXXhqS8zwrsdOYzLMsdMWdhBs8IyP6ejkMy7Mmk1fK/av7Y/l/2Z6Zvc7aWhTjuUr68mID7J5XiI0ofVKS2/swZJ0lNNYyrVWpkNTwm8Ci1xAG3XEkRDXifsLQ8AQvCM6o0epLfScfFSTCLnO0xCl6xLxCR835nOca81p5qADvImJUIfbJ6dNEnkJw0oTEmuPrfXl2kpuRBFR/DFBQxCpCnop2LTr20nElu3i3CXGxublQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4McCdrUehQ8z+d2CuK5jT+Ill5N/6hfsJ14hKO4US8w=;
 b=Eyixc2ocZWBOY01EjBHgMdHZAaxiR8Yma+RT86luKiEhIiv4c733T4/GYOPTLVkGvKFzPY8K/vPL3d9qQ5Z3uLGRfn76hVs/cQ55+KHFtgwHe9BHDClWu861ZPIrNDZ0g/JKSBH4MXikpbL2FbToTJPviLrnUuzsSTHR8KYN3d2fPPoZvaTsrhJIY21fUkN5qpGnR8iI71EJyxF6GqoU8jitQGeO3zVojOJQ8mw5ubmCi2YDKrrIhXubueAh5n1MA2ql+0X3mzpIlX2GEz2Gqk7p1sCpSwVV8w/KbCQPmat3xibrfu1PVrLlE/PGSOlapKr7kor8QY0TZJFXnFvlEQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4McCdrUehQ8z+d2CuK5jT+Ill5N/6hfsJ14hKO4US8w=;
 b=WAHK8RMq0RZhF4MT9sPf07bJ8cDaVUSB9LcCAN8YuxfpesiCRGuFMWrGUHjIw4Dg5tNcotvETMZ2h1PJuCtc7rzN00F9B2L1jrt0gqtuXadK46lLpBLjvfuzDft4l3cDYeJN6fuMpqVgfQYQvoq3eDsghphduXHWJszW4lWU8hs=
Received: from DB6PR0301CA0092.eurprd03.prod.outlook.com (2603:10a6:6:30::39)
 by VI0PR08MB10758.eurprd08.prod.outlook.com (2603:10a6:800:1b9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 15 Sep
 2025 04:05:52 +0000
Received: from DB3PEPF0000885A.eurprd02.prod.outlook.com
 (2603:10a6:6:30:cafe::92) by DB6PR0301CA0092.outlook.office365.com
 (2603:10a6:6:30::39) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.18 via Frontend Transport; Mon,
 15 Sep 2025 04:05:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885A.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.13
 via Frontend Transport; Mon, 15 Sep 2025 04:05:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aH3OCu+Y8YIJ28rl8g9ZFnAeiJ0ULKIqM4IGy/RkQF0Y3AEkB+vkLcO6jQXC23JBycXKkJ4H2VnkzGaR1YKLhHAubk8LzKEhryHNqIt1EZxxJH0usF+1b7gZ5qtkB7sqlmZ/p7YlJkeDRgXTewciOB13Tux5sJ2wXqR/kK9PrIVMOdmojsBwWDLA8iS3ilFasPHysDysOmVGZtPHaMbzLPTHDxQguYn4mjPIDY3OTRcaQNngCUw35c6ZbbgE0sCdaP5wIM6Ahw1nvrLf3bc6ARoHT/hw7GSxrWqDbApOIbVkvaBeMX7cQ4VwdOWgiE231/eGypriZhlMimUZMcKgtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4McCdrUehQ8z+d2CuK5jT+Ill5N/6hfsJ14hKO4US8w=;
 b=JRoFwuL7hzAB0D8MPRJsXmXE1VfyBZ2nbYWPYseJ1kxtRcY4AvK1En2mmZWDAdXqFjjBDWXuLW0rGzWenpQtK6hDBQltXFfDcJ/UWo3x0xQZsgiAZ4XRfgBX5iZZEQjyyorLy5/0SEfaWUCksdPOhWfHX4Y7AJdlgzNFf8pBZkuC1TFp8Pn6BqQqxmjD3RFARzZkOZFZUIJgXfVnG5vLZuy6JQsJE4RfPnTykC+tc5C/oPXdoSHPBbA3/x2aepLcM7N6mlt2Al6LenS3SgKDIgiqr251wiXbVIt/ph9tSe/PDVID7wNG1WmjrbJVh81aj807NzOqONY4tX1P0TaXKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4McCdrUehQ8z+d2CuK5jT+Ill5N/6hfsJ14hKO4US8w=;
 b=WAHK8RMq0RZhF4MT9sPf07bJ8cDaVUSB9LcCAN8YuxfpesiCRGuFMWrGUHjIw4Dg5tNcotvETMZ2h1PJuCtc7rzN00F9B2L1jrt0gqtuXadK46lLpBLjvfuzDft4l3cDYeJN6fuMpqVgfQYQvoq3eDsghphduXHWJszW4lWU8hs=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by GVXPR08MB10987.eurprd08.prod.outlook.com (2603:10a6:150:1fe::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 04:05:19 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 04:05:19 +0000
Message-ID: <ecfa6136-2aa7-4365-b913-76099ddcfceb@arm.com>
Date: Mon, 15 Sep 2025 09:35:11 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mm_slot: make sure slot is the first element of its
 wrapper structure
From: Dev Jain <dev.jain@arm.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, akpm@linux-foundation.org,
 chengming.zhou@linux.dev, npache@redhat.com, ryan.roberts@arm.com,
 xu.xin16@zte.com.cn, baohua@kernel.org, Liam.Howlett@oracle.com,
 david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com
References: <20250914000026.17986-1-richard.weiyang@gmail.com>
 <ae30fc02-c573-46bc-a5f6-935f256149e2@arm.com>
 <cf5d6ff7-faa4-469e-9e32-b90c75b8194f@linux.dev>
 <463716f5-be12-4d78-9432-779e3f11460c@arm.com>
 <20250915015722.z4w23d6ralc2y7mk@master>
 <daead4f9-aa50-41bc-901a-8dfbdbd896c5@arm.com>
Content-Language: en-US
In-Reply-To: <daead4f9-aa50-41bc-901a-8dfbdbd896c5@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SG2PR02CA0027.apcprd02.prod.outlook.com
 (2603:1096:3:18::15) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|GVXPR08MB10987:EE_|DB3PEPF0000885A:EE_|VI0PR08MB10758:EE_
X-MS-Office365-Filtering-Correlation-Id: 6019bc21-4379-44ce-4972-08ddf40d298c
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?MVlscWF4aXJzLzBtc1VvZ3ZDOFhzaWxhVnl4dy9IVkRlMVhwUDdZb1RGNksv?=
 =?utf-8?B?NEE3YzFDZEV0aWtzT0VkYmxFQVZWRnJQQ2FKQkdxL3crQUNtTDkvV3l2RlRo?=
 =?utf-8?B?NS9pd0FSOVEwUjFadHhKZmFzL0QyWDFZZmFvUXNXeW4wSFZkL005MGRvbC8w?=
 =?utf-8?B?YmJRZ2xXdjZ3NDlzcnRLdXc3TTAwaFc1RGd5TFRRd1FsVVdlOGpUT3pMWXdr?=
 =?utf-8?B?bHB4cGRYV1RqL1RxMXk2NlhmdlZiL29qRlozYXBlV09sNk1IQWkzeks4dVdO?=
 =?utf-8?B?a2V2OFM3eWpONTlnYnhBRFRZTFRSVmN2MGloYzRabVROWE10bW9BMm9CYmdL?=
 =?utf-8?B?dnZaby85SXVocktyaTZPZkp1ekJXNGxKUUx0T1d0M3c0KzcvS01SdXFHSnZL?=
 =?utf-8?B?Rk95cTZOR0ErSzZVN2VmNXBrakN0ajRrQVVVWk9ydVBtcFl6U2UvaU9JNVht?=
 =?utf-8?B?NE9wNXJ1b2F5TU5DYXh3c2NLaWN5TkZtM1lzN1p4b1JMMVYzSW84dVR1aitL?=
 =?utf-8?B?YXFneGNRUi9QV3FTdk9VVmtaU3FWeGlrV2ZNUkhFcmw0WitIOGJwcmNHbXZa?=
 =?utf-8?B?OGlwR2w4VXU3NjV6MXVycFBOVmoyRlhvOUhiTjhFYTVtbDBFLytabGVyaldL?=
 =?utf-8?B?QW1jSTUwbkFSMHVBellDZzBCZGI5WmhZR1BBKzZZQnp4N3hlTnNtZ1cwcVdm?=
 =?utf-8?B?cVg0bEFDL3lMemt2VTdjVFkzVUpNK0pLaHF5anRDOXpoTTVwTm5wdkJYVnFq?=
 =?utf-8?B?enJQQmRlZ3UyY2JORDR2L3FEU1RWa3NwUzFnYXZuT3BkVjZ1N3N3d2pNWW5M?=
 =?utf-8?B?cTdueXM0RDFjNkxTRnlacVpteUNsZHRkVkJrK1VpNWhzZHBpczJVeEtFeEtQ?=
 =?utf-8?B?WkdGYmdGQnVmWExYaHdMWExvYTh0WjNHK0F6QjJQT0x0SllRSjg1UVhaNDBC?=
 =?utf-8?B?b1dYRzhkQjQ4dnFEdGh5Y1Y1MUsvOWF5Z1J2NVR3WkpiZGZPQ2RVVlVtYTdI?=
 =?utf-8?B?RGkvR0FPdDJGOEpvYjJ3dkk0S0VxKyt4bVFSU1lvY0VudUhuSWtuVVRTVFZP?=
 =?utf-8?B?SG5IWlp3emw1MktEdnZwaW9hVmRodWl4RHVBN0c1TlBmd2lOQ3FkbGFkU05u?=
 =?utf-8?B?U3JkcXNPZ0M2M25JMlFKR2t4V1NWNTJleVJ5TVIrR2RxUU56emU5aHZway9j?=
 =?utf-8?B?UWdra1pPdXBvejB5NFJUSEkzV0oyWUNrNFZNNkpBTU1QUjgrUXBYOWIwN3hC?=
 =?utf-8?B?bTZjQzZiZ3R2b2VMQi9aYlV3R3hmWXNBU1RDVDNMZDFMMnZEclVOSjNXU0Jm?=
 =?utf-8?B?NzU4VVlpTUV4QXBKSUVvQ0xabEJ0NnRHU08wMWxscUJkUnpBVmliTEYyenZW?=
 =?utf-8?B?QlVNaDVxUndYNG5MTDdQRkRhSG9jUWxWZDF1cEN4VzJUVzQzdWxjYWtVYWNW?=
 =?utf-8?B?K3daU2dMaVdtaVgvS1RTdzFIWE9WMjM4TEVpYjdrbUJhMkpvTzF1a21kdnFU?=
 =?utf-8?B?Sy9nUDZYRUdYcGlyOGFqU21keUFUNDlWRU91dTMrS3A4U1RPWnV6bmZyT0xp?=
 =?utf-8?B?eUl5alp3ZXorWmNOQVIwSy9uOWxaQmhZMTlRcWdKdi9Ya1B1ZmEwWkR0aG5E?=
 =?utf-8?B?aEt4cW5KMmRBV2hxcnhEWCtLNUpDQmtVQ2dsb1EvZExHWTJnekRMOVdWSHRG?=
 =?utf-8?B?MmdZNHFvdWtTUEVjRGdONXlsbTZndkFxWmlmNkpvdDlPVWFKYWRaTUMxV2py?=
 =?utf-8?B?ZC9uMFZiQkdTeTN3dXkvVE5xR0tsTmRoajVUN0JEU2U3TGEvdHVuTFlFSVhl?=
 =?utf-8?B?dHViclFKSVZWaElFWHZvRWFZNTZqUDI2NDUrQTMwTE5Bc2N6Z1lnMmkrcCt5?=
 =?utf-8?B?Q1g2N1hTN0tjK1VZMlNQZ3ZYc0ZvaTZJNzBRSXpUMU55VGc9PQ==?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10987
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885A.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6eb06cca-7653-48d1-6155-08ddf40d15c0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|35042699022|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L3Z2RDFMbGhwM1YwM2xnQUxVcUd4V3pnTzhBUWgrRlBUbHBMaW50SmlSOWpC?=
 =?utf-8?B?OTRBNFBQdjkxWE0wOXE3U005T3BNaXlQbzFubjlhaVRDWEZaZjFXR3RnTDQy?=
 =?utf-8?B?K3JHc1FvdWtqS2d6Zk5PNFp4Z0JRU3VPelpsSmpYYUlOd2VITlVpSG1zeFU5?=
 =?utf-8?B?TE1INTl6dnRHaDR4RlF0QlIxc0VrcDhEZWVRbkloTFJkTTV2WTJNQ0dJVVli?=
 =?utf-8?B?R2p3N0R4OTBpWUUybDVwclc2N0RudXduOFh3SjAzT1Zad1l1Skw5MVgrUVZn?=
 =?utf-8?B?dmlsME91MHNNQjdTeVJtdDJPbDRDWnNhY0dHeStRcWI2MGVKWm5oUjZjNWZT?=
 =?utf-8?B?WVMyUkw1d0d4bHI2OFV4eVVSRjNiUXovNTFsMXN3eXdWRmFka3RRQmxuUk1Y?=
 =?utf-8?B?MU10b2dlQm51OVp1QlVmc2pvc3NCQnYwemNVNXh4dElYejdhUWVBQnRpaVcw?=
 =?utf-8?B?akppMzRyaXdjN2lBRXZzSFJPZk13V1NRaUQ1RHl1ekRRMUJCSjZvRlRDeWdX?=
 =?utf-8?B?ckdLNzdUU0ZPa25QSXBWUDM4ZUJIamhtaXlGcElqUzNWU25oOUMxUzZEUHZq?=
 =?utf-8?B?ZzhHMHh4eVl3N29xT1FES0RmQ0dvVWg2N29FZFNlY0FBaW5yQzhEaVVkbGY1?=
 =?utf-8?B?QjV1ZDJjRWR4QlZENnFldXl2S3dnWDV4N0VXSlZETGNodFhjQWR6VVF0YXMz?=
 =?utf-8?B?L011OHVrSk5ub0hNakRLZ0IzRFJPWGk2d2ZQZnVBanQwa25hVXVzZnBManlj?=
 =?utf-8?B?U1l1eHhnTk8xZC82YjJHKy95aXZOM0xSTFNveG1JTFlPR1MwdURrUjFtdytW?=
 =?utf-8?B?ZURJMlVFbERqMklQeHlJZldkU0VMdGxNUzduRnkxaFVvQ1JVWWp2ZHlScU5E?=
 =?utf-8?B?ZG5hUS91T3RzSGMvTmJpeHBlZHRCb3MySCtlS3RlbEdQU1k5NTdiS01STzhs?=
 =?utf-8?B?SHExd0N2QWUzTmJuNXBDVlcxYmsrNmEvREk2a0J0MllNT2dubWtZZEFXRXEy?=
 =?utf-8?B?SGlqQnJ6U0h5aExUV2lYWDMyNS9sMFFpbks4RjFTSE13Um1hU2VjdkNEZEl0?=
 =?utf-8?B?T0dKZE9SRHc5MEQycklhQ3BtQy85YWV3M1ppcGJKSFVhdDBvdEY5WDJGTTgz?=
 =?utf-8?B?WGxoOWttTHZOZThLQ09rQ2lqSzN2Q3ZhM3lqZXZ4M0lUN0dRQXpSc2hwVFRl?=
 =?utf-8?B?dHJKbSt3VjM3MXZFNGY2Q0F2VUtQNVg0UHRMSVRSQjBlWFhJUXNwZE5SRzEx?=
 =?utf-8?B?cnNVcWU4Q1FxeGJwTW5KQzV3dTlNZFYrWXNOT2t0cWZyanliSUdhQ0tXd1Rj?=
 =?utf-8?B?eUdGQUdhL2ducWtnRkFsOFYrZEZOVE5XMmdHTGlvZCtoQTVJQXh4NmlhRCsr?=
 =?utf-8?B?bmU0dTlscjY0bkZlUWhpSkVUMWVvUW5Sb0JrbWluQXl6MUNMaUttTDBPOXU5?=
 =?utf-8?B?UXExWE43WVk0VXpwMFZsUXVHenY1Ykx1SGd3ZitUemRzOGxORVY1SjR1UTUr?=
 =?utf-8?B?RkhlU252azRKa2NiUHN3MThHWDVBWGs5OGJ4TzhjcWI4eDA0WmFhQ3huZzNy?=
 =?utf-8?B?bHVIUFFmT3FCYm05ZVNZb3FKc1g1NTVrWWswSDRKYzZEc2hlZGNuRE1Va2hj?=
 =?utf-8?B?NWtvN0FXSnk3TFZPOGdpQVlHK1VKWit4cTlwam1DU1crYnRUdlRzK1IyekFu?=
 =?utf-8?B?VHBKM0N5UHRSSXpXOUFRdiswUGZVZ1F2WHBUS213YzZyVmtuMG84NkR2NU8z?=
 =?utf-8?B?VnYwcHlvWENWait3bDRySTY4dnhyK2Y0UDh5MDZ0YThEQVlUcDVTYWwrQmhj?=
 =?utf-8?B?WDdzMmozaHpEd2NjdlZ0Zm5mMHZ2SjB4NGNlQ3N1TXRkaTVFOGMyTUJsSTI1?=
 =?utf-8?B?TnF3Mml5Q2luOXZYUHRhMlN6azNqVmZ1NUhKMFBKWWhtYnFnZzlSQklmVlFr?=
 =?utf-8?B?UTE5cU1DMHRHdUhOWVdRb2pVbTN6dTBWam1pWkJrWVkxaGRKVEdaWFdWbWcr?=
 =?utf-8?B?UDRHK2MwS0J5SEFYcEpKNWlHd3dEK3JlSVlwTnlsbnlEODYwR0piczJNMXRO?=
 =?utf-8?Q?SuKigQ?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(35042699022)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 04:05:52.4280
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6019bc21-4379-44ce-4972-08ddf40d298c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885A.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10758
X-Rspamd-Queue-Id: 2BCDB40003
X-Stat-Signature: gcizyn17i754ekoq7arykpy8edzcrz9j
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757909159-205729
X-HE-Meta: U2FsdGVkX1/dH+qxjnrP+ubmlPIMxnaGrohx/0JY1TeHqFae6ZrsASKHjm19IydIxemB3cdwsNLVQoNmUhllBSwo/GrB0efcG1dq5jhi2YTri9cvOwkIrUMrw+KuM9CKjwpY3tnBoWn6Bpjgif80BzpEu5rVQWkEMijvFtQJilKW18rn4VnS+PYyAcf6NaVog1WaTwgWrX/tapCO3vd3fS9KvQ8zX0Ppl9zTE+bhoHJ5FD10OeOcSI0o6Kd+KLqpL9tb6i2G16HZRiU106AlnBigWy2qsmx4lkEI1vAhHH3nc8r0Cn5xU2Qp1V04djf5fDD3pPSaSTXki6nW+xBxCO5jzR1uHlmrzYYFqb6arf/muA1Bv8gUxwIy+zOqhUjUAvJfBqEfB6DkBzd3iWUisz93ifgYi8QLGEoipnWhCA7+Bnar0cPSrGjuugTU9WvoaRJyRvdzmISCvFFdTM6tMO58G1dhQ7hRfdQ9T8eCoeO3+a4CPFaE04kWiJnpMP19bWNz1znYNpN7IQvlhGmmPQsrQBcLE3v5wYbfT1INSRym6lTAGwaiH5ZJZfv76yhHQPc5CiwpzxCpIikbscq4eM/Ikl64ArT8cA/FM4zpFITE/L24mz66jQhD94c8y8sWVozPAeiwllLP6rqcZylRtj9e8iKzm/q83oGPq4sohUBBh8Mh3bclFGKGSu7Yeqg5R+AZP8sUSKUvqNUIlMYOubDQV1yWy0q/81NK3yUO9d9WZ7E3h+9mDUVbQrWe4emy9t57Z2ZKwCw8UGvWMeadJYKIa8+e6QhZ0H8HMYEyea+y4XR8OQg/9YJtKJ4FCYYU25yJkQ4+unRuaq4VqT0A2OPExnLT9MAeQE2srSPc21eeWT9swye9TZaPNgr0XuA/osqOzQdIgt5IEAKC8Py4bn4Nv3bhNoieHatUGYVhg7oqNosxN2uk7H0a0mYgkmrCKU7Vf1OZX5riIYAEMy1
 OYUtSqfT
 413g41t6jojD8lhSzq11qtGeWIZ681T5rtc0rf+3Uo8o94tDtbUq3z5EWFzKEeTzw32n36tXD4xCPn5k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>
>
>>
> IMPORTANT NOTICE: The contents of this email and any attachments are
> confidential and may also be privileged. If you are not the intended
> recipient, please notify the sender immediately and do not disclose
> the contents to any other person, use it for any purpose, or store or
> copy the information in any medium. Thank you.

No idea why this still shows up. Sorry for this, lemme do something.

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.

