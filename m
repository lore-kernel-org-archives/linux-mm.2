Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24D20FD8FF5
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 18:31:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C0076B01AA; Thu, 26 Feb 2026 13:31:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 496F96B01AB; Thu, 26 Feb 2026 13:31:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 399436B01AE; Thu, 26 Feb 2026 13:31:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 241CF6B01AA
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:31:57 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD315B697B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:31:56 +0000 (UTC)
X-FDA: 84487451832.24.719DF09
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11020093.outbound.protection.outlook.com [52.101.61.93])
	by imf21.hostedemail.com (Postfix) with ESMTP id EA8D61C000A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:31:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=mOId8493;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.61.93 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772130714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=goyiSbX06hm/ZfK3u3llBEasnlV/cwIG2gHLawCeHiM=;
	b=71w1hY5bXzOwIj9Fye0UWOzaVGf8vNqCKNHJ1gdprl/nsnTa1HsY9sC8SMVkSDwwYuTXGj
	gxUbIDXEnbbajGN1sFQmD5GTBF9uk9HTQFE7E1mW4Xvmj0hSt2IClBwn5QbKDxNmyumnDG
	iK6a/28Sn7A+5aMSfvhK2+u0LmRG0aA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772130714; a=rsa-sha256;
	cv=pass;
	b=cg7VD1mYVjbtCmEYFQeUWCGEo4CutlHCihb58eNSpvyQ/O2D+I+C1OO064xBp0HoKDiFY9
	WceYRWek3w4KkJxoBJv4TRk3agWzqXM/1zkUaoickuCDn5n6hKmjFwxMPaK4oVdBlzX9kP
	1SdyL6L+v+gSqDLXG76Wh4xCtqG/UJU=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=mOId8493;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.61.93 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RPM8WdQcsUv9EMURSnXLUEp7UntvoBA5VMCYOoUkqHX2/PZlFAXCQ931eq3Ms+3idBZVTLAncKeUBnTUH1RtQrO6hhJDS0ifRGvpFJHi1A/70KBCydMnKlGqhswyx5g3rzM78XDpcUICFeJbxQyFQg3W160WSIkFkt4eCNorFUIgNVisJg8jINJ38bpsUft1PMBCzsaDGLnRf4Y/xJn/09qTiQxt0CzRcop8145a9XIgFA0NEedxY3PaNk5+w1YTF3hcDtsYG6kvj9Rh4zYSKhHajbtDG0d3n4RXauxBZ/966nNLIFiPfssSX2IDBwa70LGtTvbqrRsOfpU4wP1peA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=goyiSbX06hm/ZfK3u3llBEasnlV/cwIG2gHLawCeHiM=;
 b=pujFgMz1fVawKR4jlBLR/GLL+5ETLMIV47p0hhCJIAGtyRGTcUuoOZgisGksaoPUAnj3/ZVfgg76wYGKhYjgfIRG9vBWCbYbbaQhAz9Rq3thE8zswWwMpkZa4ttMVJLyO8JRiYFycL7EAw7YBGP2gyZQRBHEmG/dILME3ITChZrurr5Q21HVxaLALVPF5tLeQEdnjIV7fIDl25ud2oSeRf7DBCcKSaW4hv92+0HGBCi09p/N3O5rxSELRn+xBIRQwLU9x74hqauThKsMdfmr26EKx0VnXgV6NA/6iot/6VFs4eFOG2fEZN9a9tIajQvBBOGh7+Boi7/PAK8argmw1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=goyiSbX06hm/ZfK3u3llBEasnlV/cwIG2gHLawCeHiM=;
 b=mOId8493MLfPsGTLA5t0wlMO+O1xrc621wgJvt9e1mPAQnBDYzsceZDMpcwH85jVj3u0I/Obj1B5eldfy6Jw3tRBfu7UNMyGejqoRinz2lslu1IgqM5WYOkGc7atxU41e8zhqzcpoZN0VT+udZhvTTyZMnzF4xiODapTffJE5LI=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 SA1PR01MB994289.prod.exchangelabs.com (2603:10b6:806:4a0::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.14; Thu, 26 Feb 2026 18:31:50 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%4]) with mapi id 15.20.9632.017; Thu, 26 Feb 2026
 18:31:50 +0000
Message-ID: <011671c7-6eaa-4389-a058-dd1ba133d8bd@os.amperecomputing.com>
Date: Thu, 26 Feb 2026 10:31:46 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Improve this_cpu_ops performance for ARM64
 (and potentially other architectures)
To: Catalin Marinas <catalin.marinas@arm.com>, Yang Shi <shy828301@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>, lsf-pc@lists.linux-foundation.org,
 Linux MM <linux-mm@kvack.org>, "Christoph Lameter (Ampere)" <cl@gentwo.org>,
 dennis@kernel.org, Tejun Heo <tj@kernel.org>, urezki@gmail.com,
 Will Deacon <will@kernel.org>
References: <CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com>
 <5a648f49-97b1-4195-a825-47f3261225eb@arm.com>
 <CAHbLzkqRjuWg7ybdkuv5xdoPz7z_q2n+0Eh0pRNoVxq-WskRvA@mail.gmail.com>
 <aZMCAWiA7XHYLIE1@arm.com>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <aZMCAWiA7XHYLIE1@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CY5P221CA0061.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:930:4::36) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|SA1PR01MB994289:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a985bb8-89b5-4e26-7da2-08de75654e55
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	fqcXN6c83pcmSAqjh6qedx1AK7biMi3rzUJu8Y+/OR7I2O0a9y/6m3a3Ihv63UtcxtBlFi37ybV1mh2CvbYtGmTw3Uqu6wQp5nnY6AigrYT6GIChU4F54wztzVrBogqOPLLN3g6NUSmeGxcuff1ohANgkNOBdsFztoWQriGRQTdL/4wxBlZZ2ldTJF2eqMD/c0Df4X2c7juRERllROcyEyyI1MI/QRNC1RDoQtYtK5umaqhrzprEw3fTCFpdHkEDVq5e0YpiqQmwgs/g6AxJ9Pg5EpRx5YUDDG0DqhsZbc3jz5OOsO47Jx4Cv9NNzHTf5i3c/72geJm0idt/heA5AiIvfqorAZHj9T2RNlk0fler3Hd6tbXMJn7q5empuneSZDAJ2fRdzkiybaoKHNSXi5rQNLx1Wd9IoccrACTbv0JHWYJDqfZ7ceC4XM3MtUfXZqw4J+FjtZpt+/aTG/TwZhIrYlOMgDkQvjxM2TsGRsXRc1g/+T79h/j/92LnLXVMH0JP3mILHX2vQ2c7w7Bfoh6XIExS2Wv54LJbCBTUAVJgz7Hv1hWBhlAFIa72DcKQg4yhg6JEbHIN19awh8zegBUUQQeHgf/ngiDYGBvahNWwcMZ1ipQXPkbxdXYahUMyBvW5na8P2doqQ0ulfoO7b3f7pOmbfJHVUngxx22O55HMQgaanbZzNSbq97uj/jptegjiuzTDikyQz8bHm47JGvP4L9luR5OGES4NnwX9RjA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WVVkZjZrN3VvUkV2anNrOGE1SDNLZi9jcHFiMFYzWmVNNW5TU2NlcHY1TmRY?=
 =?utf-8?B?Y29XTUFOTlhhSjNRYWU4ZkdrbWZIOU1NdG92TWV6U3E2TkdYckZkaGVWcFI0?=
 =?utf-8?B?MkttRjlwZmRyUGs1ZXEzVU96aWNhVzg5NjNJNzkvMnZ4Y0d4ZjlBS1FYYXkz?=
 =?utf-8?B?L2lWNGVldGV3TXY4RlJmMnlxYk85WTJBNTRmOHhPRzdEdXR5U2lHSUVKdUxJ?=
 =?utf-8?B?Y1lKckpWK3ZNUkVvZm9BeXJFZkhJQ2M1ZTRGSTRaWExxN0kzS2hsT2JaV1Nr?=
 =?utf-8?B?RFExdVFZQXBmeE0rbXBGa3ZOaEYvNW9udVllN3JDa2FSY2thLzF3WjQ1NHlj?=
 =?utf-8?B?elZNQnZGdnpFZ1IvOVZ6bjhmUmw0UWZrMW1iYXRDOTNFUGpUejhOTlVVb1Ey?=
 =?utf-8?B?ZHBFbUh4RmoxdEU3a3hpQjhEa2grT005cVBKQVhKZytDUkZURGJDMHh4NUxr?=
 =?utf-8?B?Wmc0bG4vZjBURmRWWVliOEtzcE1HaEdIMDdWWjZhOXE4R1d5NitCdEFjZ1Nw?=
 =?utf-8?B?alZ0UWQ0RUFHb2FmMTFnNUFJUlJtWVo4R2JkYmRWZlRTbkt0Y3FRMXJaQ3NM?=
 =?utf-8?B?MHJ1MzVFTi85cmdRN3JPVTdSSEs2aGtaSldmLzh5aWk2SUlHUTZYZXJwclhI?=
 =?utf-8?B?UjJIbTNkcHpSb3N5bkw5cU9lcDF6RFNsbTVrWnpVK2ZmeUliZldtRnFtTFkx?=
 =?utf-8?B?NjhuNzZkOTYrcVE0N1ptMzR5eVlsYWxodHdyK0ZBb0haaGs3QjRaUGpzTnFs?=
 =?utf-8?B?V2tTcENUdTREQzN1bmZFSXlKcUFZbHV2eVpwK0tadldVSExGVDgzU0hSTDFu?=
 =?utf-8?B?SG9aMkYxYnZpL3VTODZFNzdNT1BwbU5uVVNpdGxJV1pPYmp4VzhXd095VWQ4?=
 =?utf-8?B?SkNqQ0wzcEJOUy96ekRZT3BtYi9kanlFV2oxUWJJYUVBNVlXMkJGR2pVNW9h?=
 =?utf-8?B?aW43Sno5dWpsQVZPbUhxMHorbzZCcTJkS3FKd2ZYTFVNK25xak03N1JJOWpP?=
 =?utf-8?B?MXVnMXdialhCKytKVlhTMDhzNm5hY0tKWjl4R3NCNUViRWlFei9OWVMrNW9B?=
 =?utf-8?B?Q28vWHFRZEMvOFRVUG41cnVyMzNBN1ZzVy94eUZnWm56M2NUdFNrREt3dU9u?=
 =?utf-8?B?bGpVSzFHbVZwbVd3VTF6SDJQNDcxcEc5dnB1eS83UkJJTTYweUlSU0F4dURI?=
 =?utf-8?B?aUpzWDFvN1N3NjQzcWFMSnBwRDR2aTd3NEU5ZVNZYUdvTGZSOW9WdzhJemVM?=
 =?utf-8?B?TVFSeWRuN2pRNGx1RjIrZ2Zsa0FJVllGL2xsOHVnSWk2UlFxNWdsdGVXdVFr?=
 =?utf-8?B?YUVDMDlWN2IvY0JxRUZ6VEhZYVpaYytxTU41L0lrby9PaVdGanFqRTByaEdL?=
 =?utf-8?B?dk9OaU1tamt6WkRXdzVyWStDRnpkampFc2FZcTU0RTNjTFRyNUxXTVUzMnhD?=
 =?utf-8?B?MzhlOGJ5TkRKeEViaVZqZFlvdTEzUUtNcnM2bHg5aVU2Y3o0enZKNDZ0UlA0?=
 =?utf-8?B?eWxmdThBWmcxbUdYa0lTT1FKQjZwdGE5L0RkOCthYk9kYmhEWVB4bUlPM2pn?=
 =?utf-8?B?WnNUQUdGS3VsbFN0bzh6RHpNbU91Q0xlV2Rsc1g3VjhrYTdCUG1vMEVWL2Vk?=
 =?utf-8?B?K3M3dmpnNnlDcnVDTU0vaTIwL3BLU2RiNURJWGdKaENUdy9HY0dkQ0dyOXlC?=
 =?utf-8?B?azFWK3ZlRDI0N2ZSOHpiTHdrSFhzOGpmcVJlNTllY01YemVhS0VmVXgvaUZ4?=
 =?utf-8?B?dUxNSmhBTzdPNTdLbnRXV0dwcTExNTJhalUxWFBPeFZ6Rk9TSWYxVFFoUGta?=
 =?utf-8?B?dFpxZXZLcEpLOFY4U1NOcGpGZHFSMnR1SHZyV0FVdnFCOFJEdytaUmF0bElo?=
 =?utf-8?B?UFQreGYzK1FyZmZNdStFMHREMERvb2dsQVI3ZXAwNUNOZmZVUHFCUFdIL0JX?=
 =?utf-8?B?cFR3R2Z3eS82WXRBc3RSMXhNd25YMjU1bVUrMTQ4OWtIaEZVek9oMGlzQ2tQ?=
 =?utf-8?B?aUNWUEZ2NXRIQk5tOXRpQ0ZTQTZQUXNqSE85Yk9VR2tobjN4WlBTRG5BWkVM?=
 =?utf-8?B?SERjajVVODJFaFRYU2hFSVdyaUw4ZjJZc05ENEJxanRKa2tjTmJSUktpV2g4?=
 =?utf-8?B?alJYVjJPdkxLT1BrOTNzSjlLekxCQndGOFIxWnFHbVZWRXNMejlvaWZ1ZjNP?=
 =?utf-8?B?QkVuZnY3RGlBUi9BY0J4UEVBL2hYaUxNUHlJM0hvTzl3cnRYUTd3QklUK2dP?=
 =?utf-8?B?Sys2Nkl0RTRJYnUwMml0clVuV2VFQ0JuZmY4VGwwUnFxRnF1VUNQaHZUamEz?=
 =?utf-8?B?RS8zL2lQdk05SXZlaFp5dVNhc1RDWWtZZGRObHYzcVFmYlBYOUZGaUh5aU9y?=
 =?utf-8?Q?Z14ryTcgGqM49Uno=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a985bb8-89b5-4e26-7da2-08de75654e55
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 18:31:50.1495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ztq3A9ylLfGiZCADsCflMp9OerJgkeGQjGicZSZFIjmAcMzOlyiKQu2xpR+yipQO5K056wckP6yqw1YzODRWZ2aWwk0fyxBv0qC16nW/fKY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB994289
X-Rspamd-Queue-Id: EA8D61C000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 4wjwqhzgxcfq87q6zxq8z1tweuifb81r
X-HE-Tag: 1772130713-842282
X-HE-Meta: U2FsdGVkX1+6J6gfBT6DRChMZjRFBRnLL/noEn7TdaSF68I2N6c/tqFA4FspPLKmYn4uBTGXA+hQTxsOqU15m5231qtjl9C3Tw5FNGZMbhj2gJ85b4BzGzGWj7LCbGBGf9fre+ZB55e5mQQISj1R5XbB0BR1sYkasT6K097zNbUkGZap8ashRwif781udY/f7F7JtqKtQAtdpjWya4RSVIdSpFTYsfk+/w//18tVWJb1VL2AZ29VZTGbJv175lHUN4/LFc7HlYaP+weXf6UnMidj6c4Ngs/Qh8q+7t7l++PyiJp8N14VqHn+oqsT4mVTWnkZfpsjJ9teJeeABD5JVQrfLPdkT6yw86WmBnVNmww1UafZ41182vtPXMuB0YboC+lp/+OSaxGZqbQhvyi+0cYXvVwo8gTi4zmMqDz3U+nQgO6fBETLr0hLjsMtMN6Gfb8Nwjwxd3HllzXPXaZuRsgFlNTNMwKIUnWE+FoJWe1g3Smjhtjq+F0hxXb6Ga636ai0LEzVRgDXz+u4FPMIU1RbKUP7xPqjpUAvGtWNbHTp5gUExpjPOpPW3D7xonCBJS50dlPz1j6fSJcTWxTFBkV6PwAagdsRaSeooxoTAWOUOwpKIa4uWFgR4/5UWxuNCYtQzULDTGADUO43N9juyWDpJoJHpmxZ8IMhDiqpLk1ukcvT2KJJCVcNmHPXrePvhMpFuiGoZMc4uOxMvEAAx8SJ6OWoCk3QECn4z0zwvxxL/tcsC9rHSoorVq/Nu++Z/ACIMKFYUkYug1ULqnXarbaHGiOHcGZBBE+lpZETje6rhGdZfCPzxnIMBYzdLRa27xlP403h5/57Htj1BDKjG+1GsBf8AnafbYiL1HTMLDZUiRsBWV+EG/YsVj+STzYe3K/DD1zztsSsf31QXLg1XiJkXhiRl7QYle9/HUarJGpTexfF6zZTSZn2D76uR5xBhyyHMr+PXE3kRxV5KjF
 a3vwxiDd
 7aS2OKRTv36ZPjt8ll4SEBSLheYLTzzhyJOT3uuwJnqmq4TrZbzVlvu5GJXOJdu3X/0VgF/+XilM/QnyxcONlI8Gv2I/ZgWXVJqGOWeQiklrJFo3HSIv2wc0D2AZ4e6G0vKghp0zqNIZ/agsLgcCr3tcn560/p/KYH4PoxcG6qJ0LwSAG2WPtPxqSkpOBUO7xYL9L//YDNGiHI9PpXlO9AA2FAAeoChBOpoVc2D8X02RyqT3LSNEu9x98mIBu87XdD+frQPTaVJyycfflF8w7aV4KsVGUk4POvMfrB+UkTmV395CglbVdd4uUguE/CURO6XK8TyTwGaPOmxGWDgRuwLLTBDG5ZoYK8VQ4UJEtAdXYOb86n+sCtTwyTCfYAi6qOmGTowB7sR5AqgqpM3Igme9xVggUFoDspQxApR2ZK4LSfGik2ZWoy8PUuHq915oBwemQpQ/NF/5v/vW3S5Sm4rgSyr/I6zyd9ZEWAM9oHKn4uDWsJKv3o5RcLGse08u9rsciaf14z5fPt21uVOGM8vG6KwkEKNWPXaH8j3RNTsnOIsfdvGxQwc+KxJSsolu9vrrlwbk7113PCTxOH9ZV70552vGs+DM7ZLTZF2PM7cgByhT137Ccvz41jw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/16/26 3:39 AM, Catalin Marinas wrote:
> On Fri, Feb 13, 2026 at 10:42:21AM -0800, Yang Shi wrote:
>> On Thu, Feb 12, 2026 at 10:42 AM Ryan Roberts <ryan.roberts@arm.com> wrote:
>>> On 11/02/2026 23:14, Yang Shi wrote:
>>>> So, the code flow should just become:
>>>> INC VIRTUAL_BASE + percpu_variable_offset
>>>>
>>>> In order to do that we need to have the same virtual address mapped
>>>> differently for each processor. This means we need different page
>>>> tables for each processor. These page tables
>>>> can map almost all of the address space in the same way. The only area
>>>> that will be special is the area starting at VIRTUAL_BASE.
>>> This is an interesting idea. I'm keen to be involved in discussions.
>>>
>>> My immediate concern is that this would not be compatible with FEAT_TTCNP, which
>>> allows multiple PEs (ARM speak for CPU) to share a TLB - e.g. for SMT. I'm not
>>> sure if that would be the end of the world; the perf numbers below are
>>> compelling. I'll defer to others' opions on that.
>> Thank you for involving the discussion. The concern is definitely
>> valid. The shared TLB sounds like a microarchitecture feature or
>> design choice. AmpereOne supports CNP, but doesn't share TLB. As long
>> as it doesn't generate TLB conflict abort, shared TLB should be fine,
>> but may suffer from frequent TLB invalidation. Anyway I think it
>> should be solvable. We can make percpu page table opt-in if the
>> machines can handle TLB conflict, just like what we did for
>> bbml2_noabort.
> It's not about TLB conflicts but rather using the wrong translation for
> a per-CPU variable with CnP.

Ah, yes. It may be just a simple TLB hit for the other CPU due to the 
same virtual address is used if TLB is shared.



