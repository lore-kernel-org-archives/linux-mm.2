Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B315CCA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 14:16:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D7458E01FD; Fri, 15 Aug 2025 10:16:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 488668E0003; Fri, 15 Aug 2025 10:16:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 377AB8E01FD; Fri, 15 Aug 2025 10:16:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2624C8E0003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 10:16:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CC25C14018E
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 14:16:42 +0000 (UTC)
X-FDA: 83779192644.17.98A1C45
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
	by imf26.hostedemail.com (Postfix) with ESMTP id F41D714000E
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 14:16:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=4aFwVGTh;
	spf=pass (imf26.hostedemail.com: domain of bharata@amd.com designates 40.107.243.66 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755267400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LqSzzXL5llNtRhQTEX5lN2Xl8WWhzzS6kbm/VNBLJog=;
	b=Wq5uDddMHSgvPjhnPjxnID//mi17Rh7m7ntVFrMfvGK4f+dgd1fqGX2E+4ydp3tSXK7fBx
	VF364/XGdGmQYZ/Dknn/pkQ22tWkwP/76p8wA8dVvuj18hvUlv3HetY2hlM7kyAY1ooGWy
	9uHSy+f4mKiS9gcDoguihHxN2QVjpuA=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=4aFwVGTh;
	spf=pass (imf26.hostedemail.com: domain of bharata@amd.com designates 40.107.243.66 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755267400; a=rsa-sha256;
	cv=pass;
	b=uYL9+JTJ7VCXgeAHEaQ69sUQHKPZjS3THvvorxq/Yogo75FES1aMV8YgCe93MbxT7BEcz6
	UUV9jcHzi0HICZ+Q1MdbyIlBk+AlCc5yoi7cRUrDbMzElCBTl+Bn7rFJd/cgYa7yjqA/UK
	lyxdPH9vZi/J7pMK6cWXBX++AiZbCSk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EFdknYeYlo+lf+1YSoY6HAUddlUfk62XnmuN8KJoukee1Tuvp6FGIK9p9QgSQomiclyCjKaW8xrVtYjTmA+hvPf7pe1Kjv7X+9B+dC5PF+/MQAgRi1c0/GC/Xiau0xuJESaXCLWHax67OVhq1oiRKfHb5hjfejGi8+XzzqqLr2n2LpHdmOb7f7e9PJ4kHw/iZPldajley1cK6Y3QD401lOZ4whWzPNAQ8OzodCMETDBN09+FdMEQRBWK7MlCP2fAgbLNMi1dH5KbEVAGTBQi4m1V6OGhKexrivWormuV0hJKxxzIzN26XbmFf7jAdckvhgluTXy6Lirdin9CgmS9JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LqSzzXL5llNtRhQTEX5lN2Xl8WWhzzS6kbm/VNBLJog=;
 b=YQqhMWWrOQt8dxk0ezxivAH8o/5LAdmqJ12WuuXToD/EoOk9Jm5UBkRq8ieCEym7QDzApoe4yl9Q/19YG4SyDlH17kj1W3gkMyq2SeyTQ9TkfMfPvbLdCWbGntY/InhLVIVzvfRrAqmhJdv5O1x5/1CLPNRn2cOoUndxqUo9u3KE5XChK/pYSwfNv9tx+2WsyWFfqXlwxpuXVM/xHmA36amBxeGHbW2AvuYF/ZlskccF45GVgG6lnRpzE40t08cDR3/HmQW7FI2z/8lBoGBIGcx5nttSuohM+8r+Q/Jd63i72OHtcXN/Nk/f0gz0aN/aowdjtElUtqGOv9uOVW0sMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LqSzzXL5llNtRhQTEX5lN2Xl8WWhzzS6kbm/VNBLJog=;
 b=4aFwVGThhht0/jR5qdDYMBGZTESJKGXMGqHuO3mxZRYL+exvXfW0dzGMfq8ulgjfDFIxyPPpPzjxu00fPb7w5mAvagqgCv9cFFONFPz/334anGlIwmJFLWGXe0XVVXAQm9z0iM0+VhZifhdi5FyoxoNlf4G9jwa+9PvaQN6LyMs=
Received: from DS0PR12MB6439.namprd12.prod.outlook.com (2603:10b6:8:c9::7) by
 SA3PR12MB8440.namprd12.prod.outlook.com (2603:10b6:806:2f8::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.20; Fri, 15 Aug 2025 14:16:36 +0000
Received: from DS0PR12MB6439.namprd12.prod.outlook.com
 ([fe80::ec83:b5e5:82dd:b207]) by DS0PR12MB6439.namprd12.prod.outlook.com
 ([fe80::ec83:b5e5:82dd:b207%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 14:16:36 +0000
Message-ID: <8565f305-f36d-42a4-abf2-24e064067fc3@amd.com>
Date: Fri, 15 Aug 2025 19:46:24 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 3/7] mm: Hot page tracking and promotion
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Jonathan.Cameron@huawei.com, dave.hansen@intel.com, gourry@gourry.net,
 hannes@cmpxchg.org, mgorman@techsingularity.net, mingo@redhat.com,
 peterz@infradead.org, raghavendra.kt@amd.com, riel@surriel.com,
 rientjes@google.com, sj@kernel.org, weixugc@google.com, willy@infradead.org,
 ziy@nvidia.com, dave@stgolabs.net, nifan.cxl@gmail.com,
 xuezhengchu@huawei.com, yiannis@zptcorp.com, akpm@linux-foundation.org,
 david@redhat.com, byungchul@sk.com, kinseyho@google.com,
 joshua.hahnjy@gmail.com, yuanchu@google.com, balbirs@nvidia.com
References: <20250814134826.154003-1-bharata@amd.com>
 <20250814134826.154003-4-bharata@amd.com> <871ppde4b2.fsf@DESKTOP-5N7EMDA>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <871ppde4b2.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR01CA0145.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:68::15) To DS0PR12MB6439.namprd12.prod.outlook.com
 (2603:10b6:8:c9::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6439:EE_|SA3PR12MB8440:EE_
X-MS-Office365-Filtering-Correlation-Id: 006689e1-9c8f-4ec4-85c7-08dddc0657ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M2JrYTczd0NScThnQ0Q2TTV6dXNBa20zTEtXY3ZCOGRsSSt3dEJNTkpXMkgv?=
 =?utf-8?B?VVNCNTF4N00rdmJlWG5tMU9aZW9wVlV0RlJTNnZUQnhUKy85TUprZkVyY0ZG?=
 =?utf-8?B?YnowYWEvdlJjQ1dMZTFVMXgzMittY3RZU0V6bTBCUVV5c05CNi9IVzRsTGtC?=
 =?utf-8?B?dnBQM2p0Y3lPbzNuYjduV2VYRnNaS0FtaHhCL0ZheUtWenVUeHcyV29jSXFL?=
 =?utf-8?B?ZmVlckpvbnlvVXgvQ1VvMnh2Mm8rZ0VmNXI5MnFVbEk2MWlCZlhYSXdSWUJD?=
 =?utf-8?B?bzZaK1dQd05wWUtFVVBJYUxReE9KWE9OQzh3ellWS3djb1BlblpjOU5JSTRU?=
 =?utf-8?B?a2VqNnNNZTgyb2NFS0xvMHg0V055WW9VUjFWRWdPak9La2RQV0Q1RnJzdUxi?=
 =?utf-8?B?U3JjczZFL0VxaWp5VnQwdUFDTUUrbTFuandVSnllRWw1ZnEyWU9uK3VKMTB2?=
 =?utf-8?B?TmFTbTlpREhBS2RpQlQzdi9KeEh2Q0p3c3g0dzVFcVR3MTg1bWIrVzFIcVpr?=
 =?utf-8?B?Q2hmbHgzRU5yOXBiQ0VObks0cFRiNElDaDdQamswTm9LOTRDWnJqYWtIL3hr?=
 =?utf-8?B?K1ZQZGZDbkpEdS9wWHBjL1FheEJoeEE3bkFEckNUUmpVWDA4bHdJQ042L0JH?=
 =?utf-8?B?alo5bmVIaEo4cUNpQTRlSjNFN05Bdk1Wdld6SWI5YUM5QnlQL0xiTlcyWDlh?=
 =?utf-8?B?cFpaSGlyTU8wUU10bzdUc084WjQzOXlmdEhkOWE2Smx2NHRFaHo1d1pwUHNS?=
 =?utf-8?B?MThuckxDamphN1VKaG1iUjhUellUV1Bpbk5vaE5QdmQxY0c5KzJ2N0h2NzhU?=
 =?utf-8?B?RW5uVFRxMDduRUZLQkhwU1NtRXphTTRuZ1ZBNXlhU3FkVGJzaWlwa2I2TWp6?=
 =?utf-8?B?dW1oOXhXdEtrUTN6Y3hxV3hGZG5jZHFzRWVoaUhFQVNOZk9ucHBRTjBzMjFK?=
 =?utf-8?B?dCswVjlSQXVVUk9aNjliQ0xCRDFMSDRrY0tQeWxLbUxUb0pFVXMrbGRQdmdB?=
 =?utf-8?B?L0IxenlMYjl2ZytOMlNmMFAvVDFCWDM2c2FobzJPcEo0czdCYko4anVHS0hW?=
 =?utf-8?B?N1lqbC9uWXFseWdCZDNYSFhsNEl6NUFvaDE0VzREdXpyMTZIK2RtcDV2VFRS?=
 =?utf-8?B?LzlLc0NHTXJ0WmVveXpPTXgrTFd3WnVZNjY0eld4Mi94dVljQkJ6S3FqRlRD?=
 =?utf-8?B?KzIyMVlqUXJCSkkzUG4zYzVCNGZXODcxc2JIRi9aRGxSeS9zZDFzcEx0dUhL?=
 =?utf-8?B?UXcydjlSNldlZmdueXpjRk9aNHhYVzd6T3dBRTJoZTRGQ3ZWL0VHVFRNMVVp?=
 =?utf-8?B?OWw0T2IxUUQ4S0p6bUR0R2RtZlpUd3FnN3phVFFmWnVERDIzNEhaVXBsUS9J?=
 =?utf-8?B?d2VuSlJ5Yit5Y1JJMW5TeUhOWjcrL2liL3E2RkRZcXNZd0dHWGNHbWIvMTBn?=
 =?utf-8?B?WEVUcTVndWxhNHpSTk5Jckc2YVdHM001bGRRbnphM1p3ditFMHRFNVU2WW5n?=
 =?utf-8?B?bVVMU1hoUzB4NFIxRnRHNVRUc21HUTc4U2kxellHSTM5ZS9oYWprbFU4QUha?=
 =?utf-8?B?N0dIRUdaM1A5NFNGN0JkRzBVaHIzc3JOVWxDeVk4Z0IweGJJd3U0SFpFY3hj?=
 =?utf-8?B?aWlmNy9Sb0tSMkdaSEZEVWR1T25ZL3oxUEROd1JOeHB5UEpCcW1zdGpRZktP?=
 =?utf-8?B?ZFJBWXUvWDBFVjk0dkRjUlpDZUQrQldISzlpL0NPTXY2Wnl1UmhRQzc2TGx4?=
 =?utf-8?B?SWNEeUIxc24vKy9VWVRndjBWNXFQdUlRamFRcElvV3lvUTVoMUs0U21Rcjk5?=
 =?utf-8?B?UjR2WHJudHdlVGp5SGszbGMwNy81bTJVSFl1cVA2bE9xTU5nQWx4c01ueEFj?=
 =?utf-8?B?VmZrdXpFVnh5dyt0enZsUXF2MW0yaGh1ZzByRXhzUjZjUjgxek5uMURFVTZX?=
 =?utf-8?Q?/AfTP1Cn3N0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6439.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NzN2UGx6R3A5ZnBQT3p6MDNpYkVQTXpmSUlKMy9NTnRYdUswOFZaRlBOa1l3?=
 =?utf-8?B?RENwUkVkeS9Tdy9FVG55Vlp4ME5TZENKM2trYW50ZlZ2N0JqK3Z2Y2hvK0Qv?=
 =?utf-8?B?MDlyWXUxV21sWmFtRGFVdnZRQThiU2JRNWl2YkpMSnBzK0toa0VYeHZTcjNO?=
 =?utf-8?B?MFZxT1B4NVUxTExRbU9yb3IyaXl2cENlRDVGaFNJY0o4TExDRUNEdVpXMng0?=
 =?utf-8?B?SDRLL3ViZkdwUEpaN2k1dktvMUd5UW16c1RyVng2REpnUmxOYUwyZWYxS1BC?=
 =?utf-8?B?NEtYdVhuaWFrMHU2S2NNT2x3eng0TnZNamFuN0VmcUlab0lrb0J3UlE4RmtY?=
 =?utf-8?B?bTJzYStCMWQ3cGx6ZzRoRXQrYVRyMzdIOHVMb0JQNzcxVmw5YzU1SjlKNmdJ?=
 =?utf-8?B?RTM5dk5GekFIbThoME1CQXJsa0VWa3E0ZytyN2FBRkdqOFJWOVdUNW1MTkMy?=
 =?utf-8?B?ZXYxM1pybHFuaERKdTFPNVdldFl0VTExaVRMZFhOQnRpZXF6bklaT2ZRakhQ?=
 =?utf-8?B?aXNSWXVyc0ZkWUIxMm5GOVFtQUVYR1RNa3FieW9FSEVZakJDNW5OT2swUFNZ?=
 =?utf-8?B?Ris4YnR0ZTFOSEphVHdieGNBR25ZSUJOd2huelVDRXk4TnVuRjFhMit4RE5B?=
 =?utf-8?B?ZVIvbzh0eVlnY1EvM2FSWFh4YVNHbnNuNXJUSkEvNXNsdWpzOHExMEVIZlRE?=
 =?utf-8?B?TkVyNWFlZEQ2ZGxEVnErRjZZL2NEZHRvNmZSNUhHclpKaSs5N1g0eVU3aTh2?=
 =?utf-8?B?WW9pR1RveU5FUEtic2JacFhxejJSMm95djYxU0E1UkF5NDdCdDNnUndna1Qr?=
 =?utf-8?B?U0J4WGdiWlc0QlhMREx1SEdONjA2aVhqQWgwTmhMTjJXSXg5Z3E2NmJlSzgz?=
 =?utf-8?B?bnhvd0FJa2ozZ0ZreUd6eDBnWm5oZ01lTXNuR1drMk9CV3o4dzJoNnp4RWlR?=
 =?utf-8?B?NUwzSGRmZ29ZNnRmUThRMFJLNStEajN6ZENsMC9iNjllSWRnZmN4M1pZSFdl?=
 =?utf-8?B?cXdNWm14eGVPYW9sTDRjRDZWQ0hWbTJQZFY2WlhSK1QzME5ScUVBZ2V3V1Fl?=
 =?utf-8?B?S2VTUmY1WGl6RFUzWXUyS25maG1IRWtIUUNtT0VzZEdtaDBnM0RTaXc4S2sy?=
 =?utf-8?B?KzFkS1paYWhzSmJrVG12NVNhUm9haWZsZlpiL2VkRlJMek9GRzVIVXRhYkEx?=
 =?utf-8?B?Tkd6U3FZM0Z3U3ZYYWxZTjZYV21uNDY2aC9xU1BqYkVrMnVma044bHU5L3ls?=
 =?utf-8?B?VWNEU0lIQjd4aWs1SGh3WTI5ZkEzekkvMlY4dzZQL2FXbnIxclBIZTkxS21Y?=
 =?utf-8?B?WWpVczdONWFVdkc4YzFrbGw1VVowamhLYWlaUGJ1WXVTQ0JlcnZBRHJubzdw?=
 =?utf-8?B?T0EwK2pSRjc4V0kzT1lSTXV3Nkh5NTBXNjU0ZXoyaDFsM0l3NHUraTFQMFN3?=
 =?utf-8?B?Q0ZvTGgzTjJuUFgwc3ArUXJEUUhaTEZWTXo4KzhWR2FJaGxBYWRPZXdNcjJO?=
 =?utf-8?B?ZUhzZ3UybnU3amVPWDkzaXBHNFV1czBJcDQ1bFNqR2ZpamFOZjBDaGVqajM1?=
 =?utf-8?B?ZU5wbFpmbGNobDA4SzRaNjJHYndsSWk5ZnRrTEJUZzh3Nllsd0VNblhnd1Ju?=
 =?utf-8?B?bVRHV2FnYmJlUFk4Y2U1TjBGWk5jR24zdjF2M2F3VzVMM2c5MlRHUHdDTDNC?=
 =?utf-8?B?VDJaT1hGZWFtNDNtNDlGTmtnOWJMd2VhNHBZYVk4aVZDaHRITFlFQ2RqNy9o?=
 =?utf-8?B?T0tpdmZWNHo3TFREOXVMWittdlRoVzlTNGpaM0dqOWhwbjJxMUNpZTl4ZHJE?=
 =?utf-8?B?Y0ZETnJmbUsxM2ZBQnVqQW90L3A2MUlOWmgxVlVyd2xNelFjeWxiQnE0K21F?=
 =?utf-8?B?NndOSHNoaXJWVUF2Sk12U2laUzgwd0ZlTEdzSElwMUorb1g0VVBmQzJERHlU?=
 =?utf-8?B?NjVITVRUQkE0am9KSGc5S0I5SVhKdy8wNzIwL1hweGtJKzBkL3FyNUdrTWFC?=
 =?utf-8?B?b3RQbGNZVFd5ZHl2Z3Z4eU1TYlFDVWVGOFhpaXdpdW5XaWJCOENYb3JWTnJK?=
 =?utf-8?B?b2lJVm5jRzZpRitXODU2ZWdsVW1LRnRjc05jaDJIN3RFS0NwRmhpUGpPa0sv?=
 =?utf-8?Q?GBlzfOp1yQs1SSkEqZxToqnT4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 006689e1-9c8f-4ec4-85c7-08dddc0657ab
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6439.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 14:16:35.9397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pDyX6ZOPcNr8VC87iGSDTFOVSaUkOcffOxUEkEKD6wDSz+GvpoD6dy8aww/hABo0lQssYUoQOD1Pdw15wF81rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8440
X-Rspamd-Queue-Id: F41D714000E
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ed6nt6pzu1f6zdcqedxzt6g5oosdzihn
X-HE-Tag: 1755267399-63689
X-HE-Meta: U2FsdGVkX1/B/yQByNRQs6xpec+xtjAD+Wc2jx7hxB/1YrqTehaZ8N196cNJ/5n83ZnhJJfMGZG13MpRBk75r00jRrXG5UjZOl3HetpB2N8FthVgc1Djm6Q404U5EHq79ODAKc6AU5HCLeE5W6OvNbYWCaBLtWrT3qIB/YBdRR0Q+aMfecparlsZZx/ra5kIJga+PUSUIJGqUoyVtH7QJP9NaX0HCF7SHiVT3mXFhofM8Y9LmYJIqNwqs4PnUbJNNVeF6vTiYktzkezXpIU9UcYmxOXBhUcY80INm/Inbj/kCEoiED54N6gdFJbkzcvfstRGxwl73S0Bqt0ZssMztwI60/fUeuZyAb0PScInDqq0kcizUOef9LuvHZLjx1/CpV0mBY7JwSfiUk63yGlUksqTWNmJCncbSL0g1v+Zv7b/oJuTfL6lT3wQFMwR08Xr3YeFYRD/beQ4m44170POGWqsQr5IeWjSqJ31/hjDMg8ab395y48VN6N7usu5eUxE6DZaQLiH6CMv8JBBG6RutxfYy1NKipiIubBIRA0w2u2Bbsm4JtybAt8pA+IotYHJLDY/+R+j05L1sNTKVbOyC7ZpmRoipTzotaMU6rl42uBTU8J/DB0usLA6bvy2bcQrw/c8QWiJXfCkrb8vOFcbw9YgM6L+VQ6t4ZSBGfrwovKPIj1EU/6zc9GijdKUPs9UWBNOB/S4T+Ykaqh2xYKUtSxxik/BYz+EiOoLPJXxgQ0OswXA/EhVaAtHmTdjrFC0xa235PvNeE8pMRLJBPyUIsv1yYcAkn6skSmwaw9+i6lA/+i1a8RzHVWJiwYAsZedRohNhSCYnm2sZolXdf3/XpRYqvUkVHEJGNyjWKHNZbBPYUY3E4b8iFO3HqcEny5Y2yjKICxYnVa56w7JSO2xiOfJW3PZyux3eh4MyIKP9iVvMIWgtESTmNlpXvhumqOICpWCosBOC48J+BjB21U
 0uebZ6sr
 4+id3eYv02cTf5p5QkO/1GIWLPyf2WHZhy9PTsDSRYIqM0bN5utjJushH0tuBgte9m9eYYvsBY66SJf2n/V3mbSUy88ZY8n1CDEQRuaWxYSHD5cJ1uFso8xMBhELOlx66qZZdQlrq8wgMmU9xW5IqSmW/l2gaDSFyFoe9Kgm3lY1gtQqI2X6mS9EvZyTZqDyDnTG3C5VU3gEoxxyaXpwT6ltfhIBcNsdbrmHwLoglltI1TOh4KJ1PI1pThXADAYTvJca1buwk3nK5VH7NL/JDAGi/iOob4fWItmZW2CgzBDNSTnselQ7EzLSZCTEoBorSfj3gEG6HgeGDD8yI4a7zjyPq675vNmfHnGTgQ4o33kmb9EIsj6urtO1MBC1Kik40rMNwG/w+NT+FPB7X8xLTYp0SnMzi2Lfif0GdjLRfijfCv285JCvkJLEPkTOP/oksufvZyvqUsj0YxGNThAQ+s2tiluurURjv4CFswbmGodU9mW7iBmgYF5pcPm6jR1Tthcf4ZpKVxDrcxwcF/SEvt9euNarFBs07j2x23wajRY8/rT5S/HmbtNrgExgcYzs6IG7krXZatT30NI/SuJ8G0BytZT2ML6pQ9/Wu3rdWW3d97vI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15-Aug-25 7:26 AM, Huang, Ying wrote:
> Bharata B Rao <bharata@amd.com> writes:
> 
>> This introduces a sub-system for collecting memory access
>> information from different sources. It maintains the hotness
>> information based on the access history and time of access.
>>
>> Additionally, it provides per-lowertier-node kernel threads
>> (named kpromoted) that periodically promote the pages that
>> are eligible for promotion.
>>
>> Sub-systems that generate hot page access info can report that
>> using this API:
>>
>> int pghot_record_access(u64 pfn, int nid, int src,
>> 			unsigned long time)
>>
>> @pfn: The PFN of the memory accessed
>> @nid: The accessing NUMA node ID
>> @src: The temperature source (sub-system) that generated the
>>       access info
>> @time: The access time in jiffies
> 
> How will the page hotness information gather with NUMA balancing hint
> page fault be expressed with this interface?

Something like this can be done for reporting accesses detected by
NUMA balancing -
https://lore.kernel.org/linux-mm/20250616133931.206626-5-bharata@amd.com/

However we need to bypass the hot page threshold detection and rate
limiting and have the same or similar functionality implemented within
this patchset.

Regards,
Bharata.

