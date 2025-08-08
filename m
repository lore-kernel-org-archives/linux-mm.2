Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12039C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 05:19:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C7106B0095; Fri,  8 Aug 2025 01:19:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99EA46B0096; Fri,  8 Aug 2025 01:19:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83F4D6B0098; Fri,  8 Aug 2025 01:19:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 729746B0095
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 01:19:20 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ED086BED83
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 05:19:19 +0000 (UTC)
X-FDA: 83752436838.03.6F56B4E
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011037.outbound.protection.outlook.com [40.107.130.37])
	by imf21.hostedemail.com (Postfix) with ESMTP id DF8551C0006
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 05:19:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=L0yafbGo;
	dkim=pass header.d=arm.com header.s=selector1 header.b=L0yafbGo;
	spf=pass (imf21.hostedemail.com: domain of Dev.Jain@arm.com designates 40.107.130.37 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754630356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vtX70LdeOCMMwJCDV7ic9bKOL6hK0tvpbaMRIzgfpKo=;
	b=rlofyUOmRJkX6aBJhtBGfanmJrLJ0dkGfpMIb4TJ6JlfTxspH/PoLTaHMhdo3wzp1s/GNq
	EUJQqZnVQ1ClV2spM5W0GFCs6+74zNqa7NSAtrtYxjlqJzpp4M+4IrjovDQPm8qvRryKm5
	3aRV8OvhWU4SQxxZvpv9dd6S3NO75SM=
ARC-Authentication-Results: i=3;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=L0yafbGo;
	dkim=pass header.d=arm.com header.s=selector1 header.b=L0yafbGo;
	spf=pass (imf21.hostedemail.com: domain of Dev.Jain@arm.com designates 40.107.130.37 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1754630356; a=rsa-sha256;
	cv=pass;
	b=NdxNEcgkuXFJerXhstWOhfDCe4KY9p5RHK6soSZd+OeXKNqCURXK4pCv8JoOfpF5aN7GSQ
	57Hp9ioFxfkgLIO9iNUQChFi5xKF6A1YLLCE//0qBxAeDcQWLDJsYE8xmhOaR+mAx5Gsnw
	33NU+cSZdBUlJywiRtt6wpo6cFOEPRc=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=a3pUwySHpoZHmP7IBrmiOCQzAFJf09Cyv1o+DNKB5nsEOKnqGoSwO5inDWX8B2DvbXzfiXPOT8YX/+UeY/wvImE8HB12eAv9Cpjc2wUuN3mVHHqvAXBw3N6A8MVHdjWoFfmnPIlx6S0bT52VRkrf2BWiWORpIHWkLFSm9l06lFUZBoymSgW5tlf/sP9xMKhk5HB3HVf3bj0rQHGiiRAqM4tmc4T88Op3rGZspd/RVvBFdSRWdWVGe6dOVEuemx5eFjKkYTAOxJ2D6/Drp4hgDm5oJ9zWltYzq/zEa87D0Up++mxpYC9s9zV8E2GAsfMbO27ab2ie6Bv3tIKduauUYQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vtX70LdeOCMMwJCDV7ic9bKOL6hK0tvpbaMRIzgfpKo=;
 b=hL8cUz/Y90BgMKt62OmelEojmXFtUq1LR/AFl3zqWoHB/UFM2x8BqfcTZyydELxW9DIoziBJkvoj3MvHILsZEMXPm995C8npE0u7h5+koUCYApXOwPhA05oXL/5BIKV5IOmJ9WOUUkMww7g3BDNOfZJ4uN5SIHKz/JLaCH1jU+SjzzyFNDcEYK3745gp0PM7Tb7HAqh4bHnTbj6msJKLcRw+6wkqKV2X6YmMPXNAJPOEKvS+DDCs0kKEftLU1UXGKRW/feUoMrxjUXWnKjnU/+ULN609L7amg2XwfjZJAkqGMti1js09/cwHZ4nMXOrUHzI5hDlHRmnhsKuLlylJDA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=oracle.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vtX70LdeOCMMwJCDV7ic9bKOL6hK0tvpbaMRIzgfpKo=;
 b=L0yafbGo0bHvaD8f0rCOG/KQesgDpVu4HL6KJkFh7CT3xbEVkuMDpr10AW4kOE1cDfhNMxcI69smIXPOcCAVuVfx7c95IAj7A0aOAA3UvQsxyczPo8niXdIS0K+sCNIzWoI2KDmx26nSWzkyfi7XCU6/d4SYnSNEBmQQP60yVEs=
Received: from AS4P190CA0030.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:5d0::20)
 by AS8PR08MB6277.eurprd08.prod.outlook.com (2603:10a6:20b:23d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.21; Fri, 8 Aug
 2025 05:19:05 +0000
Received: from AMS0EPF00000194.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d0:cafe::e9) by AS4P190CA0030.outlook.office365.com
 (2603:10a6:20b:5d0::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.18 via Frontend Transport; Fri,
 8 Aug 2025 05:19:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000194.mail.protection.outlook.com (10.167.16.214) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.8
 via Frontend Transport; Fri, 8 Aug 2025 05:19:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xrf7vXV35js0rXEenwV6Zz8V/ad7fHZH3Mxy1I2DbSm9b+YshWsW6BsOb8C3ABF6u1MFZVLcDTjSYi7ug2tk9rDAFixJLTxHHb+VbkrJET76hAzwSPA2eiCN/X5l5Ve24qz+O4LB2uFdSi7LyJ2youkqY0Uqp5lCGQURc7S0QPfM7xwWS4L4ruaKVFuYxqP3S0YsqJwaIKB9/TGdDOVjCRlTptIox+vQO+68ZRgfa7DdPJbhifyzjFadC0cH6/Z/XTqBnErZacVdnLZpFjiES/cVLxHhghAL8wuWucNqr+M5CmQ50L+VynuAAE60aUnBCtQ4VJix1PdwnSu+dxOa1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vtX70LdeOCMMwJCDV7ic9bKOL6hK0tvpbaMRIzgfpKo=;
 b=liUXK+ZJdFASK1JSU+TCoXa55W/5DpT7B0UE59l8ch4fQff68lHz3sIKBaXUvTcAEAMPQuD/Eq/hsRys+xWU3OVxDlq63dYVaau8MFeGzAVBOOi4ZJFjsO+x7ixiEmU7WA1tLB0jKbhdE21IvZUe2pX4Hv7wasK1zUM89odwFXijqtsdjg2OqOTzWokc8bqZ+tGmm/ji3ehw2LCAXVMLXhphEYAgkTtnSb/kPWbQnySkLe8/ctrZV1I8piFOmj1ZylmU+pA4+2YWG95hur0J5rDIKIIJVSgkAwY1sLRjsHQPxsRWbYrCjBvm1Hqu6jd5DalHx5Rb75rCcmokj1vKpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vtX70LdeOCMMwJCDV7ic9bKOL6hK0tvpbaMRIzgfpKo=;
 b=L0yafbGo0bHvaD8f0rCOG/KQesgDpVu4HL6KJkFh7CT3xbEVkuMDpr10AW4kOE1cDfhNMxcI69smIXPOcCAVuVfx7c95IAj7A0aOAA3UvQsxyczPo8niXdIS0K+sCNIzWoI2KDmx26nSWzkyfi7XCU6/d4SYnSNEBmQQP60yVEs=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by AS8PR08MB6582.eurprd08.prod.outlook.com (2603:10a6:20b:339::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Fri, 8 Aug
 2025 05:18:31 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9009.017; Fri, 8 Aug 2025
 05:18:30 +0000
Message-ID: <9db37970-abfa-49ab-bab6-081d26e587ee@arm.com>
Date: Fri, 8 Aug 2025 10:48:25 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH HOTFIX 6.17] mm/mremap: avoid expensive folio lookup on
 mremap folio pte batch
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Barry Song <baohua@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250807185819.199865-1-lorenzo.stoakes@oracle.com>
 <158e6422-fc82-4d6c-a442-2ebe956a66da@redhat.com>
 <3fc75720-8da7-4f6c-bdce-1e1280b8e28f@lucifer.local>
 <6870e24f-dda6-421c-8df8-58294927b62d@arm.com>
 <ae01c6bc-019a-4263-8083-8ab073e72729@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <ae01c6bc-019a-4263-8083-8ab073e72729@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXP287CA0023.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:49::31) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|AS8PR08MB6582:EE_|AMS0EPF00000194:EE_|AS8PR08MB6277:EE_
X-MS-Office365-Filtering-Correlation-Id: 09640803-26e8-4076-6f78-08ddd63b1760
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?SlNGazdrVzJHcEx3bHh4dk8rcFI1WmtGK05hSUNaVjNKK2lTL1dXV2I5T09r?=
 =?utf-8?B?Nm1jRFFVT1JhMnplZlJDbGhoZWcvYk5GNXhCMVdlU3BVZld6TTBHc2xremg5?=
 =?utf-8?B?VFVIaHV0V01ya1NDTmlaMWhkcG1jT0RaeUx4bmVGMFdyODhpL0Zta1AwalhG?=
 =?utf-8?B?WTBSeW1FUTRScU0rVnhNa1pheURFbjhVTDBlTXZNZitxUVJQZkxyU0RILzhH?=
 =?utf-8?B?bmgxVEN6Q0k0NGJUaHhoRlNuOS9qVVJPWEZZcUJWVHBKbUpoOTF3SXc5MEJG?=
 =?utf-8?B?TmpQaE9LbTJ0WmMyMVU1V0xkUjgzVHdXUWg5ZWxIQ09aUExJM0cwWDR4SkNT?=
 =?utf-8?B?YmZ3cXgxMFdMWVZBSzVDRzdZU01wVUVQemNpcEZSbEtsQlNvMU5USUsyandE?=
 =?utf-8?B?Z1ErTm5zc0ZYU1MwYjluOEx1clllQUVyRVl2dmZOVDMrUTdpMUl2V2syRWIw?=
 =?utf-8?B?MG1nbG5rVi83NnplVWNuVi9OZzY0dUVCaThMYkpxcG50bVVZS045cGZVdlN1?=
 =?utf-8?B?Z0swS2xNWWw4Q2pOaG1EMStQRXluUFE3VUNodkNSYWppTGVPV1RvRlFNSTBP?=
 =?utf-8?B?NFBjRk96UW5NZklWa0ZlOFllY0k5NlhLdjB2a0NGekRFZUlIR0l0L3BxNkwz?=
 =?utf-8?B?TnUyQm5yTjRKT1ZUOVdLU1R6Yy9NcjRoUkFJaElUSEpmTXlJKzUweE5oTUZI?=
 =?utf-8?B?MDhwbDdDc2wzWStpaXZ0T2hqNlZmdlZuNDE2aHNtVVkwMUo0eUx3REYxa2VB?=
 =?utf-8?B?V0doTVI3UTZqaThLWFFrdHNSNkZNYjMwaml3Znhtc1N5TFBDZlluUXQ2Rnkx?=
 =?utf-8?B?Z25LbkQwYWhROGt6ZE1tclN0dmtnSFRiM2w1QVVuWjRPV3F0cFVXVUxVRGl0?=
 =?utf-8?B?YVJNUEV3a1MyOVlqL1p2ZVFqcjdRcXlIbDV6N3lYVVdYWkNkeGxGUndOenBI?=
 =?utf-8?B?UVZHQnl1bUMvZWxuK3g0M1NZdHpJMk1ZOUI0eE1vK0lvQ2MxbGU1dnJtSGl2?=
 =?utf-8?B?QXVWSDdheXpvWE9WdlVFd3ZiR2U3RHpSeS9CNUVjaVZyWm9CRG42NGNQSlFK?=
 =?utf-8?B?THU2WDYrRkdzQmo0ZnhrUzRtTkFhaUpMQVF6MWpVOHNXZzJmQmdTV2RhNTF3?=
 =?utf-8?B?NEhxVG1JTEZQQTNORkhldU4xU0hIakZjbEc1M1VZS0NQNTB1OEp0aTFsVHlj?=
 =?utf-8?B?SHRLU29jWFo0LzVqOUxNa2FrN1NEaGR3OGpCZ1BsYjZsQ200SnpkcC9FZ2Fw?=
 =?utf-8?B?amhRWmlYRWhIQkxobjNpemkyMDZIZTlRT3p2Q3NvLzg0M29vME1oNDhGN0tq?=
 =?utf-8?B?TzF5QjRLTWdkbXlkNC95dnFyTlhsemxWTGV6S2dYUTA1Y2NWS0NGcmhmUzNP?=
 =?utf-8?B?ZVhDU0tPdnRhV3psc2dBQzRyN0g4TE1yNTZLVUI1clU0RnpqNFpRZ1AxVTQ2?=
 =?utf-8?B?RkpCTVVYQmRuQnVZbFFjU3Z3TENlaURqdHJhV2Q5dWlSckFHbnN5cjkxWnUw?=
 =?utf-8?B?S2ljUWh5TFRzdEVwdFZzUlNiWWFVK0U1SGFpcVcvWVNybk1NMjM1S0VNR2xs?=
 =?utf-8?B?YTFBV2VLQVFVbk94VjFQT2laODRSNjRqZXlJUU52d1RPQkYwdHV4RElGN3dw?=
 =?utf-8?B?ZmkrU0YybFBrNWJycXYrT2RiWDEyOWhLTWJLc2FFYndDQjRjNnlLdUtydWhm?=
 =?utf-8?B?UmNBMDArcUYxaURCVXMzZnIydk05WVpPYWtEMFR4RVU2cGREVkc0V3d3VmpI?=
 =?utf-8?B?RE5LLzJRbjNJU05ERmdJK09aSDRHd0R6Y1VMbldxeStrNjhIOXBGODdraW9o?=
 =?utf-8?B?QWMrdkt3ZGxVYWhzbkVVR2N4Smo1UWQ4NWtQZUMxUE1SL1BmT2JjbGh2czlm?=
 =?utf-8?B?R0N0S1kzdHlDVFFmUUJSb2VTczg2cC8rV2orbHc2RzNSeVM0OEFnTkZNcS9W?=
 =?utf-8?Q?WNp7DcdOPTc=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6582
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000194.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3891b00c-8864-4064-f564-08ddd63b035f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|14060799003|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R1dxeDRKV0NqVHZEblA2VDBHQlN5ZHk1U2FtL0hyOVJhREsvQTRxVnlaQzRK?=
 =?utf-8?B?OFlBb3J5dW95UldwMTBFWm12L1J0a2NIQjQ1bHV2S1cxU1JaaEk3Mm5TRVBM?=
 =?utf-8?B?OTFpUEJSb25RdjROL0NyQTZIL3E3TTVMTU9TcFNmWmcweXdWMTV4ZUsrQ2lS?=
 =?utf-8?B?YWFaUlRHMHNyUmZRS0VIbnA2OWExeS82eExjL0dCYVdkWmRBWmhYV3NXQ3Jn?=
 =?utf-8?B?US9NTDRTU1JXc1J0M3dFajhkR3FVdU81aFIzb2hPdTdOdDhid3NPazFYRTJk?=
 =?utf-8?B?b1Z5bVlyOVBiMCswWnBaaDNVNWpJVHVVUnM3Ny90SnJYNzJLUjloTDUwUHR5?=
 =?utf-8?B?b1FIRWJUVWdPNUNPQnU0MnhINlB5cUtnc21QZzNpTTJ5eXFlTHkrQ2l3b0pz?=
 =?utf-8?B?Q1lZTUE4cnV1cWFNRmtFVGdCVVYwa3p0T0Y4QW1PY01OS2tvWXFyWjJVcFlq?=
 =?utf-8?B?SGNETm1xQzdabFFTYVlnakhEa0RHSjJBSU1RRndFU2FXeEhKZ2JiY1VrdUNC?=
 =?utf-8?B?Um4vb1ZkdmF5eGNEdDlTUWdGbTMwNTM1VXY1Q2pEZDRPelZ6blRYM0ErRFJ3?=
 =?utf-8?B?UjAzS2x2MlptS1JGYzQ0RFdQVnFWQ01RaytCdjZUTk9mZ2M3S3lzZHMraTIr?=
 =?utf-8?B?UThiUTYwOFFmN2JIaUFkZzY5clpLd2ZuQWlrTUhSU29hK0NWajZlMEk5Zm1N?=
 =?utf-8?B?eXBoRkVTNFdJZ1lBVHFnUytoOFBTRG52dCtWZ1dGUXFOcFc2Sk4vcEsydGNY?=
 =?utf-8?B?UU1INUh6RWxzSmhHWXNLQmJvMnBnUmp4R2Rld2thU0grOUk0UVUwVnk3M3Ni?=
 =?utf-8?B?eFgybG45K0wxMmsvUG53cThkOFN6U2x0V1pMa1pzZm1QbW12QS8rNG1MMk9Q?=
 =?utf-8?B?YXNtRDk0ZFFRQnVWVnNMWWMvT0lBYWxhcUovSEdlMFBCSEhaWS80TGY0SEw0?=
 =?utf-8?B?WXhqZEcwYUY0VGU2a2d5K3ZDb2tLNzlQWnBZNVRDWWZhK0RwZDExYmc3RHlT?=
 =?utf-8?B?U21YYWNtK29XR1BqT3hUOHVVZ2hhWVc1U0xOR0tlNlA1TG9VdjBzcmhUYmNr?=
 =?utf-8?B?dGpZdU54Um1ERVh3VG5OUFlSN2Z0VzlHbGlIL0hKeEFibGNXaDhVblEyME54?=
 =?utf-8?B?dWt2MnZ3dlY2WmErYUVWbVRFejZ2VzJMTkROekJvYlEyWEhuV2tRT0hmQlFV?=
 =?utf-8?B?T0pxNlFjakcweUR1OFRzajJOYzIrVmNLRUdSSXZzUlM0MFh1dmZ6bW9acy9w?=
 =?utf-8?B?Q044Z1ZsZ0QvdFNqS09SSnRjaWFaZ0tORWtNaDJObGVxa2RmTWpmT0xlZWhK?=
 =?utf-8?B?N3pFS3p2UzNJNHJhSWNFY1V2d2NzckNGbHd1TmRRNVJscGhaK0E2U01mUWRM?=
 =?utf-8?B?Z0Y3SmRHbVRpQ1JkdFY5N1oyNWkyQ3pqbEpTQjNNM1dRZHdlMGJDTGtwK0xY?=
 =?utf-8?B?enUxU2hVT2p5V3ZSam9NY2c4NyszbWdPVVowciszbnZFMFFRS2IzcHcyKytN?=
 =?utf-8?B?K3dCTUREUVBVL1V5Qmg0V01vODhEZDVoUDloUElpWFY1bEJqNHJkYzk5bVVT?=
 =?utf-8?B?LzdYVTZnQWFJQUJrL2s0OTJMTUZmWlVRWW5xM3poYktvUm40ZHplaEwweTRj?=
 =?utf-8?B?Q2h6dDJhTUhMRWZtUUhGc3ovYXU1ZVBvMzFyakI4Zmh2MktSTlgzNklIM2xp?=
 =?utf-8?B?ZGhZa0JHUEw2SGtyZWxSQ3pYcTBzd2ZpRVRaMmZuZHR2dGJYbUNmNzZrenFZ?=
 =?utf-8?B?KzBrdVNoYm5FZlRkZWdaNzFQUXYyMXVVVFE2R1hnYVNLb0xQRHgybmw4QkRU?=
 =?utf-8?B?ejFUN0VEeU94NGlHYTJPakkwUkVoVjlOeFdoTHZPQ2pSeTdLd2RGSkpEMVRB?=
 =?utf-8?B?UUxzL1J0U3VUUVM0WmpxQUhQRXVFc1JuWVlSS25TTC9JMXVaR0t1Y3dqWU9s?=
 =?utf-8?B?R2MvMzgyOFBwMjNzM0Q2L3kwMEtLblVGVHRSdWNzbEFWejRBaWtQUHFTTVlR?=
 =?utf-8?B?ZXRPRGxTcDVaY0xMY0NURFhFeDhSMUFqOWo5NmZCRUJ4eGRmUWtPRUI0cloy?=
 =?utf-8?B?V0JjUCtZZmNsQmZlRGU2U0pvL0RCWVhybm9YZz09?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(14060799003)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 05:19:03.8970
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09640803-26e8-4076-6f78-08ddd63b1760
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000194.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6277
X-Rspam-User: 
X-Rspamd-Queue-Id: DF8551C0006
X-Rspamd-Server: rspam06
X-Stat-Signature: pej7mwtuz47fjtfzdntjndsy3r9hgrqt
X-HE-Tag: 1754630355-48977
X-HE-Meta: U2FsdGVkX19C7XcUYqK2jRom/G8LOUVdZomIUGXnhooY2e1AE0+FCJsBFuXTfQh7b4f7Pp+c/5vCvcOqYwU6HdmCJ9Fei7Fq65eEsuomaFQU7weV19QvDk7FzCxY4w1NNCC+/mJZnBwF1qDN1x9MlijqnjiEVbXpptIAXdw6AvZQBvNeFt2zmDq2CZ/5FazZtgy70RP6qN09t6ZeHaTLXapMfnIlzZo9rUCCXDAQR6yWSwplaC9GfLoYwwN16B5vXjKonJ12icVMPSdXvfBalXvNEYPiFQkYpTGBD74R16wWFOcTF1Mw07YQ7C2FJTpUOVOClzqzKui8zJA/4f2jLrXvYvW1wvS2GLg53P9DqzRKxQ62G2Qqo01ciSPmP9Qf7F7E9CJJbfZyVUGLSNuBFWPhtfHCJBH390TpgNZP9cllg8kboK8210AnC0IQxPd6iniDtVk+M9x4f5i3xN8cddkIFCra61CPiiKlkve4bjFCxF4e/gFRVRk7dtu55vsdeAjJI0QBmmnTygfcyGxVm6gzoKMZ3aR2HwB098JgOO2Eu4SbvJNoT9ZN5wGAZQVXRkdwZcdDEsZJYp1rIAVjf7woRth9RPr7I/396x3qAZeCEDLJ7fxQPvSERF7Hlnnuuw5wBQLazn+vNQD9stJk8AJXtyReoeBKfSzOap7S6TA24HHf5bbzL0TiU0aIWyGVfb2Y639qe+FGd8T5sHxNH82aIYyRb7POSTJP5086L+6KrYsK4myB4KeqAmALju7rBA8y47EZJQ5qgQ44BZBP7Ux6f93IukZb6FhbWdtArrMr+07/1LtSWioBIt07gZE+BTRc9jt9zHjF+3OFleydcAIKB2/xbJe6SxoZrVLHho+pZa9CXcZA232NcMHRA+Idod3LTKV9ALcVBR/tQpo8INpmXkf5jacweakjp3iKY+tP3PSAwTt2LmG8Siz7PBwwtJvpeLQvNqNyslDJxp2
 wVxwFM9G
 IlTd98ImyMNrzidUGuxtlDFz88HCEOgu8SDT0fKOiKo0hMDXqVndwTJqgB0oV0Yjmj0HsOwVPL2wJAsaDnJjYgWKskdKczqoHjEKAD24ae/UmTHAcerrKeSE+d04iJveRRsKhxfEx90lThDsqkA/CbPguKMuZG/1d02QZ6QeoXqiri5W8yVSLSwAfv6aJbiSLTw9WVLqO7khbFIh/q2+jotIOtFYa1bWtLrDNgBMV2+HalGcxAmYen492WZ2hCR1Kx7oRC7LRrQ+BckOFg8O0aZa/XrE8MGpJjULN9GP6EL3X8R4rpfUwSglvrfiNAlP4yL67caPxcVzgoLWR+qMujxTxfe/OhKz4XfOcWvy8P3lI1xYEC0F4PxkB2n/fNzc32bsobkk78WSXx9rjIP2bHbROHhnsho9hrRTkvOWQJEJbmH1q6wA/DzE8b6G34g5z9zHAWJOn7BqV01vdgQb93jAiIJFHgHA8xPwd7hogl9PyN1Y/1Ly6/dgflc2jgqHWxgnoaTp7hDlJGl4wcDEPoI7zX14zvBgiKVqtK0CMW5umMs4aEBpj5Ly318LlNpcugh4uuHPWs2hyynchvgvnNXAJQgraK40epSgrMxsdc9L9oIRPOF8w8Pk9ofp2chZlUpfhErXlU+iA9+5R2ciTSn01Qg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 08/08/25 2:28 am, Lorenzo Stoakes wrote:
> On Thu, Aug 07, 2025 at 08:56:44PM +0100, Ryan Roberts wrote:
>> On 07/08/2025 20:20, Lorenzo Stoakes wrote:
>>> +cc Ryan for ContPTE stuff.
>> Appologies, I was aware of the other thread and on-going issues but haven't had
>> the bandwidth to follow too closely.
>>
>>> On Thu, Aug 07, 2025 at 09:10:52PM +0200, David Hildenbrand wrote:
>>>> Acked-by: David Hildenbrand <david@redhat.com>
>>> Thanks!
>>>
>>>> Wondering whether we could then just use the patch hint instead of going via
>>>> the folio.
>>>>
>>>> IOW,
>>>>
>>>> return pte_batch_hint(ptep, pte);
>>> Wouldn't that break the A/D stuff? Also this doesn't mean that the PTE won't
>>> have some conflicting flags potentially. The check is empirical:
>>>
>>> static inline unsigned int pte_batch_hint(pte_t *ptep, pte_t pte)
>>> {
>>> 	if (!pte_valid_cont(pte))
>>> 		return 1;
>>>
>>> 	return CONT_PTES - (((unsigned long)ptep >> 3) & (CONT_PTES - 1));
>>> }
>>>
>>> So it's 'the most number of PTEs that _might_ coalesce'.
>> No that's not correct; It's "at least this number of ptes _do_ coalesce".
>> folio_pte_batch() may end up returning a larger batch, but never smaller.
> Yup David explained.
>
> I suggest you rename this from 'hint', because that's not what hint means
> :) unless I'm really misunderstanding what this word means (it's 10pm and I
> started work at 6am so it's currently rather possible).
>
> I understand the con PTE bit is a 'hint' but as I recall you saying at
> LSF/MM 'modern CPUs take the hint'. Which presumably is where this comes
> from, but that's kinda deceptive.
>
> Anyway the reason I was emphatic here is on the basis that I believe I had
> this explained to met his way, which obviously I or whoever it was (don't
> recall) must have misunderstood. Or perhaps I hallucinated it... :)
>
> I see that folio_pte_batch() can get _more_, is this on the basis of there
> being adjacent, physically contiguous contPTE entries that can also be
> batched up?
>
>> This function is looking to see if ptep is inside a conpte mapping, and if it
>> is, it's returning the number of ptes to the end of the contpte mapping (which
>> is of 64K size and alignment on 4K kernels). A contpte mapping will only exist
>> if the physical memory is appropriately aligned/sized and all belongs to a
>> single folio.
>>
>>> (note that a bit grossly we'll call it _again_ in folio_pte_batch_flags()).
>>>
>>> I suppose we could not even bother with checking if same folio and _just_ check
>>> if PTEs have consecutive PFNs, which is not very likely if different folio
>>> but... could that break something?
>> Yes something could break; the batch must *all* belong to the same folio.
>> Functions like set_ptes() require that in their documentation, and arm64 depends
>> upon it in order not to screw up the access/dirty bits.
> Turning this around - is a cont pte range guaranteed to belong to only one
> folio?
>
> If so then we can just limit the range to one batched block for the sake of
> mremap that perhaps doesn't necessarily hugely benefit from further
> batching anyway?
>
> Let's take the time to check performance on arm64 hardware.
>
> Are we able to check to see how things behave if we have small folios only
> in the tested range on arm64
>
>>> It seems the 'magic' is in set_ptes() on arm64 where it'll know to do the 'right
>>> thing' for a contPTE batch (I may be missing something - please correct me if so
>>> Dev/Ryan).
>> It will all do the right thing functionally no matter how you call it. But if
>> you can set_ptes() (and friends) on full contpte mappings, things are more
>> efficient.
> Yup this is what I was... hinting at ;)
>
>>> So actually do we even really care that much about folio?
>>  From arm64's perspective, we're happy enough with batches the size of
>> pte_batch_hint(). folio_pte_batch() is a bonus, but certainly not a deal-breaker
>> for this location.
> OK, so I think we should definitely refactor this.
>
> David pointed out off-list we are duplicating the a/d handing _anyway_ in
> get_and_clear_ptes(). So that bit is just wasted effort, so there's really
> no need to do much that.
>
>> For the record, I'm pretty sure I was the person pushing for protecting
>> vm_normal_folio() with pte_batch_hint() right at the start of this process :)
> I think you didn't give your hint clearly enough ;)
>
>> Thanks,
>> Ryan
>>
>>>>
>>>> Not sure if that was discussed at some point before we went into the
>>>> direction of using folios. But there really doesn't seem to be anything
>>>> gained for other architectures here (as raised by Jann).
>>> Yup... I wonder about the other instances of this... ruh roh.
>> IIRC prior to Dev's mprotect and mremap optimizations, I believe all sites
>> already needed the folio. I haven't actually looked at how mprotect ended up,
>> but maybe worth checking to see if it should protect with pte_batch_hint() too.
> mprotect didn't? I mean let's check.

Yeah it didn't, it took the folio only for prot_numa case. For that reason I had first come up
with that maybe_contiguous_pte_pfns() [1] thingy for mremap, not sure how useful that is - It will
increase ptep_get() calls potentially and also won't work for large folios split into small
folios, since they will have contiguous pfns but not useful for batching.

But, I think even that won't work - I think the regression we see here is because batching
isn't actually saving anything here as Jann mentions, so maybe_contiguous_pte_pfns will
still regress for large folios due to retrieving the folio.

So fundamentally the optimization to be made in this specific case is only for arm64 - save
on ptep_get calls and TLB flushes.

[1] https://lore.kernel.org/all/20250507060256.78278-3-dev.jain@arm.com/

>
> We definitely need to be careful about other arches.
>
>> Thanks,
>> Ryan
> Cheers, Lorenzo

