Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8664CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 05:05:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7E328E0005; Mon,  1 Sep 2025 01:05:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2F0D8E0002; Mon,  1 Sep 2025 01:05:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACF8A8E0005; Mon,  1 Sep 2025 01:05:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0C98E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 01:05:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 33BA1C066A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:05:14 +0000 (UTC)
X-FDA: 83839492548.02.07371D4
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011022.outbound.protection.outlook.com [52.101.70.22])
	by imf15.hostedemail.com (Postfix) with ESMTP id 20747A0019
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:05:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=jXKDr4G6;
	dkim=pass header.d=arm.com header.s=selector1 header.b=jXKDr4G6;
	spf=pass (imf15.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.70.22 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756703110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pwNOy8h7N8oInvNx4EZJBXI2eqa83vTMC8O0bSDTLFo=;
	b=cpbwBDtfOZOBcZHYobQdzMDopzEpTFMZtWwj+Mkm0ocgLGg5qULKWEyS3dtdntM9ojI5kE
	x8g7n7akgO76xSMNcNmH/nKvcv1lzaEVTymjlc8w1ieAH/AO7RHIIXnT4vSSb4tbk0qexp
	95go38jrY8VDetFpkL3l2R1Rn7g9Ev8=
ARC-Authentication-Results: i=3;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=jXKDr4G6;
	dkim=pass header.d=arm.com header.s=selector1 header.b=jXKDr4G6;
	spf=pass (imf15.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.70.22 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1756703110; a=rsa-sha256;
	cv=pass;
	b=JkzCr/QcLi6cigfDJm8T//+Toygg87xJaaTq5p88YJYQ4mPJr763qyvq9o6FJaQ88stD4b
	dIDv/4xiN2vOszicuY22QO1odqjQOs6y7xs3J6o+VtIiGsiCrTBEx+gHfLruOudQZzKtk1
	sS3UE11HZEMDPGF4UQPO1HvdmxTnpL4=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=S0V0WcKPn0f3MAbMiFHuVDJdwzDbVi/EXK0WQMsHkyQjZ6IZPW4GA3RMS8X9ka/eJWF1tFXxEEuUO+lqdOQlVYObk35g3ptuJZp3092PJAU/ycm95yFn/w/dZ3VKCA7gMCPy4oggU6UxzDgPrMp3/+SVebiRSEpIjgcHRJbgYSYyc+3gRsy8kp+kChTmi3PKWUQTn6l1Sx2mjvAk2n1lR89olaZHdwtesaZOjuP1pqBXFKNty1gHUYYYevAJh3T34YhC0dIAkwDra9DvAAuAZxuzela4uQ6WqkjAACA1XJrmHuC5tlKo7/z6CEGC7wtGbhPmH6/Wrsl8X3lAFznZfw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pwNOy8h7N8oInvNx4EZJBXI2eqa83vTMC8O0bSDTLFo=;
 b=MSY84UMWV+JLorYGUdMAKWny25KXm910GQRJGwao7gFbSzilZ+Q1E2myvY3Tw77EODQ2kLq6SXi8rkzdnwpD3ZdWK+BpnFiPVXOun3ppO/MqdQMi4NE3lvSfR3P336SNBNkZKK4ABQDzLNmrTQrIHdpMDwYKZrVWJTwD7QyxgTowO8HXsX555yQZcHneou98zX08cFvEogdsUWnS8/NS1REAG5W3OZ4iNiTF8qcrJySVxnmFWZamF/1LuSXpug29B/vGwqopvNO4FRDw4oLnO3Mt3lXgnRVXnbFKRtIv/vWNkjKyWHCrVebmMzuvn2lDs8ELqtvk18qKfz7s4DBL7Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pwNOy8h7N8oInvNx4EZJBXI2eqa83vTMC8O0bSDTLFo=;
 b=jXKDr4G6LtDaH4UNxhl5iEGApU1A80/KKNtus1Nqlgj1MbZ3bdcgo3z+Q8Vd+We8Lqe0uVosTtMm9RHwEqhHI1HKGsY+mrOUMC4rlXlidSHU2g/FZ+sCqTHtGWKqkyFcDW3OI86ZHaeRWXyk8hMllNGC+4KTFFvRyrEX02PmEsQ=
Received: from DU7P191CA0009.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:54e::13)
 by AS8PR08MB8063.eurprd08.prod.outlook.com (2603:10a6:20b:54c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.25; Mon, 1 Sep
 2025 05:05:05 +0000
Received: from DB1PEPF000509E2.eurprd03.prod.outlook.com
 (2603:10a6:10:54e:cafe::5e) by DU7P191CA0009.outlook.office365.com
 (2603:10a6:10:54e::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.27 via Frontend Transport; Mon,
 1 Sep 2025 05:05:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E2.mail.protection.outlook.com (10.167.242.52) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.14
 via Frontend Transport; Mon, 1 Sep 2025 05:05:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jzXMxpbj97mPe5eycZ8ZbQJPqunWh0xsKiHKKitMdQcHM/SrxXXwRffwuTCCo/WuRjkNBcvDZwltA4UD6UGCDsj+cPnRjnUeZdLWt7W+dDWDytvjwN7OtRYqK7OJ4Hd0jfyKqsKMNiDEz3srRCUbSip5uAskv3uzR7P5q8TdlKzyeHs3vea1ETBvNtbDo1GEm9sxfqw2xRt9IJmt6hL1vKGu/eXkGIxq1jGekwSo04TfhqTwX/eIw/tTQ8GNu+eoShCZRVLrJBB6wuyiQyeX6g1nCWE6sY3sB/GJ8HUPsEv2FsLX895Q5yEtHh1ro4k63Tg0CX3Wrp84zqIxPePxtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pwNOy8h7N8oInvNx4EZJBXI2eqa83vTMC8O0bSDTLFo=;
 b=nMTU/Sd15Nmd8nPhWozPCN1VN00JCY9U86urN4ljKu0h3gxnAaZLT79CfHa1jwzEaqfcVWbyObQ7yipA58+ez3cfLccejiGMJbl0RmTjKYTr9seguDRpeaRmdczUqAThjRhlgperUYj1uJelf1uwVB1hvun6mC12JnM/bSCHNbMuOtRYSFe8xCMeJWQJblLSob1gz6BtglH/PgeZWFGEybmbs5wmkGDSTd+nvmxOkJ63yeCmGSnsKly9LCISnLNEhR907JVv5IT7E3N85mofHHoi+y0+udQxxaL969T1/07DFDoewAtQvblQTkNRpZtUKree2wH1KldsCe/bxSL9Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pwNOy8h7N8oInvNx4EZJBXI2eqa83vTMC8O0bSDTLFo=;
 b=jXKDr4G6LtDaH4UNxhl5iEGApU1A80/KKNtus1Nqlgj1MbZ3bdcgo3z+Q8Vd+We8Lqe0uVosTtMm9RHwEqhHI1HKGsY+mrOUMC4rlXlidSHU2g/FZ+sCqTHtGWKqkyFcDW3OI86ZHaeRWXyk8hMllNGC+4KTFFvRyrEX02PmEsQ=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by PR3PR08MB5770.eurprd08.prod.outlook.com (2603:10a6:102:87::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.26; Mon, 1 Sep
 2025 05:04:31 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9073.026; Mon, 1 Sep 2025
 05:04:31 +0000
Message-ID: <e722e49a-d982-4b58-98f7-6fef3d0a4468@arm.com>
Date: Mon, 1 Sep 2025 10:34:25 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/6] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
To: Ryan Roberts <ryan.roberts@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Yang Shi <yang@os.amperecomputing.com>, Ard Biesheuvel <ardb@kernel.org>,
 scott@os.amperecomputing.com, cl@gentwo.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250829115250.2395585-1-ryan.roberts@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0005.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:174::9) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|PR3PR08MB5770:EE_|DB1PEPF000509E2:EE_|AS8PR08MB8063:EE_
X-MS-Office365-Filtering-Correlation-Id: 045706fd-dc78-4db5-b640-08dde9151d45
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?RmJnLzJxWXFsVmpLd1lsQi8rWUQzMXpJbXNrT2NiQjJBV1BtYmI4UVlQSHY0?=
 =?utf-8?B?UDZ2aVpxOFVCdG5LeU5FdURUUDdTdzhqdElMZlZMeTV0S3JzWCtvSU5Ob3BR?=
 =?utf-8?B?eVhuOSsycWhFcVAxeXlBOWxGVENIT2tuQ1lJRzk3aFRDYm01Z3U3NngzV2Uy?=
 =?utf-8?B?TTdOejhjd1MwbTJ3TWY1eXBnd0JCR1ZQR001aldlMHdMVCtnQjQwSWZoRThz?=
 =?utf-8?B?alowbVZCOHZONWV0MFFpNXhQNnkrTU4rWXVVUFNYd1dPYjBPZjlVREdnMUlJ?=
 =?utf-8?B?MlpLbmI5U2JHNVQwd2RiMGRCMkNUYXFORks5V2NySTdWWTg1YXlEZW93WXJt?=
 =?utf-8?B?VmxjekN1RXJVMnRBMU9CaCtCWjhzT0Q0c2lIRkpzTkZCY1dTSTZVMWduRWJS?=
 =?utf-8?B?SDBxRHdMbEY3N1BmazhjU29zTzREU0lydUR3YldqWTFkN3lCVnRHL0srMGFq?=
 =?utf-8?B?dmtJelRFb0dLYnB4U1FjY1JMVUpTUWlBejJEMFVRMUZ2VnRnRjVVeGJmUnJD?=
 =?utf-8?B?bUpFSjhTbW80S0c2VEhLZTBqTU44MUJSa0tNMzZzSXNYbGVsYkNWa3ArUTZz?=
 =?utf-8?B?bG5YRk1FZ05DZEU2V0w2SFNybnhXd3hXcklxZFp5TjFsQzFsSnhRMm9oVHNy?=
 =?utf-8?B?bllHbnZXQi9hd0pDZHdHMmZvTjR1RW81cjhzaGNzVmJLekFJSytjVHBQUjEx?=
 =?utf-8?B?d2duOW9nQjRuOGZZQlRYRDFJV3RuY05QWTdWbzh6SmpYdzdiZ0tObjdQMjdk?=
 =?utf-8?B?QWkwb0JOQVRmMVVreGZwUS9uZHB5YkN6ZUxXSE9XVmtFRWM3NUU2bDJrTjZo?=
 =?utf-8?B?WWF1djUrd3lWaGZKeG0vWnh4N3JZK2Frb2FmYWJSNXZrUDJnSWczYy80ajJ1?=
 =?utf-8?B?V3E3K3FLK2tCeFR1RG9ZWEhid0RaMGJ1S0pyK0NZcktGMjNRVVVRaHljYmYw?=
 =?utf-8?B?ZG4zRWpCcWNIN01hdDNSc2IxUmxhRlNTdGRHcDJtakxtT243YUhHR3Z6M3BG?=
 =?utf-8?B?TXEyVGtyQ0ZCeDk5Qm1OUXJQcnA5R3JSSWpONGN0Wkd1L1g1SWdqblpyWTFR?=
 =?utf-8?B?VTdhNlJmQkZTemkxZ0JnVkR1TWNDUVF3aDVURUt1ajU2dmd6NW9TUTkyYzc4?=
 =?utf-8?B?SC94Q3AvWmZOS3Jranp4UUMyR3grMmlOT0RVYjlQRVBsUUx3ci90bTAxbmZG?=
 =?utf-8?B?UEM4NFVKYWx4eWo0RzFqQkFlWU1LSjdOdVFNbWUrL0tvK3JQdVFFZ1Q1R2tt?=
 =?utf-8?B?UlRvbkg2cHJSTVRYNEZ1VGVPeUNQSGVkSDFQVFA2M0Y1US9KUG5TdXVueHlW?=
 =?utf-8?B?QjNhYStFY2JVU0RyenhlR2xIRnErbzNKcUNmVEhuYmVNanJGMmlGQzNjeEZm?=
 =?utf-8?B?eFVKMXpVUlVNQ1ArZWxkZkt1ZTRpc0hXeUtQZWxEcXlCeU11SmxCS2lQaHpw?=
 =?utf-8?B?blkzN1V0SkUzU3hCVXJuUnduOTRTVS9FNDdSN0J4RC9kUlNNbGdmVmdYL1Qw?=
 =?utf-8?B?ZTZEZFpBUE9iUjFNZW1lNWRWY2hCaERiYUd0QXMrSUtJUExXaFRRdSs0ZmFG?=
 =?utf-8?B?ekZnRXFZNHJZSmVNMTRhODNwbEJpNE8rWlZBTERWNkc1b0pqNFB4WFJLeWRB?=
 =?utf-8?B?Z05YZEdpTlhUSlUxZyt6UmJ1bHdLdSt6Rm1HUXhYQ3lMSTNRYy9STFBMaUM0?=
 =?utf-8?B?bmxORUF5VDBPc0RMNkErZnRqZFVzRHI1VzkzV3ljcnRLbXRKUEF3QUl1Q20r?=
 =?utf-8?B?NzVwWW1qbjNrZGtrTWlIWWduK2FJV01aN1JRVXdYUVZEcXVieFJuT29DTGtG?=
 =?utf-8?B?RlluZFZUaWFsL05ib2VJY2RkRnh1dGtRcGhwaDN1YVdxU3V0S0k2K2hPL25E?=
 =?utf-8?B?NzdEMnhFWmhJVXJBMnhLVTRmWEMrU0RmY3U5c1d2SDROTC9uMjdpbUZwRzcw?=
 =?utf-8?B?NTlJMm5BSmttUEhZcTQxVGNnRUtuM3B3VDBjVllZRDgwVnRCRTB5bkhmclJM?=
 =?utf-8?B?RzV5WlFUSmFnPT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5770
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E2.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	be7f1b58-91fa-4c56-979f-08dde9150897
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|7416014|35042699022|1800799024|36860700013|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TGZOS1U0REJGS2dxRzZXT3dvVk51M242dC9zMVBsdk9FQTU1RmNDZFo1YVVN?=
 =?utf-8?B?RW1WK2VVSWoyWGtNaldCWDNoK1BVdUIxZ3dCZ3JkVDBKYWp6eG9uQXU1czNy?=
 =?utf-8?B?RzFiQVV0amNyaVpQTC82em9EZzZjcGFPMmFaeDdZb09tdUhlcXptNkZLTEtT?=
 =?utf-8?B?YXZnQUpJVkhFbE5EZmpXZjdYbHp0WTNmR29tb1E5T1FDMURkTnl4eXMybEFO?=
 =?utf-8?B?dEpiRGhmbkJVcFJqcklrajMwRExYemtZdUxIK0JvTEo0N1UweUh5WGdiRGo5?=
 =?utf-8?B?SEx4KzBndFVyU2U1Q3hCQmpDMmVWRUx5YXk0MFBEaDl3bkhpd1VCQXNKajl3?=
 =?utf-8?B?dytMbWtyS2krTEpBR08yZEdUcjJvRkJQa0tuODNxaXRWejFxb08vTHBSSlZH?=
 =?utf-8?B?QlNleVRLTjNXRXZ0MDRSK1RBSWlBY3NXclJyVk04bFJ2cDNpZldWc0M3Qk9Z?=
 =?utf-8?B?ZnQ3UHU3Q3l5Rm1LbFhuOVVNYWZ1R3Z2Z0k3M1g2QTc4R3BKbmd0YmxpT2N0?=
 =?utf-8?B?SlpjanJrRnBBcUtEQyt1dVo1VE1tRDVTN2JjbTRlRFdXakdTTm1CWlFaS1dx?=
 =?utf-8?B?TkZqRXhSR2xnSjZERlh5VkRrenZHcitLYjlDbjVEZi9nZDFWaDVjS3NWQm5N?=
 =?utf-8?B?ZkxWaDE0a3FnKzZlN01CR2pEY0RzcEpTRVJEVWw1TEhWVFZ0Z1dOVWtDS2ps?=
 =?utf-8?B?RitpOHkzc2pEcEgyMnQ5SXVOSldvTzlDNUtMT3hpRGRwbFZhSmtkSnQ5VUg1?=
 =?utf-8?B?WENDQ01xV2toMFRYSGhXbEI2WkJzbWI3Q0t6MnhHL2pVZ1JmaEJFcWRadllZ?=
 =?utf-8?B?akZ5TnVpOWhOVnRsUHBiMVQwY21lYS81cFF0dVhLYklnSWNicFFlY1pTL3lG?=
 =?utf-8?B?MkdmR3RuVWl4cThqY3d3NThuTEVhWjJJeG9ycnZDMGpBbm5BWXBQZU1odFU1?=
 =?utf-8?B?N25JRng4UUR1ZkZZeUlqYzBXcEUwNEVNTGVPMHVUMGNaZ0dMNGg5eU9taVY4?=
 =?utf-8?B?UDBuZ2R2UFhhUnMraGVTakMzdlRXM0pXbWxLamlnRExkRHdwNjBoRUtEdHlo?=
 =?utf-8?B?MGhqSWZkS3V0MjhtZURLMGI3QlBoaE9xNXFPN21CWGVZcUhheDZvVW5sOUh1?=
 =?utf-8?B?dS9nTXBvUzAvWEovS0w1MHVHWUNkcWthOHZyWkVMaUdUcWFpaFBLVFlmeUY0?=
 =?utf-8?B?bFVKeGdjazNRUHJ0bVc0M2NlbFZkdmM1NEM3amdFdDFWU1hoeUR4T2NEZTRo?=
 =?utf-8?B?TW1sS3FTUkZsMkNBNlk3UEZoQVlPcnNxZUJuRFpDT1RZbGpkaFBQWHVzUTFh?=
 =?utf-8?B?Z3JiQWsrem1aa2ZXTTdmREsxbWIxcXByaG04SW1rVHpJckI0WWV0MWZHSEY2?=
 =?utf-8?B?TzBVOGZmdjFVb3I2bEhPZ1hsUitzTjhEMSt0d2dRUHNkRmR5ZlhRMHZJdm1o?=
 =?utf-8?B?RTFEcFJZYTNzVzlzSm1udTNqZ1dtYktjQ0NjdEJwcHJiaXJxYVFRQ1B0bnpY?=
 =?utf-8?B?SU81cjRObExvNGlEWEorQVVkcUw5V0tWRERhckVySmd3Rk52YmhaRUZNUHBC?=
 =?utf-8?B?d1RoVXBzdTJBYm8vNlpzSG5aQzBWNGYzSkJRSHhSYlA2bkdMbVNtTXRGeHZ2?=
 =?utf-8?B?ZW1uSjZudGpmY21yTmdxTURtekxHK3JJbHBZL0NwN1lLdGR2ZURLc2w0Nkl3?=
 =?utf-8?B?Y2dqaVdVYURGMmtrdCtWYTUrTGd5RXorTU4wcHYwR3NQVHN0endjMmZSMU4v?=
 =?utf-8?B?aEM5Q2ZxUjV5UVV5WTlIMkNKSnRhNzRBWlQyMkdleEUzS2M4QXRKMDh4UDM4?=
 =?utf-8?B?WWZOK2pGWEFtZnFWdEJOb0dMVHBQNjNDQ1ZuWVF5R3N2YmZ4dm1wZ0pnUmxy?=
 =?utf-8?B?Umk1SDFmdzFRRGdSeVNjb2ltbm42bjV1WmQxQ2NFYzZvcjBZSTlhZ3V1WkhL?=
 =?utf-8?B?UmM2a3dleGVObG52YjQrRlVNVmplUXY3d1dlbDB2MHk0aEtyZmNKUkUyRFJs?=
 =?utf-8?B?UzZieUtsY0sxdlRVaHBPa0dNdVVjdE90UU1MdHZjKzg2NUVTakxpSml6M2VD?=
 =?utf-8?B?cHhpQk5nNGxoOTJXUnVKMndKWm4wN05pOGkrQT09?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(7416014)(35042699022)(1800799024)(36860700013)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 05:05:04.9963
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 045706fd-dc78-4db5-b640-08dde9151d45
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E2.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8063
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 20747A0019
X-Stat-Signature: asurm6cq755bwwjfz7anskmea848x7ea
X-Rspam-User: 
X-HE-Tag: 1756703109-94853
X-HE-Meta: U2FsdGVkX19bW9FBY+Rp4wU8B7uEYXsqamqfTU0QnpcRIalaBx+kj2IGkZ0gUUIW+OdGNFWCrAbC4lffxt3yoUq/V5BFe95tKtcPoKvr1280N9HT9kZl8woajDRLnZkcDbkzLkGT3zs8cPqGJTv3QFiKMLcymhBEim0iz7Y8PsyH9TC3gzSDjamvh/K3dn14zL7JgdcGfUB5uktJQCZDyNsnxY3VAdhgnlxOqSQZTiubPqeDO4UrEYhcsdjyiQ0M9fT8K152pTZdtwWeFeCO6SvhM6jQPtIzbHApezR3CyuLVWoAkUS7zjyjNcX8humjTy6wAI3hyFHc/TpaReIyjigj6Hi9/gtY8/QkIbW6GJCBqXsEo4oJoidb2E0PLI2NykjpMiK92TX3Zz27opWnPrPHm0TiRvhCACunihdvfd90mRZV1q4ENlmY6DjIp163ihF+G8GLk1uzPdrFgFMU1hYhPG4YVG3TMo+NC30dsU7wvQNdhzIpedko28DeytXctEAPKOQUKhuz+k/4ZDonsGX8COu2kFIt6a8PDlb97z+vSef+uD/Vtg+xS7Q/fv2hb6j7FxueBLyHXD1UU3Tr8y7WWf0Ffhbo1mUFAb/5VW7hzaPDG8vLXdieGid80Bt8mm4SHQfhnnf8lcaldxPlC5LQE+rrjnkoHLmfPldsQzCF9UYeDfYxPXLGtmze+/40synywTc4kFceA2VLFwTbOId8XPMg7qy3z0gTj/yXM1zXiHAtRBfjt1zNV9/H/MAKXPa3oKln1xJhq9o8SQ7Gs57qdK5mKUmx9fBap9H3Bvqw/Gn8D9PAVIh9JL3fCUC/JoZPpw/31HQAO29tMniof8OQJ4k7Pl+OV3nP2PxAQ9HrFXv+zuZPBsYHlKe2wZC/rU65z9Si2L9YUV7dskZzubc3d7QL8E78SpIccCU5wU8i6kl8lBuWfXeuJXndHCJxg+QKC7aHM16EZVFXSbK
 St3taTYA
 E0kWdQyl9llX/fXNUxxLe4qD4B7siHUyS4pfqNG2desWJPJRQAUl4UoZxkNWOI9ric64l/Z+rqZkkP5/qMawadhj3BIEdqF4lNguzxIXEFVDh6Lii+pTZ5y8pvti5G2E93yqBECfOR2RWm+wKoazYzp9I25w/lBfMya2GOYKGCjgiKsd9KO5C7vBmCt9S1gxOVhvkNBetcAqCZ6tK7+3zRCsDu4ARPHXsccagBiVgMBVqvHJOy/L2LCQm/1xxqYCyb6yTSGOnuyBdhFDj5umiCYD98mlJM/ivp7M9ING0l2zYguinKvcDfcrDe9S9Qiu/5/2zcl1n9dbLdLtZzj5SbN35bv4aNktZ786UWKa1N+e4f8fy47/oAwLI7OWRm6Lot5sRpZJoXKr9AF/Tz/m1Mbdv3pmkUgiNdKIrcl13l4vNu1o+DS4BxVga9yZj1AB1Ls2ntBPOnK6qpK8JG2LtVxAc9wWYCDVoC+5nUPMhZNKovkwAWVGv10ZIQ5TPHAHyrXZ9Lbl36WWX3FYzcwVTj1sfa/PASrJVigVftNORm7kSODpHgM3HXlCdjq8ZJy4YpdVcL8PASjHf5om4LxR9ZJ3A3GxgHZ4VSMj6KnbGSFP69JBhPgSUBtXRxvhOfCiz3h7jaKUdqil2jJ2BxMqUQIipi4oxlZKQCP1oBB1LssG1XbU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 29/08/25 5:22 pm, Ryan Roberts wrote:
> Hi All,
>
> This is a new version following on from the v6 RFC at [1] which itself is based
> on Yang Shi's work. On systems with BBML2_NOABORT support, it causes the linear
> map to be mapped with large blocks, even when rodata=full, and leads to some
> nice performance improvements.
>
> I've tested this on an AmpereOne system (a VM with 12G RAM) in all 3 possible
> modes by hacking the BBML2 feature detection code:
>
>    - mode 1: All CPUs support BBML2 so the linear map uses large mappings
>    - mode 2: Boot CPU does not support BBML2 so linear map uses pte mappings
>    - mode 3: Boot CPU supports BBML2 but secondaries do not so linear map
>      initially uses large mappings but is then repainted to use pte mappings
>
> In all cases, mm selftests run and no regressions are observed. In all cases,
> ptdump of linear map is as expected:
>
> Mode 1:
> =======
> ---[ Linear Mapping start ]---
> 0xffff000000000000-0xffff000000200000           2M PMD       RW NX SHD AF        BLK UXN    MEM/NORMAL-TAGGED
> 0xffff000000200000-0xffff000000210000          64K PTE       RW NX SHD AF    CON     UXN    MEM/NORMAL-TAGGED
> 0xffff000000210000-0xffff000000400000        1984K PTE       ro NX SHD AF            UXN    MEM/NORMAL
> 0xffff000000400000-0xffff000002400000          32M PMD       ro NX SHD AF        BLK UXN    MEM/NORMAL
> 0xffff000002400000-0xffff000002550000        1344K PTE       ro NX SHD AF            UXN    MEM/NORMAL
> 0xffff000002550000-0xffff000002600000         704K PTE       RW NX SHD AF    CON     UXN    MEM/NORMAL-TAGGED
> 0xffff000002600000-0xffff000004000000          26M PMD       RW NX SHD AF        BLK UXN    MEM/NORMAL-TAGGED
> 0xffff000004000000-0xffff000040000000         960M PMD       RW NX SHD AF    CON BLK UXN    MEM/NORMAL-TAGGED
> 0xffff000040000000-0xffff000140000000           4G PUD       RW NX SHD AF        BLK UXN    MEM/NORMAL-TAGGED
> 0xffff000140000000-0xffff000142000000          32M PMD       RW NX SHD AF    CON BLK UXN    MEM/NORMAL-TAGGED
> 0xffff000142000000-0xffff000142120000        1152K PTE       RW NX SHD AF    CON     UXN    MEM/NORMAL-TAGGED
> 0xffff000142120000-0xffff000142128000          32K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
> 0xffff000142128000-0xffff000142159000         196K PTE       ro NX SHD AF            UXN    MEM/NORMAL-TAGGED
> 0xffff000142159000-0xffff000142160000          28K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
> 0xffff000142160000-0xffff000142240000         896K PTE       RW NX SHD AF    CON     UXN    MEM/NORMAL-TAGGED
> 0xffff000142240000-0xffff00014224e000          56K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
> 0xffff00014224e000-0xffff000142250000           8K PTE       ro NX SHD AF            UXN    MEM/NORMAL-TAGGED
> 0xffff000142250000-0xffff000142260000          64K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
> 0xffff000142260000-0xffff000142280000         128K PTE       RW NX SHD AF    CON     UXN    MEM/NORMAL-TAGGED
> 0xffff000142280000-0xffff000142288000          32K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
> 0xffff000142288000-0xffff000142290000          32K PTE       ro NX SHD AF            UXN    MEM/NORMAL-TAGGED
> 0xffff000142290000-0xffff0001422a0000          64K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
> 0xffff0001422a0000-0xffff000142465000        1812K PTE       ro NX SHD AF            UXN    MEM/NORMAL-TAGGED
> 0xffff000142465000-0xffff000142470000          44K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
> 0xffff000142470000-0xffff000142600000        1600K PTE       RW NX SHD AF    CON     UXN    MEM/NORMAL-TAGGED
> 0xffff000142600000-0xffff000144000000          26M PMD       RW NX SHD AF        BLK UXN    MEM/NORMAL-TAGGED
> 0xffff000144000000-0xffff000180000000         960M PMD       RW NX SHD AF    CON BLK UXN    MEM/NORMAL-TAGGED
> 0xffff000180000000-0xffff000181a00000          26M PMD       RW NX SHD AF        BLK UXN    MEM/NORMAL-TAGGED
> 0xffff000181a00000-0xffff000181b90000        1600K PTE       RW NX SHD AF    CON     UXN    MEM/NORMAL-TAGGED
> 0xffff000181b90000-0xffff000181b9d000          52K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
> 0xffff000181b9d000-0xffff000181c80000         908K PTE       ro NX SHD AF            UXN    MEM/NORMAL-TAGGED
> 0xffff000181c80000-0xffff000181c90000          64K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
> 0xffff000181c90000-0xffff000181ca0000          64K PTE       RW NX SHD AF    CON     UXN    MEM/NORMAL-TAGGED
> 0xffff000181ca0000-0xffff000181dbd000        1140K PTE       ro NX SHD AF            UXN    MEM/NORMAL-TAGGED
> 0xffff000181dbd000-0xffff000181dc0000          12K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
> 0xffff000181dc0000-0xffff000181e00000         256K PTE       RW NX SHD AF    CON     UXN    MEM/NORMAL-TAGGED
> 0xffff000181e00000-0xffff000182000000           2M PMD       RW NX SHD AF        BLK UXN    MEM/NORMAL-TAGGED
> 0xffff000182000000-0xffff0001c0000000         992M PMD       RW NX SHD AF    CON BLK UXN    MEM/NORMAL-TAGGED
> 0xffff0001c0000000-0xffff000300000000           5G PUD       RW NX SHD AF        BLK UXN    MEM/NORMAL-TAGGED
> 0xffff000300000000-0xffff008000000000         500G PUD
> 0xffff008000000000-0xffff800000000000      130560G PGD
> ---[ Linear Mapping end ]---
>
> Mode 3:
> =======
> ---[ Linear Mapping start ]---
> 0xffff000000000000-0xffff000000210000        2112K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
> 0xffff000000210000-0xffff000000400000        1984K PTE       ro NX SHD AF            UXN    MEM/NORMAL
> 0xffff000000400000-0xffff000002400000          32M PMD       ro NX SHD AF        BLK UXN    MEM/NORMAL
> 0xffff000002400000-0xffff000002550000        1344K PTE       ro NX SHD AF            UXN    MEM/NORMAL
> 0xffff000002550000-0xffff000143a61000     5264452K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
> 0xffff000143a61000-0xffff000143c61000           2M PTE       ro NX SHD AF            UXN    MEM/NORMAL-TAGGED
> 0xffff000143c61000-0xffff000181b9a000     1015012K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
> 0xffff000181b9a000-0xffff000181d9a000           2M PTE       ro NX SHD AF            UXN    MEM/NORMAL-TAGGED
> 0xffff000181d9a000-0xffff000300000000     6261144K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
> 0xffff000300000000-0xffff008000000000         500G PUD
> 0xffff008000000000-0xffff800000000000      130560G PGD
> ---[ Linear Mapping end ]---
>
>
> Performance Testing
> ===================
>
> Yang Shi has gathered some compelling results which are detailed in the commit
> log for patch #3. Additionally I have run this through a random selection of
> benchmarks on AmpereOne. None show any regressions, and various benchmarks show
> statistically significant improvement. I'm just showing those improvements here:
>
> +----------------------+----------------------------------------------------------+-------------------------+
> | Benchmark            | Result Class                                             | Improvement vs 6.17-rc1 |
> +======================+==========================================================+=========================+
> | micromm/vmalloc      | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |              (I) -9.00% |
> |                      | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |              (I) -6.93% |
> |                      | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |              (I) -6.77% |
> |                      | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |              (I) -4.63% |
> +----------------------+----------------------------------------------------------+-------------------------+
> | mmtests/hackbench    | process-sockets-30 (seconds)                             |              (I) -2.96% |
> +----------------------+----------------------------------------------------------+-------------------------+
> | mmtests/kernbench    | syst-192 (seconds)                                       |             (I) -12.77% |
> +----------------------+----------------------------------------------------------+-------------------------+
> | pts/perl-benchmark   | Test: Interpreter (Seconds)                              |              (I) -4.86% |
> +----------------------+----------------------------------------------------------+-------------------------+
> | pts/pgbench          | Scale: 1 Clients: 1 Read Write (TPS)                     |               (I) 5.07% |
> |                      | Scale: 1 Clients: 1 Read Write - Latency (ms)            |              (I) -4.72% |
> |                      | Scale: 100 Clients: 1000 Read Write (TPS)                |               (I) 2.58% |
> |                      | Scale: 100 Clients: 1000 Read Write - Latency (ms)       |              (I) -2.52% |
> +----------------------+----------------------------------------------------------+-------------------------+
> | pts/sqlite-speedtest | Timed Time - Size 1,000 (Seconds)                        |              (I) -2.68% |
> +----------------------+----------------------------------------------------------+-------------------------+
>
>
> Changes since v6 [1]
> ====================
>
> - Patch 1: Minor refactor to implement walk_kernel_page_table_range() in terms
>    of walk_kernel_page_table_range_lockless(). Also lead to adding *pmd argument
>    to the lockless variant for consistency (per Catalin).
> - Misc function/variable renames to improve clarity and consistency.
> - Share same syncrhonization flag between idmap_kpti_install_ng_mappings and
>    wait_linear_map_split_to_ptes, which allows removal of bbml2_ptes[] to save
>    ~20K from kernel image.
> - Only take pgtable_split_lock and enter lazy mmu mode once for both splits.
> - Only walk the pgtable once for the common "split single page" case.
> - Bypass split to contpmd and contpte when spllitting linear map to ptes.
>
>
> Applies on v6.17-rc3.
>
>
> [1] https://lore.kernel.org/linux-arm-kernel/20250805081350.3854670-1-ryan.roberts@arm.com/
>
> Thanks,
> Ryan
>
> Dev Jain (1):
>    arm64: Enable permission change on arm64 kernel block mappings
>
> Ryan Roberts (3):
>    arm64: mm: Optimize split_kernel_leaf_mapping()
>    arm64: mm: split linear mapping if BBML2 unsupported on secondary CPUs
>    arm64: mm: Optimize linear_map_split_to_ptes()
>
> Yang Shi (2):
>    arm64: cpufeature: add AmpereOne to BBML2 allow list
>    arm64: mm: support large block mapping when rodata=full
>
>   arch/arm64/include/asm/cpufeature.h |   2 +
>   arch/arm64/include/asm/mmu.h        |   3 +
>   arch/arm64/include/asm/pgtable.h    |   5 +
>   arch/arm64/kernel/cpufeature.c      |  12 +-
>   arch/arm64/mm/mmu.c                 | 418 +++++++++++++++++++++++++++-
>   arch/arm64/mm/pageattr.c            | 157 ++++++++---
>   arch/arm64/mm/proc.S                |  27 +-
>   include/linux/pagewalk.h            |   3 +
>   mm/pagewalk.c                       |  36 ++-
>   9 files changed, 599 insertions(+), 64 deletions(-)
>
> --
> 2.43.0
>

Hi Yang and Ryan,

I observe there are various callsites which will ultimately use update_range_prot() (from patch 1),
that they do not check the return value. I am listing the ones I could find:

set_memory_ro() in bpf_jit_comp.c
set_memory_valid() in kernel_map_pages() in pageattr.c
set_direct_map_invalid_noflush() in vm_reset_perms() in vmalloc.c
set_direct_map_default_noflush() in vm_reset_perms() in vmalloc.c, and in secretmem.c
(the secretmem.c ones should be safe as explained in the commments therein)

The first one I think can be handled easily by returning -EFAULT.

For the second, we are already returning in case of !can_set_direct_map, which renders DEBUG_PAGEALLOC useless. So maybe it is
safe to ignore the ret from set_memory_valid?

For the third, the call chain is a sequence of must-succeed void functions. Notably, when using vfree(), we may have to allocate a single
pagetable page for splitting.

I am wondering whether we can just have a warn_on_once or something for the case when we fail to allocate a pagetable page. Or, Ryan had
suggested in an off-the-list conversation that we can maintain a cache of PTE tables for every PMD block mapping, which will give us
the same memory consumption as we do today, but not sure if this is worth it. x86 can already handle splitting but due to the callchains
I have described above, it has the same problem, and the code has been working for years :)


