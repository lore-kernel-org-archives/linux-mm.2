Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34076C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 10:41:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7A9A8E006B; Thu, 24 Jul 2025 06:41:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C54158E0051; Thu, 24 Jul 2025 06:41:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1A508E006B; Thu, 24 Jul 2025 06:41:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A33E8E0051
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:41:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5458E160336
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:41:26 +0000 (UTC)
X-FDA: 83698816572.22.6443F2E
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013034.outbound.protection.outlook.com [40.107.162.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0248B18000D
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:41:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=B5Kov9O1;
	dkim=pass header.d=arm.com header.s=selector1 header.b=B5Kov9O1;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of Dev.Jain@arm.com designates 40.107.162.34 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1753353682; a=rsa-sha256;
	cv=pass;
	b=XJM4CCnKY52IptZRdbXYkvp7C1bq9KjaqkHhKLYoboZbHf8co32saxyX8znIBPNB7Of+gH
	Bt6m18eUFABfdn+7DlIR5umJyqdtfDS36UG3IdfMwvzwnboL1pi9cIg7wFB3p4mGpUSBtL
	/hh+8OBmuTLzlrA85BfB4y9pdxQW9ZM=
ARC-Authentication-Results: i=3;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=B5Kov9O1;
	dkim=pass header.d=arm.com header.s=selector1 header.b=B5Kov9O1;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of Dev.Jain@arm.com designates 40.107.162.34 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753353682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bVpxmwyykIZyzbRcDXjwMXYafK1eoG9hoBHNPR9e740=;
	b=dcLjdvuL5c5WoZPJtZamiCa11FYHgcJc1AB7mda7avTJN5/QjrsIL0sX5nvGCfBuIapVDx
	QMboClUeoWcJ7OSww6lHDiVVTZSY+pMxgwL5guC2QQAdDoBdG3rICU74O2S25Wgpbm5wT2
	1ECo8/wJMurlWTU0lYFIXYpIrU24Xq4=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=hHgLzCRz6kq0KDPvTjyV5aXGwHGivgwJKTzck8LVEs4oLEwQPC4pGar+Z1YwZDkGpK8ZYDI+AECcnxKjvy5UvbE2MEScAi9Lmf+DHnTuqdMD2kD524XOyiDvyni5i3fFJySOhrPIKEmrOTd7qrCtOBeGFzkznoUQY3gZbL+Ok5Qwf+zMBFf7PG7iXr4AhtW5A1nk2hV8qFuZ2WopkmI6tI+YpQqWAHG751oboe4N6lpDe0laTi6C1swEoPwWoeO0T+ZlSxdcBBUAw0E14SACAw76BNNk8HxoISp9166E9baWiRanixUqDp50OVSoxeIjzeQ3NwUUDDkqYiJZ2UcskQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bVpxmwyykIZyzbRcDXjwMXYafK1eoG9hoBHNPR9e740=;
 b=cD8SVIYH1jmx/EnKOFRgKtcWFT0irB3bNm6GYIM+ImhQ1aFNqWiV9W0zLsiy1wfVAM1NfC0PfC+c+KeHJhAt5EUt3a0Yff8r+SANh3OhuacqoK4TOAmJOhiqhvubX2ur5sbJrxv1dIUF4BMgLYJDJ5+zGitMDO3j5LMgY1744BLAuB5Mp4auIy92MQkrMUpiLJvARHXIU4gKghkGTpLk8XVE0wJUr1V6Ymr3UZPWnXghqQQV+5p42SQu/coWYtxcu+q4PBhbjwEnPNmKJ98TO9PWY/T7GAJ2zl44RVfD2SBpsA4UCJzXwOYJ/8/idMAp76TX/vQqZ4oJaNiWzVBcjQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bVpxmwyykIZyzbRcDXjwMXYafK1eoG9hoBHNPR9e740=;
 b=B5Kov9O1TkF4AqFKChllQPsdTBROadQy8G6bGe3cNhAvAsQb4qoSsOTJHYnUInpq6RiukuaRd6+NylaVs3v1Luh3iV/Qcs21AQig556Xq8JHWC7apeukHPYMPoX4gI/DKfjN0qOVRKWLNr4njm81iIaMWrQuOgvEs0ehffvWvAM=
Received: from CWLP123CA0268.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:1d5::14)
 by AS2PR08MB9365.eurprd08.prod.outlook.com (2603:10a6:20b:597::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Thu, 24 Jul
 2025 10:41:04 +0000
Received: from AM4PEPF00027A63.eurprd04.prod.outlook.com
 (2603:10a6:400:1d5:cafe::e4) by CWLP123CA0268.outlook.office365.com
 (2603:10a6:400:1d5::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.22 via Frontend Transport; Thu,
 24 Jul 2025 10:41:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A63.mail.protection.outlook.com (10.167.16.73) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.20
 via Frontend Transport; Thu, 24 Jul 2025 10:41:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IjWH4aG1R8Iw7Z4Lzb+eQ/XTSIrBWmaNXakICkc+I86fTgIT1LDD8nLX9m+QioAUeKI5kP27ouyAR9xZZCNjJVXHo9Cv4zG+CqTAMISf9kKXn4BNZ0vHjCGiQd18DDyng2LudnlNw6L/KUBXMqBGTS0KNmRTjgHGMvyokxlAIIZ6kpw/VALCgmdYUm33JVrFdkytPshfJRSMAYxb5DpwbQJwfg5RVCWhkiYn8/bDiDPHzNRygWBvIJDGbOLV+e5vsC9S66Zptyo3/AB1JpAet1ZS6OUNVprDVzU9CfMS8oOSxsbEYpnFBI6hMvT4NN+825k2VmV89N7Zi7yP/+xoWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bVpxmwyykIZyzbRcDXjwMXYafK1eoG9hoBHNPR9e740=;
 b=K0esL797g7uKLdL4/DwLMqkk3mRp/U1XAwM/YlDzACNeH2JBLufXbbj91NWl6ie1rDStAiTLhF9nfTeLwPz8F2vcsCq3BSBBAS0IiFd5qiq+l3DKpUe2uVJ2rWzz2DAQ4GQVMK9cIisrfkkcSHybMxOQrwD32GxrNd7gX2rEST4Og4eihtfdj0rCfBBzK3v2Gvgq4qxrE1Q6qKGQH0g6I9svMZEMJM54V/uDEC9IPaEfgyIDqneRu9JVYlZ9gFiByO53QMFLT1E/kB518mDbK9oawEhHOLodbGxgSlz8YVeaxsnNRNhOlmUNrzsEt/PgIueu6sfDbbYOBNYLC4jY1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bVpxmwyykIZyzbRcDXjwMXYafK1eoG9hoBHNPR9e740=;
 b=B5Kov9O1TkF4AqFKChllQPsdTBROadQy8G6bGe3cNhAvAsQb4qoSsOTJHYnUInpq6RiukuaRd6+NylaVs3v1Luh3iV/Qcs21AQig556Xq8JHWC7apeukHPYMPoX4gI/DKfjN0qOVRKWLNr4njm81iIaMWrQuOgvEs0ehffvWvAM=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by AS8PR08MB9316.eurprd08.prod.outlook.com (2603:10a6:20b:5a7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Thu, 24 Jul
 2025 10:40:30 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.8964.021; Thu, 24 Jul 2025
 10:40:30 +0000
Message-ID: <b5570f50-8534-444b-8c7d-68d676840eef@arm.com>
Date: Thu, 24 Jul 2025 16:10:18 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] arm64: Enable permission change on arm64 kernel block
 mappings
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: akpm@linux-foundation.org, david@redhat.com, will@kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, suzuki.poulose@arm.com, steven.price@arm.com,
 gshan@redhat.com, linux-arm-kernel@lists.infradead.org,
 yang@os.amperecomputing.com, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20250703151441.60325-1-dev.jain@arm.com>
 <aIHsiPtG0Ycm2DTe@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <aIHsiPtG0Ycm2DTe@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0020.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:179::8) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|AS8PR08MB9316:EE_|AM4PEPF00027A63:EE_|AS2PR08MB9365:EE_
X-MS-Office365-Filtering-Correlation-Id: dc6937b7-27b0-40b6-2c8d-08ddca9e95e5
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?UmlxSXMwY3k1aGo1SENjY1pWZSs3Y0RoU3JuL2NFcGkzTXBRajJjdFY3dWls?=
 =?utf-8?B?eDBYVFVscmZWK3llQXZ5SWp2TVpJQ1JrVkRKbWZFNzFOMHdGMXllN21PcVUw?=
 =?utf-8?B?VS9Jc1hRc2VpclFYTnM5bmdhSlI2bXh4a0tKRjVtQ2xRVFFqSWUxcjhnOFRa?=
 =?utf-8?B?Q0VlbnVHZVpvMVFyOFF3N1cyR2YvMzRGdTlvbEphc3ZWS2V0Q29meXA4K0Nn?=
 =?utf-8?B?OVIzZVZSYzdNWllSeEdFK1Bibk5PQzRIT0FEYzF0K25WUHpkNWhmMjB2cmZZ?=
 =?utf-8?B?amxpUnBSMXZvSFFFZXNSbTZKTE1qc3N1T0EzRzVqUCtEbFFlVWpVbUxMeldk?=
 =?utf-8?B?NUNUMDJGZnpJaEN4M01oaStGcDdabk40Wlo3Wlp5OGNFZFpyZ2pUZ1R4c2dN?=
 =?utf-8?B?NGJNTXRxWFZwZHBUcjNTVjNlSWFFSlg4RCtXUEpXNExRWnI1RTY3UXhGV2xJ?=
 =?utf-8?B?Wm1wODlUZ0Voc2JudVN2VVBtZ0pCOEdhck9QWFpuSWVOOHZET1FBMTJ1TEg3?=
 =?utf-8?B?YklDZEFRZms0aC8rM0o3TjBESHM5ZGpBQUUvYUMrU1h1MDh2bU43bVgzYWFG?=
 =?utf-8?B?cU9RR2JCSFlicUw2eTlrbEtMVExCcENNOFM2bEdZM0xCenVMcGcwVFRQRVR4?=
 =?utf-8?B?SGtwQlN0aHMvQVJocTFNQkJuOFczRDdCYi96dHFtbEFUYU92VGxaZW10NWpD?=
 =?utf-8?B?dlRkeERsd0dCY3dYanBGSm1aZ29hZ0E4cFc2cmtJK0dLdzljODk5U1RCaGsw?=
 =?utf-8?B?OXVIQ3NiblRzWVJ5MzU2R3NxYXJpUFU4L2FSMUJsOTZJMytQT0pxU3pqVytj?=
 =?utf-8?B?QzBWQ2xMVDZpVXJaekdvZU5rTkR5UlpiVmlTcWVPNkFSM25qT2F0SE5oTHE0?=
 =?utf-8?B?bVFoenp4MFAweWRZSnBtZ04vdUl1ZnJVNnBOTVQ0WnJCYk45cVRPTXZTQ1g3?=
 =?utf-8?B?b01EWENDNzlSNW5obDUvdWJUenBSZVByckQ1NFo5RXpiTkk0UTFla29SMlNo?=
 =?utf-8?B?Y1EyOVYzeVIyQzhPbkNTeDFSR1I2cGw3cjVoRjlzZjVUM3Vwdm1rSzVubFlZ?=
 =?utf-8?B?OFM2NC93MmV5TnJObGJHb3UwVjBCWEErNExwM1ZjTytvcnBtSE9KcXZjM3Zp?=
 =?utf-8?B?MUNsRDFDSDg2d0hWdDFHWDhuM2ZobTA0ZUh0ZVlWVytjR2VsSmx2R0ZOUng2?=
 =?utf-8?B?TE1ZMHN0V1Z4L3NVaDZSb2Y0Zm0vLzZYUmN2MHlTRy9qbFFZWFc1a0pnNXo3?=
 =?utf-8?B?MVBjUk9qNDRJT0ZJM0RDK1U1SHBubWswY0VEcGlYU05RSklOU045Y1Rhcmlh?=
 =?utf-8?B?WjBBTkpwV3FSTGo4YlB1QWt0MWkxK3JjOWcyZ1pQbE5PTnBaU2wxN2tpeUpD?=
 =?utf-8?B?QTliL3M1TXdRdndLTlJZSFFFbDZvaU0xK2hmQ3VZZ1kwVzNWZlRLU3BFTXdl?=
 =?utf-8?B?UHkzUGF5UEhpc3VJNTRMRysrc3BoMGFiY0N3S0pSZHllRThDMWlsTXRWa3BT?=
 =?utf-8?B?SzhxV2lRVGpvM213Tm9aSkhkOG1SYUVXRU14ZlVNblZnSGJNNkFlTlFXSlNp?=
 =?utf-8?B?SHN1THlqUE1FOGt1MGpBY2NoeklYVWFCS0tLZHZqcEdVRE1VQlNzSUQ0N0h3?=
 =?utf-8?B?VnI1WGw4cnhZWk1sUVJyaWZxdFdBdHU5bzBNZUV1anhZeW4wT2pHenFxcmQ2?=
 =?utf-8?B?WkdXVDRDY0RxWkRKZ0d1U2ttZ0c2MUw5K0ZhMS9GRk9TeGVZU2cwS3BOcGpG?=
 =?utf-8?B?cDEzZGVtNTdHTGNCSmpjYXhIVUJvRmNJL0VXdm1hazNRQ1loczJoSHh4STYv?=
 =?utf-8?B?U0tOanBrSDJ6MW95Y0JlQWpvbHRzUEQ3ZHpXM0sxTlVHaE5ieGFkbzM4UWY0?=
 =?utf-8?B?Zi9zbFljakdheUQ5dUFKMEE0Q01BM2JFYkIzR2h4VS8rcUJWdXkvZXpIcXBZ?=
 =?utf-8?Q?ohS3qRCSDVs=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9316
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A63.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	114207a1-5cad-4dc7-1ecd-08ddca9e8254
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|82310400026|36860700013|376014|7416014|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S1F1cmlNRnRwYjBwZ2hGTVY5eU1xMnY2d0x1Z2s3M0NhUDNkK2JIbUhoR3pD?=
 =?utf-8?B?QnNIMkV1Z0pnLyt1MHBuV0hTeDBnanFMWHNTVmJCb1psMEdtVFF1NEVnUE50?=
 =?utf-8?B?YzR5Sk15TFhSbmhxaEhZbS81YlFBL2E3UVEwM1ZOYVlKUWJXRjh2TGlWMlJy?=
 =?utf-8?B?Q2pvbTdwbXdVYjdTTFBxNXRtaWpaQ01jaDIxK0xJaG9xSDlxV2dCSGVNZGkv?=
 =?utf-8?B?VmNkRkNEenR1TnNqdjcrOUFhVUxKS29ZSmxkQWlJcDJWL3FrM21HVVBTeWQx?=
 =?utf-8?B?UDZlbC85NFVyeDdVU2hXMnVGaUpHbzJLV0hHTkJCSG0rVnlHR3lNV0Vac1Iy?=
 =?utf-8?B?L3NueEdwdHM0OXJPYXExbDNtbnlzbTdwTlV5VzJPcHpDcHR2ekI0MEpURUxq?=
 =?utf-8?B?bEx3eHZIb1BZeVRnOGhuRTVJWk1teGFaUkZQTDRvQ1F4dXYzaVduWGpmRmNC?=
 =?utf-8?B?QitmSjEyckxQVnBsVmRMeC9GU3hRU3lMay9iK0V6WDM2UHF3c2I3cEYrTGhi?=
 =?utf-8?B?WGxoNDZuK0tjR0tBV055ZzBVVm16UzA0OGR3bWRSRXByajByc09FM3N1cmNp?=
 =?utf-8?B?ZFlXWFRXNU84emswbkNFcEJOVDkzOFZmaXV1N0tHTStzL0dQNUl5RGp0VVBs?=
 =?utf-8?B?ZjZFUnJmSVE2VjJZbkJpazJCbTlja3RRNkUwTExVRnROR3RmTlN6eDBPMjRv?=
 =?utf-8?B?eis5dE5zd0JGOGFiM1AyK3ZXV3JQb3p1ZFhsQjdBVVBxWjhYNmp1K1JEUG9P?=
 =?utf-8?B?bTc1TEhpSDNudWhVazIveHJGY09kTG9VSXZSLzY5VjVlL2ZWdys3OGlmL2hp?=
 =?utf-8?B?YkhrMUNUUzhQS21MaVkwcW5JRHQ1cDBQR3dGb2RVbXIzRW9DUlZaaEQvd1Nv?=
 =?utf-8?B?SzhEcEpDQ3RONjh3OWJ3N3hPVlMvNFlvWVNEd1lXYkRXLy9ydW1PUURKb3dH?=
 =?utf-8?B?bXF2bVVTOHVPSFpLbDdCUkN2NHFMNEVhTjhBYkxmZ0hRcjRqWWxiRG5xbGlJ?=
 =?utf-8?B?YUZNKzlyVUZvZmkwVDVjOHpYV2Z2dytRV01wOWFNYVNsaHBQYzdVc3FRRlpD?=
 =?utf-8?B?V1h3R3VUVWlUWERRNHRqSVNheW1EeDFIUWltSFIxL3JLT2kxVmR1MkdiWk5Y?=
 =?utf-8?B?Njg1cWpyNWMvWWdMTTBqb1hMR1lyVEhKeU5Rb0tiZ3FWQUpIcDZiZWVjdmFm?=
 =?utf-8?B?UjVMSlBGQ0FSNUdsMCttQXVPbWNxYTRQWVJQdzNuNkgwMnlsMjZVTmlwR1l5?=
 =?utf-8?B?SlRWcWJCbWpLUFUyTXdCa0VuamtOazlsQmpzajI0UitnVWZZQUNRSHNHMWky?=
 =?utf-8?B?VVg1MlY1bGRlMnoxeUcvNHVWUlJDWUZQMW5yYzMzZE9IaWk2MjNiT0dkUXhm?=
 =?utf-8?B?KzEzcXM0ZzlNLzhqcnBFMnFIdFVLRWUrSWtFYllxdjJmSGZneTkrWjJSazZE?=
 =?utf-8?B?Y1ZVWjJJZlh2R0o2Yk5jS1BXcTY0cHk3UHZrUDUvc08zdDZBVjFlNUlrbWNZ?=
 =?utf-8?B?Y1N1anFkRnVzbjJlblhRVWlrbHlkZE9saWE1Q1g2WjZ3NWVUZ0lTTXJxaTR4?=
 =?utf-8?B?VWdMQi9HM1lNdGp2YThZd2pHa3dpR0JnbmIrcjNUaUl2SjkzTnNoeVkrczl2?=
 =?utf-8?B?cVRmQzU1ZWlGdkR0SlZZY1FjUFAwSE9uVENwc3Y0RVBvVk1VdGI5dmdhOExU?=
 =?utf-8?B?NmNtdFhaVXZKandPN3dQV0YwUGtaZld3aEZ1VTFCRjhXU3pZUXh6Nnp3eGp4?=
 =?utf-8?B?dzNzaXd2NUUrMzJmT3hpbG5nb3JmVVFPazFsL2x0U3EvRENFZUIxUDZuR0ZC?=
 =?utf-8?B?M01lOXlOZ0RnZXAwb0tHTEdpbjJVMGdnNXBXREJDTFhpRE40WkkzZjNHUW5D?=
 =?utf-8?B?T3ZLLzJ1alhUbWpjSkF6MlBvSERZTWZYcVB4UWRid04vMGNtd0N6U25FY2VX?=
 =?utf-8?B?YnVYVDk5bXFvSUx2RkFMS3liQnpra00xK0dVOFlkOE5oV3pyV1lXNG8wendl?=
 =?utf-8?B?SzJNbC83RytjVUxSMkFjWGIyQlNmbERxckJqUE9ZbWtoN216d1JmVGU0WlVS?=
 =?utf-8?Q?6tM1Ii?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(82310400026)(36860700013)(376014)(7416014)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 10:41:02.3880
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc6937b7-27b0-40b6-2c8d-08ddca9e95e5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A63.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9365
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0248B18000D
X-Stat-Signature: 3a7exynqgxmdo58156uyzffrxqjcs8zt
X-Rspam-User: 
X-HE-Tag: 1753353681-746573
X-HE-Meta: U2FsdGVkX19cZTC4l8F3I1QapuSzEYVMtgNwXzdJ2xFZLwaF4wLFLXiRz53Im3TKfxbO3Mqe1c/y8ikxo8VK7MwAffCs2gOLbSKQ5+qpA2d7YWkv4/RK1Hefdw3h1lOrCcrvvY8VV4MzR9hpugpM4oGlLvN2aOUsdymfn2rMYziqcZwvSS8Bk+TyFO0/Yu0DQ2/DSOhpoooL5x5nXaxhP/TgZ2ooc2ROYK15oxQ7OBeUgxGGvY1Zhr4KGH8azjTmztKu0Acc7Fdo9pI8mvVMb4i6YCE7RL52nHX2rlde/VbmZdonvw6xa9ijEvMTZsYTVrQ25+kEsDTEKEV2W2w1guwYY/5bvsfcZsFpNSVC3a9KXW4e7E65Ti//kLxlcmOGyVQSqhNYkxDQ0lTgsqueiJdgr5zkBEJd8G7F61iBS38qQVBDRme8VZiW7pYOaNYm996TvYKH7n2m4ALKzt/RCJBrEO+jCxHOH9j3UBPe4gmQE/9eeXnJeyczRVavRW8vm6kai90mvkZgzn36xqPXrCkoWUgsytI5ZzC/4PeM+SyXi7hI/XUmLBz9HwMgoTjB3OWaGdqEmp342yj4SaD0qKj/R7GPiRI/acW+uS+eqgfaF4LjycDgOenxcJgDwA0v1IZjRNVF1tzcHbuYcRu80IDM4Mj/TgRJZWc1/ljhc+YDyfUAxi8bBWK0ssuO8Wl72ZebCRww8qFO9pkrvwbZoCh7+Js5sV/qG8baxyJc7Q2gQQPcqN/B76Fitv4jZJZqqukT5xLvCZ4YdCbIUbfD35mPzBWIPmkfWuE7zvbdVwx+ri7uae/hAqLRjXRGCs0W2uJohpkv4dzDpYo6sl4tZVdw1z1Y3O7NlHwmwTbwFRfZBEApVl/50VpX1aEfKjqvO+dcuQgShd4484D6HL1c3Deh8iww+gCnGIwGlsf5gE6IIcBgLbVztFd+Swha8jhx9JcJAKmMHN7jaBlvKUA
 nFkDdkEA
 WntpA3CtUEUScXosjbvNKZy0+VGR+RKo8CS6tzq2tpWgJtRrlUT6KI9P+9C9Ybbjn8aflU3F82CY/sxC3BoqMLLrnFPM0lShSL1/J65Q8s6dmw5H44h7etk8GPmmECSrXNroM+CQ25wwIQBQ8HSYZxeK8VMDLLM8kGvmEa+e/QU9VU/jGJaHhnLTdNoCwaRRNtgxq07QfbfnNDzGV+vbJnxgTOnb7hJC+hDejRKTYMgNhO+9EA3G726fNkBeNQiQLEr+lu74URslYMY/hOW25c8sqeeLC6RBoIJsn7peyL/ap8crCq6vCAAtIjLrYXYyT8NjqSDKcV0ZK9G/aYENR0d64mv9K1Y1QSLWREJXUjHxKDTlbsctjKNvVg3VQvTO8nqlcHK2i5GsZka3binlfSl+t2+hR4VzSPBlFRo3t2HjQ1QI86dNjjL+KpuBkOGZa5+Nz9Kc1Uh/Zrf3yacPB3JGu2SaameCFWRQqc56ziVeyEbTMqvOwU4Jaf1Vy56YDq5UWeHvEbD5JcEQHkEcqXxCeHnNL51oKKsbTbcK3wkoSlCU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 24/07/25 1:49 pm, Catalin Marinas wrote:
> On Thu, Jul 03, 2025 at 08:44:41PM +0530, Dev Jain wrote:
>> This patch paves the path to enable huge mappings in vmalloc space and
>> linear map space by default on arm64. For this we must ensure that we can
>> handle any permission games on the kernel (init_mm) pagetable. Currently,
>> __change_memory_common() uses apply_to_page_range() which does not support
>> changing permissions for block mappings. We attempt to move away from this
>> by using the pagewalk API, similar to what riscv does right now;
> RISC-V seems to do the splitting as well and then use
> walk_page_range_novma().
>
>> however,
>> it is the responsibility of the caller to ensure that we do not pass a
>> range overlapping a partial block mapping or cont mapping; in such a case,
>> the system must be able to support range splitting.
> How does the caller know what the underlying mapping is? It can't really
> be its responsibility, so we must support splitting at least at the
> range boundaries. If you meant the caller of the internal/static
> update_range_prot(), that's an implementation detail where a code

Yes, I have added the comment in update_range_prot().

> comment would suffice. But you can't require such awareness from the
> callers of the public set_memory_*() API.

Yes, it converges to the architecture being aware that, since it supports
block mappings, a block mapping may be partially changed, so the internal
API must split at the start and end.

>
>> This patch is tied with Yang Shi's attempt [1] at using huge mappings
>> in the linear mapping in case the system supports BBML2, in which case
>> we will be able to split the linear mapping if needed without
>> break-before-make. Thus, Yang's series, IIUC, will be one such user of my
>> patch; suppose we are changing permissions on a range of the linear map
>> backed by PMD-hugepages, then the sequence of operations should look
>> like the following:
>>
>> split_range(start)
>> split_range(end);
>> __change_memory_common(start, end);
> This makes sense if that's the end goal but it's not part of this patch.
>
>> However, this patch can be used independently of Yang's; since currently
>> permission games are being played only on pte mappings (due to
>> apply_to_page_range not supporting otherwise), this patch provides the
>> mechanism for enabling huge mappings for various kernel mappings
>> like linear map and vmalloc.
> Does this patch actually have any user without Yang's series?
> can_set_direct_map() returns true only if the linear map uses page
> granularity, so I doubt it can even be tested on its own. I'd rather see
> this patch included with the actual user or maybe add it later as an
> optimisation to avoid splitting the full range.

Hmmm. Makes sense. Although I don't think that this patch is an optimization;
post Yang's series (without this patch), if we change permissions on a partial
linear map block mapping, set_memory_* will return -EINVAL, causing problems.
  

>
>> ---------------------
>> Implementation
>> ---------------------
>>
>> arm64 currently changes permissions on vmalloc objects locklessly, via
>> apply_to_page_range, whose limitation is to deny changing permissions for
>> block mappings. Therefore, we move away to use the generic pagewalk API,
>> thus paving the path for enabling huge mappings by default on kernel space
>> mappings, thus leading to more efficient TLB usage. However, the API
>> currently enforces the init_mm.mmap_lock to be held. To avoid the
>> unnecessary bottleneck of the mmap_lock for our usecase, this patch
>> extends this generic API to be used locklessly, so as to retain the
>> existing behaviour for changing permissions.
> Is it really a significant bottleneck if we take the lock? I suspect if
> we want to make this generic and allow splitting, we'll need a lock
> anyway (though maybe for shorter intervals if we only split the edges).

The splitting primitive may or may not require a lock, Ryan and Yang had
some discussion on the linear map block mapping thread. I am assuming
that since we didn't need a lock in the past, there is no need to take it now,
since we are only changing the pagetable walk API being used.

>

