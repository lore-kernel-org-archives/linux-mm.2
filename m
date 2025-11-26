Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5A9ED111A7
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 22:27:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C18A6B000E; Wed, 26 Nov 2025 17:27:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 272DF6B0011; Wed, 26 Nov 2025 17:27:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13A396B0012; Wed, 26 Nov 2025 17:27:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 013F76B000E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 17:27:28 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 805AD5B66A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 22:27:28 +0000 (UTC)
X-FDA: 84154195776.03.E591EA8
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012007.outbound.protection.outlook.com [40.93.195.7])
	by imf16.hostedemail.com (Postfix) with ESMTP id CCEC9180011
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 22:27:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=nSTewAu2;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 40.93.195.7 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764196045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5O6an5t88ebOYIORjcsWnQWPUBZogbn4L2IxXj9PgcI=;
	b=yv+ppALXsgfJcHCKtlkLzZzDS+VxPHRHP1MA4j+su9Eztuz0ar42hYBLbr5ayAdqpyLZbd
	wObLAon+d9xtICFlUvE49PiKapfspk1e0fhTGG/vkwpTMrghDvx5mOmtuOemHijB3T9ueg
	8YLBP5z6Rr3JUxca8AiiKd6j1ioiATk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764196045; a=rsa-sha256;
	cv=pass;
	b=2BDKJbFnthxkAHXRrkDNmc1X+svv/rvQELsDfOJL5hvrF1n/EeDZ0lmek2cqHpE9kyI7is
	CXbD6Tow8IOLBulZcE7Waf6+bjeK6y3uJGh+9Ia2kwQ9kfFVoQK56twJU6F3CJAy23ST0w
	gvthJLOrjwwYgnGV/oicynf1CTcVYD4=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=nSTewAu2;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 40.93.195.7 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hbKWGLgaGAJ6WSisC5K9cuxgmOHQFKXHYako7vXzu8RgJvffW4R/5tdspsuN0VucqLzMVAsKh3DnXKVVaYOxI6Cs6oCZSComXToanFgDpF6RVNfJF9yi6yfVZfmstp8lb2LyYR4HHoxHQitDqqqGh0XVHkeseIgto5vR7CoMaCpCGgkEUHDsiLCM07JUHaCy7woB8EvrBwk3hrU3wyNYbaLxAvfx2ffo2OWNopUS5H6yRZMW4/cOflFVrCUoysS6iQyN1zayUBrZ1yl669ZtoDZX3BRPvtcZm7cqJutjLz3QaWGnu9NK1Iy7f+P4aC0ge6lJ2b8jJStSxEWOSTTKhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5O6an5t88ebOYIORjcsWnQWPUBZogbn4L2IxXj9PgcI=;
 b=D5nEgv1i9cXrN7oeGKgSHW1dREINwxBASl/xB+AIW/1Z1ckR3HrD+Dg/4WKUgNmruU+VEdkmXEJv/JVTIKW7Qa9Q2CXrDDNupuARSo0aWeYNeseuT5S7zptkFQfrnRUKMaeaNIJDPQAcQMibBBoojLASfv+0BKVXKa4CzgIr9Wj+xkxd2HvgqHmMkJ7aavFQCG7mVuszOE+ptueGXj44prjzQ+UNWDobR9Kuzw3v2DRX45Pv3/PzyH5ouC06iYhZsNiFFjY5QE67RFpfaJacT9tXbtmzzVkXrkAqu+Otni1XDZIFyYtPnB7dKlX/1EaQaQfrlNZG3BLoxdCRo7TG0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5O6an5t88ebOYIORjcsWnQWPUBZogbn4L2IxXj9PgcI=;
 b=nSTewAu2Lm2uY4zZ9ANGJxfDkw7I6KmyWGqiG7fhMAVW43RiJWr3mDGpVbUVlDy5LUQglbxXDgBbhNnxLV2wMvw+s5D4T34H/DtXLqkbijxwcGV9agAC1wkpAAH1akLmho28Ujz4hFeNLrmX1twDKG5MvBFxM6X49/2nldL0A3Q=
Received: from CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5)
 by PH7PR12MB6539.namprd12.prod.outlook.com (2603:10b6:510:1f0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 22:27:22 +0000
Received: from CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::222c:662:e585:3404]) by CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::222c:662:e585:3404%4]) with mapi id 15.20.9343.016; Wed, 26 Nov 2025
 22:27:22 +0000
Message-ID: <e66ef586-0e19-4e53-af34-129ed28675c7@amd.com>
Date: Wed, 26 Nov 2025 16:27:19 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/4] efi/libstub: Decouple memory bitmap from the
 unaccepted table
To: Kiryl Shutsemau <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev,
 linux-efi@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, ardb@kernel.org, akpm@linux-foundation.org,
 david@redhat.com, osalvador@suse.de, thomas.lendacky@amd.com,
 michael.roth@amd.com
References: <20251125175753.1428857-1-prsampat@amd.com>
 <20251125175753.1428857-2-prsampat@amd.com>
 <phywn74ghpsqncoqsgdqjoxeqdxskibzt3yltn6bmtc25sm46g@emad5n6wp5l2>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <phywn74ghpsqncoqsgdqjoxeqdxskibzt3yltn6bmtc25sm46g@emad5n6wp5l2>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR08CA0006.namprd08.prod.outlook.com
 (2603:10b6:805:66::19) To CH3PR12MB8660.namprd12.prod.outlook.com
 (2603:10b6:610:177::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8660:EE_|PH7PR12MB6539:EE_
X-MS-Office365-Filtering-Correlation-Id: a1c12f85-a2ae-47c7-afa8-08de2d3af7e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bWZJZWN0aUUvUWh3ZDZ0bWRtaktxNGtXUjdjT1VmVVI0Z3NTMSsxK21xRGtD?=
 =?utf-8?B?Tm94Y0ZraEM5TkN6dGJQZU5DdjN5VWdWeFVVZmU2bVRvR0ovZDFhSG12S3JQ?=
 =?utf-8?B?RmM0OGh6R21rUTFWaWFucFZXeWIwRHg4U0ZITEM3bFgyT0hBYTdWb3hQcXBz?=
 =?utf-8?B?NjllMXNDK2pIdm5FMmhGeTF4bDZsV0swOFREc1JaZHZONEZYOUZ2cWJDZHJ4?=
 =?utf-8?B?UUVDL3BZTzhWTUN6SFhOc0Z4WFFwSTZIMWtxZmluYXk2dkJjWkk5TjFwci9B?=
 =?utf-8?B?dTlLbDdyZFAxbWdnTGZ5UmtLMXZwQXhTT1JmWWIvRjVqbzlkdFRscE94Tkpl?=
 =?utf-8?B?WFRyU1pqaE5SV3I0UkoyU2M3MVdmVGZjeTY1V3FxSm9WQTBCSzllMzN5bHph?=
 =?utf-8?B?d2Qrbmp0c01ZQVN4Zkp0L1hZTmVKMDVtSmtRNm5icDZUM2RIZ254TkhXRTVU?=
 =?utf-8?B?TGh0Ty9vQXlhRWFBTTVZUU5CM2JJNlNhUEY5eHoyN3JNRTh5azZnU2hKUHF6?=
 =?utf-8?B?RzdGeHFjMFdlM3l0NzE0ZW8yaitwYVRhYjgyblV2UU41YlVlZ1JSNWhsWG90?=
 =?utf-8?B?bmpRK0RaL09kWFZ6OGVrU0VIdmtFeEpBYVJ3akFrRi9rcEJXVWFDVUV0M3dV?=
 =?utf-8?B?U0FQbDg4SzdIdWtkQUszS3piektmV05YWUU1YlNRTnA0QkJzakpnYjVDd1RE?=
 =?utf-8?B?dHZJRmtnc2M2VUlJK1NqSGQvUjZnK2JPcVdCOUorR0dOakZ6WEhCUjd5aTU0?=
 =?utf-8?B?bGg2YlpkZ2Q0bXhoQjlZVlFiTkhRczdHU0RQY1k2VllXVnhuUExubDF6by8y?=
 =?utf-8?B?dHVJRFgxd1p0US9kMUloSnBtZUZSQWlaWkJoTW82bExLSTB1TTJrWU0rQnph?=
 =?utf-8?B?WWl5VGRxUVNxTmc2MnFNcnFvMFl1Q0FUNjErc21aaEZLaytOVmppU1lQK29T?=
 =?utf-8?B?U2NYNXRzL1JtenEza1UwemE1ZnQrV1QxWnVwOUhGYThZVjc4U0t5dFNoTVpY?=
 =?utf-8?B?UzRydUEydXZ3M0ZTU2xxQ1RPZU1HV3h1dGJGZjRTV0tMN0xUSGRFcTNiOFht?=
 =?utf-8?B?V1V1RlBjbUZsU0V5QmJCeE5lVUk5c25HQzhOZFZ0TzhnWHpWTFFVdkFtb2Y4?=
 =?utf-8?B?b3lTLzZ1dTFjSWdXK0pkV2djSmx4bGNaeE56d0pXZ0FEQU9KN0pyTzIyV2di?=
 =?utf-8?B?ZHY0aEc2cEtacThNaDFtd3AyNkNqS05kZnlIN2ppL1cyM3ZhUmVtVUxXQVp4?=
 =?utf-8?B?UEl4RGFWdlJCcm12R0UzVXk3VjhMZmE3SjR5NDBiTnV0RzdnSFdhdmhiU3pK?=
 =?utf-8?B?NFF6dHo2MXdNTWZYM3E5Q1ZiaEdlcXpHZDVnUDUzeGVBQ3dZc0RiMFJqeW5Q?=
 =?utf-8?B?QVZsUjh2Vi80Y0tpSUxYcGdybElTTUtzYmJlc3UzQTY0TjU0UXV6eGMwTm9y?=
 =?utf-8?B?U3ZZeEtlWmdKM3NwRWk0Y3ZlOXB5T2xwL0lteU9VTS90dnJSQ1NOZ0g3b2dl?=
 =?utf-8?B?dTdJNVdyODIvbzkrblZPT25QRmx1T1FpT08xamVIViswNkZBVmdmZjVhVnRK?=
 =?utf-8?B?RGNFT0YxYkVMZjVYb1ZWLzVKUS9MRDlXeXdyRzRIeW9jWGxWQTB4aXd1TGwx?=
 =?utf-8?B?VUVFZnQ3TkJudlAxdWIzT05MNXZwalNEUW1qZEFuUHlCeWI1ditFdFpJUFB5?=
 =?utf-8?B?K1ArUThlWHVxNHNtNXFVc3ZZbkFBdHE2QW5WN3ZPS3NSNHdLY3VGc0xRUXRJ?=
 =?utf-8?B?MlQyeEhwN2c4VXk3NFNDT2xHVWxESWE0QVJMMzRlMFJhZU41eGtGTTVGQjFv?=
 =?utf-8?B?Z1JCYTh4ak9kSm5KVERGbTRDaXdzQ21GQ3hzYnNHUHFTU25BSFNWNHcvbENC?=
 =?utf-8?B?MEVBVjBJZVYxQTRFTkVNLzR5Zm9GUHhRN0FwbzZaM1E3Nnl6ZWUxMmpLTE9K?=
 =?utf-8?Q?6ebogIEsY/RDPpALbSrMevorvXf44Xw0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8660.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?anJlL3QvSkZ4MmdYVEs1cktrcmY5L3hBMzNVZXVZWXYvSVIxTEpVejczSUhk?=
 =?utf-8?B?UVRYeW8vNE1lMjljQm4xMEFwaHpCRjFycWE2OUhQRG9Lby9HWnVubER3WXhU?=
 =?utf-8?B?MVRpT3g3ZGowNVMva24xTnE3UDhxNU84c0ZBZTNjM1hWQmZpa0h1SnNCS3ZL?=
 =?utf-8?B?Z3JVeXZSc1dOMnFlTS9xMUh2ZHlYdURzTjQ4VlptemIrdHNOemVZcDFQZFhi?=
 =?utf-8?B?VFhyRmNFQW8vRWFHai91bGRaeEpNcnpteVBOUElKbDYzTWx3VGZUQ2hPKzhq?=
 =?utf-8?B?eUt1T0lmdEQyTXFHNHpBN1ByVSt1blEvOHpvcExPb1hTM2hIT0Q0dFUxZmNH?=
 =?utf-8?B?dmhOUFVPSHhnbHRJSkFGYUN5aHU0SzlKbWVCT281aEFCUGlpbVFROFlPa0s3?=
 =?utf-8?B?K1NKY256TGdWOGhzZ2d3WEt5cWphTnJPN0daTE1CZTkwNVFzK0hMVXhuK3da?=
 =?utf-8?B?SWJ2SlB4V1ZRc2RZS0lmV0F6SitKMEJ0QUNyM2xOWGQxZ2hBTzhDVzhrRmFK?=
 =?utf-8?B?SlAwVGJrN0Q2Q3hTeS92eHZLV1hjclFnZGhLUndxbCs3bFREcmF5a2dmbjdC?=
 =?utf-8?B?M0FiOER5TjM4aUhDYlUydU5aTzBHaUpGOHdVVWN2SmVZVGNYdEhlbmRVLys2?=
 =?utf-8?B?YXRZOGtOSGVGZ3h4ZHM4Wlcyd1NsMTRFejZHOTFmM21rL2N6L21lbVVacis0?=
 =?utf-8?B?L2VscU04a290Z3UzTnJMdStOZEhiVlN6TDlQNVZodTVJY3UzUSs2VzJsNjl1?=
 =?utf-8?B?T2NmeXI3SUw1cldGcVZBUHN6Z1hzd0tRaUtKQTIyMHlWUnpUSHZVUlJIV1Fp?=
 =?utf-8?B?THRGUmYrOEozbGdoTGR6U0ppY2FrS2k1RkRnVnFCZHY3UHU4ZGFYMkQwdlBl?=
 =?utf-8?B?L28xejZUdDR2eWNPK1RIeHlIWGF0UGtjTFN5cTZwdjRUSGZiODduVk5aTWw2?=
 =?utf-8?B?VG14S2xHdEFORkQ0czVWOVltMnZsVXpIa1JySkQ3NzJPbk10TFJFTDZHWCtr?=
 =?utf-8?B?ZzVQQTdvYnd5MXFVU1hwNklQenZrYW5mdTExeDFIQW1DVGFMUlhBQ1VoR0FQ?=
 =?utf-8?B?N1Y1UU03bFp2anhoZWZLb2wyd3VjS3UrMjFzL2ZERUJaOWR2U0pVdXpHUXlU?=
 =?utf-8?B?QW1heklITG9FcEs4dmcxY293U29tR0ErOUh3VXZZUTcwWHRPWk9hNGQvV3lq?=
 =?utf-8?B?RllGQ2lNVDFBcjhYNXVBYnhGK2p0T2VTQUlTRjhiYnMyTmlzTytSeUFKMU1U?=
 =?utf-8?B?a0wvQzdEeEQ1bFhqZGJXcElFN0hEUzVDV09yWWN5Q3lnVUcxMjJVaHZMdmNy?=
 =?utf-8?B?SVhqbVFsZW5Bc3JSYTRrTlZIeXA4bkdmQ1dPV05xS1Z4R2dPMkF1M3hMb0tR?=
 =?utf-8?B?YWJQV0N4Q1FMeGJFSXZBem8wL1pLRFpTRis2eEt2dWx6TFlkNFVyMUdGeW16?=
 =?utf-8?B?UDI2TWxHWHZlRmx3VkdmMW9MWm9OMXlaNUdLWjVVNVF0MDIrYnBVR1VNSk9C?=
 =?utf-8?B?akdSRGNBbkZucGxxRkducWkzalFUSFNqQ1dQT2pVSFVvWDV4aVVkV2RZQk5p?=
 =?utf-8?B?SnZ4UWJ1Q2lQLzV2UUdvVTRnYkhDaFYrYmZERGlSdndmVVY5QjEzajkveTFs?=
 =?utf-8?B?ay90TURobEZJUUZzbzBZcTY2UWVYZ0RiNmdLRStzQ0k0NHp1bVp3WEJaaUxj?=
 =?utf-8?B?dFFrRDhTcDhDc21hZVdnbmMzYXltWFNFL0dpdjF0bXNMQSsyTm1CL29wRXJi?=
 =?utf-8?B?Vk9VT3lzM3FWQXNLY1NiSjR5VTlPbTkvRExLWUJiMjFweEZScmxVTTRNbDlH?=
 =?utf-8?B?QWUxdENMbU5Qc1JBYzJJZGYvNGFra1RiSW54aXY0VU85bm1OWXFJcU5qRzVr?=
 =?utf-8?B?QVlRSnUvbzlKbTY4ZDQyVENSZytUWDVOUXBzMFFnQkY0Q2RSUmJaTWN5SEVD?=
 =?utf-8?B?M3lJTDZrcHB5UHY4TW81eUlTSUd2dE5EZ0FzWUdzMW54NlpFRHoyQmR1SlR4?=
 =?utf-8?B?clBUbGtzdzlQUGQ5M3JvQ3dQNnVjYytlaHg5NGk1VFA0eWVHMGs3THFxWjZp?=
 =?utf-8?B?c3FQUEZDVnEwWlRlMUdGekduMjFtRWlSMUkybzFaaXlaUjNPcE1sM3VLZmEz?=
 =?utf-8?Q?WGiFidjQn/J6d3hBheUYz1NiN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1c12f85-a2ae-47c7-afa8-08de2d3af7e5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8660.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 22:27:22.5266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MxoS90Z6hHXJDzYWhCZq+m+V0cVyTAlZpYBEU8aS463QPLMeYB8y4MzzQ3W4IWcRYGou5WuLz4OCFC+mlmdBlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6539
X-Rspam-User: 
X-Stat-Signature: 566ixiqoj3kha8ypzx1h7hhjohwuw18q
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CCEC9180011
X-HE-Tag: 1764196045-947955
X-HE-Meta: U2FsdGVkX19LguciHZNscfzDpwrO2FyAD6U8a6loL72GLhBczcH5Qugrl/xdRveTirMMnscM+QBg46rj9Hn/ObRTlz2elLCVp8fKwlAlyuNAE3uMTTP4R6e1Qt55F3Z0omqUxsXfqBRf0qD9vlRDS+y/zXsyso5oa5uAHbLBbe+Yo89+wZohicwHBYals3gz2C+9DBjIn9Z4CWMHJniyOC7/Twc570gI27sqMw7HDn1HF6GfAIGF/HdJ7cfqoAZOLx/i2Jg8wh3z3679J0trmKb2+TRLgY9dkN1D3/NXrb1JQ/pMlP/GDjdB/qETRun/RRHcWwzjZoHmZkkSVwUWv2buIxp3iRXA+oovTlgHLUCiKKw8WMRrJW6JXw4QcDtlOJINJYDaM1PVzWjrNerZeY4zdqqEi1f9Xfk3UFZ0+QaFDD6oFvCt8pEgPVTkGPs0XRmFqzONHeor78o/F4mJjvdKRuyVYgbpVZHhl2Tp6Ftls79G+bS7t6jXKROzBZmnWTiorxVI9m3dtkMuQzDc8l4CG66x1YhxI0ZPN7F+uKDpToon2gJgxH0a0iFka6K79NnwSLrvYUkhstggFyW52kWbRRAYBdBAyVfzjn1FqxgU+n03OTwkhgF1jfwq05gRcJ/zdmUuuwVh5D13ayYSY6bmywAwZOpOrSfxfSulK2c3Njs+eCvsKThmeD9litk/tyG2Tb5CMeOowBhaKyE1R13D6Dlj/LNKcwrOZ62rBVyLaLJouMA+Gi01xWwVPcfL2MQK0avbVpIhKXmejEy+15YYzthLpchHaE6b1Cbw7Coyi/5AcMjYyqNH6wRh6vjqw9RDvhsxm8M/tRkQOpuepD9i2iZIuUK92mOoQGFEYuU/be2WA2JBjIOvGP/vZ4RjpKM8BhlUeqjjQR4aCKIsuc/44Hh+9Sy1eUFX4NpBizOKFAgD7X/75pa4uaF/mZk0SbsQrjdy0WOfBSjNCdx
 sU+KZDi6
 numC/Q6lzw6GK/ntc6/lia8bsgsFA1S41VCb0iOAsWduM4PC3Pqx0ioJFLP716GP+aLpvmLpyfgS7BkFzLsdFhO4KYvnaA1BHGnOc2awLXCUituw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kiryl,

Thanks for you comments.

On 11/26/25 5:08 AM, Kiryl Shutsemau wrote:
> On Tue, Nov 25, 2025 at 11:57:50AM -0600, Pratik R. Sampat wrote:
>> Memory hotplug in secure environments requires the unaccepted memory
>> bitmap to grow as new memory is added. Currently, the bitmap is
>> implemented as a flexible array member at the end of struct
>> efi_unaccepted_memory, which is reserved by memblock at boot and cannot
>> be resized without reallocating the entire structure.
>>
>> Replace the flexible array member with a pointer.
> 
> Well, it break interoperability between kernel before and after the
> patch. Consider kexec from kernel without the patch to the kernel with
> the patch and then back to older kernel. It is ABI break.
> 
> Is re-allocating the entire structure such a big pain?
> 

We could do that. My concern is that we would then need to protect the
entire table instead of just the bitmap, which may add an additional
overhead?

--
Pratik

