Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B2D5C83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 16:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00B046B0089; Wed, 30 Jul 2025 12:31:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1E076B008A; Wed, 30 Jul 2025 12:31:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE5536B0092; Wed, 30 Jul 2025 12:31:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CAD2E6B0089
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 12:31:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 44C111345EA
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 16:31:35 +0000 (UTC)
X-FDA: 83721471750.02.E975E4D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id B1EBB180007
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 16:31:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LaEJhM8g;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Ad2RknjL;
	spf=pass (imf16.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753893091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VbEmOEWbnraBKlb5SxAHcT2bwSOkNujUwKMsnOcoQvk=;
	b=LL7coyheet8kVYAUXhd97QAzm30IYa9Am7cif0bYizEwsa6XSO+zE7p41RXUHalbQfUP7i
	885dcT5htehEZX40arw+jojNwdXgemukI7n+giIWMjAC4iAMv07gBS7RlrY7dAijR+NQpB
	vI6GT3olX/mhChM1AVh4pV8oNI6S43w=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LaEJhM8g;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Ad2RknjL;
	spf=pass (imf16.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753893091; a=rsa-sha256;
	cv=pass;
	b=Dm04H23k+gHCqyl6tO8zejpXhAt2J9BfQj3gXI+qBADN54X3QkcgN+wmhUUoZHIaEyrzvr
	vm6S1qHCOmQtg+jYSHd0OStcN22h6/G9BStmve21LA5/QRsbVZnkkZ8vs/YkC4ZDf+GBDM
	whQV3Q4avwVqRzl+3fnSYo+m6Y5AIfE=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56UGNica016439;
	Wed, 30 Jul 2025 16:31:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VbEmOEWbnraBKlb5SxAHcT2bwSOkNujUwKMsnOcoQvk=; b=
	LaEJhM8gcjp16kF/DfHZTGoWJaEpLqDPquyRa3xMvcye/oDNXb6fikqfIa5RJMB/
	VrwJ6eTJRgqKDgsXpd3SRh28KIxc4hsQllR6YFoOTysHmgpEKZPHMyqw0XFWc3ck
	fEPw9ARu6Q3Bg8QuyUDzN2xxaNuL+sq2yEmGXLbXanVIQqnQ69AaborjZ4lhjmwi
	uwPP4UEyD2/WfRCxctWoM6B4UOd24rLXygVja8N6++btQF8fonEu77iUEL5S7kzt
	vfZkfcR6WCBH4I5Qers4KS3GRKgJiUxlfOOoBvt4fPyTrXXAJ4h6kGsEU5Uc3HAD
	4I9/6oZ3P9RIBfwIUrroBg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q5wt5dd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Jul 2025 16:31:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56UExUUg010491;
	Wed, 30 Jul 2025 16:31:11 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfb87c9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Jul 2025 16:31:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vuYc27Tg/UFsE0gDyg9IPEKlHSeknrgOgJSPG1dOueRi6gd7+0hCq5iZGXrjh2W55XJQwALD/XBPolidnhrR0958LjRfMCJVkspToM/MdIXwSnu30Ko9EzJxbE5KUqsz810CHN3on0lZMC3RSeDcgDmzWGTA0IhbGLxD80QdMf6qJtfXPPYq2dRuwgES1ZU9mhm3t5UlhqrOsuk1txb3RWkee8TRDaGkwIcRaR4PZ3Zt0OiGAzEMtugGSlknh3X4BxFb87HqffPA0zdnELzyBgRlqQeJSC/NDuoFOqu7HYBRXMEhBPPHAQGoG8/Hh+TakOmt3/g//Jm7HM+36yo0Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VbEmOEWbnraBKlb5SxAHcT2bwSOkNujUwKMsnOcoQvk=;
 b=wm8m/zu3KIiUy4kTnIP58DwvKhf/A7i9LvDNsiiKTNXP4xu6Bi0USPC/5ukVJCg1xICB8AbEyG7lFEifgvDPvNrztXdRFHW84+kNTnNKI9fiYPHmL/yjxRdtxzwm5NAucqNB789jI4G97zTSqscuKMv61WkWEQxFHxeWC+QQdxn5pZfjehas3bPbEJ/SZSBIMbtCUD3oMLSbjEc5JUHEHWJMMdklbMkAVUjTwhWuBU5ovIQBU+VqA0wui4kah6iY4CyGMJS119LzNDgnu6490tZd9gg5+2COPJIuez354dASdDs/hd+AJi9jRSHv7j0fltQ4kBox2hXfvTyIespcsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbEmOEWbnraBKlb5SxAHcT2bwSOkNujUwKMsnOcoQvk=;
 b=Ad2RknjLhZAowSqO/AplNWIm/pzFEsFK+MU6DMKNjVJUvNy4tedWo6K50D5uBM61qNg0bSOOjo69f4IvDEZCzNBDZ+vP/Bjh9reA01GL9Ra2+Oo3PPSgZx9iKxlA+Ek9ctIGcisfhRWqhcBiMPUNKbmvWfx7uSomED0wtvprDAU=
Received: from CH0PR10MB5113.namprd10.prod.outlook.com (2603:10b6:610:c9::8)
 by SJ5PPF2BC420A1B.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::797) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Wed, 30 Jul
 2025 16:31:09 +0000
Received: from CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2]) by CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2%5]) with mapi id 15.20.8989.011; Wed, 30 Jul 2025
 16:31:09 +0000
Message-ID: <fdd279cd-81e2-4abb-b344-2686758f6a2c@oracle.com>
Date: Wed, 30 Jul 2025 11:31:03 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] idr: Fix the kernel-doc for idr_is_empty()
To: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        willy@infradead.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20250730113402.11733-1-manivannan.sadhasivam@oss.qualcomm.com>
Content-Language: en-US
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
In-Reply-To: <20250730113402.11733-1-manivannan.sadhasivam@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7P223CA0021.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:510:338::16) To CH0PR10MB5113.namprd10.prod.outlook.com
 (2603:10b6:610:c9::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5113:EE_|SJ5PPF2BC420A1B:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d8fa948-8bb9-4238-675e-08ddcf867bb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U0x4cnQyRFBNaFlhNnhocWRVSmR2dkZueHkzREJIMSsxUERYQXQwVkV6SjFN?=
 =?utf-8?B?eVRLSldBdWlqOGZ0ajhMcEIwL2ZzUzlmSG5FZXdwdVFiNitiTkVLZWVTSU1O?=
 =?utf-8?B?Z3B3S09va21QeEVhV1JjcndhSGlFQ1Rvd3BiRlBFTS84dnFhV0MyOHNLalQ5?=
 =?utf-8?B?RUNiK1Nyam52VDIwb3AvaTVUWHc2aHRuUXpoVUlIc2s2Vk13ZXBOTE9ndXBM?=
 =?utf-8?B?VXpXMUhJOXlXWDFEcjYvS1Jpa1o5Z0hUWnI1TXAzL1p5U2dOUUp4ZlN2ck9a?=
 =?utf-8?B?TDlVNkRvVTI1YnE1OTA1NTg3aFhpTlRGc3lVcjVBaUlUejg1RHU5ZXY5SXZM?=
 =?utf-8?B?YmlqQW1pR1FWU012SG5xMlREKzdXTXArWHZMUEorUjRUK1MzZ2puWGQvbmlV?=
 =?utf-8?B?TDd1R1JwNytsN1NQQVZ3bjJqdkVIQlIvcmRlaFVpd3hianp3V0FWOXZTRkxJ?=
 =?utf-8?B?UGNxTnNyRUNjNzZ0RTFVRnZuQ2JrRk8xcllvd2xDMDBlRWltNHNsSHEvR2Q3?=
 =?utf-8?B?c0pLMmVaSGRSUlRtWTlPK3ZKdmlPczQwZWR3cWR4VktDa0VLVWtHUzZ2dkRM?=
 =?utf-8?B?aUhTdTE2cnFsanJDTUE0c2hzTy9nTVEwSXlrOHFLZ0FtV1JZV1dKRmpEODlT?=
 =?utf-8?B?bk9GeFI3QjdWQjZYanZZRGRzOXdLclZQN1ZvUDYyNFc0aXd4aWdIQXM3VWZi?=
 =?utf-8?B?K0o2ZHA5dW04Q0p4WTFENHdVdFpvNVp3Z3BTaW5tZEpwdzQ4UTJHd2tsUWg0?=
 =?utf-8?B?ZDR0cms4bUZDUVJweDZnb2Fod3Rwb1VES3FPdVBwMEJ4SGx3RUc5aHlxQjI1?=
 =?utf-8?B?S24xVndod0FCdy91bjdPd0VTZCtkMUM3bnQrc3dCZkNIUXJSOG1FL0hqN0lM?=
 =?utf-8?B?Mk41QngvWDQvZlJuNlU1OEcwQlQrWGRXK0hiMHBtZk5JMEtLdkFKL0Q1ajNu?=
 =?utf-8?B?b1V4dXlQRS9VOU9OK2w0TkdOOExrZlFReXJNeWRjWUVLbjZBUTB2U24rNGdD?=
 =?utf-8?B?YlY5ZE02SkJyTUxFdlVCREVLRTE4aVRXY0F0Y3lhYTA3TUYxM1NHU0tlZXlY?=
 =?utf-8?B?enZqT3MxYldZUENlOCtudHFjYXU2TWVvWkhyaW1pM0FRME45aUVGUzV6blFr?=
 =?utf-8?B?c0RRVzVhQ2JDWEc0bG1Ua09ZTDF4dkFsSDR1bUVEQmdjSjJoaGRpaDJEVnhl?=
 =?utf-8?B?aEp5TFJMMTllRjA5eDFkaGpGV0RQVklqU2t3dzdTOGlyekNPOTVFME9qQ21L?=
 =?utf-8?B?b0FQSzMrMGxIQkh3bkNLNDNNQXRmaXNRV1E0TmRkd0NIY0p4blBvQm5oUTNN?=
 =?utf-8?B?SFhHS0pEWjFlUk9SemhGemN2U09yS1pLb1ExZDZRQks2RzZwVmlhMTVlclph?=
 =?utf-8?B?bmd4M0pOT3ZlZ2tmVXNqUGRXNExiUTBUMXJQcEd2VE12U2lNTkQvd2JGYnNS?=
 =?utf-8?B?dVptUHdqTUozNmZyVnYvWEJBbVIvZFgvNXlDUFhvbkc4WHIvSExKaWtraFND?=
 =?utf-8?B?R3MwbS8rTG10M2JIemxvTjRiNUo2OXZiWXBnZXpReFUvRWlKZHdjdWhHL2VI?=
 =?utf-8?B?Y2MrNUVjdU1yN1JYQ0JTbkR4WmpEVnF3YnlwSWtJVHlQQnRjbjVMMjZ3TjJs?=
 =?utf-8?B?bzgwUE1yWkpQaDhIclZvaENrRDN0RFlrZFBhRjlPbHNVQ0V6bUtUNUN0T0Fo?=
 =?utf-8?B?dXV6QitvaGFWbmNyWE93ZDdhaTVOZkNvWVRObGg0UzZ0UWtlQkx5MjFDeVIy?=
 =?utf-8?B?K2JGYitML09mRDkveEpHLzZzbCtlemgzNXVtV3d2YmtuN3JqaTQxRTFMd2NZ?=
 =?utf-8?B?MC83VHNOWlhXS2x4WGh1Z1FFMXR6anZJYitSMGIxYWE2ZWllNjBaVldlUmFO?=
 =?utf-8?B?Q0NBcGVLYXl0STU3SWlyL003V3JFRlpqbWNpVG1jZ3FVS3c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5113.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dUo0Ry9EQXlHY0VCblB0NDJNeHlvTEV5ZzkrRFcvTXhSOEJXTlM4WmdodTJ3?=
 =?utf-8?B?WVFUQ0xib0JjTTcrTnJURXBSMGZ3c3BKY24zL2lFelZJUTFrczk2NGdpWklB?=
 =?utf-8?B?ZUdYRnd1QTBGc1J5MGdVNEpIV2dMdDNNOVJEdU9NNTlsM2N5YkI0d0NIUDVq?=
 =?utf-8?B?R2VwVUsxalY1c1FONmhXajJKVDlYYW5EcnRYbU9iT25GV05jNCtWemtNbW1Q?=
 =?utf-8?B?NlAzMWY2L1pGMU1ScDJLaVd6ZFVUa21XZFh3bTJDWVQ5akljWGt0QXJLbVBZ?=
 =?utf-8?B?RThPMm1pcXpFNG5PMHJMZnoyK3gvSGtlWDJUYjV3Y1c2cDRldDBBc1htR2Yw?=
 =?utf-8?B?TzRrZ1dQeklPdUprV05uckt2KzRFTlVGV3JyTElrc1RSTGF3YVozcURTMTVt?=
 =?utf-8?B?ZUM1dFVTWHg4YkZIMVRRQU1tZ1lSbGwrVjY3UUR6UENNMXU5cDI5VHFqenA2?=
 =?utf-8?B?bHlRaFFwRGltcXQvUm1IUEFDRTVuRXVMWXl6OXpXZjNXeURCODNibWVSbDV2?=
 =?utf-8?B?RHYvdCtXZXNJSWQrZWxHV01OVU82N1QwZTd0VTgyYitvdUcyWDVDRHloRXM1?=
 =?utf-8?B?c1kvb3IzTU55NDhDSDEwcTFJT3ZHbm9nQkdabVFNODd3ZEZleDhIYmdmVFpi?=
 =?utf-8?B?d0xBQkhpQVBoMlhZY2lrZjJoOGJ3TWFURHo5OFZtdDB1SkJmaHYyaktpd2Zh?=
 =?utf-8?B?ODAwMGZlTFkrM1ZWcTFhOW9rd3lCK2FRRHlwZ0NTY0hHNXNnL1duSE1CU2RN?=
 =?utf-8?B?Mm9rRVBlN29OaFZsWXc4c0Z2V25Td1BFQTVURDJQbkV1aXlQUnd4R0x1TWFJ?=
 =?utf-8?B?dkV1cFcybC9DZFpSaGlBcStlZThLa3RyWUVmV2xnYU1hWjVNNGxReWRjZW1M?=
 =?utf-8?B?NGs5M2pqc2ZLdWdpbHRCRUFQRC9hMzhKc0VnNTcwNHdpRmZzR20xR1dicjVw?=
 =?utf-8?B?dnhxM2RaWFpONVZBTE4rRmxJYmUrTlN5WWluVmlaK1FCN1ZPaVdXaFluVHZ6?=
 =?utf-8?B?ODRRY1UxTzN0MG1XOUd5SUxubUNZZjBtVW9HazBOQ0dnYjZvVTVVNlBGM0FT?=
 =?utf-8?B?NHIxMW00VmR2djBjQlExL2RRRkdTR0FRcGZXVUZNVEN0ejI4bEpZNFVPcS9T?=
 =?utf-8?B?RWNwTnBKdGkzSGpXRzFaaWYxVDhXUHgrL2IyUExqc1NRWm55M0ZNMjhra201?=
 =?utf-8?B?QTZDVVFmRzZENVpHaDNvbXR6M0ZPTFFxb1ZEdGwrVGhpZFBYNnB1Snhoa1VI?=
 =?utf-8?B?SmpmRVY3WVNaTyszNGJmN0pONllXSVFSUk1GVG9Nb2ErdStKdi9ReHBmTFZ0?=
 =?utf-8?B?Vm9xVVpFZkNUcmJldHRMQ29sVWJZMGJUR2YwbFFTUjhTLzVqajNzL3U4T2w1?=
 =?utf-8?B?MFFObForb0xGSmhpVXF4eWF0Q1IrZWVOZFZXdmFnVzJEeG5Ed1pXRnZxSCtR?=
 =?utf-8?B?R1VkOU5sU2Y3QnhnS2l4b1NScmJRSUdqMkZKQW1MaGRMeTNBZFVJandFVXRk?=
 =?utf-8?B?bmFNN0ZQaXNVZHhSa0paZUlFRTViYis4czROSWZYWmJZZGFsclVScnJjVFJa?=
 =?utf-8?B?NDVWY25Kb1hzU1dSZ3BHS1JiRHFPb1VRWWV2L2hFWnNnYlBGUXBGN09MMEtx?=
 =?utf-8?B?MFBDdXVMajZzK2pHeWQ0R1YwVlowdmY4bnhzeWZLNFJqcW1UUHpvS1lDZHlS?=
 =?utf-8?B?L1hCN3l0WHk2N1JETmpzKzY0T1Rud1Fvb0VYaXExeGIxcUp4eEFmaitPKzJ2?=
 =?utf-8?B?SVFPT1l4S1RFSGNwY1dDN05FaWlQZllERXdMMHZkYWswVDNWSU9uN1p1SE1h?=
 =?utf-8?B?SnhGZ2pEbmR6dDdONG9BTEtVZVFSMEpmTnFMVEJlTVo0Vy83OEx6Y1M1YW01?=
 =?utf-8?B?TTdQSlNZVkNlN2xhNDV4QlI4NVFTUytlWWt0STRtZms4Y0VGaHpEWTlZZFBz?=
 =?utf-8?B?T0xuMHJsei9yZTU0RlpFNmdQc2o2ODBLWkQvZVczWStxeGwvZmRJbkJob0xu?=
 =?utf-8?B?d1NJUitMa2JZWEJSS0hpdlRYdDRGZ1ZsWFpIaTYxOGJVYlBWbEkzazZqOU9O?=
 =?utf-8?B?eWg5QWZtRHc0KzdnTE9NUWx5WnNzL0dhYk9BUEtKQjlLdDRVMWRCSEI1R1F1?=
 =?utf-8?B?Q21NZEhIdEhWbzFEdjZzdklWcGpUV0Zkakl2RVBGYkpueDIwbFFzWUU4R2hD?=
 =?utf-8?B?WWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WHslKH/uZMlTvRANAg6dNNYRTNoTQ+Zv6bHZciE+vZK8u0eK2QrNOd+l93loRx/du10P+tr/jQwuLzW+HPZRYetqlvH85iiRnIPyD1nZ7voFvJjq1w6V5yunY+cmx3w/HFxZPanXBICEJy8I/TTAWvNIFIjGJ0cicK/BpwrRrSyggygro2nd7qxKB54HgpHTDEK7CQY5Yhw4JilBDkam9VldXcaqUDnmF7SXhUxNQDnGCX9kKgdXGBjPFKVBGitDeOyLGPIL4vwj06zP5QJsrD6v5Psuge1Vnvj3sLBBdnv2FLeyrC/hYIJcNjh27CL7koNq9xKjnqMwyoelQRpAX4xn2Oan+AgLB89MxETE6VZtpsLTlbEdbKjADTxMeVSdF7HB2gUC2oontpZ85+5lJW0r6i9NowZZLGyvxWJZdyEGbtHsWIo+Fp8QJa5JNBZ6YVOOJquMbmzh09IEO+/pWW8031Xe7iRu9aaKH+a7TPrC08LM67iCqWijE3DqhTLJqEryWiFWQRbIBo5emUlcL4JGnoFkbDAn09v1dvTPza07+E66xguV/E8Nx03sJJyFwaPlkq3dpOgcPxhjnunhgt9hj91fANoYyH2oOlECl04=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d8fa948-8bb9-4238-675e-08ddcf867bb7
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5113.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 16:31:08.9910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OmvUYRfyDfNbmXiFUp4xJs/mTCyev/HLetaOgOmYhBVW05i5PzsExBoVjNS656cpCjZdN9ymYin+DfH6MfzHKgmAcshdEQwbd7p2PwVYqqE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF2BC420A1B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-30_05,2025-07-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507300120
X-Proofpoint-ORIG-GUID: 9NOzJLd-nTMglmBM-yW-E7hj8xQW56wO
X-Authority-Analysis: v=2.4 cv=LdA86ifi c=1 sm=1 tr=0 ts=688a48d0 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=EUspDBNiAAAA:8 a=yPCof4ZbAAAA:8
 a=wdO75d1KzVfsu_Tj0kQA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13604
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMwMDEyMCBTYWx0ZWRfX2CBZoqZhyHy8
 AW5KzFXGqsADQ737EG9NxbfJXLh8Ig1O9NlTWVq0iLvyfONA9pzVkaAERwiJYVXoqw+QZgtzoKm
 25oU50GDXj791KvI30Vp93bNjuuh0aUVOb2o86G4AolI8K3HA6kKRWQAmfUPJE6jia3+UwRLSw0
 6nPe/22oo0cC3Jq7X84IPW7AnTrufHTQ4fqNFoNdtpX4Pp9+dMG9oeQN8wQCifvasIUoZMWgkI+
 eqqkFFLat7wXeNz1tI3/x0gdlIoveZFIzPmz9xv1zA+85aztuWyQBjwnSUVTPu8eI1a1PrQp3yx
 w9GYoZtLdxs18lr37mW+NwkgIJbV1t8QkEAixhgWABFECMyfUl7xk6H2U0eMSuk1WCo73niFWM1
 jIiFWMAottfP3MnZlEMW5R2OtkjZ3FrxxvYMWMlo28KpajVryRDvCXiYuj6w71SRYCV2JirR
X-Proofpoint-GUID: 9NOzJLd-nTMglmBM-yW-E7hj8xQW56wO
X-Stat-Signature: j7ntz9en1g8gqnockhuxydfer5sjkkfa
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B1EBB180007
X-Rspam-User: 
X-HE-Tag: 1753893091-523956
X-HE-Meta: U2FsdGVkX1+5PIM4iZBuu0qxyaXvQZo0DJBVbc7N2sk9nyZOrQtwxMNxDKCWJ5zUa9jclWp5EBRn0VdGE3Nl2DUrOq/RKCy8xB+nZz7H5LOBqFrNBXFmRpT42I3rwquijqDU/pCknJip/Xsgf9a9xzqw2oH0kdLzm0jWHhCra4Kt41nitcMAGEpTHf85vQkP6G4uo8S3E0WNzzghdWo5Uwyi11N95TAwGBUbNYEh/V+cZKR/tDh14zbfDms1tx/QNB+ta2HQc/FeMdp3IxEUbG4V5IswAzKC4DV2RWij8UnF9hdMLtPomQAR0ddXhYXW0DW+A6apx2Nzp5cyf8+NfeaIswerRTbhps9hlg7qmizc/qGAUc7pGbDCwezmYFn6yfyqldcnqfmaw9pr7cfotJV1W3PqQT81wEkTdU0+mKYIgYKkKPtzdtqKYt4/yA0tg/UTLy84haLvUxvpWbK25H7Bs467svcROeBNXrTyWLkpCtXYEWIMsF0NB1Tzrf5VWZCUetgDrjvkSnO8IbaUgJlp1UJsc6R5aYcnm00AISbBoNkOLxN1RkhTqNmr3BlTUKMufkKD09Q3hrsxPJwrGsWhNRG8JLVeM8G/5xqYE/FHoT7p4la5BnCFZsOMvSI3QfwHO8bB+KynztDnuwPDYy+Hj+JTHByk2jz07bQBFfMS79+Bas+es6cz7e9vVN89glp8Ch3UbTlBm7jBf+erFzL9Vt+PcbGCOc1W2/LRPuC2McuGZRBNMdr1zvP7l6kf6Q/knKRiDxjFrPmLV3A01UhtIfQdGNofdbNVLn+9LVuOQrscBXlbqs5jIKR8dmfliAIfORxp/YmZJH3hrC03Kkci8tHZ2awhXiVpQsI6nq4fUdUQRB2mJ5fo8fbPscSJk4hl17iJqAdX8IsVWurqEVh6qi9jiiTuAgbxdDyQoFkX7DUwWRSfyTX4u8x6/TQ4isWVMNFv6uzOpx2Em91
 +QBVnRq6
 J4VqecCybZqrMMVRG73i+1PBwvCn6hMl+MMEjDDum4lXZdU0uw7egRLFGp6Oq+noxbwlUKEESX3RdkHO7nHGOBiSi/J1mf/6YFjdwq+Yd87u/iWgNTzzEU2Qdh0NpvDfQNe3pdORZHulxhBIomGRcQSQFZRID5zrEVeWgOXUZ8ZCcHW7ep6Hii+pn2es+n+VVF1QnERm8iAfiXXSaJqJnyCOqpPHH07y1N2DS7L7iC87QbQT0UvHsne+0YGM9z64Pim8hHw6rm1mqZDZSGDMAp9u6ZFg0Mlq6NBDQhjjst4zygxenDtGX4goS7EupVwblmPmCAUXAVTiyua1VOLZbmtYrWF4fjaLk0ICVKYiDrO4hxmdIB+pd8DiNK53C2MqWVDJezlP46IFXQEkFSWPjWcy7xYtFdNPHArrgo5VaHAp1xVtyZTWoETBeyKPApecCvIQlfj1qk/TCRK3jg9lFVJzxEWFgyhYa4krNjnlaPagkT+Au23+GKPLKNffiFGzHOBq0iaXC9BsuFZYOJH+IsX25Ur+p4CM/aF5GjQ8c9bnLV7aY4dcfddoExH45GIOz2zVTJ+EvqSKh8icqxMfdxAngd49UpOm5miB1wByGwaX8/Dc1XJJvf2fi5PQuEuEU5NneS3H4WWg6oNxbn+7n7Yd82YvumPOZhX+thNDiL2bLmkTbtu7LmaDbmTgm0jtNU2WoW/livip3jT00a1LQ2izuz3f1UeyKyviYdVjB8calYXh8r9D9V0BEdcpdfkekSGrVaafWRXceq5nELZfVZv+GLR9jYcd1OwjR74hSvFRyYFcp6+iUfxjDllP/ih5YgX+b4H4P+/0Uzo/vis5zajzYctm46Z94N734
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/25 7:34 AM, Manivannan Sadhasivam wrote:
> idr_is_empty() will return 'true' if IDR is empty and 'false' if any IDs
> have been allocated from it. But the kernel-doc says the opposite. Hence,
> fix it.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>

> ---
> 
> Btw, I'm not sure if we really need the radix_tree_tagged() check in this
> function. It looks redundant to me. But since I'm not too sure about it, I left
> it as it is.
> 
>   include/linux/idr.h | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/idr.h b/include/linux/idr.h
> index 2267902d29a7..4955cf89e9c7 100644
> --- a/include/linux/idr.h
> +++ b/include/linux/idr.h
> @@ -172,7 +172,9 @@ static inline void idr_init(struct idr *idr)
>    * idr_is_empty() - Are there any IDs allocated?
>    * @idr: IDR handle.
>    *
> - * Return: %true if any IDs have been allocated from this IDR.
> + * Return:
> + * * %true if this IDR is empty, or
> + * * %false if any IDs have been allocated from this IDR.
>    */
>   static inline bool idr_is_empty(const struct idr *idr)
>   {


