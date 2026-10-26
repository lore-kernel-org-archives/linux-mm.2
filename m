Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75555606A323
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 12:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=kIqEX5ia
Received: by kanga.kvack.org (Postfix)
	id 76A596B05B2; Mon, 26 Oct 2026 08:35:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71B616B05B4; Mon, 26 Oct 2026 08:35:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 630876B05B7; Mon, 26 Oct 2026 08:35:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 39A386B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:35:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C7EB0A04FC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:35:55 +0000 (UTC)
X-FDA: 85364724270.22.33CF12F
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011052.outbound.protection.outlook.com [52.101.52.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id DE7A2140008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:35:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=kIqEX5ia;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 52.101.52.52 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793018153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dA1WsAFM4CA5VMBWb/lIlNYRchfNZZexmLX+/O1mJ1Q=;
	b=dKCNqQHd9zXVtL0WeDpZIoX+OTNC2uiVeKx7Yd1L0n0+2MIRSDL4ARCpSnRfc9wG/ZZM62
	fAzVY1QGeAyXZG1+SkT0SL6gNZFI0daLU+8pXYv00mrVrz0BFYcG1evwX54EgK/ErwwR9Z
	siFsjo4NXOYGw4auyxqZQgXWO2uy76M=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=kIqEX5ia;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 52.101.52.52 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793018153;
	b=wSLjfoeF+WRB4acoATkyn8djcNDr4xAcfc3vOQqiQr8T35YvT2UvmHNugl63CkrzjF4qKR
	cLi5tbOupbZBJal5Fatbi7mab6vu4dTtRqDySPf1lID5SbcEOdTMRwV0cZSCyjwgqaalbr
	0pzKNRNdpdhKBd5qmbAO1JPTmW08M0I=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tRkZnWngMoK7Qi78R6Di+w9o/qLeNJslbqjnnPkliRHLHk8kaLggZe+xq3VGgUvfAeVQpuF1aHL1h9Oclel6ZNU4AsjNzmR3bmNvF+C7qGwLIT2r6cn7Idmldvcwv60boSsaq8rT8RAccvtv9vGNZ/ZcsgaV8xSYPRYkfvz/N/vXFEjC6+sJdH2/rYsRT2c70gHcW9m1YBhR5BRpUwNpO770rBjNy+n5cw0m+NiSp/e+RmX+bJ4e4DFChyE3NzgrU4N3uA4jQVegIS0HEfl6tSZyqqx9UmWym7gGuPBXODWPb07Wk8lofQfZ64OIGBd0n+2XrF1F/67ohRc0AfmAmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dA1WsAFM4CA5VMBWb/lIlNYRchfNZZexmLX+/O1mJ1Q=;
 b=tmHqi2bpKHcDSz16AA7tDNVvgdlZHA7TJTLpKUq4nLbdRxMynaaQKjwrNPvcvUmOvo7YeBiRadQYxhVc54oapYab3UBPgvIfSKYyNQxtMXlKL/k6h9om6Qr0Quxc3WbHA/ZQqYA64sP6IW6IolPdpC2hUpxtG4djuit2eFBMrU32eSMhb+J8pGleB/Z4Z9kcMe/g+SttVEu4Niw22E18h68x1VwgSLXH47ITVdD0s/WZaM4R3+JKBxzJJedo5KI/BMiGVBDk56mr2Bn0s3Rj/T4vkKD7RKaWwW/qM1JleD5u4B77c2vhC6JsXbk0WxtaIwbLEjF53qLlOMUiBpaAsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dA1WsAFM4CA5VMBWb/lIlNYRchfNZZexmLX+/O1mJ1Q=;
 b=kIqEX5ia+OrY1UCuVEqlueSuK6lyOXq1aecwilLoMggQxKQvFD1COAmzxLJSo74Xdar4mmrkxxHmLiBcYIsBU15wCqBv6vaiYcc3A37YF0ytW7Me1Wm5sXvCpMcnb1gzfbJe6zob1mhwEEOI/ZMXahmnkK7Hu0BOjLtOv82iODM=
Received: from DS0PR12MB7771.namprd12.prod.outlook.com (2603:10b6:8:138::6) by
 DS0PR12MB8414.namprd12.prod.outlook.com (2603:10b6:8:fb::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.22; Mon, 26 Oct 2026 12:35:50 +0000
Received: from DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c]) by DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 12:35:50 +0000
Message-ID: <8839b7e4-a830-4c88-9e7d-dd35757c5167@amd.com>
Date: Mon, 26 Oct 2026 13:35:44 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [FYI] DAMON and virtio-balloon in DeepSeek's DSec paper
To: Gao Xiang <xiang@kernel.org>, Muchun Song <muchun.song@linux.dev>
Cc: Jialiang Huang <huang-jl@deepseek.com>, lance.yang@linux.dev,
 baohua@kernel.org, damon@lists.linux.dev, david@kernel.org,
 kunwu.chan@gmail.com, lianux.mm@gmail.com, linux-mm@kvack.org,
 mst@redhat.com, ryncsn@gmail.com, sj@kernel.org,
 virtualization@lists.linux.dev, xueyuan.chen21@gmail.com,
 Matthew Wilcox <willy@infradead.org>
References: <20260925054408.10431-1-lance.yang@linux.dev>
 <20260929123241.1408414-1-huang-jl@deepseek.com>
 <aruyFPzEe3pS_Qzx@XiangdeMacBook-Pro.local>
 <AA71E56E-F29A-44B2-B5A0-7806CD684B21@linux.dev>
 <ary5Nn9le4xG7_-N@MacBookPro>
 <CEE47F27-874B-486A-995F-E223249659FE@linux.dev>
 <arzlfSOgtC-CLoZt@MacBookPro>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <arzlfSOgtC-CLoZt@MacBookPro>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0140.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b8::8) To DS0PR12MB7771.namprd12.prod.outlook.com
 (2603:10b6:8:138::6)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7771:EE_|DS0PR12MB8414:EE_
X-MS-Office365-Filtering-Correlation-Id: 3aed4381-2377-4a49-a76b-08df335daaa5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|18002099003|6133799003|22082099003|56012099006|11063799006|4143699003|261021121427099003|10067099003|261022075727099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	58Zox8wmON7Bnjf0AW0i/gzeVaf5RCFI6tv/Idjl2RnmWSMru22MNWNYCTblUB3ZcWexwJIrCgqtWUXLBaw/3RzeqEyQFaj9lC9i7vcuirAcJX3A/xlTwE0lJUB6kh4zIzBj7M4duMrJIOb2MhZKAybDXUOfWBlc4lV/lBzOYy8lJO7yA+SOBwx185UEhag1IpXq9YlgcOthT4atthRbKTlBUste46okbVetUKAUHYxbogi6BahEOibt/6GgbKDNJ8aJMuISYOTVeQ4jUTz0x3ox37y+izLosJwCmm6pJXM3NPocbUsmDMBKpDOgzX7oBlN2fsuhUMvmiYjYwQQXteOAuUXol7sJTutXhwXZBgV+Aj8gY74xWOnfQyS1GahhElhJT+grJW1xvrxqbR5RhNQk7gnAua0cLBtd9s+txdpiq+8tNAc0p1ogkUSgIeDyTWY28SHONEwVsNYuYXKpoA4Xitewix2HPTgG29K6sVibzrlCgRAIs/Jb4uQXbZ+RP6oFZGJFV0hTf8Lv2cVfXCLfofTLk2hATq3EOF0Df8ncpznStUPA2zBquyJh3vMOp22WjBONLktka51Fg89syqVuE2jQgFU4Qt5k8O5t4TvN8GF69CuzmSbnDK1HdvZqPQ+Xbx21sZiX0Ty7rObmynFSvsXrmIEUl+Ov7JftrYU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7771.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(18002099003)(6133799003)(22082099003)(56012099006)(11063799006)(4143699003)(261021121427099003)(10067099003)(261022075727099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K0FZQWZLQmdLaHJKSTFPaGFyV3dVcWEwRTh4MVZxd0NsTTdkRElDSTVZTFlS?=
 =?utf-8?B?c0g2WEZGdmE0a3ZFZFZmQURGUEVpRlpmbitFRVhub0JBUlZIRE9TOW9pWG9P?=
 =?utf-8?B?ZmtDV09JZkRQOFlpalg4aVA1WGNNQjlIZXo1Q2xpY2lNaVg2eXFPdnc2Qzls?=
 =?utf-8?B?OGJGTUJ1bDFhUlRuOXVmVmo0UWRpRnROb0RXOE1uVzhnbmw0c0FVSndleVpq?=
 =?utf-8?B?TFhmTmV5emhwZGRjODFUNkVtNGlyTU9CTThxemFjTDJpSE1xNW9VVGxOZ01O?=
 =?utf-8?B?bHZzcDlaRE0xODlIaXdnNFdnRC9mYkdhM1RmN2pvbG82dXNSMjdXS0lWNFgv?=
 =?utf-8?B?cUdmVitzOUl5VnpsRWswdTlYUytnLzRJZjhYNXc0SmZxRmZFNzM4L1VwRHhY?=
 =?utf-8?B?S29ZYjREdEZTTnZYVzRpVlhyQmwxOTBDQVV1QUhLYTNkaCtYa2hUTmd5QlBq?=
 =?utf-8?B?YzVKQkZENzZKMllpdnpTSWNrN0htN3NGamZWN0UxamMyQmFTUDFRdlpYL1Zt?=
 =?utf-8?B?ZjJWRHZtczNZeHROZ09ZTTgxTmxCSGJDbzgwRXBCRTJZOUV5RXVzZ01FamFY?=
 =?utf-8?B?NTN6RGVXT042TkZhakJCamt1N0RxU3BnVnNIMnNTZWhoNlRrMUtta2syWXBT?=
 =?utf-8?B?Q3NjNVBwVHV5ZjFNckJVTzBJQ0Fnb0RzOUhLZTlBWFR4T2t5K2xDdnVWMWFp?=
 =?utf-8?B?cElCY2VFdEcvamN5eHhMZ1I3cm1EWG0zZEgwd2k0eUJSQXpqbzlvVHZKdHJN?=
 =?utf-8?B?Zm5TVy9yMjRsNHZ4K28xVDZSdVpzOGtsKzZyWmlMaGpndXNsQjRoRjlZUWRS?=
 =?utf-8?B?VjdESFIyRzlpblpleTU1ZWVhd3lwSEZ2S2hFTXRoSmVzMEFIeW1XTHpLZzA3?=
 =?utf-8?B?cWtwOHhIMUpBeFZ0a3VMdFB2bUh2S2hqRDBGK28ybEtLa1NkblRpOGtiKzFy?=
 =?utf-8?B?QVhQY085U3lDODFxK2RrVk9ia2hNR1QvV3RLTThhbGl5bmJxQUdVSWZRcXA1?=
 =?utf-8?B?N0VYWEZKNDk4dEdhRUNWaFlJTjJzbW5KL0JWRGVsNHFtVlJub2VnZ1AxRkxG?=
 =?utf-8?B?ZHVYNTRUcWFzMDNqaFhGL2JCSzFiWlpZQWg4MHFFOXlCaHBod3IxYm0vcGpP?=
 =?utf-8?B?V3NwZ2VIRXBDTmpJdUtlcFFQcnErdHhySENvN21zR2ZJRnNUelNrako1dEVY?=
 =?utf-8?B?MzBPTjB3cERoUVREWE9wYURyR1dSazZIemRuQkhUMkdVeG81bWJhY3ZTY3N3?=
 =?utf-8?B?NlpoTitQOWw2S0YzR0ZqNFdiSyt2dUxKY3IwV3hxRldqZ2FqKzhKR1R6K0lu?=
 =?utf-8?B?TnplNEIzTFNIcnVGN2lkQmpRNktyd0xiNFpITk9jbkpBY2pkbTRYdmVmNFEr?=
 =?utf-8?B?ekRiYnRlMXNCV0JLVTM2NmxMYktSaGtweVJ2NTV1M3JPci9vSlhGU1pXRmFE?=
 =?utf-8?B?d2M5VW1RSXF4dklLTVpBY3RUVUE1dCs5WmlWN3lJNnAvT2tvVnBWT0dKSmlh?=
 =?utf-8?B?K2cyd0pHY05CTm51d2oxZm9NdnVZNTNHZk1WRzk4blJ5WWJGSnZYazhzMTV0?=
 =?utf-8?B?Tkdza3M5VVljMXZSVk9zL290Qk8wV1llbmlYR0JhZFk5Q29haGpDMXJ6L3Iy?=
 =?utf-8?B?eUw2bytTODYyZVUyTnExL2loR3o5UVUzYWtwL0pBenpYUGZ1cU54Rk5nUTR2?=
 =?utf-8?B?ZkpYVjFmc1VKMkdmUXdnN1lGbGlZS0JzclJacEEwcmxjK3VMdTdBSzhPNFRG?=
 =?utf-8?B?cVpnallmRzJZT1gzdDU1bGRsdzVud1VTVWRaVXFQYm1CbkkwM0ZuV0l6UTA5?=
 =?utf-8?B?Rm13YmRuOGUvcUVMaHF3L3R6U05EYXpzTWU5Z2VWdmtocFROWUZ3ZFNNWXVI?=
 =?utf-8?B?THluZkVsK2cwZlJ2Mi8rY3RaYWZjZ1VMejFIQUI2MW5BSmIwZjUraDlxQXlM?=
 =?utf-8?B?UnNSMll5dHpXdEhlM1A0RUMrbE9LWDJBckZTMC9MUXA5dExkSmtLL0c5S3lW?=
 =?utf-8?B?cDhWZDVaMktTM3BKdExaYVoyNFBhZ3Y2MjhlNjg2aE4zZ1gwcGdzMW5NNU8y?=
 =?utf-8?B?RGp4TnNwYzhLZUZ0bERRNmpZenBBOVl1OC9OSFJCZTVhZ0IwY2RtQ0RQQnNJ?=
 =?utf-8?B?RE95clZmVXM5NHp2b3cyRTNKb2NWVzV6NnhsUTN1TEpsYjVYSzJ1aEtwc0dk?=
 =?utf-8?B?WjZiUmVyMXdEU1VCRXNhSS9tSndUdWtLZSt3ZW5XSEpFWVJxb2k2WVlNT0tU?=
 =?utf-8?B?NE9GUG5nbGhIREZWZzZ4VGNKQWN3OTMwSVNqMnNQd0drSE94bTY1S21vUk1H?=
 =?utf-8?Q?Hp/GRpO/h2YnyoN70B?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aed4381-2377-4a49-a76b-08df335daaa5
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7771.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 12:35:50.0343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XGvktr8TFO5bEcXSDeG4Z4aeyJ5ybywnHBmBMdEpnZoYLBtItPdq5dw0GApRzQwo8dnBOcMOTP7y0BYomWDa2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8414
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DE7A2140008
X-Stat-Signature: 59ss8kbcnstzjmgmspz3p3iasqwsskqz
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793018152-9367
X-HE-Meta: U2FsdGVkX19qv3/eX+Ifbp8u2xfJMEnc3ZuDTc31UyMzYI+S7ZgN4L+FY9a41nDSuykBuFC74nABl1HCR+YptLhuKrjGE7KDeIVD3JpmqMU9xkfuqc60ZHR9qV/kNTSwDI8jt+EqyiSqCfvJxXIwzg5ErwjwpvFdB8T+NTUTbgBZP99Lt6pfl6ZOp/piDn9IWZlsPYzKWM539zwH4IXHitadTfP7uEZMaVlJx3ynzxD6oSuLVbW2IgfvDctHQFbSB4YVyYjBUD3LD5oMYc7b39qmdNO6HH6yRxlf1pQElUcsZBYm52mtnxBSz60AQxz2fK4bLyIEr8WwqtDNy3t6yEO/jZ+LnUjMH99BCeJw/O0Z9eCbHEzoziyQC1EQy3un6Ag5liaL3GXdOQiM8UTKz90hOD6bncEzB1mQHgj0IR5mDLVbLxGp3duut/fvHCdRQooOmWU4Feqodt2dsFRKrpqAzqfbttRwxZRHv93INVKJTrMyQhMxtHrwdhK3MXMhgllPbuUGAihQmBzSLEnFvOQdn0+EX+bsSNOn3dontsdgFdFZ4J428WmOsYUQ7lcitUP7m36kxDqlzW5Q3L7dILbud7TBNAptVE91g08zxeckqRgYLB0sPx9QbsUoZc0ofDzYY7no2jBaDLukF7P5wHPuhy26z1vnxXFP6P5hrnsb4rHt1Io7awhkj7zzaqkWSToKM97jFBtKTdKhX0a3cLb+0E/QBO1HESwI9hEljJC1NbvAKCto1p0k2AyvWThVsviisB9CrfeJR1mder2hSBJkw0sXqMX3teT2GM1EE7BMvyWgy0uetunoOo4D4IUStTDMIAODZRJsd8k4hYlHU3DDA8C5I8BvmhjfEOGxFI6IxsGOZM6dsBPXXDw4z1I5kwfvhsybzttpBfnBEJMwiiAUhhKx3C/9AcKEqcb98vEaRUvxWrcE6phgoysgI26ib+PcM6YrPPG2fJImGCq
 Voejo5tk
 8X44/1c38+CpC7jiWBIdUyVEdEI/IgQBheeb535KRYzAVqRV5Y5Ywba8kaX8LGXdssjEXf9aK8rq8wmUNTjb7zKwNa53wvlGs8rYkpVmuLJ10zAAjjfAwbyKnQC+lY3YVpGnEP7DAAdebruVGwUAwBH6tRBujMQ5LLGVfsxd2CfomX+dL5DGQv5D856U24QbpXC6iDanOThLdePIh6e6Vquj0DYdPvbHM1o0GqwO4g/pe0QmIR3Gme2TO1Qy+iTqdnmsXCP3949b5lfNRYaNxd2X3PofuXG9sgVcP162Cr/h/XXTakjPE0TmpUo3Dx9eWbYUV1ctVKleW7RP/MjpxwMpTQi8Btb3qaXCe+FVDpMLoyp2JVf+q9kGZ66zuxWPjqLY/XjvMGejMng1hKdvdTl84SQsdQIsc2vMCuvJk4zQ7RVkMr3Vu0p2lK/pyjy8bIkvk5BUExqAOGa5XuX0RvI8BTSNKrBbneme4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


>>> Anyway, it'd be better to get some numbers with RL or agent workloads
>>> (especially the host memory is under reasonable pressure) before
>>> landing all these new infras upstream if proceeding in this way.
>> At least for now, as far as I'm concerned, I don't intend to land all the
>> features mentioned here. The first thing I want to address is on-demand
>> allocation of struct page.
>  From my point of view, on-demend allocation of `struct page` for FSDAX
> is indeed useful and can be landed upstream, mainly because `struct page`
> initialization takes much long time for large FSDAX devices even a small
> range is used, that impacts the guest startup time a lot.

Would on-demand allocation of 'struct page' from the device itself (a 
variant of the altmap case) solve this problem?

For virtio-pmem, since device memory is backed by host page cache. So, 
in the worst case host will provide memory for all the 'struct pages', 
but the guest itself won't OOM.

Just sharing this idea. Anything I am missing? It could be another 
optimization on top of Muchun's work.

Thanks,

Pankaj

>
> But in order to make it safe for production, I suggest reserve the
> guest memory in advance for the worst cases of `struct page` at the first
> stage, otherwise it could cause unexpected issues for many guest workloads:
> it's hard to perdict if the guest memory is still enough, it's unfriendly
> to system designers as well (that would completely based on their
> experience and hard to ensure the service quality beforehand.)
>
> Since the guest memory for `struct page` is touched on-demand, the memory
> over-committing on the host is still workable, the memory reservation
> can be removed after the reclaim path is done.


