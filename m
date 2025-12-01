Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAF16D116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 17:21:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EFC06B000D; Mon,  1 Dec 2025 12:21:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29F656B002B; Mon,  1 Dec 2025 12:21:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1407D6B002F; Mon,  1 Dec 2025 12:21:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EEB5C6B000D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:21:11 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A11A614030A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:21:11 +0000 (UTC)
X-FDA: 84171567942.21.BA09FF0
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010010.outbound.protection.outlook.com [52.101.85.10])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8ED7420005
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:21:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=yxGt8pbx;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.85.10 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764609668; a=rsa-sha256;
	cv=pass;
	b=8jZAuVxaEGCGlQQ3DuXM4sWdlZtETgiLqGWALZcZtxLamqXV5mG5KwQNCHJVver4RDV59A
	gtJ26nYz/5QC/pI7kEbQQNMIRCBcaV0UW70U9pNZa0yqGq0hvTTl6sPUw6ngldi2pQFF9m
	OLxl583g6D+LwsolIwsHKiPkCmUpZ3c=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=yxGt8pbx;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.85.10 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764609668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ml6WQbaurFtf8dU4Nam6h5iGsZBbej+dWuvGyMNqfbY=;
	b=Fb2BIwVg1pOMnvB3PjJVABfAusSa7w9tenymcnlxM665xf4hnKMJtcPauEwnRWRm8N5H12
	1QmhYx4B3m3uNY6JZYeSNCE4sUE4jx1kOg9LuyOMdUbgKrPnU5CQFQWdwHImWErghl60kp
	QX2TXFdMUFPHqWLAp+Yq3uHulTsHA0w=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aQ+NMisUN5XH/aDQDIveJSa5WPt+fz5QsE97uwbuxT5RV5iv7zPSQyrEzwO8WIV+lu3SY6l1mBdUCuMfzsAErYFcqEQZo4qzFN7LrEgV/gBMt8/iz2gS5sRxd91NJw4aaC52LyFuX2RlNyCQf+KsHYn9pN1rpyD1bUxjzp/5FfeOacQi741DVIXqVllotG0/BOHYShsk4+E3IVT3qeyZmcWAol4ssE46ueMzg+KOzGmWdACG7nBxewP+EMx2GmY1Wwse3QBYddg6bvu+tigtibNEYyqFQVzGRX2Rxo7rQk5oQlpt5gU2ZnTXSr20OfkoIKTjmAZzNIgziGg8WSqONA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ml6WQbaurFtf8dU4Nam6h5iGsZBbej+dWuvGyMNqfbY=;
 b=lCsH/5c89fW9i0zWAOP4sRjKQcAwM6ZQLbLv/90YVe3oQ6Z5rMy9Cahi128DVa19lN/Wy/RtSa/TMBdfh1FDx86pBcD+kiKPc87SVhx2QKAl+ZVsox068AjbuZki0S+SPQ1DwL7cEndoVl0+lwMEjK92O99yHD2Ofiz7/rzI19EjAXguyI8n6YSxIc81C/bOb/FotCYruGTNABO/mgUBwy47M1QA1+gK3VmVcPoT5Liqo5Koh8NEZLo/CAgaLgaMr+R8pIHS39JjBtk3AtFEwLbIsvQ4IiMbr59bkBPT4IQ3Vlg9VNGCy0LuJfo9zIMUZlJeU/CfPHGaJ843oizVeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ml6WQbaurFtf8dU4Nam6h5iGsZBbej+dWuvGyMNqfbY=;
 b=yxGt8pbxvALam5TEEuOy82nxpW+kiUQt0RgMio67BL3nU5v9hn2g85PPbOV8eGXSIbtjw0wq79lRCg1SOYTDNpxiQm4Xu3pXko0nHTyOmgFYKzUQOtafCX+BghVbMp3raQ750pefCKm8oYl8a6z89IJSCh+MYGYaEXliS9Cya/s=
Received: from CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5)
 by SA0PR12MB4399.namprd12.prod.outlook.com (2603:10b6:806:98::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 17:21:05 +0000
Received: from CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::222c:662:e585:3404]) by CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::222c:662:e585:3404%4]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 17:21:05 +0000
Message-ID: <73a69c03-feda-4c56-9db1-30ec489066fb@amd.com>
Date: Mon, 1 Dec 2025 11:21:02 -0600
User-Agent: Mozilla Thunderbird
From: "Pratik R. Sampat" <prsampat@amd.com>
Subject: Re: [RFC PATCH 2/4] mm: Add support for unaccepted memory hotplug
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-mm@kvack.org,
 linux-coco@lists.linux.dev, linux-efi@vger.kernel.org, x86@kernel.org,
 linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, kas@kernel.org, ardb@kernel.org,
 akpm@linux-foundation.org, osalvador@suse.de, thomas.lendacky@amd.com,
 michael.roth@amd.com
References: <20251125175753.1428857-1-prsampat@amd.com>
 <20251125175753.1428857-3-prsampat@amd.com>
 <ac479414-e0fa-49be-8a30-8f9c0e7b7d32@kernel.org>
Content-Language: en-US
In-Reply-To: <ac479414-e0fa-49be-8a30-8f9c0e7b7d32@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0092.namprd11.prod.outlook.com
 (2603:10b6:806:d1::7) To CH3PR12MB8660.namprd12.prod.outlook.com
 (2603:10b6:610:177::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8660:EE_|SA0PR12MB4399:EE_
X-MS-Office365-Filtering-Correlation-Id: 581af4c7-be80-46e6-ec87-08de30fe023f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TklhS09PU3dwT0RrdFhSVjBnb2xTTndWU0c0a1JvTWUzbThVY3h3blJPN2tZ?=
 =?utf-8?B?WlpJVjJoWXUzRlNHUmY0ZnU1b2hvRndSN29QRnJCc3pKNURERFZiaFg4ZU5t?=
 =?utf-8?B?QWxZcmFtYTNIVjF1Rk5UQldPaEprU2JkRG5rb2pCMnlTZFdROUQ3SSs4dXRr?=
 =?utf-8?B?VWdPUVhRL1V6YXRjWS9WSjExVGQ0NHJEMWd4UFJMY1llZWE5MXZuYUFiTGpG?=
 =?utf-8?B?TVQzU1FUaHRPZjVYMWtpVnkzMHg1NGl6bnlBZ3E3K2lsRWx1ckRMVGl4RFJX?=
 =?utf-8?B?blpiOFVDTFBuR09KdTZGcVQ3bHVSVEJYNVlGKzNxTUpxTWF4MFVIOHdJMXVr?=
 =?utf-8?B?WE5IY09WU29oTjFuTWhoZzdBTjFYb1VrWFVPc2JXdE1qbmE0dmZuSHkwbHdU?=
 =?utf-8?B?TlZHK1VqcEdOeEJyaW1sQ0RTUURPZ211aThpajZGTjJiVzgvQmNmK1RYWlNx?=
 =?utf-8?B?RGdxUFdUWFpnaHRjc3FxMmtSRXVicUVUSEx1OG1xVXBudmdvV29yS3VJZGFI?=
 =?utf-8?B?R2YycCtZbkE4bE1TV3Q3VzFXR2FhZEdTV2dkTFlSZ0VsVXlQYnZ4NEkvUk92?=
 =?utf-8?B?SXMwTjZxVkxEQ09pd2xYUFVxYTEwMTV1RVdQbkQ3a01CbGJyeVBvQllmZGwx?=
 =?utf-8?B?blgycHVWL05tSTZhbjBBZmdZVVJNMzloMGJsU0ZPNlhad3VHNU1mWFZJcm1N?=
 =?utf-8?B?dmhMZHBtWWNDSUNPSEowd2JjNjkyVWlad25SVEhUMW9DQ0prNFJmeWN5UFpl?=
 =?utf-8?B?SGtoT0JFcW5wR1BGUjdIYXRkTFpoU3N3ZUEvd2hFVkVVak5TMUVQRDUyNXFN?=
 =?utf-8?B?NXN2RnVFeG5VcHk5T29JZ3dNZnVkU1NmNXpnTis1OXdWRi84SXZkS0FRUWJk?=
 =?utf-8?B?UGh3NzNGMmRoUVZHNVR5aXVyQW41YlJTc3NwVzRUQmlvY1BDUWkzVVgwdE0y?=
 =?utf-8?B?elQ4S3pCdnhCSURrQUFlZWdrSHBjNVhTaTZiM2dhNkJhWXNwaU83cnpZR1Br?=
 =?utf-8?B?cms5VEx3Kzc2THV2WXRVY0swdWE2aEg2bHdQQUYyNHI2L3BSVFVZQ3Q4QUlU?=
 =?utf-8?B?VnJOdlhkdzVscWVSbElvWWFCbTEwWS8zL09UQjdQbVpaVk5Sb3ZMaEJ2eElE?=
 =?utf-8?B?eWtYazR6QS92amJ4NlZQRmhZdVE2SWxwdDRic2tHT1VjNmd0ZDNwUDhOTGkw?=
 =?utf-8?B?d01TQXZ3OWkwS0hvUVJlSVZDSVNzNEIvN0hxakFHQm9wQzZ0RExoS0VXb2pK?=
 =?utf-8?B?VmdUb0x0MWlHZjlxc0ZaZmZWZ1E3MVcrZHpBOHVrc0ZHdUNBODFSZW9UUWV5?=
 =?utf-8?B?Vm5JQUI1QkVwaDNTU3JLV0pEdDFac0hMRTZ0Mm1BamtTMHdVWFpHNk5vOVo4?=
 =?utf-8?B?dDA3d0JhdFd6VTFnOEQ2c3JEcmhMUTFTbDVWaHZ3T3NCSEFYaHRWWlZUV0pL?=
 =?utf-8?B?QWVBYi9JUGEwUUl0TU5YbFprQ3lrZ3VkNTdzUDdtRkZYb1pXREZkWGRLdkRC?=
 =?utf-8?B?aXFrcTlPSGpkSUtHOXVOeVRMdFZHaVp3dnpJazBPa2VlM09Tb01lNzQ3ZWds?=
 =?utf-8?B?YVNLQlhIQlcwWWJwWDAyRUZGejZQcW5FbFN6ZDVRZG5kek1yK3NNMGhUS0Fr?=
 =?utf-8?B?VWtVUTF1Q3I0Z2FwOG1HSXhFNmJ1RU9LYWN0ZXp6MG1EcTk1QWFuWmFObmRs?=
 =?utf-8?B?NnB0ZDgva2EyT1dWUUhMSDllMU1YRzdMSEt3ejdPZm5nbFRJbmVXaHZIdGVp?=
 =?utf-8?B?RG16WTNVTjRRVWh2Wk5veG1PeXk5YURiaU5oZ0JrZGJwUWpMdjk2aG5Sdk9r?=
 =?utf-8?B?K2xzc282WU9zSXQ1YSt5Q2Z2WWpmUzVNQjUzK1ViaDg3UFIwRWZHQVZYdExV?=
 =?utf-8?B?SVJYVGRCUkw0RDZzQXpCSEZ5ZzBYcDkwanRDQmt4K2FHb1RtQm9VQ2ZudTRK?=
 =?utf-8?Q?goRl+FV0U9uWrCQpUAOpzUAVvptT3+bC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8660.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?enFnNWtMdTNXNHBQbVIvVVR3NEt3VTJjK05tb0o4T0dkbmFkaUpmb2I0VHpU?=
 =?utf-8?B?Y2o4SmFSZytPcTNpZ0FMN09ZWXcxV2s2dUxRQWRHdnI5U1l2RUFqcXpsRE9k?=
 =?utf-8?B?MDdGVUJkV0tqcVZGL20zY2VDZWRhdGJkaWlwbFFLWGFqUEFIYXJTQ0QvUy93?=
 =?utf-8?B?c29GV1ZORlpMWHdheFNiNzFTQjU0cFdqU1ZvU1ByNjIxUENCenp6NnQ4eFRO?=
 =?utf-8?B?ZEF5VVFhekRHalRKbUFlWjVCd3VKRjJuZUVwM2JiRXJRL3FMQm42dzVoZjhE?=
 =?utf-8?B?bG5QcnAvNy9GKzNQbEViUk9QMitJaDZjVkp2SkI3NEVpWnZmUjdQNmZIT0Z6?=
 =?utf-8?B?NVVvbStxdjg0OHUvNHJMYXIwUUZ6MnlMWEJrTUJ2TWdOVnY4MGlKUnB4Rk5s?=
 =?utf-8?B?RzIreGhWMjF1NWNqRW1yazRvOWRKd3YxSFNkSkZPMDFXcFFoOEJPVC9mNkVW?=
 =?utf-8?B?RC9lVmw1QmNJaTRkL0tib0xENFhRTVlUV2l2R1U0SUpNUWlQT2tOUTg1TnF5?=
 =?utf-8?B?aVp0elVGVGpCaDREampFRXFUc1MvWEhGZytRbTMyMnFtaWZrYVZFeDZpV0NT?=
 =?utf-8?B?QWhmRVB2ZitRcWZ2cU1pTkhwSHNmcFY2ZTNuQkdYcHVhWWlNaHlJUktXQTR0?=
 =?utf-8?B?ZUJvRG5uSU1oemJqTkZ6dk1MaW5Lc1ArZjJOYzZoYk42WXVSeDN2NFVqSitH?=
 =?utf-8?B?ODljaXhKV2dEaEhWaC96a0xvVDUwdzRBZU1nRHo2SkhVRmtVa0pYTmc0WFY0?=
 =?utf-8?B?Q3lnYkdvbjMxaUlKVE1EZCtCeEVRZmhKZzFQUGVlZU9ZWjFka2dzb2x4TXQ2?=
 =?utf-8?B?dGJTVUxFNHlnZkJaQWpxUGlLcVpMVzlVL2ZNMU9WcWoza3A4dXlOZk1hckwv?=
 =?utf-8?B?dHBXcXR4M0hleVZMUXg0cjllMHd0S3hLZ2pPdHhhaFk1dkdRWit2T243YWVF?=
 =?utf-8?B?dEU0Rm9PYVRpdUlCaE9xY3BBNmFLN1RXTzloNFBDYzdzRHFTc0R4bWN3MC9U?=
 =?utf-8?B?OGhqcTlvNy9QamhQbG1nUEs5di94Yk9QMjc2QzZTcUlEQzVWR0JoMkJrMVRP?=
 =?utf-8?B?ZVlHL0puUjZ4VFB2ZlZacWpjSXljV3pQL2tncC8vamVWVFJ2azFBODlIdEFD?=
 =?utf-8?B?MFhCUHpnZ2VQUGhwaTZwdzlFVi9hdkcxRWtQTW1LWDZLd0hFTFZ4d25BQjBv?=
 =?utf-8?B?QzhyZWZ0elNsRk1JeWpBZGFLTEpTaS90Ym9hSm5MSytRNmN4YXBycHBDMjlG?=
 =?utf-8?B?U2FjR1FXQ094NnE3MWNHbXZPYVFmNXVIcTFnUkthMVpuay9Gb2ZTa1hkQ0o2?=
 =?utf-8?B?NzRBYXF5Sm1jOXVBUlV3NGMxTmRwYit2SmJMZGhrcFdOMmJLWUg4TFhVTXd0?=
 =?utf-8?B?KytvMVVubDd6bitmL3Rvbk51Zjl2ZUVna3A4NHlqTEN0UFBFNHhMYUdRaXgz?=
 =?utf-8?B?WmNVMTlZb0x2VmpNMmh4YkJPNjk4d2JJa2U2THc5RFpEK1NHZmlvVDI4Ri9j?=
 =?utf-8?B?dlg5STI3Y2puazk4MkdLeTdQbUdQajlPeVBhTXV5RXpjWWJEMndWQUJFZVU1?=
 =?utf-8?B?TUhWOHg3VXJiVDdpeVVyQi8za2kvUkZndElDMWxkb0VLUmFXb3JITHZxS0k5?=
 =?utf-8?B?YXNQaXdpaHNYRHhGYVVDRHdMZTZNZVpJK3EzU2gxWjJ5UnFPQXVaL3MxODNX?=
 =?utf-8?B?UkdyQ2dGN0ZNaUM1dzdrWGsvNkx1dm0zYW51UWJ2MEFTQnRYTTZMeWpuTzNJ?=
 =?utf-8?B?cTBDczQvdkgwWlkwZy82cFFTMnZNeXVZOStXMjJHbkdJVnVIRFljNHY0Q1pm?=
 =?utf-8?B?NXdEVGtYRmxINXhCMjd3UjlweG0rNnRtdm9zaGczUUYwSC9NM2x0OXFKS2RK?=
 =?utf-8?B?RlpiUXJteVA2cUpWd1Q3eXc0LzVVaXB2Z0ZmVlJDdk13WUlPWVhlVG1reG52?=
 =?utf-8?B?bnBsa3FrbVhCQmFtcXdhb0pORlJlbTk4bEdVQVprK2ZIYkJncDI2MGcxWmhs?=
 =?utf-8?B?MkNkd2ZsZjZLRlU3aUc5bExkcFAzMGU4aXhRT2E5c285NTZUSUVwcU02cElE?=
 =?utf-8?B?c0JGMHUxMTM5U1d3bjF2VU9ieXh1NisrNjkwRmlhbEJSSDVuRm5zaGRRTVdq?=
 =?utf-8?Q?JYIBbINg1jkjvPP+V6ouS39hR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 581af4c7-be80-46e6-ec87-08de30fe023f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8660.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 17:21:05.2945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y/ieVz8uRa6Yxl4WS/1XZUWY3Kle04qCAs0wXEDR/IbDONtBhAl3qLIQ13kXJqyGc7pdRPq+7ih9x6qMmjQ+/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4399
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8ED7420005
X-Stat-Signature: ri8u9wo8k4cegudq7tcsncck7ckj43jb
X-Rspam-User: 
X-HE-Tag: 1764609668-700382
X-HE-Meta: U2FsdGVkX197QxfrWcuia34T3AR17SviNh/kFT73gy/37ruB7YBkJ9eDx1Nsz4QIlcBU5WtiKxEcm0o45twU0VsFmrUGsrK42eDzzJs1e+apyGXyog36cFk+45K2pksmfbgufDQ63WTO3inz2XUkOg3O2e+vLMFai7RKueQ5pp8VW1BZW39ebW/9fGSR+0JTjJYm0FBNCP1bTWA6DKwJoORYfi6N0hdBwRDpJipICACQcTJUYcXLDuZxVy8N5/LiiAKhUq+a51g+PrCIcapIg9RXUCQ7T0E6his8Hb7igcIMTaY83ekr+CaWa+f+lJ/xFqCmQtfuOIRPin5UCCzaixYqu6viUavvG8/XDEN5pO+QyH5M4HpUme+g0B/Qfu9AmUMacOp+n05UAM/5vgxMkzoGSfxMPpwDjzK5WEcIXrQRKPdb+AkQgaglZYn2ag59aYRn2zB+e8dIcX0oeQ/ue7jAR5I3LakmkD2n4SNEeMJ8UuUPm83zIlgNzjQbkYh139qTVLS1mGHc0EKf4FA4p7L8WIaVUvPOw9vj4StY3091SAzGqp/QYa1Vz6UTUqK6q1St2lRSRDff4OhSdaP0VtYINIAgXO4eFSZkfAOJxlhdMFYXywCl82sFIdIIMMqL4vuA9hOJERD0AoYqqfEKTBJadr5HlQf2A2ev3sbskbVE4KRv/KFYXbp/D2K995B5NzO10AggMJvpJWt8XJWomC9kAq2DMlhmt1E1by+EW3BDLL3bUNbeNue7eIFsx/WCiodS4dC7m8eUHGY38MPcjvJeISjyWJcmWiJz8BNWvmd1Um4qboZ5oyib358MwAAmlUQfhtj0Wtwc4hk2jvbjDLve2GGi+7Ryyqqo5b+IJGEOj19V3y2qvbiUz/nYe6xJMfVXd7vzfstNoiALs/aCEjstMId+wEdf4Pkjy32EGPHP43xqC03ybD8XQAu7I4NtSWYFpxZaLq2DDvx4P+n
 OZKPNtaj
 B1CEjt/4TAvDSbaubu6K+jkPPsZqQzkxHMBg4LopfDnR9HxfDz9CjSY3WXJ8+Ja1n6tFVNzadwPrKWXff2QgxrH8arTxSLvQxANOk4xO7dHmwEA+f0Z4+kc9vaZaHhUgn57AdY5mvVbeH0bHQ0glaMl45RffHIl2Vc+3vHvt257NuwqmOQ2vWK4ovQ1I7ZD1n2QzQvhIMj21o4R7O0parAY0J8AazRTmQbCR81Nms9y0rtPIJMijekz/c0q11JjHxXLVAiKS1dIqzV9EGl6SaGhYbOjjOmW8lJlPDhKyz5iWVU4hgrOU8BhBcM6AH51rbqGCm/EmhoO7/Ju7zoLR1xGDrIfvPT2cNYcBJd6j06AoZobmpj1z1H7HVOR8fSar+iRssizxNvR85VWDMbI+Wu5FLzLSk9R5j6r8S6nm1yHqx2feJ7j4UeqvDmtDwIsEC1s1HfuNUBin4wMNvL/PqU6zJqNONfxeq13iilnRlAgMuntbYvR6TG36ZSxEy5nu1vApqEOslEZy3SyUCVDDPMNSSScn/mH5EvCcRHFIZwceQZOcOqPx3gyIgnHh5UHyPDRcSCP1E2cnyo6hv49Zlwx8Bx0/EzkLDG+cR4jHGDk3ynXL+UNVRP1hJ/GO6h7SqK+vC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/28/25 3:32 AM, David Hildenbrand (Red Hat) wrote:
> On 11/25/25 18:57, Pratik R. Sampat wrote:
>> The unaccepted memory structure currently only supports accepting memory
>> present at boot time. The unaccepted table uses a fixed-size bitmap
>> reserved in memblock based on the initial memory layout, preventing
>> dynamic addition of memory ranges after boot. This causes guest
>> termination when memory is hot-added in a secure virtual machine due to
>> accessing pages that have not transitioned to private before use.
>>
>> Extend the unaccepted memory framework to handle hotplugged memory by
>> dynamically managing the unaccepted bitmap. Allocate a new bitmap when
>> hotplugged ranges exceed the reserved bitmap capacity and switch to
>> kernel-managed allocation.
>>
>> Hotplugged memory also follows the same acceptance policy using the
>> accept_memory=[eager|lazy] kernel parameter to accept memory either
>> up-front when added or before first use.
>>
>> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
>> ---
>>   arch/x86/boot/compressed/efi.h                |  1 +
>>   .../firmware/efi/libstub/unaccepted_memory.c  |  1 +
>>   drivers/firmware/efi/unaccepted_memory.c      | 83 +++++++++++++++++++
>>   include/linux/efi.h                           |  1 +
>>   include/linux/mm.h                            | 11 +++
>>   mm/memory_hotplug.c                           |  7 ++
>>   mm/page_alloc.c                               |  2 +
>>   7 files changed, 106 insertions(+)
>>
>> diff --git a/arch/x86/boot/compressed/efi.h b/arch/x86/boot/compressed/efi.h
>> index 4f7027f33def..a220a1966cae 100644
>> --- a/arch/x86/boot/compressed/efi.h
>> +++ b/arch/x86/boot/compressed/efi.h
>> @@ -102,6 +102,7 @@ struct efi_unaccepted_memory {
>>       u32 unit_size;
>>       u64 phys_base;
>>       u64 size;
>> +    bool mem_reserved;
>>       unsigned long *bitmap;
>>   };
>>   diff --git a/drivers/firmware/efi/libstub/unaccepted_memory.c b/drivers/firmware/efi/libstub/unaccepted_memory.c
>> index c1370fc14555..b16bd61c12bf 100644
>> --- a/drivers/firmware/efi/libstub/unaccepted_memory.c
>> +++ b/drivers/firmware/efi/libstub/unaccepted_memory.c
>> @@ -83,6 +83,7 @@ efi_status_t allocate_unaccepted_bitmap(__u32 nr_desc,
>>       unaccepted_table->unit_size = EFI_UNACCEPTED_UNIT_SIZE;
>>       unaccepted_table->phys_base = unaccepted_start;
>>       unaccepted_table->size = bitmap_size;
>> +    unaccepted_table->mem_reserved = true;
>>       memset(unaccepted_table->bitmap, 0, bitmap_size);
>>         status = efi_bs_call(install_configuration_table,
>> diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
>> index 4479aad258f8..8537812346e2 100644
>> --- a/drivers/firmware/efi/unaccepted_memory.c
>> +++ b/drivers/firmware/efi/unaccepted_memory.c
>> @@ -218,6 +218,89 @@ bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size)
>>       return ret;
>>   }
>>   +static int extend_unaccepted_bitmap(phys_addr_t mem_range_start,
>> +                    unsigned long mem_range_size)
>> +{
>> +    struct efi_unaccepted_memory *unacc_tbl;
>> +    unsigned long *old_bitmap, *new_bitmap;
>> +    phys_addr_t start, end, mem_range_end;
>> +    u64 phys_base, size, unit_size;
>> +    unsigned long flags;
>> +
>> +    unacc_tbl = efi_get_unaccepted_table();
>> +    if (!unacc_tbl || !unacc_tbl->unit_size)
>> +        return -EIO;
>> +
>> +    unit_size = unacc_tbl->unit_size;
>> +    phys_base = unacc_tbl->phys_base;
>> +
>> +    mem_range_end = round_up(mem_range_start + mem_range_size, unit_size);
>> +    size = DIV_ROUND_UP(mem_range_end - phys_base, unit_size * BITS_PER_BYTE);
>> +
>> +    /* Translate to offsets from the beginning of the bitmap */
>> +    start = mem_range_start - phys_base;
>> +    end = mem_range_end - phys_base;
>> +
>> +    old_bitmap = efi_get_unaccepted_bitmap();
>> +    if (!old_bitmap)
>> +        return -EIO;
>> +
>> +    /* If the bitmap is already large enough, just set the bits */
>> +    if (unacc_tbl->size >= size) {
>> +        spin_lock_irqsave(&unaccepted_memory_lock, flags);
>> +        bitmap_set(old_bitmap, start / unit_size, (end - start) / unit_size);
>> +        spin_unlock_irqrestore(&unaccepted_memory_lock, flags);
>> +
>> +        return 0;
>> +    }
>> +
>> +    /* Reserved memblocks cannot be extended so allocate a new bitmap */
>> +    if (unacc_tbl->mem_reserved) {
>> +        new_bitmap = kzalloc(size, GFP_KERNEL);
>> +        if (!new_bitmap)
>> +            return -ENOMEM;
>> +
>> +        spin_lock_irqsave(&unaccepted_memory_lock, flags);
>> +        memcpy(new_bitmap, old_bitmap, unacc_tbl->size);
>> +        unacc_tbl->mem_reserved = false;
>> +        free_reserved_area(old_bitmap, old_bitmap + unacc_tbl->size, -1, NULL);
>> +        spin_unlock_irqrestore(&unaccepted_memory_lock, flags);
>> +    } else {
>> +        new_bitmap = krealloc(old_bitmap, size, GFP_KERNEL);
>> +        if (!new_bitmap)
>> +            return -ENOMEM;
>> +
>> +        /* Zero the bitmap from the range it was extended from */
>> +        memset(new_bitmap + unacc_tbl->size, 0, size - unacc_tbl->size);
>> +    }
>> +
>> +    bitmap_set(new_bitmap, start / unit_size, (end - start) / unit_size);
>> +
>> +    spin_lock_irqsave(&unaccepted_memory_lock, flags);
>> +    unacc_tbl->size = size;
>> +    unacc_tbl->bitmap = (unsigned long *)__pa(new_bitmap);
>> +    spin_unlock_irqrestore(&unaccepted_memory_lock, flags);
>> +
>> +    return 0;
>> +}
>> +
>> +int accept_hotplug_memory(phys_addr_t mem_range_start, unsigned long mem_range_size)
>> +{
>> +    int ret;
>> +
>> +    if (!IS_ENABLED(CONFIG_UNACCEPTED_MEMORY))
>> +        return 0;
>> +
>> +    ret = extend_unaccepted_bitmap(mem_range_start, mem_range_size);
>> +    if (ret)
>> +        return ret;
>> +
>> +    if (!mm_lazy_accept_enabled())
>> +        accept_memory(mem_range_start, mem_range_size);
>> +
>> +    return 0;
>> +}
>> +
>>   #ifdef CONFIG_PROC_VMCORE
>>   static bool unaccepted_memory_vmcore_pfn_is_ram(struct vmcore_cb *cb,
>>                           unsigned long pfn)
>> diff --git a/include/linux/efi.h b/include/linux/efi.h
>> index a74b393c54d8..1021eb78388f 100644
>> --- a/include/linux/efi.h
>> +++ b/include/linux/efi.h
>> @@ -545,6 +545,7 @@ struct efi_unaccepted_memory {
>>       u32 unit_size;
>>       u64 phys_base;
>>       u64 size;
>> +    bool mem_reserved;
>>       unsigned long *bitmap;
>>   };
>>   diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 1ae97a0b8ec7..bb43876e6c47 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -4077,6 +4077,9 @@ int set_anon_vma_name(unsigned long addr, unsigned long size,
>>     bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size);
>>   void accept_memory(phys_addr_t start, unsigned long size);
>> +int accept_hotplug_memory(phys_addr_t mem_range_start,
>> +              unsigned long mem_range_size);
>> +bool mm_lazy_accept_enabled(void);
>>     #else
>>   @@ -4090,6 +4093,14 @@ static inline void accept_memory(phys_addr_t start, unsigned long size)
>>   {
>>   }
>>   +static inline int accept_hotplug_memory(phys_addr_t mem_range_start,
>> +                    unsigned long mem_range_size)
>> +{
>> +    return 0;
>> +}
>> +
>> +static inline bool mm_lazy_accept_enabled(void) { return false; }
>> +
>>   #endif
>>     static inline bool pfn_is_unaccepted_memory(unsigned long pfn)
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 74318c787715..bf8086682b66 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -1581,6 +1581,13 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>>       if (!strcmp(res->name, "System RAM"))
>>           firmware_map_add_hotplug(start, start + size, "System RAM");
>>   +    ret = accept_hotplug_memory(start, size);
> 
> What makes this special that we have to have "hotplug_memory" as part of the name?
> 
> Staring at the helper itself, there isn't anything really hotplug specific happening in there except extending the bitmap, maybe?
> 

Right, we are extending the original bitmap and initializing a structure
to track state as well. I added the hotplug_memory keyword without
much thought, since I didn't see anyone else attempting to extend these
structures.

That said, I agree the name is awkward. I could either come up with
something different, or we could eliminate the parent function
entirely and call extend_unaccepted_bitmap() + accept_memory() directly
from add_memory_resource(). Similarly, we could do the same to
s/unaccept_hotplug_memory/unaccept_memory too.

Thanks,
--Pratik


