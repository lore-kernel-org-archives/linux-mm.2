Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95092CAC58E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 03:50:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEEE78E0006; Sun, 14 Sep 2025 23:50:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC6C68E0001; Sun, 14 Sep 2025 23:50:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 966DD8E0006; Sun, 14 Sep 2025 23:50:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7BFC78E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 23:50:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 90FB458DFB
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:50:47 +0000 (UTC)
X-FDA: 83890108134.16.5A7DA50
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010035.outbound.protection.outlook.com [52.101.84.35])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7D3721C0007
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:50:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=YHSxzh0q;
	dkim=pass header.d=arm.com header.s=selector1 header.b=YHSxzh0q;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf20.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.84.35 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757908244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g3ZRJ40lQsZ5/EuwyxFJd8Zi+8HXcRCeK0Q5ptty3nw=;
	b=RauIZyqC4DY/zx2OtGOv11LB3rXXq6SGlRZPd/Tm+ut8PI7MNZgRmczjL5kbVch4IIz4GT
	50efNBcogiDw4xCEMEoPLK5A0OJsVTOeArmQrwffTqjeN26NZOwcof2wCoj40UYk31lQNX
	G8bI1FvEbbugNWyB11Pczc10R58PPyU=
ARC-Authentication-Results: i=3;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=YHSxzh0q;
	dkim=pass header.d=arm.com header.s=selector1 header.b=YHSxzh0q;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf20.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.84.35 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1757908244; a=rsa-sha256;
	cv=pass;
	b=wWfQPnVMpVMJCjXwQrwwBO+Ezl3JHI2G/67+Br/W8vm3lcbICQJrU61YZq78eXBtp3wN9B
	RredWoAvoAtBPB+dzHU7VCQnku3Rwp0NfTV2q1SKofxT/ttCf5Qe2+DIWQPeoTcP+4jhxE
	iAEKIEl0CIoaWnH9CcETu9nUtvFyHxo=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=e0YLWAFI8kNj7W8pOQBJkZcS3Q1Y92j3mP7NfxOXWQNvTC50LYdAn5agTUBIMKRGDn7MamYmyjohOqJe/I0uTlwo/C5cr7UgNQ8uiMF41SyFqZlUDwTKJ1yHAaDeVLx6BqznaMAc+C4cYwB5fdo7FRFyeYP/9Dg35Q8u2TMwLu/LBtvz6YNzy9b+2Pj7WcFwhJRQtb0svaFMw+2FUAmbN+v8e+d4nSMHU7hcyDCRz4RqD9pNtY6VxU7L2bj2tdBWioyprMH2GLBPSFjZdifQn3OtBSJQAFHea5hlm7laPMatVd0QZEEQ/dNmHmyXPZhoGPqWiPQSB+uG9UuRCHRoJQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g3ZRJ40lQsZ5/EuwyxFJd8Zi+8HXcRCeK0Q5ptty3nw=;
 b=wWWWyGVh01+r3JFKSUf2iLNBQ4P+zUW8wn8mrclGJRYAdn9HC7GCxxTK74B3+JcNB9qZo/d5ake+S0Ly3kIG1cMgu8fplBkb267ADW0gV35e71WmW41Ss4CN5AZMeR0SO7yzNgIccaQEjB8gtfpsrNyIm6XjUiHvtyG/q/MYJKvsZPAG2zGFdHfNYEvCShJft4AeJ6txXOj38apPpyLmSR3FsHw0mS31AxE/Nw4YdjEogBFmP0LFRYgNqohbl1Ru3u9jkq+/pv40FXsKVR6/78MiHJx/JKtRqnf1+z3GA4n1IS3S2GC8CH8/b0943PRFDgqfjZjsbjV7XBDDG3NZtA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g3ZRJ40lQsZ5/EuwyxFJd8Zi+8HXcRCeK0Q5ptty3nw=;
 b=YHSxzh0qlCg7mbBTxrB5XXXdXwbmnyp/UA9FgR5D4j1HJELGjcqaTFkBaspnxIGbnSiAsaOB0KaTLYE3HfJ6Deei2chHdpfJRf/o05vpMz2S00BTn6lJCCp6JAIrx9JkNDNcse0QqDXYjXs4ikEM2gknV0T/U6vN86kUuJRgRkg=
Received: from DB9PR06CA0004.eurprd06.prod.outlook.com (2603:10a6:10:1db::9)
 by VI1PR08MB10123.eurprd08.prod.outlook.com (2603:10a6:800:1c7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 03:50:38 +0000
Received: from DU6PEPF0000A7E3.eurprd02.prod.outlook.com
 (2603:10a6:10:1db:cafe::3d) by DB9PR06CA0004.outlook.office365.com
 (2603:10a6:10:1db::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.20 via Frontend Transport; Mon,
 15 Sep 2025 03:50:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000A7E3.mail.protection.outlook.com (10.167.8.41) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.13 via
 Frontend Transport; Mon, 15 Sep 2025 03:50:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A29lusatkx+QA/4LpDqvr3KEfBXJg+lZG6RXFr7g4tDjzdjEDTem3L+dBtxvKWtT0HKbJ+vt3lfBINdEJ5KQr0j/h8IIGb9h6ffByCIQgT3wDpxc/558J/cYbF0XrJ23wKSy+DoGAq1u+9/iIufyKgUPnSWKWQtuJv6dKLsgBvKCj6Z0ioO2NX/vCUSLd7EpCfecVC/uffVH1IF4s8S5zMHb7EkBuCeUh8ZzvGGuW1orJutYN0uLAnfpKabspzOCXabSfYWIqOTlEbecskz16YMa4nO9XQmUCItRARktFDirUU+A9nGO+7nal+EKYN7rtA9kK89jBIBZF2mUT1tQlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g3ZRJ40lQsZ5/EuwyxFJd8Zi+8HXcRCeK0Q5ptty3nw=;
 b=AQy1LLxCjEZoUuVeAGTlJTATAO4pqObFl2eUzaiNNPK98PlEJ/aAZ3jQHZzlMBAjbMjeeetT9esu8RRmVEAHskvJL2I3iaQ9jM7op3M+Ezyo5OWDwgKBYpMxt9nHrqbKVN2+Ws7U9hSr9+6dCTQnnRLYS+lJf8jPLC7lVaAYM0KfCl4qzCAblHbCuQmivze7gKr0ZtnDWl/KKm0/3paaRft1XJ/WcFfU/srnS8wWyvBjkCC0/waH9DuKSoIDXlPRCSGzGLWiqx9mMSgYaGiu4UeZ2AaZBU/+cqOk4YKDPXlXYt/JRj5ql0WEWeYl3F/Czng6pVTr16o5SwLXPgfKbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g3ZRJ40lQsZ5/EuwyxFJd8Zi+8HXcRCeK0Q5ptty3nw=;
 b=YHSxzh0qlCg7mbBTxrB5XXXdXwbmnyp/UA9FgR5D4j1HJELGjcqaTFkBaspnxIGbnSiAsaOB0KaTLYE3HfJ6Deei2chHdpfJRf/o05vpMz2S00BTn6lJCCp6JAIrx9JkNDNcse0QqDXYjXs4ikEM2gknV0T/U6vN86kUuJRgRkg=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by DB3PR08MB8818.eurprd08.prod.outlook.com (2603:10a6:10:434::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 03:50:03 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 03:50:02 +0000
Message-ID: <daead4f9-aa50-41bc-901a-8dfbdbd896c5@arm.com>
Date: Mon, 15 Sep 2025 09:19:55 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mm_slot: make sure slot is the first element of its
 wrapper structure
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
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250915015722.z4w23d6ralc2y7mk@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SI1PR02CA0034.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::10) To AS8PR08MB7111.eurprd08.prod.outlook.com
 (2603:10a6:20b:402::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|DB3PR08MB8818:EE_|DU6PEPF0000A7E3:EE_|VI1PR08MB10123:EE_
X-MS-Office365-Filtering-Correlation-Id: aee34607-d084-4445-561e-08ddf40b07a3
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?K21EQndkdE0rUWVuUjcxVWwzbk1tQTVCNTY2Nys5QWR5ZjRMSDJhdThPTkh6?=
 =?utf-8?B?N3lyVktRbkp4Y3ErNmN1VThMWTRLOEZJNmxsRVg2a3dpb0V6TGtDZVM3dDR5?=
 =?utf-8?B?TDNjL2F1NEFTQVhjSWQwVy9RMUkxUUZKZHB2WlRoZ0lXWm1tdU1VTFZDbmdI?=
 =?utf-8?B?dU8wWGE5eTFFeXM4QXZQcFdrODFOdi9BZGxMeEE2ckJZRHhNSmVaODVXM203?=
 =?utf-8?B?NXdETGtXeExHNzBPVC9sUnZtLzZWbWRHWEJXU2FCRHk5dnpua0c4ZzMyaHlD?=
 =?utf-8?B?am91MU5MRHFDUHpQNFp1TDNOZkpBUHFQaUR1bTVNODF4aWQxckpQOHBnNFU3?=
 =?utf-8?B?Q1doOFdGeXBYT2cySjBuakdNUjZINjUxanMzZ0xNUGQwaXh2ZUFHZ2piZzVW?=
 =?utf-8?B?aVQyZ0Z0N2FZWDd4R21hMGl2RVZ1THV5RFhNWWN5YWg3a1dPc0RUR1RSa3Nm?=
 =?utf-8?B?L0lZQStTOGFoMUZ6SEMwa3Erc0hvcG12NUpFODlRWGVUbXovVFg0NVFlZGh4?=
 =?utf-8?B?UWxza0lTUWR6SnlXN01RYkYxMGhBaE5VUVhtY0NPd0FtZTZzQ2xBV3FNL0NI?=
 =?utf-8?B?UzVSU21oQzdmaVZyYUxYcjBJSC83NEoxRDdldVR4aC9XN1FnRExNSTl6akxO?=
 =?utf-8?B?UkVISkZTK0JXMjZNYWd1ejVGYWhLbUdMbWFjRy9LODR1dzVaUjVpangyR3hG?=
 =?utf-8?B?NXZqOHM3c0xlVGFvWktNMzRsUTV6QlBjQWhOYzhTckFGQlFEbE5MdEZIMUlC?=
 =?utf-8?B?bzJHaTNzZ2czNStSOG1peG9oeFJqYTRCWkhCTDFJdEt1bi9FM3ZuSWlyZU9l?=
 =?utf-8?B?NVh1Z096RjQzNWdmSjNNQkVoTTdFZXZLaVRqOG1PcDNYMjJsNHB1UU94SlM5?=
 =?utf-8?B?eTBLS2FUT3BzdnVBb3huaGovelgzZ21jUUJnUGZHRzc5RWVEN1RNOFAyaXlp?=
 =?utf-8?B?M0VudVZmMFZqQzBRY1BjU295SkFGRFl3dFAwczFDbHcwUHZudktBYVBaTE5H?=
 =?utf-8?B?dklwUStLRzcxbFN4R2J5NDJxWW1FVWR6UUFWYVVkWTljTGszRGlBM3N6VzV5?=
 =?utf-8?B?MWRiOEZPR0hHNHRoT3ZiSXZqYTdNN1RBK3l6Qmp3dkd6UnFvc0g2RjBsenkw?=
 =?utf-8?B?SVBKRExzeE1ZelVzSnVTQ2lHcmE1WW51NXpDbVFic09lSFMxL0ZIYUZvbjNp?=
 =?utf-8?B?TEFHbG9EN0V1UnJNR0VtdDR4VkI5dDc0WUhhQ01ZazNwTkN3NmViQUVMSXIz?=
 =?utf-8?B?cjJGdGs5RnhCV054blh6eVpYTHAxeEFyR0VoWVV2T0xUZnZaS1kraVJ6Sndr?=
 =?utf-8?B?WFpvaWFmNzBHdlVicStpRmN5bjRTZVlHSE1wM285Sm5EU0UwQUx2ZER4SXFY?=
 =?utf-8?B?YllmTGlLdGFxazNmNTgxNWZPOFFrOWVyM3BDSnQrWVh4Nk96dG1pQ1NlYzNy?=
 =?utf-8?B?MjZhZlJoL2NzL1M3TXRMUXdnZHFSODZTNHk5bSt2VXdvTzFoOU8vVW5Ga3BE?=
 =?utf-8?B?ZVpXY3JheXpra0h2M3k3VzdDVHM4QVZ5OVZPa1gxVU81YjdMcWdOczdNK05P?=
 =?utf-8?B?U1doSmVVbEhlbVg1bkNQU3NZQmprR1VvYXRMWGZPdFFHSXNYdWs1U2ZWYnpy?=
 =?utf-8?B?OXFSakdETHBvRWQ2THFjQjM4dnlzOUNUbXJVODdwME4ySkpkMnBoaENrMkc4?=
 =?utf-8?B?aHdRa3F2b1pOL2JNcWJIZGJWS0R3ZStBbkZKdUZBcVdJNFFhT1ZBQmRxWmNy?=
 =?utf-8?B?ckRNOXhac0JpMk4zOEljT0Z6Nm9FeHNFQUI5NWgvNXBsSXhlQk1XTVNoVzlW?=
 =?utf-8?B?OHZicFNTQXZMZURnb0NiVkYwMFFGa29HeHoyejF6c3ZNc00wVWZUaGdSbEQ5?=
 =?utf-8?B?cG1oRHpxcVZveW1IdGVyaUwyNDNSNVppVlErMG1WVzZxZG9XR3VmRHh2a3dN?=
 =?utf-8?Q?gQ2EjGSYD5Q=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB8818
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000A7E3.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	16525244-361d-4f74-259f-08ddf40af32a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|35042699022|82310400026|14060799003|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?em14cVRnQjNBc1BPSklNTWtVMDNzQ3RIUHBKUy9WM2dEb1JFb3VQZzhvV0kx?=
 =?utf-8?B?K2dXWFJFUHptVUl3R2pTK3JDdjZYZWZLek5KRFNuOXo4MnM5K21vTjM3QU01?=
 =?utf-8?B?V25SSEJVRHFqNXUxVmg3d3dEcXMvaUY0dmNTek9OK3Y2cTZBT0trTmpFWkFz?=
 =?utf-8?B?U3BoZjljN0QxakoySGJKWG5xVVNEczBHbSt4NEs4MmZwTCtwWmNaUDRzL2tk?=
 =?utf-8?B?R3IvUUpzazVuUHFxZGxSejlqR2o0cVVzM2VjRUNta3hUNG5XcmlYcE1MQUtW?=
 =?utf-8?B?M0RkQWRKdkpmZ3VqVW8zMi9iQWRaZCtNY0IvUzN5d2d1aytHOFdmYU51QkdX?=
 =?utf-8?B?NXRzdWIySTZFRVgyeXJxY0tVZkxzNHBLZTlJZ2lSWGRSUGVoenBSaVpnMnhG?=
 =?utf-8?B?YysxRWh2TW1ZYStFc1ZUZTFKVGJqNW1IRk5obEI4NTZwM0dLY05CaGV6a21I?=
 =?utf-8?B?MXRCd2paZmVVRTBvU3RtSy9uMkRtVHBPRWlzaXhPUGhTTmxMaGhpWEcvRXNi?=
 =?utf-8?B?NmlSaW10TUFQQXNqUnlmQzJBNjg4M1lyT1V5by9zV2QrK2tzc1c2cnlTeWJT?=
 =?utf-8?B?YlF1RllFMWdMMFdLTlVpVUZJTWJZcXNwaHdQR210a1U3VFlmQlJ0ZzBrQzJn?=
 =?utf-8?B?cGxHWG1nam5mZDByaWxrbzhPbmtJemQ2RjFWOE1nK3EwdXo2SWIwYkN4MmhW?=
 =?utf-8?B?UEMwZkNTM0tWUHcvWHFOUHNrdW1PRG9nOG1JNmJxZ2ZoSFd0MTNvc0Uxekd0?=
 =?utf-8?B?UnJsaUxoRVhBS1JpSW1EbC9mOHNxMkRacjBvTmFRK1h0aVAvOUs1b2tEa1Jh?=
 =?utf-8?B?K1pSQ3QwcUdWVmY1cVYya3BCK2hES2dxc29QOXROUUVBRnJMNjgzc3hFZFU2?=
 =?utf-8?B?bFhWV1hlOE53enRFRVV3VFRncnhxVktZZ1ZaRGdQMExqSUhkNjA3N2E0RnZw?=
 =?utf-8?B?WUNDc1N3bzRseE5FYTRPZUh3SjY0ZUlJemp6SHNISk5hcC85WlhzRXEvb0Zr?=
 =?utf-8?B?ZnVWMHJERm56UUkvdzl0UVUzOWlHTDR5ZFRXQ3FVOStUZFU1bmdnSEJrNlNz?=
 =?utf-8?B?WW9XTlF6MU9zaUtUWGk0YUJJQjd6QTh6WitmbVJTUTNCNHNvYlI5WUcwdGds?=
 =?utf-8?B?ejUzOExYbDY0WXhDcjZQWTRWQnNKeFNJUVRCdVZtVENKNGMzMUtJWUUzemFV?=
 =?utf-8?B?N2p0Q3lxbzZEMzBIaE1tY1JBVWZLTStVaXJOU3M0MU5hQVdrTkFOcWNpem9y?=
 =?utf-8?B?OGJNMjFZVzlWRFRZZFFNSjFSQTdiNm84T244K00xbFFaSzlNQjdlM1lheHpz?=
 =?utf-8?B?ZllMdVdUWWJ3WnFRYTk3dEUyTDRDNm50aHRlbkxmUGxSaHdNQUQrSm5HZmR3?=
 =?utf-8?B?TVQ2aHJITEFvUEp6UDVDa05ZVEh6aTJDNi8zcnJpVWM3cG0zNjk5OW1OYk1k?=
 =?utf-8?B?ajhzNXVGSStPWTZtM0NJQlZGbm1iVmY5VUJ5U2M1WnpFMDRUN21ydU1YeXNN?=
 =?utf-8?B?dks3dTM4b241TkMySllVbzAxSzhYMG0vU2JWS2pKN0l5UEs2SWFnMC92dFhN?=
 =?utf-8?B?ZFZDTEsvRmwxL3hIeTRkZnZrNzFNbUtRcXdIcmZCYWwzL1hEOEFTU3BrUE85?=
 =?utf-8?B?blJzd1JHUFAvdkZUdC9NNUIweHJxakp1QUJzQzRDOWwyQWxHTDkzWE8zV3FJ?=
 =?utf-8?B?NEZTT2JrRWpSNTFMa0hEMHFLWVlGemk4NTk0b09WN0ZLMktLZlpDWXpmT2NU?=
 =?utf-8?B?ZWRqWlJicFFackJlcjZ0dDMzYWh5SVUwaXNBM1U2aFNBSDVNOTlCYXd3RUYv?=
 =?utf-8?B?RUYwSm9TaEVVc0kwQVFvZmhJWnJMN1B2L0xITjNYaDMvbWQ4WHQ3cmxQQlJO?=
 =?utf-8?B?b2VLai82bEp5dlN0QnJ1L2pweFZuRVpYSWFadDhIZ1hxL1RIaDJNa3NxODV4?=
 =?utf-8?B?L2xKVnpmSStabnlGOWZpdmJWb2duMURrZ3QyVEdIZDhQQlNSQjZGOHJ1RXlB?=
 =?utf-8?B?S09MMEdweDA0aThjRXJIWG1EZTloNS8wWW5xSm53cHo0dlpMZENCSitaNTFK?=
 =?utf-8?Q?PRXehK?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(35042699022)(82310400026)(14060799003)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 03:50:36.5470
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aee34607-d084-4445-561e-08ddf40b07a3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7E3.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10123
X-Rspamd-Queue-Id: 7D3721C0007
X-Rspamd-Server: rspam05
X-Stat-Signature: ukdaidutm49jz5nfxne3zu8qsfxpkx7h
X-Rspam-User: 
X-HE-Tag: 1757908243-189628
X-HE-Meta: U2FsdGVkX1/QW95D4zRPiVGlmdFM5D0GOlKK1/mNxb4a2c20raS94cnTcOeRQ2N9qJ/yfJsP5SI76OTnjkDCjiif61BBmpYl6NHuJRimvA2vXNWBzto0oAqmM4Pi8Epz9VOLUy1K1YPrMvTg/V8AAXDejstbH79CCeT4/cPt+U92cdXClKQon/Jkocay+ZsOu2njqw8miWz7RTB/Hm8y4wSW8/1Mq4oPyF2LyUpIUghpBC70kHEFaMAEPhz+zrz2GS2XkKv9RSEOCByJb42I2+QGpSbuYD794U+/CPPTya6VIklEY4DwVV79U+0lkdh7M6XJDewrxah60EvMs4kZwLlOA4zzfyO8ulkrRSroDnQ9Ey5bWSn5KM2vQg0TP/DMmJdauT3fbEVMBA7vgh8/1Kv6/5ok0hBJBCkpG9EqT0/Xe04ZeVqk2Bz9OurmBLJJoUR/q5uynMMw1NFJ/qxU6NMtlfrCnQkW9P5BwAHJ5Jr653KR6Zbh7LFJ+yvvXQlahwKaEQPtTEBPAGEi+qsS/v63WSy4w53NTN0gbWiGCWVU87WQCF8nYsaUqm+awC16nNhVaJcnjgvOGDsi+dRAzGce+ALWT8AuAqGdMqDdOTE/g6BW3cS5lGdpIkl/m15ZdKop215q966dvYNg8+6UfDR3F0V+CXwjtzX9nduI5H80kNU4pki5YqqAsvch07Or9EE45F/fK1YI0s9wZnrK+ar5rFJFRR8j0gcFkUlTbXLnZJ0d633UQe/Ivcs7R86GEkh/jkq+MkVGBSK3a+Jux+TXpRx1+wKQSTOPItYNs+mVvVtO3CELfujIcv3XFA9SLqcL3oY46SOeQDuDf+D+RcdHHVMRd1re5QcaVc/isUhtlkfM7H+qZgS89vL06+A7fKUaizK617Z1Ue5I/JtqxtjQDyafb/7acWeOVGS6MtiLr9sBy6RxIr0PjeAm70N4iJjjWHkMm10p5L8Odqn
 RDSncujJ
 eyXn7kdRQOK1n43ZNvNVgWwJY59ExIG2Ec1d3ZUqJItGtd0qCV7/osYb1xZwS+v8TUxEHxGUDTyV8CndF6jzNsUSUvL27Uqhe/esWuTZc9COHLutKGVQ/MRfePx3kApvME7PgPOsRDPm4xz9RPsKT+Qh05MOW5dE23H84vNxQFpCpm/r1nMkas/MClDM9T8C/o6lD5CtrjkcfmlW52L4eGdQKFo9uDa1EmwXE8bme22FxwSinckHc5KSmN29kHH2LhF9SdxezHXDMOvOEEo5VyRKeG4y56ZIoY9WoH0DeWRWG8OTxSA/Ls1AJqpYoazBlOv6TKjeFXMSNDfpTsK+16fOASGdmPr4+LknllDY//ErmWktv6kNXiS9vOkRMkWq80DMN31ooukop5TFj7qMFc4OlMxAuOOPXYrFTsaD5csKGKPkq934dpEntFzwzMcngsVqFpHpeie0KfBDVRXfx0mGLJFDA/OQo1+8LVvKV9Iv2N3K7sQedmXrZ7s/PWsWyVIuX2IteDfYqjq0ShFkLB8V8UHT8+oQcjXibZa6NDGK1PmLwv9coaBa9Hbf3xqob8dCP29JZBVfkPkPjKtdAsWfhdzAgwYpTis/BmiwocyZmBuRtVx7p6a5NzNybONOj6VftN5qRAIvEM+xUrMw+ayny96lYIjmMVBichULNUxL1XyDRQ4UjQaIzH2sbeH0QvPDc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 15/09/25 7:27 am, Wei Yang wrote:
> On Sun, Sep 14, 2025 at 12:59:33PM +0530, Dev Jain wrote:
>> On 14/09/25 12:33 pm, Lance Yang wrote:
>>>
>>> On 2025/9/14 14:21, Dev Jain wrote:
>>>> On 14/09/25 5:30 am, Wei Yang wrote:
>>>>> When using mm_slot in ksm/khugepaged, there is code snip like:
>>>>>
>>>>>        slot =3D mm_slot_lookup(mm_slots_hash, mm);
>>>>>        mm_slot =3D mm_slot_entry(slot, struct ksm_mm_slot, slot);
>>>>>        if (mm_slot && ..) {
>>>>>        }
>>>>>
>>>>> This is only valid when mm_slot is the first element of its wrapper
>>>>> structure, otherwise a NULL slot would converted to a mm_slot with
>>>>> negative value. And current code thinks it is valid and continue.
>>>> Shouldn't you fix the code for the case when you can't find the slot
>>>> in the hashtable, i.e slot =3D=3D NULL? Like, if (!slot) return.
>>> Right. For khugepaged specifically, the slot =3D=3D NULL case in
>>> __khugepaged_exit() (only user of mm_slot_lookup) should probably
>>> be treated as a kernel BUG for new.
>>>
>>> But I'm not sure if the same logic applies to KSM ;)
>> I haven't seen the KSM analogue, but restricting the position of an elem=
ent
>>
>> in a struct to make the code work should imply that the code is wrong in
>>
>> the first place :)
>>
> Ok, if so, I think this should be a patch with Fixes tag and cc stable? A=
nd it
> supposed to be two patches, since it fixes two different commit. Am I rig=
ht?

I don't think this is a fix which needs to be backported, the current code =
works.
What we need is a VM_BUG_ON() or a WARN_ON_ONCE() when slot =3D=3D NULL, be=
cause that
just shouldn't happen, and then safely exit.

>
> Originally, I though we don't want that bother :-)
>
> And now we decide to fix this, I am wondering why we wrap mm_slot with
> khugepaged_mm_slot. I don't think it is necessary to create a new data
> structure to just wrap another. And this is why the problem comes.
>
>    commit b26e27015e mm: thp: convert to common struct mm_slot

Yeah I always wondered why we had that wrapper, makes things unnecessarily
complicated.

>
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.

