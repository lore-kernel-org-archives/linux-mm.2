Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E191CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 13:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AE9A6B00A0; Wed, 14 Oct 2026 09:21:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 087196B00A1; Wed, 14 Oct 2026 09:21:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB72B6B00A2; Wed, 14 Oct 2026 09:21:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA3FF6B00A0
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:21:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 567C04054C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:21:08 +0000 (UTC)
X-FDA: 85321292616.19.1B99E19
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11021108.outbound.protection.outlook.com [40.107.130.108])
	by imf24.hostedemail.com (Postfix) with ESMTP id 665AA180006
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:21:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b="RGlt/vA8";
	spf=pass (imf24.hostedemail.com: domain of khorenko@virtuozzo.com designates 40.107.130.108 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791984065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ySbuWqyOG7qfPC9SJMX9PPTulpIPyCip4Vvwurb/yuk=;
	b=aND16md3j+er3peynWtNOB/41iNBGSz2W8uxWL+Iwk+47PjZv27j4E7aUfg6Znyo9iSkdI
	cPQl+ol+e6FaCpC4o+YQZx7UYs8Sr0aG6NTI4CO83fdlR2PYj2zzbVmSj48Uqhvi78g5ik
	TIfQxzd6fUbSS3ZwrW5Rod4cQQv+nCg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791984065;
	b=mh5xM5TgDh9KmT8fVRf1a2hA6KeU2vlQeLDYn5XOszMQ3HItJRzYNXh6zjhCAqV1yHP60W
	PcPwuZXDFf+9iZOTZ3xgcWtGPLvrBs0j+M/1ERcPSpMppdajVQsu1spUAntsQa0Q4pINQF
	M2oDq1OaiYoty9VBHL8709OXaHV/doA=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b="RGlt/vA8";
	spf=pass (imf24.hostedemail.com: domain of khorenko@virtuozzo.com designates 40.107.130.108 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yVvLjrBtIHdS2/ZhegY1/HGFnKDUJdjgesZf5tECjVkpln6e9XIbMXXUaDFxjM+QlO0m2QRucVtJg2cjRvygVYw4uSlNkPNC7dvW4H3nhqHCXL2ER8Lji3HZ97802/2n65jIPBBJij+1W2he1DiOmvxVwGPiQz72v2toUU9yQrxEQ0bx+tRFqhisxPCPan+PVgYTxh8+hhXZQ1JEHlCYWII1l2yvCtNpfV6IdEYco+VakGYQhoazrVw4aDZVXRUwEFCBKisFW6DfaeDIAw9H4ePViMkywFR5QMM3dnnYqXdk/XH5fXoI7WIwJGYsSvLsEF9us3YveGS8EIxhYW6udA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ySbuWqyOG7qfPC9SJMX9PPTulpIPyCip4Vvwurb/yuk=;
 b=PGtokdeaFIGrW/jZEpK0opJKsK+jzaqzvpOvC1PFUwSAlzXKqk/UymoOsxqj0tVCdqpES8rDR/xVadwEr1Cu4eVwMVVBLYw0W+C+DGKexnpQkR0a3sjADDguqqnzZf9nomc6go8/n2mYXM0H+xnBWbycLdgR/Ny6+tY0A/YDkwrbtZCIdgLiIQPB+m1Cnfp6QUF7ANL2HI6XMgnWkC+Bc+9JCFxDwpfDFId8cv1vnHbTSq0wXns3BhW4QVw1sjJIJDMZek1AU/jjLJ0Q5n20AjA1ugxMsV65ZQmHqkgGrpzAUWM6IwtsLwV2RwPoIO8WU7O1CJO0WIDi74VIzLiNJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ySbuWqyOG7qfPC9SJMX9PPTulpIPyCip4Vvwurb/yuk=;
 b=RGlt/vA8ePhjr8GAVrondJI1tuDCnNXbfw0d6Ng7uciSUpcgc4c6JlWN7Lz0whN38zclc0I8VEwNYRZGCv+WNxulJ7aSUj0+mJr7t3e5yDDiktHPUdn3bUSy+G/5ZU7wvQrrb9JN/9qWr97Ds9DXXcusdaBkZYMUwlEwMx80U+ZjL2QUl6Kh9q3aDWktWJ9zk2MRYCOwS3e4DMWUedkQefX/Bp7wtyjrBcuTG8Dj4OnChca4L9gOtwjYkQacGjyIm9nXry97C38cD+5faMZ4kf2IBCaJ2HTZpgfDfTWU5sS6SBoSBShgZEtztaBb39zVsx9Fdxf578DmzeLZFkQeZw==
Received: from PA6PR08MB10708.eurprd08.prod.outlook.com
 (2603:10a6:102:3c7::20) by GV1PR08MB10422.eurprd08.prod.outlook.com
 (2603:10a6:150:166::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Wed, 14 Oct
 2026 13:20:58 +0000
Received: from PA6PR08MB10708.eurprd08.prod.outlook.com
 ([fe80::1999:c6db:dc55:494a]) by PA6PR08MB10708.eurprd08.prod.outlook.com
 ([fe80::1999:c6db:dc55:494a%5]) with mapi id 15.21.0522.011; Wed, 14 Oct 2026
 13:20:58 +0000
Message-ID: <7d037519-3034-4e7b-bd9d-6bac0960fcbf@virtuozzo.com>
Date: Wed, 14 Oct 2026 15:20:53 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/shrinker: size shrinker_info_unit to a power of
 two
To: Muchun Song <muchun.song@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-0-5a7608393b7a@virtuozzo.com>
 <20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-1-5a7608393b7a@virtuozzo.com>
 <EDF08D88-7AD8-4697-A1EE-F20BB1F83AF6@linux.dev>
Content-Language: en-US, ru, sr
From: Konstantin Khorenko <khorenko@virtuozzo.com>
In-Reply-To: <EDF08D88-7AD8-4697-A1EE-F20BB1F83AF6@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0008.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::18) To PA6PR08MB10708.eurprd08.prod.outlook.com
 (2603:10a6:102:3c7::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA6PR08MB10708:EE_|GV1PR08MB10422:EE_
X-MS-Office365-Filtering-Correlation-Id: 09233156-a3dc-4995-7972-08df29f5fbe8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|1800799024|376014|366016|18002099003|22082099003|10067099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	w1qK37Fjj+thQJ6nWOjKAbujD8WRRLdLjNfCajkAf1vgLt5kq9gO+KM4WzC5Uq8c66jgyb5zap6gIGPMr0Rhruv4I2cyxkazp09+QRPjp6YxgeT8mD/ulddkdUOzCJhIKYl4utyJ+NORtYlts7eYx+tq/qizfs/a2supTror2cNHoJG+oTwvRn5TrDJYc8KAcTmqvwgDyAOPINbbAPmRTYoMEV74hNAzDaI4N/a/479rtoxFXGw7+ek+fWYeY2mbVWhukd7he9AcUcFVTm4WT/xLXlsdkoIT/FrfyxIeuOOQTlbWiEn2YX0g/CHf2Nimtp3iQdeNmzntEIvDybdLRge60DpbJHqKCo1y0GDv0zVMHfeEBK7kVPwMfOsdVVob5OqnTtpCplqyUYgqriQ6X/bTZS9sXxPIM4l3xkgsUZEUaK+a2YuoNODrgCJAVXKwQCvCC2huGftt76CCuudjbCMM5bi6tAdrwB2s81bFSc+kesPLNergJOUfBb7x+FouVegoya9Ow19pSCiYl3hdE9ZNKzqRodxeCSVC6FDDnN/VBqwWge8Y1I+XG/wqlBRsuM/7OWPSvV8gXIlOulqTUnFxORJW9++r0gnJxbiNWm0sO7la1+cBlk0FgczDtqfzqyPWcsLXqvs3SyqVRbGtT/W9JKrBx2aRVSkJYork1dk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA6PR08MB10708.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(1800799024)(376014)(366016)(18002099003)(22082099003)(10067099003)(4143699003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZUc0SzZGZG9uWnAwZ2p0M0RUWis4RHAzU1BybE8zM1hiaFR3Q1pnL3ErVFdo?=
 =?utf-8?B?OUl3UnFJUnZ6L0o4WGw5a2dlWnExN2w3T3o2Y2ZqYUs2RG05MERVOENiLzR4?=
 =?utf-8?B?dk5FS3ZaN3FEMERkeURGemltWE44TWt0Yms3Rm9hc1k3SmV0aHpNZHRQOW53?=
 =?utf-8?B?dk4rVXMxcTRsVXRPVmZXbFFRMFMxRmNETEpheXkxNGUvLzFxdk1xbDJBOWh3?=
 =?utf-8?B?ektBUVdhbk5ob0pKaXRKNWRFbmRSTW0yeWIxNmpSN3FYbGhPREFEbk9tcklF?=
 =?utf-8?B?S1U4QTk4a0RWZStWSzgxYzJyem05WksrNHBnVFJNU29mUjZOaXQvTnhQWW1X?=
 =?utf-8?B?aXNmNUdwRld2Z3B1Y3dlUElNcHVmYkNQeDI2aGd3SDNmSzl2TVNJK2phYzJN?=
 =?utf-8?B?MnF6RUZDZ2NHRWl2TlJVVGQxamFmL2E3Y0dJSS91enVxV2tNNVdlZ0t6YUIw?=
 =?utf-8?B?Z0RnMkw3VnZHZGdKaFFKdlVoOU5WeFJiZUY0b2FtcyswV1hGaUQvbEhTTEhr?=
 =?utf-8?B?MHN6L2FEWTh3YzVKVENFM2YwdU5ycENLcHZTS0FqVnFOWFRETkF2bDJvMS9Q?=
 =?utf-8?B?RU8yL1lNYW9wZ2kzUWlYVWFXYTdyZGRTN0EvZzlkbkUyYWg4dUhTMWZ2MHMr?=
 =?utf-8?B?NDVmOE54ODJiMlNHejJLaVkwaWY4aDVDYlZ5TTdyR1FONk1oNFh0UGNrc3hZ?=
 =?utf-8?B?RVduNTRWZXRsUGYyV0pVZU84RGR1eTZ4KzFLQTVWMFVZUlpQVFQzZU9sUWRs?=
 =?utf-8?B?em9keFFrKzNTbnR5ZTNIU2pQb083Q3crK1JrbkhDdnZCU25HWTltSGQ1Kytl?=
 =?utf-8?B?YW9wY1Q5bmtUaUh3aXd5Sk1neGpWU1NxRGpLTHBRWDBaeHFHSFkycVhiM2J0?=
 =?utf-8?B?aVFZaVdyZHVaSkFaRlFqMmFNcVRWSi9aVVRlTWpsN3RpSXhoYk5XSHRtNlZI?=
 =?utf-8?B?b3Z0UjNKQnk5NHAyV0gvQjhwMEFsY0xNOTdjYmI4MWVpdTJVL1pmR3RJVzY3?=
 =?utf-8?B?T1p4UWxsNUkyUStUTWRRTjBvb1VUWUgwTllGTnZvbHRpQnlXSjBUbzVTUXpv?=
 =?utf-8?B?TEZkYzJhVDJEd2QwbURodlpoa0o1RTFvUDJTcTdBdDlVd0JPVnFzZElxQjln?=
 =?utf-8?B?S201aFRoRk5IR3I1WVFYV3prNU9kWmhaZVhKRGZLUGZBV01DM1pKc1NKV0l3?=
 =?utf-8?B?UCtCaE9OWmVXWElEbVB1SkVzbngrcmJqQkI5Wkt4a2haeWZlM1dRZ2ErVWFs?=
 =?utf-8?B?VFFUZVBHNmVxQTk4UDNLZDVBNnBGZDFVUVZMZ3JVanlKMk9oUlJlNXlUL0pJ?=
 =?utf-8?B?cldWMlFSUFJ2RTZ5dGthYVErdHhKWVBkNng3OHdXMHhONThTODZOWEVGZVZu?=
 =?utf-8?B?KzJicG5oTUtGVU4zODd1QlQ1R1dnaThkN01CYzM1QXZNekFPdW9FVFZoUmVH?=
 =?utf-8?B?S28wS2hPRzN2R0YzOFhhNVZtRUhDamw5QTZ2UWRKRWZrL1dCY1BwbTBVWG5a?=
 =?utf-8?B?bW1qQ3dzT0Zma2hHdmR2V1Fyc0NTQXFVYkF3c3NBdU85QVROK0ZxK1BweEtF?=
 =?utf-8?B?VFNSWEFEajk2MGs5VGpFY1ZxQ3VNdlQrTm9JSmgyRTROUUZ2Ynlmd1BBblpu?=
 =?utf-8?B?WllOOXRiMFZkK040RWdJMGNXRXJTbitHWHVKbytOcVNmczlTS21Pa3VuSkxO?=
 =?utf-8?B?dWtIV3NLNk9XRjFGUUwwUVVrQmVXVTRQSWxWSWJaVDV5QzVkeFBhdWYyNXJP?=
 =?utf-8?B?T2I2VDR3WVFMK1Q5MTZhNEw2NWN6MHZaRkNVVlRpRGtPY1hoN1pPRFZmL3pi?=
 =?utf-8?B?dW54d3p3cGVXN2s5WUxBVVByanBBYW1STXJ4U1FreTJXN1EwenMxTDJqSk42?=
 =?utf-8?B?NWltWUJ2OWgxUm4rOE9sV2NVV3FTQnY1M3dGWURFYmdNRm9ndFdZNUxlYWRR?=
 =?utf-8?B?NmUrV085d21EamdJdDF6eFBsd2E1ZDRsNGVWVWdsei9Za2lldUZrNDFYQlBp?=
 =?utf-8?B?a21tQXh5SjVBaWhJQThXYVl2alA1NFdpdEwzVHJXa0NXaVE1QTlWUHB4QzBD?=
 =?utf-8?B?Y0hUd2R2T05rTlV2Ni9oMHJNR1ZHRWNUUURDYlVoT2kwN1htRmFJRS9qS3pV?=
 =?utf-8?B?cjRyWTdpcXczUlpuYy8yTFBtOEtUcXpSY3hhVGtya09tWm1ZNEtsQ3ZsMXdO?=
 =?utf-8?B?MXNPS3pOTmR2MmNwUVplOTVwd3kwOTRyUm9kbjY3SEViWlBZdEwvVi9sRjJ5?=
 =?utf-8?B?ZnBjMVpGVVpmemd1OFJ3ekhPSFV0M3p3M1VuZkxpV3hGUlA5Tm12QW1veEdC?=
 =?utf-8?B?MSszaW13ZVVCdWZVMGJMbkppNVdYY0Z1U3BVdGNuTU8xbGRaYjZrZz09?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09233156-a3dc-4995-7972-08df29f5fbe8
X-MS-Exchange-CrossTenant-AuthSource: PA6PR08MB10708.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 13:20:58.5267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h3Y1q+6mEsiRyYedZ1joy6pV1Kwi5PpSN1Qr51whDBVc4D5dhckr16ojDUsHUox5F+nGd0OdJ31EmAMhgtaeGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10422
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 665AA180006
X-Rspam-User: 
X-Stat-Signature: 4sw65jopmhpwkinr63o41nwdqwtthdm8
X-HE-Tag: 1791984065-293770
X-HE-Meta: U2FsdGVkX1+zQF7Mu8U2lR9yO0OQ8/gKtcS2owXZ3Z3yC1TCAs/xGm8UItFm063tptm6F0+HyHlMeR7amnez9xRmGHndFqgb+bJpJS4Gwh+s3gMk6FO4B74ImCQsXtpCianoov9nxWfH3g+x4JpFaxeS0877sT6DkiudE48tTD0gQFkBj6k8vB47MVMrDwxUFW60zbyddHjJrHGTaL/c1UrzseAUg4/j9F7e104MXlHy731mTSPkuTqDGN9cfWqmhD0BT0VpN1R0/sM1GSNcS/nRF6gE5xsOHwS0zirQleqJZJzENoh93cOQh5Sq30wMNWG62TAfRLFXDs0Y0w+B9wExa0r+/r+cgkAg4PCxSlOVQFMaVIyNnI2w77Jq6zy58TLCXvm/dZJag4AsPdor5lGERccsjio12MfQIj1XNlQXszqqL1frXQ5Vid+pVPAx9dsq3qOVTEN6QGFRFeYXK2/KsPoZEhM0NA4H08IzHVcWeLpoiIglXQEkTqvWnrRbJHpxnT96WJMzYkxpqOoFoQVUT7oFLq4OXLv5u3Z9nxJpEW/qiHWi536GYcjex+1rZbSBiblJJVr81xYWiZVk6fC/DV1+lahBJh/s3urGrQ70StSUeMNsX2Mh0Mw6SshY5l/PbPo6wgr4lPCC7B680vsMze7WLm7T2Du9tbA0cKvJFvR8Ro/L5VpwkOudbR/L9ymQvAbY+aBBHJVoi2UEh4N1nHLMk/apW/pghDsu2g5iJgum1fy5QbUKM8bSzdpvAJ0yAWuKmFlc8OWyDeUyI9xlFixLRWS7kGcqaDXihrbj4ZHDl+Jpm76B2AcXKXZTl0W+eUMvz3F94CBAlbo+PiEB+Y3Y26udDm2DQFNgAaujzbnde12wTqN3ZJwNOpbXrGD97d1F5RfHO1O2kqtPNWT3zNrk5+zbgTKtaJdPwdzRuwVQ7lgzIjmVNgIAA7BfpL6vvbAhUPzJsbcxvwk
 Epp9csg1
 LW1rmoqd74LEeTxy5qrpZzrxA8Y2ZJ0C9CCER8vAH5fZXa4Wep9GANzuGRGphuzolf5t4vezh0Tt61yyjR+I+5kI/YeApYfxhI3zMOZRxxEZpszYKEKcub6y2u4XnqfaX+2LPqxkYAf1ehwvB2eJkNFSKp2OxCR0ZCU6y+4vXydfa7/GFzS+JLumyTr6qDGcIxzwFdj0li3gyjlHyXDvVbEBqon/KkNPjDFTJjBU+3z32ODmF84pFcq8MjD8MDZWDh3QCPiaxq78ca6FnLjOCE8KjIqfmbfl+heCjwqgRrfNtbqh5A8IHnW+jQ+zfWSpeoKR5cSbJskd2NXY9dRQJO3ZQ29dRqaYrox1b/LnO62+pm5CVlUPIcK7ev4ScAuA8LplUI83uyIgqW/D/H8JpufzYkJeqOYyxs9mO5XW6y5Wnzxc4jv4rttHwPKbAOyoaTMmVfqnleTKUxgk62Yggaz8Q8VHaAmFRPWA8oz+8GKLG0LDqiWrqZABlQvzsc+ZctttEiHv8ezR31Dr+734xzXj8uwzur2vrld9w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/26 08:18, Muchun Song wrote:
> 
> 
>> On Oct 13, 2026, at 03:02, Konstantin Khorenko <khorenko@virtuozzo.com> wrote:
>>
<skipped>

>> /*
>>  * Bitmap and deferred work of shrinker::id corresponding to memcg-aware
>> @@ -18,6 +22,9 @@ struct shrinker_info_unit {
>> DECLARE_BITMAP(map, SHRINKER_UNIT_BITS);
>> };
>>
>> +static_assert(!(sizeof(struct shrinker_info_unit) &
>> + 		(sizeof(struct shrinker_info_unit) - 1)));
> 
> This assertion is not straightforward. I'd like to use is_power_of_two().
> Like:
> 
>   BUILD_BUG_ON(!is_power_of_2(sizeof(struct shrinker_info_unit)));

No problem, i'll send a v2 with the modified assertion.
Muchun, thank you for the review!

--
Best regards,

Konstantin Khorenko,
Virtuozzo Linux Kernel Team


