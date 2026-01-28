Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68D42D46C0B
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 22:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 812866B0005; Wed, 28 Jan 2026 17:25:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DCD76B0089; Wed, 28 Jan 2026 17:25:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BEA26B008A; Wed, 28 Jan 2026 17:25:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5B51D6B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 17:25:39 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ED40413BB36
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 22:25:38 +0000 (UTC)
X-FDA: 84382805556.16.8ACAB6C
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010046.outbound.protection.outlook.com [52.101.56.46])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2FBD340007
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 22:25:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=yLUbUF5U;
	spf=pass (imf17.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.56.46 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769639136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vnIal0IsWXx+NQl+1mOsZcc3kQDbvRefIg+Y2z+hcdQ=;
	b=vVX0R2wP3ay3Z9wZApRgkgygej3CxbqE3zGGYxqK59XGMsa+INo8muLkaTyLxBy3vtZvGu
	2LSXx22Ptz2zMy2kvrhSaLa1dPAeprgxtzjCcOtEi25RRsmAZ/Sn8+0KSgCKxADG3qdmkA
	21EHXjXtL6QoRqyPjWjgeAF25XCDHI8=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=yLUbUF5U;
	spf=pass (imf17.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.56.46 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769639136; a=rsa-sha256;
	cv=pass;
	b=SASx/OPFJblmIEO3ekKdWjejM+IMOdU3kyhzbv69m+So/BOjT1HDXgWSimlWmpmDRmCF8+
	fF/6wPWdabW3vqqP4nPhQV8hu+gmKgEGgVoiJU4AyJjFSutpmy+1tED/NWd2OJkbiJTIlr
	YsiAbErWYBr13HTefOBpkVqI0+R9Gpk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rpKJdE+pwzeogzzzCIwYvaPQjugFDbTAuQEOz5nSsQ4qboLifojOygRA/E5xb8e+heWeq3JY8eUQG0wAne+c8MqB2BCRJUzbrp+R6XTl8ul2+p0xK8pQN0e7s2vFerj6GTYsUbea8Io6RFuhkKmLvZtgMOsJAgUOR5KoJu6LAw3IapZqvHbG0VZwSfQYEcFIQVuu+Zf9Csu1osMEDvmLyQ+Kgr0z5wS6C+sAme6hwA7Qn6TRIOo9OBVbLe81mn9xlV7zj644UN5/PZkQARmoS2TOF/3FmkU+kkjI+1O6li5o52xAunBp0bq7XIxSbCM9XrU1XBecRwmGOJHLiucJgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vnIal0IsWXx+NQl+1mOsZcc3kQDbvRefIg+Y2z+hcdQ=;
 b=ULz/5ULSipVokBltqRf7CF+JAWyYsVKg6RZBs6qV4yaIGxBrby6pdNvZSnKrQO6fUp12GXOeJujKYJC7dORJQrWjaes2ExlXezhr/JqBW0E39i6RsL3zjyjSXc2ATMFwFnGF9yDu2NJd/+DofMIN5/ROzDMzp/Q40jih95Crc+RDXClGZlUzlZ137M6tBZkVDsoNXe6i2wnTFYSnRi8/qef3I0Q1RnyWcKbNvImWRsOwIv7fxZ5qFFF1UUUjUYbruMKkJnY4ddlOESdqEDx66L1+pm//cplxoPCxXYa7tXSEsjfh9ZiBH1luI5v+0ouAOIVfKfB2GCw7OJHFhB00qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vnIal0IsWXx+NQl+1mOsZcc3kQDbvRefIg+Y2z+hcdQ=;
 b=yLUbUF5U2KcUFb7O7oGvaowvMBlzDqXQ1cfscAoOVP5KmXeOKqZ+lvqnzKOi9CGu+ZbK1elUNEUnq6sa0ibXOW3fvMXhRtAbp1JyP6u4Xlr/QC+nWAafQeihqScI676vQVTXXhKkHOnRtxT1qdepAbOh0fmxPdSjFDRSsIRz3TM=
Received: from CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5)
 by IA1PR12MB6628.namprd12.prod.outlook.com (2603:10b6:208:3a0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 22:25:32 +0000
Received: from CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::222c:662:e585:3404]) by CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::222c:662:e585:3404%4]) with mapi id 15.20.9542.015; Wed, 28 Jan 2026
 22:25:32 +0000
Message-ID: <eaae739c-223f-43aa-9f08-fe0e7c2ec290@amd.com>
Date: Wed, 28 Jan 2026 16:25:29 -0600
User-Agent: Mozilla Thunderbird
From: "Pratik R. Sampat" <prsampat@amd.com>
Subject: Re: [PATCH v3 2/2] x86/sev: Add support to unaccept memory after
 hot-remove
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev, x86@kernel.org,
 linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, kas@kernel.org, ardb@kernel.org,
 david@kernel.org, osalvador@suse.de, thomas.lendacky@amd.com,
 michael.roth@amd.com
References: <20260128204105.508855-1-prsampat@amd.com>
 <20260128204105.508855-3-prsampat@amd.com>
 <20260128130800.40adb423627ff6d8ffce7ccd@linux-foundation.org>
Content-Language: en-US
In-Reply-To: <20260128130800.40adb423627ff6d8ffce7ccd@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P220CA0024.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::29) To CH3PR12MB8660.namprd12.prod.outlook.com
 (2603:10b6:610:177::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8660:EE_|IA1PR12MB6628:EE_
X-MS-Office365-Filtering-Correlation-Id: ed9303a3-a6ec-44d4-ba8d-08de5ebc2618
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VVVjUDM5QzZWWE1CeEd2alh1UkVMYXVWR2NJQXJENU5SZXMrUGdwR0crRWor?=
 =?utf-8?B?NFdoTUxKaWdNYTlGdzRjeGIrRm8rQWJEVEkyQm1aMVQ4YmhPaWdyWnVPYVhp?=
 =?utf-8?B?RWUxbXcrcUVwVk44SmJVTTJJb2R1enRBMzhIb3BWSHY4SXhCdHJkOWxtN0Rn?=
 =?utf-8?B?L1dWaUJpcjF0V05YNG4zVC9VbWtDczBDSU1icGE2K3RFQ1FGZk04Umd2WmV3?=
 =?utf-8?B?VS85T01sTTU1WDFWSktqblZUZXp6Ri9sNFBSR0MxOVk1TjZNK3NnVHgrOGFS?=
 =?utf-8?B?R0dkRFdmRmtnVUVhRVpCbVBDTjNxQ2FCblNQMFVDTkRmVERIbWRSRGVUeUM5?=
 =?utf-8?B?eDN2RktaM0JjVThOOUJGNGdqQmhNcEFxd1Fja1RyMjY4eEdGQURNR1VSSFcv?=
 =?utf-8?B?dXZFRkN0bUNPRDZEMm5RZ2dINnNrWU4vSTBkcE5BeXlHbjFaeStLL0Y5c0w4?=
 =?utf-8?B?TVU4ZU5SRnlUSUtiZnc0bWNTZzk3L2JZL3hGMnN3T3JhR0ZHK2pBZ2RkV0k0?=
 =?utf-8?B?am02QWUyWW94SVBHeWVpbzJjZEFib213bDBTeDJFSUthVDVwY3FzRVozQ04y?=
 =?utf-8?B?U0hObnRlVCs2TjlQV05Ld1JraEZQV05ldGdOd3hybkdueHBUU284U0llSTE3?=
 =?utf-8?B?OFhPRGZHeEdPb0NTdVJLWW5nZVRUUDMyUk0xbGVzSFc2TERjK0pYZ3h1Nm5m?=
 =?utf-8?B?ZXI5SzF2RWNvbGkvZW1DU1lkRmpHZEZQOEFUNm9MeHQwcFI3V21QelZoZXVO?=
 =?utf-8?B?TUdkZ0RjYkNVeUNDa2hYaTFEcklDRnZDNkpJRVR1QUQxc1NYVTYrNHNNbzJZ?=
 =?utf-8?B?bjJrWkhTdDk0UE1RTSthaFp1RGpSVGlxaW5tWEdYMlp0cXFEeTM3MnJTY1FF?=
 =?utf-8?B?Mm1vclhzMm1VY0o5QVFVQlVZYUs4MTd5OXE4bmUwcUtBUlFkZXMxTUU1NENL?=
 =?utf-8?B?VCsva0pydkY1MGdQeVdtVTRoWi9SUlNha0hOZEhtdHJzS0J1am9MQy9IYUk3?=
 =?utf-8?B?aGZ5STNSNERxSE45TWlKTEpncm0rK3lQNFBuNkMxbDFqNVdUTzJtTzZPaGVm?=
 =?utf-8?B?QXBHZmJ1M3pXYmJ1bUVubHh6RlVIazY0OWlwL3luNDMwcW1FOExSMkhEMDRp?=
 =?utf-8?B?K2hHYXBBSzNhZDlBYk43Z2QrUEVRdnhabVhjY0I4cFRYRDlnejYwSnZwOHFJ?=
 =?utf-8?B?OG14SjdBRm1BblhXSmFDVTRPVnBjTzNjbE9hbHpNYldLNVFmKzdNQVE0TU4r?=
 =?utf-8?B?a1g2TDREYUVjV3FiWktoNzFNTXkvTUJaQnZVNU8yeXRqOE1ybktoVDUzNmE1?=
 =?utf-8?B?YXR3WUhIOE0vSmI0aHB5eUM4M05mUHN1czZFcnF2d1pLSVZYZTA1MGJMK2tj?=
 =?utf-8?B?SlFwTTlVNGtPNVNWR3BMdVgxbkp2SHZURGgzMWpWOUFQN1Q1RVNCNDVQY0l1?=
 =?utf-8?B?WWR4anRWR0ZGVStIK01rRlFRdDc3WEh4MDE2TnFQM3RCY2w3ZnpWWW1jNzl4?=
 =?utf-8?B?Zm93SzFkOWF6MW52RmZsT09iM0lJRHZ2M2puRFFIN0VoVlFrUkduUFRCcUN0?=
 =?utf-8?B?UEx0aTFobytQcGxlWWszeXFjQVNoRmQvWDBWTEppbytTamFHbHR5TUpxeEFh?=
 =?utf-8?B?ek5Mc3NndElmL3NSQkYvNUx6Z2lhd1ZZdm05b0RNOTl1V25kVVJJbDJza2dm?=
 =?utf-8?B?dHljQ2pZcW52aWU1Y2tzMVBjQUFnNmNneDJENnVJZ05vU0RqSWNrYUg0eE9r?=
 =?utf-8?B?OE1QbDJTcW9HdGVoQm5GMEJneThsMzdVcStSY0NXZmp1V0tZQkFocHcwL2ZT?=
 =?utf-8?B?akxvanlzU1pEYkJnd0xIbFZFdmJWSnpKK0FkL0Q4UG1qdEgrbXY4enk1U0FQ?=
 =?utf-8?B?dVRwOHVPRGFQZTQ2WEoxUnJFRHhzNHVXbXBPeWNoZWx6UnRBTUZ6aGlzZ0FB?=
 =?utf-8?B?bDNvMXcvT2VINEZnZ1pranBlby8zby82TnEzdDJMZ2IvTUpZaXVMdjdNak1N?=
 =?utf-8?B?QUQ2NEIyanRGcDFJVnBmb0xrbVduWGRQK0ErRnR5QjFLKzA5UGxaTDF6dStR?=
 =?utf-8?B?bGhMVDhLTGZ5UFhqdGYzanRWeE01ZUY3YXhQUE5OdmswNU4wUTQ1Kzd5bWVX?=
 =?utf-8?Q?1ZBM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8660.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WHB3SHg1cjA2K1p1ZGZEdUhCZmNzcnl5L0g4c3VUbEVTaVZqdXFVWW0vMkhW?=
 =?utf-8?B?M0NyenVjMDdJWVdaejJQL3dGK2NuaHpRUTlWT3l0LzhNTnR1R0pwTUxJSjlL?=
 =?utf-8?B?UEduUE5LNUZ3VkFuY0Q3ZStMUitha09NUFZaY25IamxEc1oyMXBsVXpmV3VM?=
 =?utf-8?B?MTFONG5KQnBYQTR0Z3hwZ1RkZFB4Mk00YTJQOGpDVVNxMUNFYTNzOWdEZmVl?=
 =?utf-8?B?SGRuejJ1d3h3QWpraEV0cWdnamJ3L1pFMkF5a05SMk1PeHI0bEJnUW56Wlpo?=
 =?utf-8?B?TVZ3S291Ym1xa3BvVkl0eXpYeGdWbHVoL0Zkdnh5bGZ4VWRTQkhabk4xaitT?=
 =?utf-8?B?S3hiaWl2VVVDMXRrNzhJaytiM0UzeDJDU2RwcHJpOG5TanZHVEtxaDdWd1F0?=
 =?utf-8?B?WGJzbEQ3eTJ5ajFWeDRuM0h1RlF3STRDdXRDYUtLRno1NG5mS01aaXhlTDFN?=
 =?utf-8?B?VXdCZ1lrazRQNXlNUFRXM1A1N2pNb2lGcGZPSk54V1ZhcEFwZ24rZjVLZjZt?=
 =?utf-8?B?QkpRbGlGcmZLQ1hEOHlWZkorRzgzclNubS82WkMzemtPWVF1LzQxbjdTb3do?=
 =?utf-8?B?cVR5eHZaZTF1THk3TjdTSGlUSU0ybVRzek9ZUmFydWU4NElvYkVTVFJuaVp0?=
 =?utf-8?B?UzNOMkw1UU9PczJNd3diaWlDZEJwNVhucTBXRlh4aE1CQS9yOUZnT05YUHJ1?=
 =?utf-8?B?M2ljNUt5MnUwWFNQNFdpaEw0L3JKSTNxc2tlaEt5UzFTWXFKODNXTXhmU3dY?=
 =?utf-8?B?SjVhU3diN2Q5VC8zZHJUWHBRajdUUWJJb2VmdXU0VjUwYnhKUWJLRERXekxn?=
 =?utf-8?B?d0VGVW5JOVBVemlQU2Ftc3dwQnlLNXBuZTFSREZtSHJQeStrVnQ1blBHdnJZ?=
 =?utf-8?B?T2kzOWhNbEVKS3V6M1NuV2pYenMrekVZRFAvdVlYTUZHZDB1d1ZJKyt0QVV3?=
 =?utf-8?B?MmtWMGdnUE9LWFh4OVgrMXRtOFBBK3J3eEpqUzI4OXpjQnpKSnRQbi9WVkRC?=
 =?utf-8?B?OThGa2tvSG04QzRlbVJZUnZlOERkeSsxMVRVc2xZWFUvbDJOU2pFa2k0blJz?=
 =?utf-8?B?Qkw4ckJsS1R5QlBiWlJ2RlQzTWtkeU11ckJveGcwMkRQRGl5YTlaVjhqNVBR?=
 =?utf-8?B?bUpGZ0QvQUV4UmJaOW9EUWVXeDMrcFVTTGlua3NKN1FsT3pUdkhWZVdncURF?=
 =?utf-8?B?SEk2TFZnZCtQRHpndTNPSU84VHRaY3hDbVlRMW1FeUZ3UTVvREZTQXM5b3Np?=
 =?utf-8?B?VkhXS3h6aWF0RmtURXgrSUt4TUM4QUFhOXZtbVhJa2pEZGh4ZEwwQWNaamRZ?=
 =?utf-8?B?aFIwYWFqSHEzUWxYWnFWN3BIMFdySW1MUldDbHFrbkNTQ1JHWHRhRFdvU1c1?=
 =?utf-8?B?QnRObW56T3h5N0JtMGszdXpDSjFhanR2VGFFOU5MRDNQalpCK1JvN3VtNjhH?=
 =?utf-8?B?SHBJbHJNMDEwSnJFcWFHckVtY0tpdEYzUFRSMmJjbW92WFZMQTJTTjB1Z0VR?=
 =?utf-8?B?L3V3WnUwQVRKbndBakZDbTVqOFNaazlUVkFhZ2tTNUZGc29MbU1lT1JNTnVW?=
 =?utf-8?B?OS9hVWJmZ0JTbDBpQ0VwUVNhR1c2OXZkVXpxMEx4L3pHbFN6Yk9JcUF2NUNO?=
 =?utf-8?B?OURFaW5yeDJBWm93WGdpRS96KzhFeC9UKzVvaXNLSjJQcHBOaE5LeUlJU1FT?=
 =?utf-8?B?NVM5R0pSa2lMSm40UDNMSUtRTTRLNHRZekJlSWJzaFg3bFpiQ05aaVVHQ1Mw?=
 =?utf-8?B?Qnc2TW1Samp5bWlZQ0JqeGlwNnRuMDV4R0ZhSThCOTlib1R6TStjbmtFYW1h?=
 =?utf-8?B?ZiswZXJsKzdKTEFHVmVRMmY4Ty9qMmlUUzBMcmg3TjQxY2NGcFgrSTVvSjND?=
 =?utf-8?B?RGVFVEJQWm1uVnVXUmNZb09kUVdHa1VWSFBYZmNNSDloV25QSW1XTVBMbGYz?=
 =?utf-8?B?SzkrcW5zS3R2QTJ4THBhUi9WVGI5WU5JQnYvNWxTZFl5QnVSZWhhT3l1THhV?=
 =?utf-8?B?MUxJODRabDVvZ3JEOU1MR1ZmUG1Na1pSTHNiUUpWcEhvTCtwQ3FVUFM1N0hE?=
 =?utf-8?B?SE83UFN6dlFYcW92aTFacFg3V0VwTmd0VXp4VU8xL1hxZVg1MDdpL01VNWRV?=
 =?utf-8?B?d0ZyVHBENGk4UE0yWm9nODBOL0JGVGlyRi92cDNCU29NK0EvVXhYeWg1ZDUy?=
 =?utf-8?B?VG1KOGRteWFiei80N2tGbFNCQVI2MXlJeTh4L01nclhyYWVtVlVobHZxZkZp?=
 =?utf-8?B?dlg3cUU5aUw5eHAzRElLc2srZFk2R2NTTzJKUTdhcENZZ3VvTU54YjRyQUpw?=
 =?utf-8?Q?WXdbNNni/l9xSFL+Qx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed9303a3-a6ec-44d4-ba8d-08de5ebc2618
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8660.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 22:25:32.0566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LP4qgKVak7I7eByhc6HOcOReDbC/0mXRI3GAPFJZCKShQNADjZTO84emuQJ05PVdhtwDWC9sL3WMnEQdzQcAGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6628
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2FBD340007
X-Stat-Signature: p1az1w43kfy5mh6wrktswregu4q8k8n1
X-Rspam-User: 
X-HE-Tag: 1769639136-885199
X-HE-Meta: U2FsdGVkX1+1oqQp4AQU7U/cOuLBfwgH8lr+vO+emi5mWDviICL59iT/6tXWtmNLJQnWr3x3LsOw5ZKaYXEoc07wGp5o+BFRWLCkU1zrksb/rB8BCB79Wo2vscfMa5PSPQtWF/g38uHrY8qsBpWudrhtnuybpJnvV3di+IMgaXrq4GpzNfuPPQhdtEeeLDNr2M/MWJ+p3rANymIRqdsbf3akhd7PNcBbZnCz8AzKnNlI8poBY1xI1tvG2pDUjCg0UpDmq99rx5erVNb++KwaIrsqF7MaJqRNqPcgYTb7+KmX2Qj4IxCJOMrYQ3rOrYhRIWFxnz4/EYMXHRCqXmZRBEjAzgQK6rk8hSUn/X49LPqgBADKm61SDd6WWu20sZAU1TkhilcOpazxPhPyH/fy5Dli+gmO283PVUdWf+i1QsaFSQrEduOYp2QVpy/yEf06PABF6lpuBYgLx6WYCH3SdZ5DTAtPF/wNHDAvvDAy+3NdNFfiZE8qJT33PxsUg0DRBbadDyNDP+eLKt4wicJ8a6qIIqmUUw29UgPyTfmFrHZwNh8Q2DdqhHjVEzzBJ5EA+THlq+ks5MrgjjgQEIiDRaCop8wSYnNce71UjQwNU7WBJKPkzP9Li3nP+vwJZE5LtCSjKv7j5lPIBCQmFHMo/tJerfPetTNTp5Ia9PyxJSqp6O9A9S2tgp5jeCv9gyrfgoERoT8WSdTczJVNmJcLs7QhAdI0QW5U9LXLUnVgi8vJYyWc09DgGRWQDw5GenklWkIMlbO6orwqq5CJz/PflQATLfeLNe7T5tbjbXMCrb0ya9y24j5yAYZOjolDdgsZfAJMGM+8zszQ59uEXwSSleBtmBG8Q1tyiQzdL2Jbk+LLyLbFsFeNuke6GY5/MPEUk7qaUSd50XIUnHOxltXGeov+xI98IgrcCUA+bzhYq+w0AZrsXGkx6sbgItUyT1NiwhlrUX42nz1unZIxkRW
 FDrs9MHs
 Ax79fPH1+E+x/uRaFnj6RlzGdh0tb4XWHy+s36C43S6JrXXbvS1///q5bSBkcqrtpCw6tTfejxlXKvJvhdh1J0hElvMJCP713qsZVrOUUyhFjTKs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Dave, Andrew

On 1/28/26 3:08 PM, Andrew Morton wrote:
> On Wed, 28 Jan 2026 14:41:05 -0600 "Pratik R. Sampat" <prsampat@amd.com> wrote:
> 
>> Transition memory to the shared state during a hot-remove operation so
>> that it can be re-used by the hypervisor. This also applies when memory
>> is intended to be hotplugged back in later, as those pages will need to
>> be re-accepted after crossing the trust boundary.
>>
>> ...
>>
>> @@ -623,6 +624,7 @@ static inline int snp_issue_svsm_attest_req(u64 call_id, struct svsm_call *call,
>>  	return -ENOTTY;
>>  }
>>  static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
>> +static inline void snp_unaccept_memory(phys_addr_t start, phys_addr_t end) { }
>>  static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
>>  static inline u64 sev_get_status(void) { return 0; }
>>  static inline void sev_show_status(void) { }
>> diff --git a/arch/x86/include/asm/unaccepted_memory.h b/arch/x86/include/asm/unaccepted_memory.h
>> index f5937e9866ac..8715be843e65 100644
>> --- a/arch/x86/include/asm/unaccepted_memory.h
>> +++ b/arch/x86/include/asm/unaccepted_memory.h
>> @@ -18,6 +18,15 @@ static inline void arch_accept_memory(phys_addr_t start, phys_addr_t end)
>>  	}
>>  }
>>  
>> +static inline void arch_unaccept_memory(phys_addr_t start, phys_addr_t end)
>> +{
>> +	if (cc_platform_has(CC_ATTR_GUEST_SEV_SNP)) {
>> +		snp_unaccept_memory(start, end);
>> +	} else {
>> +		panic("Cannot unaccept memory: unknown platform\n");
> 
> Seems severe.  Dropping a WARN() and continuing would be preferred.
> 
> What exactly happened here?  Am I correct in thinking that the check in
> snp_unaccept_memory() makes this a cant-happen?
> 

You're right, a WARN() is probably more appropriate here.

Based on my rudimentary understanding of TDX from Kiryl, TDX module is
what maintains this metadata for the HPA.

So, maybe the WARN could just be:
"Cannot unaccept memory: VMM responsible for unaccepting memory" for
TDX? Or, we could let it fall-through for TDX (if and when there is
support for that)

>> --- a/drivers/firmware/efi/unaccepted_memory.c
>> +++ b/drivers/firmware/efi/unaccepted_memory.c
>> @@ -157,6 +157,52 @@ void accept_memory(phys_addr_t start, unsigned long size)
>>  	spin_unlock_irqrestore(&unaccepted_memory_lock, flags);
>>  }
>>  
>> +void unaccept_memory(phys_addr_t start, unsigned long size)
>> +{
>> +	unsigned long range_start, range_end, bitrange_end;
>> +	struct efi_unaccepted_memory *unaccepted;
>> +	phys_addr_t end = start + size;
>> +	u64 unit_size, phys_base;
>> +	unsigned long flags;
>> +
>> +	unaccepted = efi_get_unaccepted_table();
>> +	if (!unaccepted)
>> +		return;
>> +
>> +	phys_base = unaccepted->phys_base;
>> +	unit_size = unaccepted->unit_size;
>> +
>> +	if (start < unaccepted->phys_base)
>> +		start = unaccepted->phys_base;
> 
> max()?
> 
>> +	if (end < unaccepted->phys_base)
>> +		return;
>> +
>> +	start -= phys_base;
>> +	end -= phys_base;
>> +
>> +	/* Make sure not to overrun the bitmap */
>> +	if (end > unaccepted->size * unit_size * BITS_PER_BYTE)
>> +		end = unaccepted->size * unit_size * BITS_PER_BYTE;
> 
> min()?
> 
> If you like min() and max().  Sometimes I find them annoying - need to mentally
> expand them to figure out what's going on.

Same! :-)
That is why I just aped the implementation from its counterpart
accept_memory() but can definitely do it this way and shave off a couple 
of lines.

Thanks,
--Pratik

> 
>> +	range_start = start / unit_size;
>> +	bitrange_end = DIV_ROUND_UP(end, unit_size);
>> +
>> +	/* Only unaccept memory that was previously accepted in the range */
>> +	spin_lock_irqsave(&unaccepted_memory_lock, flags);
>> +	for_each_clear_bitrange_from(range_start, range_end, unaccepted->bitmap,
>> +				     bitrange_end) {
>> +		unsigned long phys_start, phys_end;
>> +		unsigned long len = range_end - range_start;
>> +
>> +		phys_start = range_start * unit_size + phys_base;
>> +		phys_end = range_end * unit_size + phys_base;
>> +
>> +		arch_unaccept_memory(phys_start, phys_end);
>> +		bitmap_set(unaccepted->bitmap, range_start, len);
>> +	}
>> +	spin_unlock_irqrestore(&unaccepted_memory_lock, flags);
>> +}
> 


