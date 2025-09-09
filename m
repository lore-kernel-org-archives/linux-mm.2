Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B84E7CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 08:47:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04A968E0009; Tue,  9 Sep 2025 04:47:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F164F8E0001; Tue,  9 Sep 2025 04:47:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D68718E0009; Tue,  9 Sep 2025 04:47:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB01E8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 04:47:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4AF2758E6B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 08:47:22 +0000 (UTC)
X-FDA: 83869082724.16.8248361
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011057.outbound.protection.outlook.com [40.107.130.57])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9765BA0008
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 08:47:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=DQezyIrX;
	dkim=pass header.d=arm.com header.s=selector1 header.b=DQezyIrX;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf25.hostedemail.com: domain of Dev.Jain@arm.com designates 40.107.130.57 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757407638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uQtF0YAtItBDoFBZKsG2ch864Fq7o3S2Tpy7QEanfCg=;
	b=R5GK5xbVfXy3HZGq+d299vylM4DXNmqgtuTMAOFuwB0py8vLwdfOSd1TiUa9chj7en68xx
	ReNrd8gpqyLV7NQCr5A+aim7um7GGHY0aFEWiKz/iBOeGW8F0FvOz9zv2fRC7Z4j9U6IwM
	mWOHxMF6+CnqYO0YA5CmK0ENTPvPK8c=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1757407638; a=rsa-sha256;
	cv=pass;
	b=ev3pCNzwtBcS6ekuesI5MydlPHpWwjkksoA7TqCy1G3luERz8HFtrRBxf04iFVEmHRQsOO
	3aHQrZmFfSMMXT/Cg0sLRvzlNix4rZnsu8CMtoBaCNYXhYoLt5doTL/wbVQzPlldYkaIMz
	+1PKwHJZHjXr5MlB7GbH5/hYBrQBvis=
ARC-Authentication-Results: i=3;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=DQezyIrX;
	dkim=pass header.d=arm.com header.s=selector1 header.b=DQezyIrX;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf25.hostedemail.com: domain of Dev.Jain@arm.com designates 40.107.130.57 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=lnqeEg6rW1TBHfOFGJmmVbQwRgEt0a4De5d3NrWp4Pngws2tD7V6sFJ12b22UBvMm/G5+W7PWIaaJbo10IXx5l0Y29UhSRLa/TQM2ZrY4jXQjpfflMuLQJwsMqcQ9x9w49m28XA+x+4ncYYJ4J8R+DP/V+f6/uHlrwbelmEfD+2G84/Bog0u+O70xUH5Nf8MD9c9lI92zFNEeeuqr62rxMPzBqBHaE9JPV9XIrCPP6F3+aBlRm7egUUZ1Fic0vreNPjp9lgcOTKHe4ywVzmLyFLg2IVCuZzHyx68FO/4AGF0UwRk+IZoN7hW/5lrN0rcwXvbkHOIov09kY8XonwjAw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uQtF0YAtItBDoFBZKsG2ch864Fq7o3S2Tpy7QEanfCg=;
 b=kyjh0XJU0odgQ/zgjOMo7LT5zMkNAp/LZAdg2Bp6sL7jiuT2WzkN9WJk27s3PWdmQt9vO79j0CdZlrwlFuXzKP4pBHOWZ0rGy8UUqIdp2OrADK396qkokZ51NVrh0kMdk1jEcn7HCCGM6KYDaMA5MNWVFkteWv8VpAAwozaWR24cdTmzRigLBexWLlH1vEtoEXDjtzTLGFSU5tnyCYtOZA+7e88mr1e6OT7Fk4iV7f8WcxVPixfo4tQhBFA809d02mL2RwmeObmuSjYIn/TaJL98mbRyzPC+otEjx+DBIUMqjsrFrDebAhvLgc6O7A4ipqREoppmp38IgKG+h/FnRQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kylinos.cn smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQtF0YAtItBDoFBZKsG2ch864Fq7o3S2Tpy7QEanfCg=;
 b=DQezyIrXc46eNr/ThjMV30wuLuUN+yWFDYur9MP9FOyPHOUz56o+P7+WITgaiShr6lYs95kloAwNXrAbCxOpsGwuSNLxMGSFzCUvb4oFXAE9h2zS2ZO700hAQseMNWmpMWsFSF8lu1x9dsPvWwLUyWkUXaWNNyo/PftxhxEYasM=
Received: from AM8P190CA0006.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::11)
 by AS2PR08MB8904.eurprd08.prod.outlook.com (2603:10a6:20b:5f8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 08:47:13 +0000
Received: from AMS1EPF00000042.eurprd04.prod.outlook.com
 (2603:10a6:20b:219:cafe::43) by AM8P190CA0006.outlook.office365.com
 (2603:10a6:20b:219::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.15 via Frontend Transport; Tue,
 9 Sep 2025 08:47:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000042.mail.protection.outlook.com (10.167.16.39) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.13
 via Frontend Transport; Tue, 9 Sep 2025 08:47:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EgODFvROA9YNkS3JBpxL3xM9xQSOpnrdIKhYSP9PuoQHUmHFIo/gRpHrn+A6CvGe72DyneMKaUu5102l28WMtLlRGK9eiYWDmY9zRPE51ATJaMQ2XKhDCqV6EE+1OaX8uUshdfi8imdtWenOzxnK06kd3Gv/XYwrxEyBQxOOvkqUIqIFEH3KhPvhnqYAkQVpo1p7+iMNoMwGJE+ejXXULnYiGuwtvV98/6rpzmnh9uw2kdkSmYQkl5Xe+3OsLaW1q1caGfFrY8b1tbItxSJ6kN3NXOdGTQNESi2TwAXBhAaaNlpfb5iJ5cUSvNPYPbL4cbnfSuxQ6I7cz8W2ziwtPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uQtF0YAtItBDoFBZKsG2ch864Fq7o3S2Tpy7QEanfCg=;
 b=SCRGpec63CsZPukLI8Txaq5/pHaGX1GdVhObY5f1IIh6BavHnJ2DQ1Vf1j9wfJqEtmP2o3UtA2KJEHqIPGQOpHRVQuvuxlsEh6DKVNLu4lVG12bgSAv37L8z5n+MOTLFsioUTDgJQQWWd/v5WJuICFvJ0WcZwfuYfVYqZAew7JxV/HtVQLxbMjXG6XUpumy3N4+VxajcwU3hvlzRO4pqXR+re3GEg2uaw5k0ZdMV9la1bWIDjnCsu1GkO2P8g1Zvk3ygkdRp9P+T8HQkU2tzrKCM9n/x9b1WnKDvu0JBeHHtuS2uK12KizVyY0vn4LBiUs+/X/gJnRdnUyFO4OA0MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQtF0YAtItBDoFBZKsG2ch864Fq7o3S2Tpy7QEanfCg=;
 b=DQezyIrXc46eNr/ThjMV30wuLuUN+yWFDYur9MP9FOyPHOUz56o+P7+WITgaiShr6lYs95kloAwNXrAbCxOpsGwuSNLxMGSFzCUvb4oFXAE9h2zS2ZO700hAQseMNWmpMWsFSF8lu1x9dsPvWwLUyWkUXaWNNyo/PftxhxEYasM=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by DB9PR08MB7558.eurprd08.prod.outlook.com (2603:10a6:10:305::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 08:46:30 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 08:46:30 +0000
Message-ID: <c880df01-3041-4af0-b4d1-167193e8e6af@arm.com>
Date: Tue, 9 Sep 2025 14:16:24 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: Use folio_nr_pages() in __free_slab()
To: Hu Song <husong@kylinos.cn>, Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250909074812.599030-1-husong@kylinos.cn>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250909074812.599030-1-husong@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0034.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::17) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|DB9PR08MB7558:EE_|AMS1EPF00000042:EE_|AS2PR08MB8904:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b976d57-1d48-46aa-1640-08ddef7d787e
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?SEE2SmU3ZUIwZ3BNb2JLcUEzZXhVQXdVZ2V6Tml4ODBkdUl0amQ5YjB2MDZi?=
 =?utf-8?B?TDN6TmkwVGlMWkloOFRNOFVMOEpiKzhyNW0rcHFzTGgwMUxQelVYdFk0V0xk?=
 =?utf-8?B?SWl0cDJVV3ZRYmZLYmdnZjNpamNtRWZCOXUwVExvNUVTL2grcXh1eGVlTjFp?=
 =?utf-8?B?b2lwOXd0Q2dDVUwvemtpQjd0RHNDQ0pTTEJueUlWb0QzakhHSC9Ydm56cklz?=
 =?utf-8?B?THgzQ3FyTDQrdE9kNGxQcDhRMjhMcnZURitLMXliV1ljaFNsT09abGFuZWFs?=
 =?utf-8?B?NFpldlJRNTJYUU1PN2JVWWRSVzFPYU9HSXkzRkg2U0ZJNDdNK0huajBLMUJW?=
 =?utf-8?B?VlU1emEzWGdtYU44ZC9vdnhVeHBHakRKd1RkMWxzOFFGK1BqY2FwVFd6TnJG?=
 =?utf-8?B?cVI0eEsrMWhvakxaM25qU1dCZzZjMEZJazVzV3NWNGRzclFQbkMrb3BCT09I?=
 =?utf-8?B?UjdGaGJLVFpkSG5DeUQrb1BoN3NvTldXYjAwSW5aNE9JNmNwR3BiT3h3cFBK?=
 =?utf-8?B?MS9DcHUzVllqWCtrbUMreXcrN25VWEFYTlFXR0ZqNlhwbktKTUZ5TXlNeC9m?=
 =?utf-8?B?K1I0RFVFZmx6V2N5VjdEUDd2TFBDNTg2YThDNmVVbkRDV1RONEdzMTVRMHFG?=
 =?utf-8?B?Njl5cGMxdE5QbXNaL2Q4VTdJYXRWT0FibWg5RGR6a0JsNVArTkVHQTA2ZmR4?=
 =?utf-8?B?akFpbUpEanc2blo0OUdZallBcG1TcUI1OExCUnpYUXY2U1lkSjVvOTZLRit4?=
 =?utf-8?B?VSswVmRsUXJucmFxMWNiVDBSSXRNQjlWcVZYeVhwckZ3UEh6Mzl2U2xmMmsx?=
 =?utf-8?B?NUxGZUxtLzNTOENmbmVCVGV2a1BaeXBhTmNBZXNDUzkxMmhFSnhvUlNCaVNx?=
 =?utf-8?B?OC8zVzNhZGRvYlVvbzVSVlZjM29SeGxYOEhWSVUyWVZ4eWhDanBNUDNqZjJT?=
 =?utf-8?B?aFRYdE12Tld5RW9tSGduVHJ5UUVQRmtuejljWGZGaFAyZElTZGo2aXF2Zkgy?=
 =?utf-8?B?ZEVSV2tmL0NDYmJKcWlhcXFXck01c1VXZXNyTWpIWFpwZnViMS9ZRFR6NEFp?=
 =?utf-8?B?dXJrdysxRndNNkVGMi9VRXFBNThjU3VhVVZhdHBJTG52cTNjYXhUdGw0WE80?=
 =?utf-8?B?dC9ZdWZHdzE4b21Yb3g4SUF4T1lFdzhFemowYXlzUzJHY01BKzlZaFpDTTlD?=
 =?utf-8?B?ZG5KS1ZkSzdyQjBCMkM0a3ViNXIrOWNmRTlSYVBHSVFqUWdtOUJoNk1zZFI0?=
 =?utf-8?B?U3cxNVgrclh0WkxreGR4ZHlTcGpDb1dhSy9mL2dCZFBRZVdCOFhEYkVoQVFX?=
 =?utf-8?B?ZG1tRlYwUCtxSm9hSnZGdS9Dd2JHZWEvd2dIcWZXRWtnSkdEbERIMk45OTlx?=
 =?utf-8?B?NFhrVmZxZEhWL2VzMXBIanQ5UG1ZT29EUWtDZUJzVklGUXVOMmNRT2lldXVW?=
 =?utf-8?B?aVJmWldYRjZaWjAwQkk2QkRMVVB3M2pyZi8wMHU2T0JySHJGMW9XTkFLUU1J?=
 =?utf-8?B?Ymc4TXE4ZTFxSTNyN21RWm4vclJrUjUrNHRLNzlLY3g5Qkk3WVUxK3kzTi9D?=
 =?utf-8?B?c3JRc3RGUzcwMnpwSG1ubkVBVVlaVEF2RkhIZW5wK25iTTJFMzlPYkgvNExO?=
 =?utf-8?B?Z0pyRlNPREIvWU5UREFvbWRwTXpVcUhNSXBIaXZCR1RBRDREMnVwQmVtQkxR?=
 =?utf-8?B?bmJ5RHZpaFV5aE5NOW9NcFRySm8xZmliQi9GZHZBTE9WNERUYXIzSWlNeUdR?=
 =?utf-8?B?TmVGNWFBa0FyY25tamMxN2ptTTlGV1lNSGJwMktxTEFpbXQ5WnJjU090ZkRM?=
 =?utf-8?B?ZWtXOWozTmU1czZBcStvR25ucXFpMFY5YmZDSTAxanpZL3FOSkZpSzcwR3p5?=
 =?utf-8?B?Zk9HLy8zRDFiSjdpWWZqN2laa1dqL1VsY2FKR1QrMisyM0FWVU41a0Y5WVZm?=
 =?utf-8?Q?iwIS+zTfsFQ=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7558
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000042.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c5c7866a-f26f-4e8a-4b49-08ddef7d5efe
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|35042699022|14060799003|82310400026|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OXU1aGR1bllxRUtMeGpTdkswMDNaV3hGL09mQjRoeHFNdUhxWXZVRHN4NDNN?=
 =?utf-8?B?THU0K3JpMkVOZjFZZjZNYlp2Vmg4RndmZnhkOUlQZXFyOHh2ZWkraSt0V0hW?=
 =?utf-8?B?dmNxVlU0anc0bGx2Zi95WnJPNHhCRkYyQjZpU0p3UDNKZ21QMXJia3l0UVpp?=
 =?utf-8?B?QlN3NVdWUkgvMVdXUmlpb3grTXVnc3FQWmtHbWpRbGp4bmZCajc5eVhRSkJv?=
 =?utf-8?B?b2lUVmlQWWFkMVNWZjk1SmNIaDhIaXl0ajNwZVkwTGxGYjM3QmxITS9aUjN0?=
 =?utf-8?B?TXhMRkQzaHFtaW50STRQVENhWTJQTWtTRklxQldXRnVicDRzS3FKUWM3M0cr?=
 =?utf-8?B?NkRaZUQ3cTUvOVovWURYdklPTE5oTHZxUXF2d3AwZWVTRGpjVXBsbndRTng1?=
 =?utf-8?B?TWpiV0pSV1VZQlgzK3JhQUp3RFlaVlV4UVgzTG41NGF3SEhrTC9JZjhCUGRw?=
 =?utf-8?B?ejhuU09KVWYrSWhCeGlEQlMyemZEcVY5c0N4ZVJ0UlVyQVI2dGxOMlRpSnZK?=
 =?utf-8?B?NWk4WnRhbkw0bXllaUMyYkd0ME0vdXFhd1hBYXZ6Q1JZNGZ5NFl5b0k1bTRU?=
 =?utf-8?B?UjVGV0pNWXJDeWhPZ1RCaHVVTVVaOEpLS0p5RHIvZ0RJQXJmU2NZODNzOXBz?=
 =?utf-8?B?bDRHK0lUYkduL0s2M2xuRkVpYTZ0MThiR2NjcWJQTG00Rk0wbFVLUVFBUjU4?=
 =?utf-8?B?U1R6YjZDMVRnL2VqWU0yMXhVRGt1dGhXYW9yTkRkTFBvNW4wTGZSNU9lMS9Y?=
 =?utf-8?B?NjBGQ0FxSXFUOWJwOW1GT3JiSzJRMmY4ZlU5ZTlDWGV3ZzY0clY1VXIyQmhp?=
 =?utf-8?B?dWRha091TSsvZ1NyTG1uS2NzdmN5eWgrSzl2VkpwR3lrblJSei8zVDZLa1lr?=
 =?utf-8?B?N0RhbU5GcGk0NE1mTThFOVpmeVZsNHdYK05FQitHaS90SU1RWGlWN3JvRlRy?=
 =?utf-8?B?a3owT2RGWmw4S3BKTGE1bW14eUEwMDhUL1M3cHZzNTh2Sm5jOEZIcUxuZ1pN?=
 =?utf-8?B?YnlVZVJuS002cXYwSlR3UWdYODU4TlRNbFZPcFhrNUsyWWhyeW9EN2lZT3Zi?=
 =?utf-8?B?OHFRTEMvNUJoWCtCRkxaU2NvUklKVjc5MG85V05sdExLcUFEcC9yeW1VcldP?=
 =?utf-8?B?NWVXTTBHeU5tdjZXU3JleFU1UXV6elZFR2ZiTExPNW9NZTJldDlmMk9QTEtx?=
 =?utf-8?B?U29HUUptaFA4Z1pEZURMMXZJNzBVY3FFN1UrOTBDZ2syS2lydVIzUUY2MjZX?=
 =?utf-8?B?YVQzVGFMdm9LeWlNalF3OElBemllOHoxbElkUFJrT1B2eElHZlE4V1JpVm54?=
 =?utf-8?B?dDB4Y2VmUVYvbm8va2ZCT2pPWWg4TWNtVlN4cG5ZQzgvSTNuUHFZUEJVWnRV?=
 =?utf-8?B?Q253c3NwcTdmM1RCdzRJR3ZldENlMDJQYklvRGJiOE03Vi9VSHBJY2g0NkJm?=
 =?utf-8?B?Q2YyQmdNQnRhYUtTalVzQ0dWWEFKYXVlejQrWkpaV0pud2RvelVHcFRHSVBJ?=
 =?utf-8?B?SjdxOHVOcElURldWbUNRM2tMSk14NXVDU1laUEJmU1pkSEhMVnc0SjMvNVpj?=
 =?utf-8?B?d0RLR2o3VEhLMCtUZVJkUFo2eHk3R1ZUdFpyTHMxQm9BQkFoeklyMElsQmNY?=
 =?utf-8?B?bThMdDdUS0xFcTJ4QUpRMVdtS2lhbWZDejBhVU0ySVNtN3hLTzBPOHg1UDNI?=
 =?utf-8?B?Q3d0dUZTeis5SzB1MGZIbWlIZ3lLMjV1NDBJcnYxM0JMalZsL1VPZUlYTVo2?=
 =?utf-8?B?QWpnbGpjTXBsY1dUSkJaWWEvU0k5NlRibUpCczVjbnhkYUQ4YUNvVC9vcVZF?=
 =?utf-8?B?Y0dEZVVqaDRlZ0VjSEpxNm9qSC9SSzVpNGhEeGM2TkNBdGgzcFptaEZ1YUpY?=
 =?utf-8?B?QUJoVE4wUUxsNUpMd3JQeU9XZ3M2Q3g5MFFDTmE2U2Z6cHpCY2o5YWczRS8z?=
 =?utf-8?B?UEpBcDhzbEZ6REtNVU1jb0wrUGlhRjA2R0JUTkJRNFd6bFhBQm5hOFVRZkdr?=
 =?utf-8?B?aTVEWVozeXlGYXdTYzJYcHJTZFYxZkdrK0ZWUHd3QUw4czVPVHZTOVo4RzB1?=
 =?utf-8?Q?DfhUi/?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(35042699022)(14060799003)(82310400026)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 08:47:12.6769
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b976d57-1d48-46aa-1640-08ddef7d787e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000042.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8904
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9765BA0008
X-Stat-Signature: 9m93jt5str8fbtymp5q57qwkr4sweezh
X-Rspam-User: 
X-HE-Tag: 1757407638-48862
X-HE-Meta: U2FsdGVkX197AjNaqfF6k3IfwdwPQYHtadOyZ6yXIQyAMW12WGoRRq8/d9vp5634kSvAMRr4wKyIk5scqWpRIjRIjhz86bw4HlSYtgSvgb/DS0CeW7Fo9NGzXYxl5/tsie23+jAnGpSj/KbGn3uQbxc+qQVgKkqNaSwliwrcDycsbbUCoHtXANk3FnCkWttXUst3lnxzaNR+BEBENUmBiZj3e5VnMCZMpaptjh4piLwnuD6RAzN4hYB30nl+h1+tLncx773vr/xAiD7GYK9jN1YrbZ0rLqdw5x1B1wl8X5EnHF9LpF4FdvT3n9ET4jeLJJ5E8kpwtXv2NZOAOLY4kxKzgrdPV5T/W/s6zl+yLOiuEaOEymexpTCFd4BBvNYz86llPlseQgYCtyKbIUKV8DzGDwndICTDWbq+xwhzEPM4AaGSnlBvmKAFHjrUiQbqKsBdA/DN8zjFuJaCu7cuRtYXN5OCUQ+wI28myrRuHNdwKbnaUt2evaL+ow/YYpnTzl7QQDI19OmW23ZirVYDwGTeNnaGRZR/688B1L52nOrB2W3U2UN76ZFcbUNcBK8usa9NiXYrajUcitNxxroOoGV7YSGIN6jYX9U/RVANyxxhh4R6OHwfwg+7oMD4FaRMxySViR9suDkWDLU5TFS8kU/O2f16ZZGHn7ZkVyzkHuv9F4kVzUYMxZVZhkWWUoVELkyThn4ZD1sH7nTxnA3s8cf/5qgvBihq+FBht1Qmeo1JAAQKe70Kda1WKygG2JEjX6AX/EVRUaaHo3iRdR6rmr681ytdM3zUI23QG5WCwPpVeWc73E0XUzuy5uDJvYMttaRKqGVSxFwQ9zP1YSTxc3HzEM5UUk3/w3jJnS0ywQkSq0PR4waWjstNsh45qbCiM7FMbSx8Rxa/aZCg/iwyHNL1iiT0d+4gMblSI/9Y5BqBcGaRKYj/F1uPCEQlcXjrFzzYQrxRmBr09mcQcjC
 SeCrSlYd
 MQmEk7gsu74dn4KqsP/+EMqJOlg22+0ZuOmBce+AG5eJek71vRV1mRNNAZjsy1mck2ZzJ6tW5bpzhQG5ZPmttojx9JWyuTao/xG0KTtkJUrzVmLCoH56wtcqe2jERrWNaksa7miB6R9UYAdyw4ulDAHkz429WP35DWtbuYUyvjvyDIqVaG1ktCT8k48K+vGxWx8rJ/7Dxo7kpLW87nzVnN4QDY7ap8v8n4jQSuJaH6fxt9tP2dEHrIuZSYH9Tnq8Jn5WUjFKhBbO0xfeIraEF2T/U9NAlzgdPvsPhDcjIGosu0Bi0ta2O6TaWi1n/+7y6H8jdG8vnI32My7yjPUQ2zzSmrzjMp3UCb6fsi3tz0Wa/EzhJydP3QYLdC1MVRUvk7crxYzYdb45Gzjmts+kG/AX7WZ+6Bs0U3IhdpjX+Nbcmsv1n2ZQJwa+NCDcbBrKf+PuXVYHTKqAVTi6g/zlgh6gujCkcaORMWnfESoC3RQeToeQM8nisv+VJiwjPLlPBjEoI8OEV1aRvfYdnE9s6kj6TYalfnP4hBSuFylBGSFiLmml03iIXCrHjk/SVSJt9V7r2AMTUzl32OtYmaGu4VuJvKcxl4KxkJrqkDZ6m8fUkjglwWvyJsZdYSCTdBv6wGmXK2Rusjmocy5JzD2WK1FjLeusnbDAPryxCsc0/wOPVJ4Kc45/MvcBf4DxhU5aYQft/yNoOHcA4uFQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 09/09/25 1:18 pm, Hu Song wrote:
> Use folio_nr_pages() helper instead of manual calculation (1 << order)
> for better code readability and maintainability.
>
> Signed-off-by: Hu Song <husong@kylinos.cn>
> ---
>   mm/slub.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index d257141896c9..eba25461641a 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2719,7 +2719,7 @@ static void __free_slab(struct kmem_cache *s, struct slab *slab)
>   {
>   	struct folio *folio = slab_folio(slab);
>   	int order = folio_order(folio);
> -	int pages = 1 << order;
> +	int pages = folio_nr_pages(folio);
>   
>   	__slab_clear_pfmemalloc(slab);
>   	folio->mapping = NULL;

I don't know, the current version is more readable to me. We literally
compute the order before, so we do a simple 1 << order. I'll leave it
to the rest.


