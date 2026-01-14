Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CD0BD39008
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 19:48:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF9296B0005; Wed, 14 Jan 2026 14:48:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA6E86B0089; Wed, 14 Jan 2026 14:48:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 958A36B008A; Wed, 14 Jan 2026 14:48:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8321C6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:48:12 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 33755160600
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:48:12 +0000 (UTC)
X-FDA: 84331605624.29.25871A0
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013018.outbound.protection.outlook.com [40.107.201.18])
	by imf23.hostedemail.com (Postfix) with ESMTP id 357A214000E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:48:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="GuFbK/CN";
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 40.107.201.18 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768420089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MhuR1LiAVdrVkHn9zisJkr0QCEzjrsnw1A3gaD7RxQo=;
	b=NcE5AyFPZsO/N6HYejH85cvuUVVEmTITjMLju6L5O39PqNZAb7OYfTPZOkfEdMJHpUySPZ
	xyui1XTQuV8v0DiLnaFa0vAEduaoKo282/1cn0Ic5fRHkU+0lVlDXpbEJxHDxEz+hHBrPB
	L+R8WhnMsbdn8SVOINYaTTKMHvuj3gE=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="GuFbK/CN";
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 40.107.201.18 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768420089; a=rsa-sha256;
	cv=pass;
	b=WDhkSYEelC4lc5ufDDKkK1hG8Cy560Kk1ruYPFfzfZE+U3kzb+NgbiATf15kgNLvJMHPFo
	DASJ0NkQhudBAhIIokFXD7jSNaEkewhJCMfxM3M1XC4mPxHnNrWksZO0V5kgB83UquZCeS
	xSmg9vHFNXS4xFDptalEYOrDl4MTQF0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PpOZNHowYDl3Nx+15dSoNEKpvlE0tsxynAEiHx8PxSund5EiIQq/xeZhuCjHytKE2NnagBf1VpOIfcchtFSMxwcBKspgIfAV/bWccqbGnZCdvLQ5OAlhsJmMEz1ie8HKEfjAv1wAmXIfdccdTgDJ+XxqghYssXjxyWJIdVuj8QhNLUbhjsdSRRieFU1H4xQMZF5wquqbP9ERevB1RQyNNyOy3PUU+10Eq0CNXHTw1PiUT47vacCGBQrCzGecdCkJ3mdxYQhgTo+c5IJldBqW5P4AZeqn13JYTTg9tpTe/+3WK1iBI5rUPPGIHy2o3poUYuilIOWJqjgWBHsp1BITtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MhuR1LiAVdrVkHn9zisJkr0QCEzjrsnw1A3gaD7RxQo=;
 b=hZzi762henbOYprnnseYiTritHPIUZ7+N2PEkOmAHlcoVJW8fgvD71z2VYaueR/YCqOJ3B3zG1jHX7wGIdHi9gc3idrg26DG03NhS9pTwuyw3FMrZwrRB1+C79AAWjLhgCwQFkfBK3dxPsrKdOxRBHYdfVkCyD3YNaixL92oLrn9+Dq0O7g1sm6k6OWwwUmbd+lAiYQaW43wdEM2H/la0aOBxpomfCH18ZPnanM/WYGRyLGihtJMKtNh7f3lmy7tBupE7HMlOOPJ75DuRtKclaO4A6C2+e8t/x9nkK3t+swAfko6iCy93QQg4L+aTv6Ap2Mv29cX9NmuzYKJe/b15Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MhuR1LiAVdrVkHn9zisJkr0QCEzjrsnw1A3gaD7RxQo=;
 b=GuFbK/CNKpsbv977ExQ9XjbOq1CoLKfwKUH/TVVFn3In3owSChw3avrw5JXp6VkoFcY63LAgjVaF/F/KLfRsZc6a0Z/1wPtkXPX6kNvViay2uK4M9gE1Wva6I2Bv86jM1kOOVDRz82GpK8bznoeE5SUYkv1LQ9oJdspSLytf/10=
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13)
 by CH0PR12MB8532.namprd12.prod.outlook.com (2603:10b6:610:191::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Wed, 14 Jan
 2026 19:48:03 +0000
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d]) by SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d%6]) with mapi id 15.20.9520.005; Wed, 14 Jan 2026
 19:48:03 +0000
Message-ID: <7a42515f-ae57-4f4d-831c-87689930a797@amd.com>
Date: Thu, 15 Jan 2026 01:17:51 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 2/2] mm/khugepaged: retry with sync writeback for
 MADV_COLLAPSE
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 Branden Moore <Branden.Moore@amd.com>
References: <20251215084615.5283-3-shivankg@amd.com>
 <20251215084615.5283-7-shivankg@amd.com>
 <3cc27720-8f53-4b6f-9202-42b3b73928b8@kernel.org>
 <dbbfc5f1-d9e5-4d39-a2df-e35d6ba73063@amd.com>
 <d6287c39-59a7-4592-8afe-bdbdbcd70b04@kernel.org>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <d6287c39-59a7-4592-8afe-bdbdbcd70b04@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA5P287CA0031.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:17a::8) To SJ0PR12MB7458.namprd12.prod.outlook.com
 (2603:10b6:a03:48d::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB7458:EE_|CH0PR12MB8532:EE_
X-MS-Office365-Filtering-Correlation-Id: 6276ac02-cd0b-415d-ac6d-08de53a5d471
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d1dxZ21GS05ScldPR1N3RWhqeDVVL3hLSyt3OENVZ0hWY1dud2NGRXk4M0pQ?=
 =?utf-8?B?ZXVtd2IwUVZWaEZhblJTNCtXM0NzVGpkajRtSXBlOWRVb014Q05RTTIrYm1K?=
 =?utf-8?B?Njc0WkRFWUovTGpWMGxhb1RBeWo0Y2ZiQ01tTWFnc1BoSzVqcnFiL3ZWeWJH?=
 =?utf-8?B?M0Exc2tnbjhpNm9MOS9mSSs5d2M0bEVaZDBuM2hXa2NhdER4bU5sQVB1ODFl?=
 =?utf-8?B?UHBmdEZObmdzYUV6eHJHY1F6ZFpUZTgvdi9sN0xTTlNwWUp3KzQzL0VUbGJ6?=
 =?utf-8?B?ZzUzbUtsaGwxaEM5V0svOFpzeUVFd1BzMUY0ZXV3VE16RXRyVmg2aFR4Z29L?=
 =?utf-8?B?OGIrYlVUeW8xSlM0SmRBaWxVcVJCcXIrTHhsM3YycU8xYzE5dXkreDgreUFB?=
 =?utf-8?B?aHlNQ05wQmhLanN4WTBGSWRvMjIydmVWT2xqSVJFOW9jWmhrZ3hFdXJWeFhQ?=
 =?utf-8?B?cXFJdlJDUUlJSlpSd09nM0xYWUYzeFhQTS9ZRnFWdm80bEs5bUx3Qk1MdjlZ?=
 =?utf-8?B?UkszUFdUbHpST2h1elJ5ajRKNjlUcGRqeGlpYnRWNURDYTVYK0p1NElIbnNy?=
 =?utf-8?B?Qm14WTU1RncxTjNWOHJBaFVyQ0NSREVScUUxKzdoR1EyblFzRkhGUGtMZlJB?=
 =?utf-8?B?WnhHczZtS0tKNzR4bUcwR0RuRVZ6UjB5d3BrTFFzKzN4RDF6TXBNWk5hN24y?=
 =?utf-8?B?ZXZzSWtjR0VtYzlSNVJ0NFI0Yzhua3MyTGkvbEtjUFZnUUl6Q1hRS1ZPeDNB?=
 =?utf-8?B?RmdjNmswYTVUYi9ycmt5RHd6QkM2bmpSWFdObm1xZGFzbjdtZEQwOHphOFlL?=
 =?utf-8?B?WDVCaXRlUUhMQk9zUThpRDcxd3NjNDVuakdiNklVN1RwenUra2xTSzR3ZUth?=
 =?utf-8?B?S2Q4eTRiMDcwWW4raGZhUHk3Z1ZCN0RlUUFNMDRkSjk1TmpCVVc4dFp6YkNo?=
 =?utf-8?B?dFRTSWNoWG9TcU5ETlZVZS9jeENFUVNEUTZGRDRNWi9WM3pTTHFaMjVKbENT?=
 =?utf-8?B?RVFnVGk5T2RTV2RrU2VsZkxTUTdEajBQaHdKb1B4M1dPQWV6K2hDRGx6cDN1?=
 =?utf-8?B?c0YydWFEcGZmQkdYRlZQb1o3NHBhZVJYajlyajlIZUtEUVU0bmw4Z0VmclFV?=
 =?utf-8?B?bTdIbTRRaDBFeVp3dHh2TjNxRFJlTDFZT3pkT3ZrNVpoS0V5WXJmYnk1dFRj?=
 =?utf-8?B?UThqeUloY2g4WTJYQzY4aG1Ob24xUTk5SWQzeEdDczJDMnkzZlZCeWlGWXNi?=
 =?utf-8?B?eUo5QWM4TUtnMHdkTjhGVEZqdDhHeFdEWkRVaWM4cTZZdHFBT1Jma0d4Y3hZ?=
 =?utf-8?B?dUxHQzcxcVBqVUlVSENBS0FGSjA1VEQrNnQ2Z0lvbG5Zb1JRdFBkVUU2ay8w?=
 =?utf-8?B?NmE4UnFNOFJTM2MvQzRvYUg1L3FXUnNQdm5ScmhKYVFBUk84T3BieVJiZWcy?=
 =?utf-8?B?UENUbnlDa3JlNTFVWXp4YWF1ZnBzOTVxN0EvZU80U3pwTUR5MUk3aVJDNEtn?=
 =?utf-8?B?VDVFV29HbmQyRGx5TzJRTWx1TXpyRVNFQjk5T0ZBQ0JVY1Y0U05SSS8wTFND?=
 =?utf-8?B?Qm5vNk1CeG52WGJ3RlYxNXV4Y1A1Vk5zQzhkYzlOSWkvbkpyM2lZU0FtdDgv?=
 =?utf-8?B?azFTNkZjSGxQMFpmc1lBUm1RYVcrN0o1Z3l0TG9oMjZqdTJjdkFJU29DQmtp?=
 =?utf-8?B?WVJPZVZSby9YM25JZ0pQNmxhNzNybnM2d2F4bm1zY1dNZ2dGclNEZkh3Ukxz?=
 =?utf-8?B?QmpGUFZmb3M2TDQreHUvdVBicjdlZXl0ZVhwWVhGTkxFZ1VRT3U1b1FWOC9l?=
 =?utf-8?B?enNKbmVjMnFVZG1hK0RGd0VlcmVDRTdpeWxuc2JocEVsUGZyMmRRTzhjZGt4?=
 =?utf-8?B?S3A0SjF5YXY5SVkza3dmYVFBUVpuNXovbWVRV0Q0QlNYNWl2T0Rrd2xIU3ho?=
 =?utf-8?B?ZjVCczFtbHMzZ1hyMjJoSFQxaWhzM2ZiZk1pMnl1NFZsS21FUHlWWUNaaXRl?=
 =?utf-8?B?MzR5clVyWVNuQ0oyVU43U0cyRkszYy9Vc1ZiQ1FTUWVoaXZIeDdFZXl0UVpx?=
 =?utf-8?B?THdHeGR1NTZmL0oxZ0pYaDdYUS9jYXgzeVhDRm1HVEt0Y2dJRlkvM2lrZ25F?=
 =?utf-8?Q?CfyY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB7458.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1EvMlZETERnQ0d2eGZwR3Z4a2JSOVVMMktoRmV0S29YUjBvZFJXRmx5Q2ZR?=
 =?utf-8?B?T1pNdHFndVI2NWVjWXFBK2JiVGxkSWJOcjM3eFhVQlRpeEthNXlTMWo0aUVC?=
 =?utf-8?B?c0RaeEErV0pBalNicU9BZ242OEJ0dERCVW9wZVRoRWR1Lzk1MTNHMWVCdHFM?=
 =?utf-8?B?dXJkcUVJRDFjYzRYUWp0U3ZMZ3lDMkxDZ2pVeGRpelYxaFdYSmthYUd3bGYy?=
 =?utf-8?B?bmNhL09SV2FDUnJLck5NOXJxbWRFcG4vUkRWaC84dVBkZDZxN3FJbkdJandw?=
 =?utf-8?B?bWFpUDM4dkIvMGFPeTlVVnQyTEtob3FDV25kRkdlZ1FlSnlrTGV0dkMxTjV1?=
 =?utf-8?B?NTBGVkp5cjFlZ25SUGFjQXNVN0NldHlUOHRianBUaWVkY0FLMW5pTmNVTm1H?=
 =?utf-8?B?SnVpQkxZcERKOHVHSVhhYlA5RkRSSTRZVEJSME5MMDMvcjNVV0xUQzI0VTZD?=
 =?utf-8?B?TGZMMVlvTnB5cXRtUGpQMGllTVpDSGgvK2FPM25XWXNYNjdRZWZrdk1zallC?=
 =?utf-8?B?NEdDNkpFWktqZndBS3N2VWJ0S0xSUm91bG8vdEs4KzJaSlkwa0tBL1YxNFdo?=
 =?utf-8?B?Yi96VGU5djM4cEl2TWhtcld1T29HamxQekNraGFDL1JwTndJdkRCdmFaTmVG?=
 =?utf-8?B?ZzVzWVphMVFmTldSRWsxVW1DQUFLM2pPQ09ZRnlSb21BU2JubDFia2JOOVMr?=
 =?utf-8?B?ekg5UkZCdDB5R1RseFhKelhqOVpmaU1kMzBLMUpSQkk2RHFoRmZIV2NHeHh0?=
 =?utf-8?B?bFpnWEptSkhjalRZK2U5UFRDNVExeUwrWllYSWxodVVGQnpOemZzQVh6cjlM?=
 =?utf-8?B?MDBFL0ZrZytjb0VlSnNEeG5qb0ZMOUxvMlh4RmlhaWRyNTN2TGFOMFUyeFVH?=
 =?utf-8?B?SmdicWxPT0tkUmI5bGZZOFpRRUl1MzJzVXhHQzFGYlgzMmd1TWJNL29EajFn?=
 =?utf-8?B?aWh4Q09kM0JFZjVnWFhsdDJEc0duL2xTNTJEMFNPbEhVUm5saHBTeVlSRWVT?=
 =?utf-8?B?UlBFMzVBQXBKdThOd1o1aTgvQThyOWZsUkRrbVB3ZWc1SjZiN0k1NXlnaDE3?=
 =?utf-8?B?dE5maUEvc1V4Z3lGVk0xZ3FwRUtvcEkyUktQRlFZSkxaTmR5V0UyZUxIYUVJ?=
 =?utf-8?B?bzlOTlNmUjRNZEpEaWZHQkx4enRYTTBPb3JkOXVjWEIydnpkeFNuRExPeDZn?=
 =?utf-8?B?S0ZQSzVzUWFYZk5BTTljcElLcG9icXA4V2xkY0tJS2V0RlYxQmdvaStlWWJ1?=
 =?utf-8?B?MXMxUmh2MFpybXppeHk4NFpTTHB2N0V1YlhDOWRsMDFFK3pDSWd1NkJOVmEx?=
 =?utf-8?B?YTNCN3dFT09SZkZPVWlRT2Mrd1VGV0tkeHE3Ykx0VHZiOWxCZ2d0Qzg2R3Ew?=
 =?utf-8?B?TFZSSnVBd01PVzl5dk54M1VSQjBjL05VZ3YyVExGbk45WDFRSXA0Szh0ZlZi?=
 =?utf-8?B?UmNtazBqS3V3Tk1qaGxLSXJNQm10YlNRMmJBdmdrZU9lRzZqLzFFeVk5WGJa?=
 =?utf-8?B?VEdtZGJiVCthY3c5MEhBd2RhazNQbWNFR2U0MWZNaFJYNm1qTTdVWXdQQ0Vq?=
 =?utf-8?B?aThXL21tSzlCdkovNkpPSU5WUDZQMC9nVVBldnh2T0VoNFZjVzJudU5ZcWtq?=
 =?utf-8?B?dHVwaGRWRlRmMy96bktzS3VNeDBURDB6Rm1kR1k3NTNtaHVDWEgyMEFGcUpr?=
 =?utf-8?B?aEptOE9xYTYycmE3TmVKVjVBb1ZIZzcrVWhtUXNHcUc4YU82bnE1YkNNbno2?=
 =?utf-8?B?akkxTDNIMnhqTjVua3oxaUY0bmFVbkp1UWwwYktydVZHb1hidUFqUjVlYm9i?=
 =?utf-8?B?bUNnQUMrOWU3R0pLbEVoNlJPemtNZ0xyVU1nR2JWSFRpOWNBUlpWVTEyZjNE?=
 =?utf-8?B?N2wzcGNwaEd5TXFoekJESCtZTWxFUm9QYWpBRFZTa2sxZk5IU01MeHkyRzZF?=
 =?utf-8?B?RVNUZlpBV2V0a3RWYldXUXZxZkhJaDlxT1pEMkpIL096U2VYakVEb3BrMkVY?=
 =?utf-8?B?SlVUaytzZGU4YjNDMGdQNmpETlAvRmVGdjRBeVQ2bmVTRlJLVEY4VjB1cit5?=
 =?utf-8?B?Q2c3TUpPZW9MZGJxNXB5cGZFanJ5Wng2NjZwZ3B2T2J6MWNXZUk5YjN6ajZn?=
 =?utf-8?B?YVc0RmE4ZHdMYnpCRldBV3AyWkxKeW5Xc3VCZ1ZyRDhsRFVyY00rRHhKdCt2?=
 =?utf-8?B?N3ljWlAycHl2eEhnUnRoM0RXekx2UEZaaTRJTk5MaHlDQ0h3NmhobTNnMGpP?=
 =?utf-8?B?UGFoVlpGZEk1VTFnR25lQUcrSzJWSng2WlowOXFvd0lpRFNhOWpDWU9SVis1?=
 =?utf-8?B?TUlkWjFBeCtNU25JTGRQZUZpMEc2MUhSZHBVQ3N3aktYblBBVXl3UT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6276ac02-cd0b-415d-ac6d-08de53a5d471
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB7458.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 19:48:03.3701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x113Ma6TabHO762AOLbVQRZaYMUPvrjdA7IQ/yRJcjHb7r0jxY4yReujOGm3Moei+lLqFuQwl124/v+vcb6YPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8532
X-Rspamd-Queue-Id: 357A214000E
X-Stat-Signature: igy1usqfiifa55iiu389867zdeiowaur
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768420089-287120
X-HE-Meta: U2FsdGVkX18LgI0hTau8AcCfeBwCLs8usWAwHU9BCf4i1EhtfThdNn2DAXsgUFObTDNQlHE74IWUZP4QQAuvcfhKsJO6aLu4WqHy/I+3yyHHb4mb+CV+Jxn/41lreXwxLAQDIYOHNNThtLP3OrQsbozQgrj+O4fj6gkDsaSldfc9H1nnSTIznxBM8BlxY0urPwvgrjZUwhWxuR/r/vBit+gJ/1KQubA0Yw/G2g0uQYoIKK/nUaxf9J1Riw4Pgdswu+mLyt4LwTR1RES0kUX8wkzYV2TZElWeuN+VDqHGX34Q7dRoQb+dalv2mWfkri6p8amvqUDJf9YIpWXglFAUb2+arftorH2db0Sm4EOoisOaFe+11LrijecxP+Xjcr9PEB/Dpau8ONkF4ycGzT6Ws89VArl2XFfiPEWdKekwdtWTDbNyanVjv7r+QuvoGseCkzkf1d30ejIy6bGfEZFK10FY6o5p5yrL6YS/5daR7z+UZqC9SXDLesOQI4DIx3x1wKpgQwrbezuQPiC0UpNVD7RtQ7HIk8y9lcqPduLxnHHgKU0G7OMLra5rTVBm23QjBSQrhxda9C4aJ02+sIoe81tppClYEw2WpHurm+AVUy2lo5rPbhsISkRcKnwElfYtxMhs+id6vg8drKgguOjl8aIgzUFyi4zKA/VuAFhdvqOUGenHegEqh16vFxxoXdB+FcMxtfoDI8wYlnZSC8/cIXjQh50ZzrzoZqg8ZDrDk2VSkvWvOqLi42fwsBpyEC9k7LjdP+O5vziEPxIVpWvfTwT9Ln4gArxW08f5yAB5s9G8fn7PUow+aFnDFWU03zQ8ewo1nMrPXhuXpVUDKEOE4vIgklEYiicJA1YQo8SikZGsogPYY0ei2FfxA5hE6adl7J2Mu0/HdAKa/Pg1z3gCYCRCZILE76TQLiWdVSjaJRnrPSiYbXNVQMIoFrYa/VIyiv8x1SAiOOf3a0LmGSa
 A7cO3PIx
 czuqgwYiDYnRA3bRjpNGg5WUoi+Kju9tmoGbvmPbZPoynKaxEoauWe7GYHaDuJMHM9Yr9bxumuo1NDBeZszyZWi2+7bXTb37294puEiCAcFaNKOSRmSsxbhfVL19px8mQ8rijipRA+BtrTKqlhBDkw38c6izVQZeUEQ5ROnGNxl0LBmlUSsjoI4Hw5Gtfw1xzVP04e2LVQlz9n1sXrZRbK6AlqGME8Ut7PR25bdgr95TQEHRC5rIbpH9VrVk9BjRlUv8aFf+UX35DSw7N5dNxSxjIhehkKgF9+xhVMhihCJqeriy9nV0J0YwftUtzihOR7HogYFAyCRuYTISQetm43wsrHOMLett3/zY9P9PukIKDcNbXmHh83xs5SBfm8x/fnr0nPl1LdzFyXejdufgzl+T53ltJZCYukYkECBiAll4fCIFTcg4GFB+YlNhd8S6mzWmE5wYNFynBMFi+NJnXU3y+i9uFKiI6wTMP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/11/2026 4:59 PM, David Hildenbrand (Red Hat) wrote:
> On 1/10/26 19:20, Garg, Shivank wrote:
>>
>>
>> On 1/9/2026 8:16 PM, David Hildenbrand (Red Hat) wrote:
>>> On 12/15/25 09:46, Shivank Garg wrote:

>>>
>>> This looks a bit complicated. Can't we move that handing up, where we have most of that
>>> information already? Or am I missing something important?
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 97d1b2824386f..c7271877c5220 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -22,6 +22,7 @@
>>>   #include <linux/dax.h>
>>>   #include <linux/ksm.h>
>>>   #include <linux/pgalloc.h>
>>> +#include <linux/backing-dev.h>
>>>     #include <asm/tlb.h>
>>>   #include "internal.h"
>>> @@ -2786,7 +2787,9 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>>            for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>>>                  int result = SCAN_FAIL;
>>> +               bool triggered_wb = false;
>>>   +retry:
>>>                  if (!mmap_locked) {
>>>                          cond_resched();
>>>                          mmap_read_lock(mm);
>>> @@ -2809,6 +2812,16 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>>                          mmap_locked = false;
>>            
>>               *lock_dropped = true;
>>>                          result = hpage_collapse_scan_file(mm, addr, file, pgoff,
>>>                                                            cc);
>>> +
>>> +                       if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
>>> +                           mapping_can_writeback(file->f_mapping)) {
>>> +                               loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
>>> +                               loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
>>> +
>>> +                               filemap_write_and_wait_range(file->f_mapping, lstart, lend);
>>> +                               triggered_wb = true;
>>
>>                   fput(file);
>>
>>> +                               goto retry;
>>> +                       }
>>>                          fput(file);
>>>                  } else {
>>>                          result = hpage_collapse_scan_pmd(mm, vma, addr,
>>>
>>>
>>
>> Thank you for the suggestion, this approach looks much simpler.
>>
>> There are two small nits I observed:
> 
> Yeah, was a quick untested hack to see if this can be simplified :)
> 
>>
>> 1. In the retry loop, it is possible that we reacquire the mmap_lock and set
>>     mmap_locked to true. This can cause issues later when we do:
>>
>>         if (!mmap_locked)
>>                 *lock_dropped = true;
> 
> That whole logic of having two variables that express whether locks have been taken/dropped is just absolutely confusing. Any way we can clean that up?
>
>>
>>     because the caller would no longer see that the lock was dropped earlier.
>>
>> 2. We need an fput() to balance the file reference taken at line 2795.
> 
> Ah, yes, makes sense. Having a single fput() would be nicer, but that would require yet another temporary variable.
>

I agree, that this interaction for lock taken/droped is confusing.
However, a proper clean-up would require refactoring the locking logic across multiple functions in the collapse call-flow path.
This seems significantly more invasive and risky.

I would like to handle this refactoring but in a separate TODO for later.
Could we please proceed with these minimal changes for now?

Since, V4 has been in the linux-next/mm-unstable for a while, should I send a v5 or an incremental clean-up on top for this?

Thanks,
Shivank

