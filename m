Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58623EA795F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 03:50:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FE7D6B0092; Wed,  4 Feb 2026 22:50:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A8A56B0093; Wed,  4 Feb 2026 22:50:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 869EA6B0096; Wed,  4 Feb 2026 22:50:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72BE16B0092
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 22:50:10 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 283E88B6F0
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:50:10 +0000 (UTC)
X-FDA: 84409024980.13.BADC869
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011003.outbound.protection.outlook.com [40.93.194.3])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2418E140004
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:50:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=m3ecdhPP;
	spf=pass (imf09.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 40.93.194.3 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770263407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OUz/5TzpnJljMSykwz3l06Nrmi4GdzByT7RobYsbT2M=;
	b=YGMBpv5yLD4vhQ3RkDoG4WHJdSDHYqYmW0S3eNXuDuuCXZFrjYezPS0E9yo6c/iEWs1d1+
	hZQxBG8OHWPLtk6MLvz++crp3x92uPV9M+6jnEEidJ5AGFfxb0WWMZbWwz3GwZkX3ZewFz
	xmk/gaSIhiB9ukiAlA3q/TFf6ZyVv4g=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=m3ecdhPP;
	spf=pass (imf09.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 40.93.194.3 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770263407; a=rsa-sha256;
	cv=pass;
	b=3hyS10eSDyMJ9F38aUz65MSml8EukRAhcBZvKpdpnLQSTm/Uiek83lY/RtK0fmaOuINFO0
	u6/Kk02eAvPsazItGA+EJGxtYj8ocXwlHty2cKa7kzJtL6r/XTSY3bfZ28Oym9MM6RTTfD
	xln4zPsgvKW7nOzfgQLBbClfW1OcSTw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bJtvs1CbShigO+/u60QvgWrKT2b0lT1J22VrfjVgHjSL7jhar3xmh/1X2ZQ5njip4zIydM5WqoBd+9CJglK0k1yRTVshoz4eJqCrYkHCqXQefuKiwDra4zyUjuAH6PcjENcS3HokhoqYQKeTCi56Nh7ZeJBgYY8Ffu9A5aXfuMFx8+pWU/kp6l/fgInB6gB+szLR8H6g+GG/LYHcvqjgp0ht1vYnw9hUPcQe/koC0D0g4cTnaEVRGwATUxYqDU2M+CHu3QPyQpapF89Pg+7kaDj5hZBqbKzKJJqfJJpyIdpXp1jxi35aWg3nCX1+4OSdh/pEIAaR+fxaMStkYqE3Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OUz/5TzpnJljMSykwz3l06Nrmi4GdzByT7RobYsbT2M=;
 b=ujqrngMNXfY6PZLExU2KigPqwDXZOYJtJbeUZmQLK7CyMjGB8UHD7BS88fyRMJe0ZnLuWIX/ljIamXwcS5rIpS3Asw7k3G3SO9Eb9fG/WxseV36Qsp3YeR4vKHOo9FoeXv5tGUDQt97LeXF1j5K2bRg3ybbv6610VWXzrKrOgs+yA8DRFfa1/kmqfEEU1bcf0F3YuMsqCpV92/ejgsGdMJBajY0WMhbf/8L64n9hQYZ17jgXybUb0NCypRgQWo+j3AEZxNCBcsrdSk0TkustyWtOkaqr8fhJjuJ4M59ncDAk1Gb09b83A36ezPF1cyRBPH1d8FN0zQpZQ/vm80FhEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUz/5TzpnJljMSykwz3l06Nrmi4GdzByT7RobYsbT2M=;
 b=m3ecdhPPXqFnUQsKFRoMC5LjY68ALN5/jcwCfuq7pbb03KnWIievsJnN2ndUCV7/kduONYnI43sZEnC87UjSkcJ1Oa+auuemNvLBSjgSsh1yrfv1nMv+MpzrU9ohKcpTJJOUVAzW7nlTmCrx1MaawgeJmJS+SVbz1kYRxzdIROY=
Received: from CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5)
 by SJ2PR12MB8977.namprd12.prod.outlook.com (2603:10b6:a03:539::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.14; Thu, 5 Feb
 2026 03:50:03 +0000
Received: from CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3]) by CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3%6]) with mapi id 15.20.9564.016; Thu, 5 Feb 2026
 03:50:03 +0000
Message-ID: <550c89ae-de6e-45f7-89a2-ccc815f8d5a2@amd.com>
Date: Wed, 4 Feb 2026 21:50:01 -0600
User-Agent: Mozilla Thunderbird
From: "Pratik R. Sampat" <prsampat@amd.com>
Subject: Re: [PATCH v4 1/2] mm/memory_hotplug: Add support to accept memory
 during hot-add
To: "David Hildenbrand (arm)" <david@kernel.org>,
 Kiryl Shutsemau <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev, x86@kernel.org,
 linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, ardb@kernel.org,
 akpm@linux-foundation.org, osalvador@suse.de, thomas.lendacky@amd.com,
 michael.roth@amd.com
References: <20260203174946.1198053-1-prsampat@amd.com>
 <20260203174946.1198053-2-prsampat@amd.com> <aYMjjyVVax5cml9B@thinkstation>
 <29b4dc97-bb01-42fd-8ccd-f4cb2886ccd3@kernel.org>
Content-Language: en-US
In-Reply-To: <29b4dc97-bb01-42fd-8ccd-f4cb2886ccd3@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:806:20::28) To CH3PR12MB8660.namprd12.prod.outlook.com
 (2603:10b6:610:177::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8660:EE_|SJ2PR12MB8977:EE_
X-MS-Office365-Filtering-Correlation-Id: d8b4abdb-bbdc-41f2-e857-08de6469a506
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ejI5NUV6Z0dXKzZvK1AzRk1MSGpGb0RFK1UxeWdMbDh5MEJCL1JTMTRTcUgy?=
 =?utf-8?B?a3lUWlZ3ZFJMajRhallKME5Xak05NnJ1UThpeksxMlJOOFVtZCtqTDQ0UE5h?=
 =?utf-8?B?MGZvd3ExaGx3M3FWUU9vZnBvY1gxZjMxVDhWWjBkcFlOYXNiOTBQeGpYcjNp?=
 =?utf-8?B?SWVuZzc3cE9uQlo5L3NLTURQQzMxdkx6Lzd1em5UMmEzOGVQQ3VVY1NMSmdT?=
 =?utf-8?B?NG16Qjl4Nk5RbkhvVG5mOExWVVRwQUxaQWZuZTlabTJRVlhoMkRDUEsySFVW?=
 =?utf-8?B?SGxjOHZpQ3NOdEdnZVZQNXpHSm9NUUlqRTNxN2pVWVVXeEx5YnFGUmFxSmxx?=
 =?utf-8?B?Qk1rZVQ3K1h6QmlVUDN5d3VJck5wZy9RSkZwc2szSVZwLzU4aEpDZVZBU3Ix?=
 =?utf-8?B?MHd3MVB6Sk9WY01uNG5mVE1uUllaRTZiSGRqYlFYWEtTUUVialNaSGFobWFo?=
 =?utf-8?B?Nld5L0NuTEdxS0VLSllZbTBJNW9FVndOTmpuSElTdkFPNnlFb3VSejI1WWdY?=
 =?utf-8?B?TlhIRFBUalh3WFQ5S2ZySXVlZWg5ZDUxV0J5SFVRekpndFVlL3hVZ3JHQnVi?=
 =?utf-8?B?SjNBQS9BL3FEWU83ZUliM1h3UVp0SThpRDZheTF1eDgxM28vVFU0SmJ2bUxZ?=
 =?utf-8?B?dDI3U2UxZWxPaWljTXkzdERWMXRWaS9SWFNFY0hmNGJteW04cW05QnhnOU9a?=
 =?utf-8?B?RGhWcU9Jb3YrTTJNeG9hTjB2STNvT1pvV0JxNzU4enVBT3VIUW5qcjJxM0xs?=
 =?utf-8?B?bDgvM1ZEM3Z5dGRCdTZ1VGFNbXF4aVJheUdGRUhSZGo1TlFWdWNBN0N3QTJy?=
 =?utf-8?B?Rk1SNW1Nd08zdllTR1NZdTMrQXBMRGFld0Y2cmJBUWFKOURrcWZyRStNMGF5?=
 =?utf-8?B?S3lDSUFNcmh4bGZNbHNHb3ZSYzZjNCtKYm14dHBTMStJT3ZpQjZiTWFuVm1v?=
 =?utf-8?B?RDhFWGp0ZGJ3YkVsRVB0bm1MYTY5dFdZZ3pPQWx6SlRuQ2ZDZG1maFd3YWlw?=
 =?utf-8?B?TTA4eWM4SnZaejRvSjBvaW9DNTd2V21vQmdiSFowODdkR3lKZGNGN0ZLcHo5?=
 =?utf-8?B?WkJxTUFqU3FLWU1wUU1naG5KeGhSUWZYWkZGYXNRY20vUlBEbGRKTW5lMGQx?=
 =?utf-8?B?dEc4cEoxUWk2RWtnRWl1R3hPRVNBWUorcnpCdmNpV1Rsdkg3emJoOG5qeDRC?=
 =?utf-8?B?NEp3ZDF2WFJmWDNIZ0NoVkxBUUpQYjNLMUJHZEZFS05pRTl5STU4RnJSYW0v?=
 =?utf-8?B?amVJQ0c5SzFWK083UVIyeFlPVlhXdGF4ZEphaWd1ZHBxTGNOY3k0STJEWFNo?=
 =?utf-8?B?T2kwRnRCZTJRR045T1ZGbFpRMnkwdFJpcE9NazBqWTdZeXBLdHRIY1hiK2Qr?=
 =?utf-8?B?czlUZUhIZGJpVThBMjBWalF5L2dqdlQ2bGhoWXc0K0xUTXdObDV6ci9WeXBz?=
 =?utf-8?B?QVM2cXhnay9yMHhmVXp3MEdDM1JMczhqMGpYWnZDdlVGUlBpY296R2lZUTNw?=
 =?utf-8?B?azQ3cjE1SUF6dTJlbm5tcCtFVXJudHo1QUlPb0w4SlhHYnhHc09TTCt3OExS?=
 =?utf-8?B?OWllaWhjakIxMzg4c2Z3ZGtlYzhRU0lFR01RcDR5eFgzaE9tRWVRSFVpQkhI?=
 =?utf-8?B?d2NValZiTzlLK09tMHNEVEtYY1N6U0NlNmhOMlh5TEwxRzBXM0lSTWU3UVd0?=
 =?utf-8?B?dnpRVW9YVUZvUDBEUzRLT1lEQW9COHF5VSsxeDFGb3VjUXc0SVlJYXBiakhz?=
 =?utf-8?B?VFFnTGFPMUNiMm5oTkNWQWpqMFVCRDJIT2l3RmFjUExiYm52bEpOWUNYVmt4?=
 =?utf-8?B?TXRYV2JuVjMrRXU0SFlwNFJZbEJXMmVaa3IxR2dHZHVOVTcxUks1VEF2WXJ2?=
 =?utf-8?B?cHUxSlc4M29UUVUrT2JkQzBMb2pLSVZwVmErT0huMVN0YmZYMWl0OHVLYVVH?=
 =?utf-8?B?ZnNMeDZDb2hqRGpWOGNYYjB3V2Z4elRhbnRMRWQvcWhXWWRiRzUrd0Z2cmtz?=
 =?utf-8?B?T1VlNkordGZUOFhBNWV3d0NwTndWMlp5OVMrQURIKzBYd0ZDc08vY1F3cWlU?=
 =?utf-8?B?Wks4UWtnTXRjMnBiWFRQc0hva3QrOVVDNGRtV0lTR0hmVHpsajU5Z2k4UVVL?=
 =?utf-8?Q?RG1I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8660.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RDVWellBeVE5TlB2cllPVUZIbmJGc2Y1NkFJM3lvUFA4SnVrMlNHdEM0NE5r?=
 =?utf-8?B?bzFUbXVGbGh0OW1YMFAxa0FvYUtGdEZCeElybjYvU3VORG5NMGtEbUJCR01E?=
 =?utf-8?B?WDh0ODFBTURGNjlSR21wS2hrU3hlWWRQMEFqa294WUt0d0VhaVZVcGs2YnU0?=
 =?utf-8?B?V3FzMGV3czhOSGd2b0lXZlRjTXFLZ2ZnUnFEWS8rcGY3WWN2cmhHQUZrUXAw?=
 =?utf-8?B?UU05KzhvdHhRY0RhcVk5L05UWDZQcFlkNlNZbXUrMEFEbDR6NHNxVk4vMXNr?=
 =?utf-8?B?ZkNJaENKVVZuZ3NUWVYwL1duZDM0d05xa2RpV0diT0NUTG56akNRZmpzMmhi?=
 =?utf-8?B?ZnFyUVJXaVY0OTh0KzVpS2MvbVdVQ0FBc0JJSnZ3U0didHZNK2VXc21qVjNr?=
 =?utf-8?B?Y0Z5djNYSnZGcDVLTGhuMUZiWWd3cXQrcjVhUWhzYjFHMW9SM1ZPQ3lRTjZm?=
 =?utf-8?B?QlUvVE9JOUd2d3h1bjViSE9DdjZBN3JiWm9CYVQ0ckRDQ1pncW9EL3l4c0xG?=
 =?utf-8?B?bFVkM01ROWJuZmM4a2dwaVVSWFJoYnhhS2hLY2NaTm5VOUJYWldCTEhXZHdo?=
 =?utf-8?B?YVFyRWV1enhkdFJkUUNvMjFDSG9qb2dWM2Uzanpta1lLb1FTSkVRVGJlbGFV?=
 =?utf-8?B?c2NOZ3hMbzcwbVNTRWMzWHMzVkVSWUx0SHBad1dZVUEwY3N3VjZvbU05Wk5z?=
 =?utf-8?B?Q1Z5VjlkSlBYcUZ5N3JhNW1WcDRPNi9qa0VCcU1INW9BUXo0aGFPN1FMTzdZ?=
 =?utf-8?B?NTNEWWo5RHJGUUN5RWJ5SzV3ZG4rTEpyaFRsdk9nYXEvWHYza3VxZDFqOThj?=
 =?utf-8?B?L2xSUTk3RTVHY3FvZytNSUVwTUJodXNMUGNxSWFuWGEwbXJIRmRpZ3o5N3hY?=
 =?utf-8?B?Zmx0Y1czZ3M5YndTMUhVQVhLcDl6TTBUNGJLc2pRTW05ZENiMVRoeTh2SkVS?=
 =?utf-8?B?YUNQNVBCbVErWW5lSmFQQW1FOHhaMkhUVGo5QkxtQi9pNXpWYVpZNzdXMVRK?=
 =?utf-8?B?SGhLcXd5ODRrdnRMelNyWVBsNGZSTXZpbFFzSnRUaEJSeW1hQVB2N21yemV2?=
 =?utf-8?B?dWdIcS9LUUMwMHRwL0VjMFFZMHlJQU1FdjZJUlpYNEkvM0pJazZabGtjTWZ6?=
 =?utf-8?B?WkhqSTFsL2kzUTNIODc0QUxHaWFkaU5UbjdMSVlFcDFtM0IzUDdPQTMyd1pk?=
 =?utf-8?B?cXl6VkozdDZwS0l6czJCNEtTc05ualBsbHBiVHFXZ1hWU2tkL0M1VUxxandC?=
 =?utf-8?B?cDRveDhrTjh1WUN6cFpMR29rakc4THdsdVp6c3ArdzBqQjVIV3c0RHJpbVBz?=
 =?utf-8?B?WmVCcjBMb0J4MUtCWlhFZThXMzdJaHkrZnpyWWFOYno2Rnh3UkZiMFp6VnE1?=
 =?utf-8?B?ekx3emFmaWtLMTRxbWM0NjJpOUcyMzNrc0lWMmVDMnpDOHhtOVVGb0JJajBI?=
 =?utf-8?B?dTJMVGFzRWZ4SFRLaW8rbXZGeisyK211Wm5TYVdiU01FV1VGVkJtNlVSLzdO?=
 =?utf-8?B?b3RJR2lVeGVrbmxLREJKZ003Vy9ZZG0xWjYvVmUycEYyYW8wNGprd0NKaXJ3?=
 =?utf-8?B?bHFpaHZhOUZwdXk0d2tTVm8zbVZzZXR0ZjBqNHJlclZMc0dBaFE2aGk2dU5W?=
 =?utf-8?B?a2hIT1lMQzZTZnptMWFSUG1NRlFKSTc5V0dEWW9WUGlhYldJZkMxL3lhTXho?=
 =?utf-8?B?M3dJM3p2ZUZlN1NYNXpPcEd6eEtWbHFWdWlTRnRNTjljZFhMTnFzL2lXZG1z?=
 =?utf-8?B?Um9xZDhaNERRVk9sR0dOZWNuWW5DbFI2TnBxK0pBWkNNY09aTktTVzFIYU1T?=
 =?utf-8?B?c2ZZVGtJOWxhUlUrUkd6cnc1MkNSQlNneGFUY2dsVCtCZUxMV1cwV2dNZk9p?=
 =?utf-8?B?VlNsbU82Q1VKQzV1N0UvdDBTYWM3Q3RLd1FNRVdDRkNqamdxaU55bktqWTVI?=
 =?utf-8?B?My8rWUt6VENSMzR2RmowZlkyWXRBSjhoM01LbnZLaGxCKy9Fc3JzcVozK1di?=
 =?utf-8?B?a3BrRys2cEgrTGdNYUo1OVJaUTBCTUpYTFg3T1BxSmg2RTlrRXN2cTRNbmNw?=
 =?utf-8?B?Z1ZMUEI4bHZ2RWhOQzJpVC9DTDNrcW14TERWbC96bEtCcjJBN25sVGN0YTRE?=
 =?utf-8?B?bTZ0RmNXeTBIRE9IaXAzQ1p4M0hhb3RNaWpjQ28yTk1qcll2dnphNjB0SGJN?=
 =?utf-8?B?WVo1Z0t4KzJPNE8wVHJEQ1k2bFVFdk54a2UwdXFsWXNtbmI2RGNycVA1cDFF?=
 =?utf-8?B?WHA1VnVvMVRrK0lHYUVJTXF1R2FyVm1OVWZlL3lHL0xXMk9wMTJ1NkwzMzI5?=
 =?utf-8?Q?vfF4LttvzxFZHOUPQT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8b4abdb-bbdc-41f2-e857-08de6469a506
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8660.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 03:50:03.7811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yLEsfqacoLtm9nj2OftaGXmduR85Kid2090+tXZJLuP97qjMEAuaQIyTx9h6/C6cBGLRkRDvcMU6nXFibaYyFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8977
X-Rspam-User: 
X-Rspamd-Queue-Id: 2418E140004
X-Rspamd-Server: rspam07
X-Stat-Signature: 5kcd7h54w9faz7qhphmjfrjz1n7do43m
X-HE-Tag: 1770263406-374004
X-HE-Meta: U2FsdGVkX19Zz8w5eRzw2W8b8eSen1VOQmaGafdOJsC9/HIO8DjU/Fl6/keEmZlBvLa9WqdvrpV56Re2U7mTcHEnMnzC19MAhu+FEEIjdEoIlyL3RG+CuOAh8lxEtBXKNNBjCocc562ph/i/RiEWtvF4KfYI71yeioW1nMHwoImK0crKAu/gKm4HTx3IDSsZkggOjBBK02zQVQxvKfUvYjJKSYg5snqnp6c0qW5xYYd8sW9XTjQwBRe78Xf9jZz+3FOKdllHF4VgwSRUaKM1EXFnA+8o9xMp2Q0J3ah2+swBcnbDibr3EtjRx75e7xMb/RMFy2nmDN8Jz5vkYcOIsbRm7v4y8obItPN4S5mUKDasDBIclukVm1QCXkLDoLeFnxy/suLyyqTW5HNOz8uY+bowvubz8FXApsT07JCtrLXzCmRtOq6i/BSa/zHFDEPAnP3uLIV87LQpRQucoIi8+IPgNQZY61EaL7Hgv4mPnbA7wkXDojrIRaVkWfQp8WI6Gb/OeCGx/qWE+GoVlUabRoi2wFxx6upXtCT0aYDdJ8tu+WzW/zlFYQcfFevufihG3P89kOJZjJO0pTCHgNEL9DXwI3VIsHRFjC2NywGlw6txbGkp9eS6nbo/yGsFWHhXSpxvtnHY+ytxfjmNtM6dPnY8xyY4wrnGmAxI+i1iwIbYiiO3Kl4U6Af+9DEC8s4m7HRnNeJYTLfyyE2aG2fK1t22r4CN+QnZbsnNF3+to9DD2hmEwY1bWORjnSUcDA+18L6sze3LJACqbyLojNIYv3f6Wab0j4YURdliTQVJO7ImOYdXUJlg6QM+qkBt6jbqwfNMjYZXQLeq+0SjzrpAlPztGh7e6/H4J6awno1v+OJwZ6g46rvo5ETJ+pnMjuH86iSPVMhUmus1+2ooRNCHcKdVJArl5Q+R10v6dA3OQokgGAkJXMcex3PMSNWjfEm7ngYn32l8TlxWB10v7M8
 PdQcPouU
 cTgTLZ5duYgWGK9aQu9dPChvqA4N8fxqb594nd+VgbaF4y8DoO9FugZAWuGCSW8eHsOPbZFpBDIbWZpxDzfJdHEwWCir/adQPYkFtI4Z+kDpLk6EJP1c89c+0DrRwd4bDq1wJBmVmgHx556Rlt1EewFYSTYPPNuNH1P9818ZH44i/5LUE8v8XBKh84QZsKs1TPLeqLVVg1nPcrFEYuKjSJrBH7yvX8ph9TnDkzhBqUAKQ0y/YNpc5ZOOhBms+UesCf3ypR/mtMfAtc4Paa2cYmo1M1qsSkywDlH5ZMOUHCrklWi1RYgBbG06RbODVVQ+AM+riJLROyG2msycibpQVZbj4G//uYctuZ6y2YO1s9pqYSDt27bN+jKh/nQPAGJmMFdX/kK9racQvLouZRu5sRRrzPRzUinz3UiJj3/tSIpy/yZKDHEB6zq5mOsg6sfxkydUTcpyvhlmnXTfh9dKEMEOcdR3IKwOAHKLGoKQ7zURv4bV/Yf3d6/KhL2H1QIx/VhjHI9UTwaSsN/HKlafu3otdmSZKWhx9QVjzjDMrtlH7tXNENVc4QowfVSR34Kw4f2JMmekUs/48iXCrykXkh0KQ8zH+gBWGFWlKe5ENniiKjU8H5rt8qlAUHhIhSC84YDkUQXFMXpdqy3wk4I/zVdaSGw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/4/26 1:59 PM, David Hildenbrand (arm) wrote:
> On 2/4/26 12:22, Kiryl Shutsemau wrote:
>> On Tue, Feb 03, 2026 at 11:49:45AM -0600, Pratik R. Sampat wrote:
>>> Confidential computing guests require memory to be accepted before use.
>>> The unaccepted memory bitmap maintained by firmware does not track
>>> most hotplugged memory ranges apart from system memory annotated to be
>>> cold plugged at boot.
>>>
>>> Explicitly validate and transition the newly added memory to a private
>>> state, making it usable by the guest.
>>>
>>> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
>>> ---
>>>   drivers/firmware/efi/unaccepted_memory.c | 47 ++++++++++++++++++++++++
>>>   include/linux/mm.h                       |  5 +++
>>>   mm/memory_hotplug.c                      |  2 +
>>>   3 files changed, 54 insertions(+)
>>>
>>> diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
>>> index c2c067eff634..359779133cb4 100644
>>> --- a/drivers/firmware/efi/unaccepted_memory.c
>>> +++ b/drivers/firmware/efi/unaccepted_memory.c
>>> @@ -209,6 +209,53 @@ bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size)
>>>       return ret;
>>>   }
>>>   +/*
>>> + * Unaccepted memory bitmap only covers initial boot memory and not the
>>> + * hotpluggable range that is part of SRAT parsing. However, some initial memory
>>> + * with the attribute EFI_MEMORY_HOT_PLUGGABLE can indicate boot time memory
>>> + * that can be hot-removed. Hence post acceptance, only for that range update
>>> + * the unaccepted bitmap to reflect this change.
>>> + */
>>> +void accept_hotplug_memory(phys_addr_t start, unsigned long size)
>>> +{
>>> +    struct efi_unaccepted_memory *unaccepted;
>>> +    unsigned long range_start, range_len;
>>> +    phys_addr_t end = start + size;
>>> +    u64 phys_base, unit_size;
>>> +    unsigned long flags;
>>> +
>>> +    unaccepted = efi_get_unaccepted_table();
>>> +    if (!unaccepted)
>>> +        return;
>>
>> This can be tricky.
>>
>> If we boot a VM with <4GiB of memory and all of it is pre-accepted by
>> BIOS, the table will not be allocated.
>>
>> But it doesn't mean that hotplugged memory above should not be accepted.
>>
>> I don't think there is a way to detect such cases.
>>
>> Your check is probably the best we can do, but it means VMs are going to
>> crash if memory accept is required by no table.
>>
>> This is ugly situation.

Agreed. Breaking hotplug for VMs under 4G is absolutely not the way to go.

Would it be worse if we call arch_accept_memory() if the table doesn't exist?
The table is primarily to operate on the bitmap's entry. We could wrap these
accept calls within an arch check for TDX and SNP guest if the unaccepted table
is NULL. Or, less preferably convert the panic() of the existing
arch_[accept/unaccept]_memory() to a WARN() instead.

> 
> It's all starting to feel .... very hacky, sorry to say.
> 
> This should all be easier. If we expect memory hotplug (SRAT), why can't we just allocate the bitmap properly?
> 

The unaccepted bitmap allocation happens a lot earlier than SRAT parsing. So to
get the right range, either we have to duplicate some of that parsing logic
earlier, or, replace the memblock allocated bitmap later. The first one is a
bit more hacky, but the second one would require us to the change the original
unaccepted struct from a flexible array to a pointer which might break kexec.

Neither of the approaches seem less intrusive than the other unfortunately.

--Pratik


