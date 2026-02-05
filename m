Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E332AECD9AA
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 22:06:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DF8D6B008A; Thu,  5 Feb 2026 17:06:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 263186B0092; Thu,  5 Feb 2026 17:06:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11A906B0093; Thu,  5 Feb 2026 17:06:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED95C6B008A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 17:06:49 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8E43513B8ED
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 22:06:49 +0000 (UTC)
X-FDA: 84411788538.16.AA4360C
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010022.outbound.protection.outlook.com [52.101.201.22])
	by imf22.hostedemail.com (Postfix) with ESMTP id 88975C000D
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 22:06:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NwH4p8Bv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.201.22 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770329206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fLchTlDvsNB2KxYwhyJr/GmjmzwtR8nj0dC77Oot/V4=;
	b=J7L+WqHJQqOL0mtSFNSJhUX7+ITHiL52rm4wSm+rvoAKs3QLTmaz8Jxh2LAAq8IYlbjaBf
	aBtRDji3XrUW9ML50noIbhx92lRze7iBAOdiZ2lUTxT6Y96oyQDfWIfF6dGptgRfnQylb1
	dYXoOOmNT6B1An63Gso4D3yoelGBPMc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770329206; a=rsa-sha256;
	cv=pass;
	b=ldg624H/BTD2PNgiEWE3XKAbiuVRpaxBCN25nOJuPD2RWZShEAqe8qPn3WX7719VO2WkhZ
	68jcREU6qPittwmv3ZL65IE5mzN+XD4xsK93hhSEj9AKpGeM+mWix95xTA23fdb31rOWEi
	gDvLXcEed6ptYT6l0AdigpUmSVGbeVc=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NwH4p8Bv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.201.22 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g0zd4kQWr7mXdkT5kgNVOGhpONQrG/sQqMfNNgWA7zF4xV5jdgRFZ+q3vI/IQajDevjy7Te9nqeB/zM/VZAYmPFRrzo+EytoFyjWREyuKv9SgeglVihFHaHo0JwmobsBfGK5ZGsOldTcRQgQsIPlPTLV5g5EAKNUjPNYydT2QMwi0GYenQHWd1J/buTB/zsabNpThikTU4jYcqYJZ9pMRxjAZJpIiahKYzUb5/DGDd8jx1AMIjlzJKIUKuD2vFAAczl7C6DgbAnsri1uo5DLPcmvHx5dixNPEvOhJAQU98DMgpvqPEJkOld/BJoimRVmtUNJ1D3bYABAg+DAKxPbrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fLchTlDvsNB2KxYwhyJr/GmjmzwtR8nj0dC77Oot/V4=;
 b=xT0bdrzIGsYfHdX+VF2ZKj4CJAKGxWEST3IISoSAAa0Pg/x4/3PnVDw8Io6m0CuNwFgVtnZF45+IUjT5X1Fd9PMKnfM6BGBu+tBGPJtOgxal+O8PHhCz/+lw049mMO9CYPLy1Hzk7hQKEctHY1cNjsb3Kkv78v97cXclgIuMtUD7nRh14R65IH+8HrgpUVomujR2W7gMFa9to94vJ2CS2JEa/TseAlK4l8OEnaq1vw6NmJzxE8sB1vi1QzewMkKAt2UEmAIu9vJxz5C7TuN1WOc8DwTJIi33kGtsoGSstyiLAdYxxq6v2Q5As7NntExZ7BFryDA84Zf3Ef5x41AjTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fLchTlDvsNB2KxYwhyJr/GmjmzwtR8nj0dC77Oot/V4=;
 b=NwH4p8Bv95e0DnNIRE+uc1wAj4Xfmdw7LsxTnLPxVAvDPKZg468++ip+VLC9nqtA99gXZQDNWK8Z1BFI/4VVLBVSaCr/3nI8Nvuc18EWp0XWh2yCi/LZFM4DW1NRIGVNX2WEmrMOxjJ6cDMXzBLbjEEFuMdyE0U9W4n30plP1VDYfY5pPBwSeT9zxj9aWLjfJ5xcfmkSRVP6UXFPuu/t1z7JKK8ElOu0OojgtgWl9s4bBf1stGG2S8ik0Ume5+m60670bb9dzq+d8Wh1XImCqqq2L7yROCpqmmmZP3xbGkir9TyYQ3bMZZIwR8r2mMEPv+TTIapFnlwDWgTku9wr/Q==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 IA0PR12MB8206.namprd12.prod.outlook.com (2603:10b6:208:403::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.14; Thu, 5 Feb
 2026 22:06:39 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%7]) with mapi id 15.20.9587.013; Thu, 5 Feb 2026
 22:06:39 +0000
Message-ID: <301725ba-330e-4aa4-822f-9ce2fef17b5c@nvidia.com>
Date: Thu, 5 Feb 2026 14:05:49 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] possible deadlock in gup_fast_fallback (2)
To: syzbot <syzbot+c8461425abb63bfd3445@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, david@kernel.org, jgg@ziepe.ca,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterx@redhat.com,
 syzkaller-bugs@googlegroups.com
References: <69850f41.a00a0220.34fa92.001d.GAE@google.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <69850f41.a00a0220.34fa92.001d.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0013.namprd04.prod.outlook.com
 (2603:10b6:a03:217::18) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|IA0PR12MB8206:EE_
X-MS-Office365-Filtering-Correlation-Id: ad347e12-f279-4ce7-32ee-08de6502d622
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|10070799003|1800799024|7053199007|7142099003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cS9xOVpDU2YrNkdha2gxK3J3M1AvY3B4VGpHZitwMUVPME8zNlNEdWd5d3RG?=
 =?utf-8?B?SDZ2SDVoMmMrSUp1VmNPTThrNnV0d2FyUW9JazFpcWtKdXRIREpmNXlWYXU2?=
 =?utf-8?B?SFFHc2pOdmRuRTQ0ZEFBQzFLcTRvbGMxZG0reW5wL2NyU2dhNGxlTUNPa1BC?=
 =?utf-8?B?Y3pJTzhCVmZJaHRhZ3UxS2tkMFhoR2pCSmhzWG1zcjMxQjBXZVdXVFl5d3BX?=
 =?utf-8?B?Skwwbk92Rjc3Yisva2lWeTUxclkwcjF6R3hIT0hveVR5STBEbWkyelBIeHQv?=
 =?utf-8?B?M0YwZ042U25XZEpmUkFWcUtnZGJteFRVOHg3Y05INVVWUU5hVVNCTTg2bzFI?=
 =?utf-8?B?NkovWjZNM3FVL2pUUGU4Zng5RXJIeUFnbzJUbkthSE5UblFmazVXY0FRYjY0?=
 =?utf-8?B?dWc5M1htaERRVlRCdG16WjFrZGtENmMxeWNZbzBMZVdyQ3lEM0s1M0FZVWN0?=
 =?utf-8?B?UkcvNk95aHpHRkNpN3V4OWkwRTNrSlhZWWpFWTJpWGRxbDN1bnlPL3ZLUkcw?=
 =?utf-8?B?a1NuWWtvaUJ5dlJiSXkrLzZlcDhUamlzbTE2RUVjK3h4bG1BREJiVDZuclZr?=
 =?utf-8?B?WDc4amxBelRhbnZEbStaQzJNNU9KdHprSnNQSnU5YVRLWEZ5Vmh2MURrMkg4?=
 =?utf-8?B?eENsTlRvR21DT1FsVUE5SVhEMkJZVExRZHN1NXdsb3lPKyswUFR6dDI4dzlS?=
 =?utf-8?B?YTlISUJEVXdEb2lYazBWR1hISWdybUtGMkhWUVROR2tZSVRZZE1FQkQ0ZVI1?=
 =?utf-8?B?NXJjY2c4VkR2aEJkM1hnM1RqTEVMVWFMU3pZMWJvdUk3eVYyZG4vZTIvT2sy?=
 =?utf-8?B?d3o3TUcvZVJHbG13Tm9xMC9SdFM0V0FOTVYzdVcvZ1UwSlZiUVk0TXVWQ3B2?=
 =?utf-8?B?RWxVQjlUSFBzaTRSb2ZWUFY5aDRhRkttR0tON1BNaE1vVm5SMnIvbDU1Nk5R?=
 =?utf-8?B?THF1NUtZbXBmOU5FeXJGanhtYnIrQWRQSmQyenJoeXZTRzVtSkV3Sm9aZWpy?=
 =?utf-8?B?U3VxaUJJVGlreVNSeGFOVGNjT1B0YWVxa090SmMwUlJRY1JYcE5PeEN4NUlk?=
 =?utf-8?B?M0xTNkFnYmVaN3U1K0twMXVIbDcvQXQza0Q3Yy92MXZ6WGI5VmVJTEpJZHVU?=
 =?utf-8?B?S2lldzk5WmpwdE5jcmplZ0hGbFU2aUVhVndtMGpLU2oxWkZOcDI5VDIzOGUz?=
 =?utf-8?B?d3gzSzJ5VGpFUzZtbDkveW5zVGNJNjUwdzNkRUNFczAzWlRMeTdRU3pTZlpE?=
 =?utf-8?B?MHgvOWoyZW5Fb0NTODRlS3hicDhGNmhJT0tNWWhZVGFCQ0dSMFZkSGIxYTh4?=
 =?utf-8?B?VldhbFJId3BLbS83QjRlYzFVWTY5TlNjK2JsdElkOVptR1RsNUxXSHhkM1F0?=
 =?utf-8?B?d01tbUdUSlNUQmRBVkhBVnRpZk5kdEhoZVNlVUQ1RkpYdHNycmlvWVFkcThW?=
 =?utf-8?B?WkdiLzF6Y2dFSXZMeE1XWXVySStFUXRxenFoT0l0cHFuSHRkZlM0WHgvY3Bv?=
 =?utf-8?B?N2ZmNXlNTFJBQ2R2d0tzcXNUUFlnZFlKMGNOU0lxYTZGRk1rVmlkRGxJQnRi?=
 =?utf-8?B?T3NYVXhXVWxHODIraHJKRDNOdkozYUVheThISnRxWW5NbkRIZ2RUTVNueG5w?=
 =?utf-8?B?VEJWM2IrUlVsL1ZNZkhrb3ZKUElsVlI2VkNqaWkvOWtXQStHK29rYlhLYlo0?=
 =?utf-8?B?bWkwNXNrVVFuNStVTWdwb05Bd04xR29jRENtd3FFKzJKU3ZHWnUvUFcrbFNn?=
 =?utf-8?B?c1pOSVF3UTg5UE1QTFZxN2pvYUFGUWFjVzVubkdvZXhtRGhySlpCT1NFakly?=
 =?utf-8?B?eFYxd0ZFWUE3V3IrS0p5d1hSOGloYTR2NkhQeGNlR2pIaktWeExDZzJPUllO?=
 =?utf-8?B?ZExxeTREMlNZTFkzZElLNm11SFR6YVU0Wm14Z0dBTUtRL0dibUJBL0twVHBQ?=
 =?utf-8?B?YmV6UDUvcUNibjhrdkd4SFNxM0wzYVZHdzR2L0hXbisyU1M0dm5uWjE0eFdP?=
 =?utf-8?B?dVliVkRFdDVXSGIrUWxSako3K3lydlRROEliS01NcU5keDhLRURvUDdvcE1X?=
 =?utf-8?B?cm00TUJOQmFaaGRSNG9maUlTZFYrRkd6RjZmVHhKSW0xY0tiTXRBVlArT2ta?=
 =?utf-8?Q?PMsY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024)(7053199007)(7142099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZThFQ2dRUmRBcEFQNVBPTjloM1hRbnd6alFHMTN2SnMzQVB2NUFDSy9NYkRI?=
 =?utf-8?B?RHVjc0hzaUdJVGlsemFSNkpsSjlCaG1TcVlWaWhzckZBZTdBTm80NGxoZ0JC?=
 =?utf-8?B?VUJ2dFJ5d2hMdFFNVWI2UGpSYy9BcHg3aFR4bWppTjZ6S0RKZStsZ1YyVkx5?=
 =?utf-8?B?RHp0ZDF3VVdhbWFVZ1FYdU1xOGRsdDRtbkhhRVRPQjBhSzBhYjBoOXRkODdY?=
 =?utf-8?B?Z2czUFBJOU0yZGhZVEoybjVNWGs5SVBiYmpMNzBYbzA5UkpEcVJFcFNhMmtH?=
 =?utf-8?B?REFuNTB1K2NHajhoWTQvR2FCRWwvTHByZVpia1paeDRYaFNwM3RlYmFPM3gv?=
 =?utf-8?B?eTB4TERsUm54UXVpOTdPSW02aEYvVTcybnlyWWpMdERVQWlUb1IwaGM1dUtu?=
 =?utf-8?B?cU42YnRuUkVkaU4wUGZmSk4xU3ZtcFhUM3B3RERRdU1lbEp4K2NQbjd0S2pv?=
 =?utf-8?B?SHFQSlE3Zk1GS3lLUThicFpyQS9zMGhqVEkrbENJVncvSTNTZDZ3dC9pbDEw?=
 =?utf-8?B?TGFoV0IxbDc3OVBTRkVNSWVsN1lqbFNabm93YWMwUlpKbDNaZ24rNDVnaFI2?=
 =?utf-8?B?NTBURHdiaW40S3pYUWxoeGhyNWlxb3lBMUZxM0RZTjlaaUVuQTV5QjJpS2pp?=
 =?utf-8?B?d2ZiWGFVSVNDYTlWd25qcUlSc0lSUVV3OUhUYWNmMS9jQUNNcWVpMHZqbnpE?=
 =?utf-8?B?UnVwNFVTZ1V3VFAyZmhVejNHdm9vdXk3Y2FNQndVenhWOXZjeEtTbWZFUFU4?=
 =?utf-8?B?R2s2MGxUc0tqZVJmVFpTYTNhOW1IcDArVmhIYTNLVkpOVUh6aU1MVVc0Qy9B?=
 =?utf-8?B?OTRlQ0hkUUdWUE02WlJBcHp1TWZsMUJnSjgzYXhCZTNheU96Ukd0VmtLeE5y?=
 =?utf-8?B?enpWL3RoWWFYamppM2h4aVJBLy9PYjg0bUVKOVc3SStZSzZGUzk3aWpSNXRT?=
 =?utf-8?B?ZkFmR093Z2NGWEx5S2k2RGtGbjNuR2VBWGVKT1FHTjlJK2s4L1ViV3RCeU43?=
 =?utf-8?B?ZDY3SkpRbExPVEdFcXZQT1dVQnJZMnczdFVpS3pSdDlwdldleHpqSFlWUFpE?=
 =?utf-8?B?UUZtVVNZZVIwcjEwRFZqUkpDNHBKYTdYYU9ORkF5UEh5eHpiM1I3R2t1anRr?=
 =?utf-8?B?YUovdXNBWmxXN3lBOG9oOHhTSE5IdGJwZmV3Si8rSy85Wm5scjFnQmo4QTZa?=
 =?utf-8?B?bml2dW9YbTZvS0VRc200a2FUY1p6a0g5UU1Wd2ttTjhIc0JDTG9qK09TOWZj?=
 =?utf-8?B?OTV5ZVdRc21tR2hwa3QvZnMzQWx3UjRNeHd0enF0a1U5UXYvSnNkQ1B4TDBP?=
 =?utf-8?B?Z3pZN1VseUFIemlQMm1GYXFBeWNtZFYvanRwTHV6NEZCaVRyOXQ1UjJGZzVI?=
 =?utf-8?B?K2tvOWVXYkgyZEFyL2taUjNobFJIQkVyMlpJUkZ4S2duYUl5OTB1VFNRYnpS?=
 =?utf-8?B?dUpMZWovaVJ3YmJjcHNNNzBTRnh3WXdLVXEyNEYzZlNrdVBTUHJNWGZ5bGo3?=
 =?utf-8?B?cTB0R1RMT2NhaHRTaFJmREp3WEFDS3dRMisvUmkzUytIT2x5dWNodlJ1NFBK?=
 =?utf-8?B?WFJWd1RhSktHUlRMT0lDVHBVYWtSb3JsZk9tbCs0OGFSSmZjOXlkdEM3Qnl5?=
 =?utf-8?B?REdYZE5GUWd4V0drNElYVVc2cEYwdHdldnphUDE0Z1lSam5BNnN4MzNncWZP?=
 =?utf-8?B?cUlpdno3NFVqK0J4U3Q4aG5FRUkrMWozNldYY2tSYmdKdzVUMXY3NmtaOGd5?=
 =?utf-8?B?a3dwVEZEd3NxbVRPR3ZlOERLNm5ucHFqT284OXlsT3hHZ0RsQXhZNGh5S0E1?=
 =?utf-8?B?TTUwSnlLWTNnbVhQd1N3QlJoK3VnTG1nOGNOR3ZkSHlDZThrcVhFdE9DT3NB?=
 =?utf-8?B?UGxFeS9LOE9MQjhsUlJWeUt5RkJqSk1JMU9xUFFwbkg2Ukc0cjFpRHh1ZGJ1?=
 =?utf-8?B?OU5UWU1uWnJpNmpqZVJHWVozT1ZuOUx3c3E0MzFmbVk2Z2Y4Zm9OWUt3U0tQ?=
 =?utf-8?B?THdDbS94L3pXZmgzbWZMSVFtMDZPcit4aUdvaFMzSUN1bEtTWGFCamhNcktp?=
 =?utf-8?B?NXgxMU1uWGQ3Q0tCWkdaczZQRHo5RklIVSttV3FGUlp0aWw0UllGdEhpNXBz?=
 =?utf-8?B?Mnl1NG56cERjc2I4Mm9kYTRFcEM3MWRhZ2I3QTBVc0pabG9rbFVYQmZnZ0JT?=
 =?utf-8?B?Z055U2hLb0tmN0p1dUQzYWFyVFpkNkp6MEswRStPSW9DVUNMVThRMkswYkV1?=
 =?utf-8?B?bHhkaDNkVTB5NWQxOXByVWx1T3pScWd1a25hU1VxUlFPU0RxY21wWnBETUNG?=
 =?utf-8?B?SjhOSm5RQjZwTEtCRW82TGJOd3dBdWFvd2FlVjRmbExkVFpBZUVTZ09NakxK?=
 =?utf-8?Q?xdGvCWwKJW1rbHCg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad347e12-f279-4ce7-32ee-08de6502d622
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 22:06:39.1959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jTi0A7fs2afZAV2zJl6BDFyAeyUvuC8kIj4kgbvAe66deEwQiXKMoy0rwDCIWGRIsbTY7LowasYxuNBZshknvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8206
X-Rspamd-Queue-Id: 88975C000D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: dfihrx479qz7nrtshuhzastfqhczq8kn
X-HE-Tag: 1770329206-564
X-HE-Meta: U2FsdGVkX1+JAZwJ34020NCag/nmiAAA7V8qS878aPodZ6PnAk3VNFhsa3OisogjeDlL2m/d9tG9JLzg/o4C79LsCNBoLA7+MpSk+uk8nWUa+0LN6FPVn2GCaaTUK3V9ccBhBCrh70RV1XZoxPcyx0nAxED1Zci/DhJguRJHhVjtm1cBCR76HlC48Q6ft3pMiaOQNBaUlhWBUYfju16xybY840PY+Q0AciW3pQ1YjmgT237m7bAnp5CutVJKJPcywGsT9190A4CXT9pF5wLUucWzPxwL/2jMe+6bvuIIcHrernrwAvHC0wiB8Y9jGBXNPn0Guf+k8+YchwECdVeyM0OilvXY1A/neeDsdAKtNbLPdP3IeZfwC1793Q2jYYO5cKgi9qBnJ85mdO9sHUaXUmQvYx40hCRaHYZsuGrzosOVqyKN7OJJxcUcmEnwoX8zNWtMZEoefsMxHoEV6AqxETa2yobtri2iUemDwIc5cXRzJKNf7bX9w/W0ctOPMGCGzPEhLKJ1ybxJkIn3V3mLYWLGo9VK1yjTFna7K1XK2aXzcKM9MC1+G3jWqcTvitay8c4FIP6j/E0FCyPlvMxqOMWH9MqRASHcdNg9KMst5sia45VV2czIbhoW5YVOKnoQtU7Av3ggLapgz9PJua/8aErNb3B6jO9dCML7eh1EdAr5j5PNurVK8knAId4mcR6nLdf1SOKz+LS9wkEaYZ3n1WgGqcZJaetgbj3LDsHGbnuHHdN+uJlhlcOPdR+UEZYtyKhgSbyzjYzmfSYlr11/qFMLEwBZMJkCNpDOoEANM3hg+oGjpytwZYEwxieiVNbjxUVDcpV7IsVul/k7Kt5jntP9a1BO8dtkMAIv5dYhYzgGc5Qiqx2+2KhyRMnpO8PAehWLNEafuDH20l28IVsrSI49NMJ2YVg7C+MLJU5GAEkAgSPkoG6P27uSaX92+gUKxdK82TracTDJIr1juPW
 CioGDY/H
 XV3o8R2dqk0Sja2iMQdyRZb4Z9tOdjuHlOYXQetRzBjgdDlRK31ad7sM1K0NN43jLL8fEBpDfOMHmOfk9u7Iz65SLoFzwmTuirA/68qHerY8iO9NJUYVoMiRl1BBroeAD7Hj/4icFh06KpN8bqFEjtVvaUassyeK0SOnHnHBC7kisNnnm/7lnJgNMuPMlPSxnxMbasv1916tBxdvb+40l+YTHxwOlOvoCwTOI0TMXDL4ES0c7si6sImJsAX3bmqgpJ4Iclre5GFiy6d8Vtj5kSB5MkyNry0uu3ZxWh7yIqGJv0yMTXY9VfcBits3Fjlq2SxzZdief5INN0nIqnGagFiTzltYlDZ0nHK+u4aLO2LA1c+mta385oPsJ2+iQXbwtwa+V9HpYtY1MnREh35+C4dT+BZ3ojfvQCFUPjHsZwbycrEQNysyJ123dWK5Is/jV5pN1ILkUogrRZ4dPFS/jf4kwhN10b7mLm/fgMBp/N785hjxjARG8k4GRUY+hjRtlqtaz6MP3DE5QzpFwN4hV3a+RALVVdr7prjhlFjDB6PtKEMFOWA0J0OXfXh9ZgsRyd8lgWFa4kX/4y7ueQGm1K2YaxOlxtutLqq+EtoyHwIfzDl0Le+sR65U9usBM/4rrRKgE5Xq4UNogiAMAKpzgJgLNq1qA+4t6vbnmtRGa9QZzedho5oWWhY+L4ToiPiR0uhfYaZ2kqpTzwfe7i4fVPSZKX40ZnfYL3pBQNaau7hXWMYJhLAYh4dG4Loj4pDL2GkSeYsvyzYGEstrdmO6WAKztDFSTnlnqfmJuRuu3ug/lAVE6aZRqN3RLnh1OxTqpupZjT7qAH2JoE1DF6YJ9LvRXAimK/sJ6oZlNBox4nmrHtZHBblvn0pffdqip8LeX3qb6eUtf7Ph75WRR+N9SfpsGxCqdRTfxofODjHFyfTB4egcWPEnXuEwEPjcPVSMIXaCFk187hbmtrkEiNlcUAw/5kqxX
 6ZwNSYtZ
 SjnH+xxffhRoZsTVx2/s8i2UmDSLsLFE6qKid7/SsHSGD8qEAqTgeGv58DNPX76FBWizqt+H/HizbAHTIpViLHzzoJHQI4QEuR7557TAB0Ntu0XiMbERf5scLucovh2VDSrGTqxf65tm5UPbMn3RqXikbRALdz4DpDSxzWAb9ru6cA5F1rvWBUnCbBYFG28yWCDYkNFR0tWB+2XOrS2bT7iH6UI50tRYeEb5FaItLXrOJqwMpIlS0QDVUCdK7sZdtajbWm3eDm+ZQdOiQstdYYA4wqw6yVMd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

#syz fix: procfs: avoid fetching build ID while holding VMA lock

On 2/5/26 1:44 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    f14faaf3a1fb Merge tag 'tsm-fixes-for-6.19' of git://git.k..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=10928a52580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4aae00ac5a9d2645
> dashboard link: https://syzkaller.appspot.com/bug?extid=c8461425abb63bfd3445
> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17078a5a580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14df4b22580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-f14faaf3.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/2fe7f2219e97/vmlinux-f14faaf3.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/b1acb6ecfb89/bzImage-f14faaf3.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/c52bcc06e784/mount_0.gz
>    fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=13a5c7fa580000)
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+c8461425abb63bfd3445@syzkaller.appspotmail.com
> 
> loop0: detected capacity change from 0 to 32768
> XFS (loop0): Mounting V5 Filesystem bfdc47fc-10d8-4eed-a562-11a831b3f791
> XFS (loop0): Ending clean mount
> ======================================================
> WARNING: possible circular locking dependency detected
> syzkaller #0 Not tainted
> ------------------------------------------------------
> syz.0.17/5488 is trying to acquire lock:
> ffff888044e06540 (&mm->mmap_lock){++++}-{4:4}, at: gup_fast_fallback+0x20d/0x22e0 mm/gup.c:3204
> 
> but task is already holding lock:
> ffff8880467da130 (&sb->s_type->i_mutex_key#24){++++}-{4:4}, at: xfs_ilock_demote+0xbd/0x290 fs/xfs/xfs_inode.c:285
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #2 (&sb->s_type->i_mutex_key#24){++++}-{4:4}:
>         down_read_nested+0x49/0x2e0 kernel/locking/rwsem.c:1662
>         xfs_ilock+0x109/0x360 fs/xfs/xfs_inode.c:152
>         xfs_ilock_iocb fs/xfs/xfs_file.c:195 [inline]
>         xfs_file_buffered_read+0x15b/0x330 fs/xfs/xfs_file.c:284
>         xfs_file_read_iter+0x280/0x510 fs/xfs/xfs_file.c:312
>         __kernel_read+0x504/0x9b0 fs/read_write.c:530
>         freader_fetch+0x1cb/0xa00 lib/buildid.c:100
>         __build_id_parse+0x168/0x870 lib/buildid.c:297
>         do_procmap_query fs/proc/task_mmu.c:733 [inline]
>         procfs_procmap_ioctl+0x7ae/0xd50 fs/proc/task_mmu.c:813
>         vfs_ioctl fs/ioctl.c:51 [inline]
>         __do_sys_ioctl fs/ioctl.c:597 [inline]
>         __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>         do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>         do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>         entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> -> #1 (vm_lock){++++}-{0:0}:
>         __vma_enter_locked+0x243/0x710 mm/mmap_lock.c:72
>         __vma_start_write+0x23/0x140 mm/mmap_lock.c:104
>         vma_start_write include/linux/mmap_lock.h:213 [inline]
>         mprotect_fixup+0x5e1/0xa50 mm/mprotect.c:768
>         setup_arg_pages+0x565/0xae0 fs/exec.c:670
>         load_elf_binary+0xc5e/0x2980 fs/binfmt_elf.c:1028
>         search_binary_handler fs/exec.c:1669 [inline]
>         exec_binprm fs/exec.c:1701 [inline]
>         bprm_execve+0x93d/0x1410 fs/exec.c:1753
>         kernel_execve+0x8ef/0x9e0 fs/exec.c:1919
>         try_to_run_init_process+0x13/0x60 init/main.c:1506
>         kernel_init+0xad/0x1d0 init/main.c:1634
>         ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
>         ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
> 
> -> #0 (&mm->mmap_lock){++++}-{4:4}:
>         check_prev_add kernel/locking/lockdep.c:3165 [inline]
>         check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>         validate_chain kernel/locking/lockdep.c:3908 [inline]
>         __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
>         lock_acquire+0x106/0x330 kernel/locking/lockdep.c:5868
>         gup_fast_fallback+0x226/0x22e0 mm/gup.c:3204
>         iov_iter_extract_user_pages lib/iov_iter.c:1763 [inline]
>         iov_iter_extract_pages+0x37b/0x5f0 lib/iov_iter.c:1826
>         __bio_iov_iter_get_pages block/bio.c:1237 [inline]
>         bio_iov_iter_get_pages+0x4a8/0x14b0 block/bio.c:1359
>         iomap_dio_bio_iter+0xcb3/0x14d0 fs/iomap/direct-io.c:460
>         iomap_dio_iter fs/iomap/direct-io.c:-1 [inline]
>         __iomap_dio_rw+0xf57/0x1e10 fs/iomap/direct-io.c:753
>         iomap_dio_rw+0x45/0xb0 fs/iomap/direct-io.c:847
>         xfs_file_dio_write_aligned+0x36a/0x450 fs/xfs/xfs_file.c:707
>         xfs_file_dio_write fs/xfs/xfs_file.c:910 [inline]
>         xfs_file_write_iter+0x7dd/0x920 fs/xfs/xfs_file.c:1122
>         new_sync_write fs/read_write.c:593 [inline]
>         vfs_write+0x61d/0xb90 fs/read_write.c:686
>         ksys_write+0x150/0x270 fs/read_write.c:738
>         do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>         do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>         entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> other info that might help us debug this:
> 
> Chain exists of:
>    &mm->mmap_lock --> vm_lock --> &sb->s_type->i_mutex_key#24
> 
>   Possible unsafe locking scenario:
> 
>         CPU0                    CPU1
>         ----                    ----
>    rlock(&sb->s_type->i_mutex_key#24);
>                                 lock(vm_lock);
>                                 lock(&sb->s_type->i_mutex_key#24);
>    rlock(&mm->mmap_lock);
> 
>   *** DEADLOCK ***
> 
> 2 locks held by syz.0.17/5488:
>   #0: ffff888031ac6420 (sb_writers#12){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2683 [inline]
>   #0: ffff888031ac6420 (sb_writers#12){.+.+}-{0:0}, at: vfs_write+0x227/0xb90 fs/read_write.c:682
>   #1: ffff8880467da130 (&sb->s_type->i_mutex_key#24){++++}-{4:4}, at: xfs_ilock_demote+0xbd/0x290 fs/xfs/xfs_inode.c:285
> 
> stack backtrace:
> CPU: 0 UID: 0 PID: 5488 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> Call Trace:
>   <TASK>
>   dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>   print_circular_bug+0x2e1/0x300 kernel/locking/lockdep.c:2043
>   check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
>   check_prev_add kernel/locking/lockdep.c:3165 [inline]
>   check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>   validate_chain kernel/locking/lockdep.c:3908 [inline]
>   __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
>   lock_acquire+0x106/0x330 kernel/locking/lockdep.c:5868
>   gup_fast_fallback+0x226/0x22e0 mm/gup.c:3204
>   iov_iter_extract_user_pages lib/iov_iter.c:1763 [inline]
>   iov_iter_extract_pages+0x37b/0x5f0 lib/iov_iter.c:1826
>   __bio_iov_iter_get_pages block/bio.c:1237 [inline]
>   bio_iov_iter_get_pages+0x4a8/0x14b0 block/bio.c:1359
>   iomap_dio_bio_iter+0xcb3/0x14d0 fs/iomap/direct-io.c:460
>   iomap_dio_iter fs/iomap/direct-io.c:-1 [inline]
>   __iomap_dio_rw+0xf57/0x1e10 fs/iomap/direct-io.c:753
>   iomap_dio_rw+0x45/0xb0 fs/iomap/direct-io.c:847
>   xfs_file_dio_write_aligned+0x36a/0x450 fs/xfs/xfs_file.c:707
>   xfs_file_dio_write fs/xfs/xfs_file.c:910 [inline]
>   xfs_file_write_iter+0x7dd/0x920 fs/xfs/xfs_file.c:1122
>   new_sync_write fs/read_write.c:593 [inline]
>   vfs_write+0x61d/0xb90 fs/read_write.c:686
>   ksys_write+0x150/0x270 fs/read_write.c:738
>   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>   do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f85b679aeb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd910b1588 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00007f85b6a15fa0 RCX: 00007f85b679aeb9
> RDX: 000000000000f000 RSI: 0000200000000200 RDI: 0000000000000007
> RBP: 00007f85b6808c1f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f85b6a15fac R14: 00007f85b6a15fa0 R15: 00007f85b6a15fa0
>   </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup

thanks,
-- 
John Hubbard


