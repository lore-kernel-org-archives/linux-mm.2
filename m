Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1687FCCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 22:01:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60DD68E0003; Wed,  5 Nov 2025 17:01:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E5658E0002; Wed,  5 Nov 2025 17:01:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ADEA8E0003; Wed,  5 Nov 2025 17:01:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 36E648E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:01:00 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E670A1604A9
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 22:00:59 +0000 (UTC)
X-FDA: 84077924238.24.59A9A78
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 886BE140015
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 22:00:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XRbUfKco;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bApQy+DE;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762380056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qiTI2paJLlPyFSlDR3dMdyc6obsVBrT7yP6xHXTwjDw=;
	b=Atu6Sqs8aMuue1Vl85UiXwLZ2p6LcXJqgLzYpO0N0A1aUH+TxbL/r6Fb1tc3U0w9DA5HA1
	zHzan7Nk635Wb37K+z6RYilBwqPNeENSXle77nqtNkxsQ2ef2mMpIE45Ci9T4D9LdHCHE0
	DRwTpZUKV3bp3iQ9d1hsV2w9BqlZLBM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762380056; a=rsa-sha256;
	cv=pass;
	b=NdZ0cZA7i27IbIjKiUi6WLL4KXZGTfTT5HjywMID1l7y3/hLlF7eHDih4szf8V9MH+4+Kf
	uxnbSpF8FSqLNQ8K4u8sTuYSIVwDmOb23SKFATeXC/wt7ZwGnEQZsk0Ulc/wcyeoJWAVgJ
	UzUi+ms4vUDFCXDWnpwZwYN0bJRN2NM=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XRbUfKco;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bApQy+DE;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A5FxrX0011641;
	Wed, 5 Nov 2025 22:00:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qiTI2paJLlPyFSlDR3dMdyc6obsVBrT7yP6xHXTwjDw=; b=
	XRbUfKcoSQD9N/a2iytaN5mR6QJGSdsyQeEfGy2RYHjIgjB5YkmzEcuSS/6CTprc
	mKm8sEw4m8cwLCFPIo+HhF2t99V7uu4ByVo2N1QW5ErAAmLd5jDJ/I/M0gzBUEUn
	ttGW5v9t71nO1ok8wQHJWrUAfd37GRK0v3ikT+sTQjtrO5k1NG2zThj3X46AEE6b
	wdDq2ac+TDJJLXXRttDUccS8tudZrHfZfpIZ4qotPOm2sjLMkDse1rza766HGsxT
	EDjWrO7JDJQ9pWjEJIkYS+JJf6C0BxOVUYi9EvNvz9Sk9k2uIdTzTySUhCuPbOiX
	czL0ImFSRW476UrR1w/QUA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a89q40u18-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 22:00:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A5JuFmL035865;
	Wed, 5 Nov 2025 22:00:47 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012005.outbound.protection.outlook.com [52.101.43.5])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nndce8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 22:00:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eAKcU6Q/mU9cOGO7b3O0+kftoVS4keBfBfnjO3XzkW4lMuymoBEh8R3LSMXyuEH6nkrf1hr2MRdZ4hlmKkAwhGt5AyCVsBX3/tTmw9gC4gIHVv/sxRuypaquTZF13b/Aljd9uthz84tXMgi5kotbRrq+UFyCzwynGgJ+HRHKMsHyAE6k76Ja8lZK7gqnGdX/+aPOzIY/lsq1AXSkDn2D5iF9EBdAcNf9iFxVu6/Yj52fvmxuzh8sX274VS5NugphGcgpI8920peq+dUrOWlICV6huZGMiWcg2bHEQhWUVe/qNWBDLdyW/u8yvC6+Lsd50TDzlFNMPzqwbSW8Tdge/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qiTI2paJLlPyFSlDR3dMdyc6obsVBrT7yP6xHXTwjDw=;
 b=uriYz3KE9GC0JPPj1T2gW5fsuXSITDabdgenKi5vqafOjTutdNM7zcv5H6BdX9isQmi3N+j4fUbynQ82ZjvDcamHLN0mY0n0QSSS20ixOPCNbxTAdlV+mHFFviAivP3c019I2XjXtnSeZtKkVGkiIXW+y1m8Sj1e3uc/rjnReGir7Rf79zAWxEzAzRJd4w7moaYqa/qWyfYNHg4N5TwR1cuJZ7cvijxwsHBNfe7v1k/HzyDTUzLVXjUCHQNQqemSy5xqLas+RmGVf9fU4QBmZmScG8ddRFAwc7I5fDVFX9xGuv/5VaMMsePIcgB2SkMkQDM0HbOzaKZsxKztpQeJ5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qiTI2paJLlPyFSlDR3dMdyc6obsVBrT7yP6xHXTwjDw=;
 b=bApQy+DE3Ma5RZwIms1wUjPN60TSsiyf8k1vCWc3O4l0CULR3MMoNSvEQNzDYOv3N2ajjhiD5K8BHSF8DUe6vSEZ9KoC80ENcxnonZaQluZM8HHkK6yo593M4ilfyiTGVMW6TuHFZYVsJZsm3V153HqNAfD9f4MZVoYI9JeGuj4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH4PR10MB8123.namprd10.prod.outlook.com (2603:10b6:610:23f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Wed, 5 Nov
 2025 22:00:44 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.9275.015; Wed, 5 Nov 2025
 22:00:44 +0000
Date: Wed, 5 Nov 2025 22:00:41 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>, Marco Elver <elver@google.com>,
        stable@vger.kernel.org,
        Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
        Baoquan He <bhe@redhat.com>, kasan-dev@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 1/2] kasan: Unpoison pcpu chunks with base address tag
Message-ID: <00818656-41d0-4ebd-8a82-ad6922586ac4@lucifer.local>
References: <cover.1762267022.git.m.wieczorretman@pm.me>
 <821677dd824d003cc5b7a77891db4723e23518ea.1762267022.git.m.wieczorretman@pm.me>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <821677dd824d003cc5b7a77891db4723e23518ea.1762267022.git.m.wieczorretman@pm.me>
X-ClientProxiedBy: LO4P265CA0222.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH4PR10MB8123:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bb844bd-58af-45db-b545-08de1cb6c462
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WlorKzlVVXEwYVdIN2gwU0dXRk9wbUM1dGhZRDlnRHVGS0VMRHJkUkx3UC9X?=
 =?utf-8?B?eVpRc0x5ME9BbUZHdnM0azd0aVVSczlDS245RDNUaEtlbU5oMXFzcU9rL1k2?=
 =?utf-8?B?UWZNaHNUL2sydHZDSWRiRk9xeWF5Y2dYQWtqK0NFVSt4eGkvcGJUeUp1VElm?=
 =?utf-8?B?N1ZzbTlUWnVWWGhYN1FySC9Yb3BlVDlITDBtMFdkZzRSZkliTXpINEptdWtT?=
 =?utf-8?B?YkdzUlFubFFIUkdXdWQwN3Bnd2QzWkdCSWt1RkZEeXFyL1pQaC9yd1VoeWVx?=
 =?utf-8?B?L2VoWEtYYnMweUo4NStuOUdYbG1VeHIwamQ0SXB4R0dXc0dFaU4vSzRIekxM?=
 =?utf-8?B?c2VwdlJta0p1amZISWxRV2tEd2FEcnZDU0wyTHd1NmdFTVZVU2lodTlLdGll?=
 =?utf-8?B?L1lrZy9SakJWZnhHTzVZTXdvM1YyRjhiZkVhcU9FdS9VZEtYRHZsZy9ReUpM?=
 =?utf-8?B?WjdxYWpua0pLd1BENlRGK1JwNG9Ldmx5WncraEkrWnM3bU1YcWtFemR1ZTZu?=
 =?utf-8?B?Vi8xYjgyUHlmODBWSGh6TWQ0Sy9aMkZJKzdBSzBBeVVEMDlWcU9ZR29peHZh?=
 =?utf-8?B?SjNUa21ENFRSQ1hVYTlnb2xqanJjS0I5M0psM3JSMGN6QnQ4TjVnOE5Kbmdy?=
 =?utf-8?B?c2gwdjZ3MWx2bVcxRWdpZGpOalprK0JFdCsrNzdRekxRQTBEQUd6LzZxQmJy?=
 =?utf-8?B?WC9WdEY0TGdlLzUwalZ6cm05cXNOeFJvNysyWHQ2aGJmQ2Urek9tWUhxWVlR?=
 =?utf-8?B?b1lvZVArOXNiUnlkM01QbVRaSlVLTVcrSUlZUzh3S0FNUXE5LzlOcnlhR1RM?=
 =?utf-8?B?eFRlOWJ4THVna2RxMlpqSWQzVmFPSFFjRURTbHlBOFpXRjcyeFZJT3FmUjBJ?=
 =?utf-8?B?TmRJTnh1bS9LaDdxUnhzbURWTnNKRGRTeWJVNDNja2swa01mVHk0dVpWdG41?=
 =?utf-8?B?UmhaTXIrajB4aDJSMFJaNHc1R1JOak5QZXZaeUFyRExIMmxDd3MxRXh3WnhB?=
 =?utf-8?B?STFrZU9nNFFRRmhacEpoY01yUUt6WWQxclk3NDc1cXUzQVgwZ3htODA5S3FF?=
 =?utf-8?B?a1MrbEF5UWNKZjlsL0FVbmN4dERZZVZZZUZET241UDNYZ3F3RmVqZDFiQS85?=
 =?utf-8?B?OWIzN1g0S3RzaTNQZlIxeVpKS01LRk5GMGhIWGlVNnJsekd3VEtCcWhtNGwx?=
 =?utf-8?B?aWQxaCtGaldzUS9WaHpwenl3ODAwVWkzVzRVc1o5YWdJSFRTSW9rNVpGeVIx?=
 =?utf-8?B?aFFvUU5IcjdxcC9vZU1xcUZjWWxJVmgzZUYxSU9jaW80aHBVK0RVTUl1UmZh?=
 =?utf-8?B?bHBteW8yWEEzZ2RTdllOUWNqMU5CS3h6ell1OHhCSXA1QkxrTUw1VXVQYlVh?=
 =?utf-8?B?TzN5ZXVLcVA2MlBGTFdnbXRmbmRHKzN4bEh0Yk5GYXpqN1gwRUFLVkM4YjI5?=
 =?utf-8?B?OUN0VENMWEFmS0JKT2REcEY0VjZtU0hPYUozdEwzbFpLM3BBRFRIUmROTlNE?=
 =?utf-8?B?RWYzSTUwK3NjWkhNbmR3bzh0Q2JhSXM2a3lubno4ME52UkprcDNZeFd0ekw1?=
 =?utf-8?B?d3RZVUNwWTVQVy9IbXVQbk9BdVpLMG9VYnRQMkIxRUd0cUcwOElpOVZHSm85?=
 =?utf-8?B?ZmFYT1ZRcW1LNkJsUkRzNUxUMW5VVzhkempsS2RiNXZwUFpoWGN3NkVmZ0FT?=
 =?utf-8?B?dHFIV0tCd1dESmNaUkN5aFVHSUdWZXhnQVA2RSs0NXNpYUMwRFhZZVhBM0N2?=
 =?utf-8?B?bEZTU0wxMFJTLy80alRiTXBZdjJGT2ZpTTJ0WDB1YnRjcFVaU1FUdEZieDh1?=
 =?utf-8?B?YkZoQkhRYWgyTHRwS1MyanRqVDNTTzg0NHI0ZFNlYVdGOWR3aEpzTWhFUHVR?=
 =?utf-8?B?OHpWZ2M2d1c1MXFyK3VoMElUZFRPZUZxTFFXb3phRit4dlU5cHk5ZjVKc3cy?=
 =?utf-8?Q?xob1yeSplmubrvARkTgqs/FOE6eavFiz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WnlUdFVqNndRTXQrTE1tTmFFNm1xckhQNGh4d0RQZmNaa1Y4TGh0TUxUNmI2?=
 =?utf-8?B?TzRzbzlsV1BUYWJIanAzbzVJTmdHYTJtbUM3THZGY1VxS3R6VkdYYVdFSk5h?=
 =?utf-8?B?WjRIZFU1TEEyZUVkUjZrTFN3OWpuNTlVUmtYWFViNmFtOVFVRWl6MmdmTDZP?=
 =?utf-8?B?UjBRNDE4clpDenBMakppQ24xZjVYeklYU0R1Um9BcWdSSHhKWnBId3YvbjNC?=
 =?utf-8?B?azRpcE4xd1dTakpCamx0N2VIV0s0TzJ1YXhHckNTQXBTUWg4YWErV1N2K1kz?=
 =?utf-8?B?Q0NZMFhaQ2FoV3o0ZDdkbWZIajgyY2l0Yk5YNlNkLzJnU2RLSlRHcXIwMmJl?=
 =?utf-8?B?Z3hWM1ZzL0d1ejlkRis2dlRwTVQ0QVpmcnJCdFRvMWo5RytNczBiQWYxZE9a?=
 =?utf-8?B?UFdGK2VJNlFsZmVPME1qZDdCOXJsREorajFlRzU4dmc1aVNUSmZBcDFncis2?=
 =?utf-8?B?YTVKaFFUQVNUclVUeHQ4akZyWTIyZ0ZUelh6RkRReVhjbHpER1kvL0tiQ2hJ?=
 =?utf-8?B?dUtnV3lMQ0h0OUcxeFE0RmFpUFVZa2FKQ29HTU0rOG9EaTlSQi9FaDM2REZU?=
 =?utf-8?B?NGpDR0hhVGNTbW5sdkNEeUMyNFNNMjAxNTdOSHllZUM2VnhPTWlvQzRSK1Ir?=
 =?utf-8?B?ZTUydU5EYm5NS2ZOZU5WSUhUVjNzczZBbG1JRk9HcXhqRlpYQ0FYN2l6b1lC?=
 =?utf-8?B?Ym5DbUJzaDhqVGN3dWlmK3FPS2lMczZ1OFlBRUlxVVljZzRqbFZHcXFscVUx?=
 =?utf-8?B?KzZvTk1RTkZVeUhHOG9vek13OGsrKy90VmV2ZGVwZ05XWFZid0VyOCtLNnJE?=
 =?utf-8?B?VVliZHRTMEFSa2RPYXlFUm5tRmJpd3ZVWGo5TzVHWHVVc3NZNnBMNXc4OGRC?=
 =?utf-8?B?VnF0Umd5MmFBSUlzdS9BN2xYb3JSblRsa2loc1NkcVp3TlNLTmdZdkpNeU1x?=
 =?utf-8?B?cHZNVzhHWXI0OXBKQU5yY0hudU1NMXQ4a1hyZldnWTgxeGZ4OHVxT0hTWFQ0?=
 =?utf-8?B?M3ZncVdVcGlNbGJ5Sk02S0EzemFLV3l5bGk0NnpEdzlTVSt2dWNjTW85M2NR?=
 =?utf-8?B?Wkg4N242aFIveGg4d0VqV2lGUnNJMEcyOGhtWFF1MEpUN0xNMUNlOGc4dE90?=
 =?utf-8?B?OW43UkUyTXpURThHWWZhUjNpM3RPbC9JVWp4V3BDclF6UnZncDJRUldiT2NE?=
 =?utf-8?B?MEk4TmFBM2xKWW5lU1JmM3l0eFRwQTU5cmxrV2x0S1VHNTBEcUx0dDlzMVVI?=
 =?utf-8?B?dmdPOUVtUjJNTE5TNzBUVmo5RVM3dW5La1Y1bjJuTWNsRDQ1NFE1Z3hyWWFu?=
 =?utf-8?B?ait6VTg4UXIza0lxUUhkNktjTXdEMlJmNWtyd0hYNXQ0TjBrREpvWTJzWUQw?=
 =?utf-8?B?OEZpeXk3eW5tV2ZJdG9kQVMyQzl0MVp2YzVLVHkxaHZUTVh1VzA4cHdyVmNM?=
 =?utf-8?B?am13djNOb3orOVF6Q0d1c3hJdlVYemYwOVhxNExNYTN3S3dwNVB0ZGpZZ3Y5?=
 =?utf-8?B?YjFNOWwrZ0hQbGF2YWtEN1VZb0hQTzRFbzhSeFdzTnpWU29WcHQ0V0IxR0d6?=
 =?utf-8?B?Z21ZV3RKTjMrZlZyQVRLY0xjdE4vUWtwd05IZmtIcEEvei8vYm5vVWJXeGtH?=
 =?utf-8?B?ODhhcnA4MTBIcXk0TjNVRjkxRjZHbHZUQ1B5aTd4VWR4aVZ5WEJJMFAxdFRk?=
 =?utf-8?B?eG9sS2V6T29KL241YVMzS3RnNHlOUHNuRUlxQmp5bEEzbC9qZ25LaHA0ZjZQ?=
 =?utf-8?B?ZDBBM3pLdDEwckhna0l1b05WSVNtVmpjSktaeHlGTHErYnJoZkdQUFBHNlF2?=
 =?utf-8?B?V0dXZzNpVjFOcGxybVVIUFNWVmRib0dsRFMyaExFNitaQTNySEs3UklNSkpZ?=
 =?utf-8?B?VVRkdC9TaUpGclZKL0ZoeWRvb200dXUwcHJ0cldRYlJDOW1haEpUUkZBMU5T?=
 =?utf-8?B?OFNhcDJtQzB2T1hCSTB3aVdvTDRXd0w0eGhpclRlazBUcWpwQVdmWENSQlY2?=
 =?utf-8?B?azFHV25OSDJtN0FTVndxL1ZHMzJlRmM2Y2tobndpTGFKUjYrWUoxVnRCNmhr?=
 =?utf-8?B?V2VWdWU3MW1MSkhYSUxlMnhVK050c3hFdGxDQkZBMk1MQnBWTGlvN3BGQlZK?=
 =?utf-8?B?RzN6clJxNTdZSzhyTHhCWXV4cnpldFVFVEdoYmhEbVhOa0psWFpJK2pjd1hH?=
 =?utf-8?B?aHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mKrJphqZrKY/qlPAwpR0d5crhlftqTY/YRWTzoM1lvCMmRjLxp9sNH8aMqPub/mCri0n6qnxMG27gaBHw5Bvi+WE+OV+K/ghtqEKWkIWT0ZOxFh1G4mg3FOyZ69pOElG4X45BxTdsR52otPIvogARuBaJhSmOiVT7bjdFb7y8mSw8KHcZp80CH8FzMMPKFVH4VFKbz1++PzB88HoCwSD5oPaMDL0B3qrQsw4a4ydff52cxUjldEYU32kk6G3CV5kpMpEbKAcSGihBx1AKBOyIBebsqiGugGH6lwJtHtQs2qtUWkel959Pasb+FDO16Pd9UWk1G8FkiLY2fHYBULxisUbSQwF3IzCdlnF+dEOYaLyJYXf41Jz/0LDpe5te+HNp83UOTtvFNPasGafZ+S3xynUnL0HDl8gI2VOgBguYkKmp30Ke83KUHSomK7A9aSjWSNOJx8P/Etecf5OxTqMe75d4+omivurViJp2NJqGBgdC6qFbIWqx4x9glZYzf9E/PhzVg0QCRP1ddZQGU7KRvUlemilMxXFtM68RKPiy04YqyaosaFhOZLlPDtZTPRxEphzKKAaA14O33n81R3B6WDHDFXGWIE6LEr8CBn2lHM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bb844bd-58af-45db-b545-08de1cb6c462
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 22:00:43.9695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2B2phqQgvvNDCZGe+8+YXQ6UEelFQKBRnXgEFHFytViedPtrPmVuTuWoZ6VRjxFYtFR3KOIa4k/ogS+viwJB8W0hIF+GowI/V7aCEuzaRO0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8123
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-05_08,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511050173
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDEyMyBTYWx0ZWRfXzq8M/oXj1w6h
 agl711Z//x/FPnTBak8kCcFaGhvJNy+W1T4Spop4Eg0u5YMxZb6KEQYp+5/RhKHWGLXordOBMMT
 X/mp5ZGGjo7LwszdeDE1IU6YT9jGM+A8g+3X1jNFcD16BqbVNmKgzVxSIbYlNDDLM0izB1s4JoE
 lwPYRVCDjk297o+1hE10r5JXeYPYapjumkWnaAwqPAPVkWnzpU6RZuW0/kUWVavKieJspg5bkRK
 w/eIh0LQyLBrW6k+FDlmdWkHQXEUl8Prl04HmD3ulOu7xvrLVMl0MJ09ep86LiX7e387buI6i/A
 MNqD22rMXAb8orDsiLJEYuNmZ16HzMz3J8ZmlnW43vyQnEra1SC70z3Hy+DdE8rbcnk312qyGxQ
 JObzrKrqmiFg6XCOhvVUJxVEjudZW1VPtA8KxxtqiXDYNDQF5Z0=
X-Proofpoint-ORIG-GUID: Gx9unveIEigpyg89vZQpTuL6PvMixX94
X-Proofpoint-GUID: Gx9unveIEigpyg89vZQpTuL6PvMixX94
X-Authority-Analysis: v=2.4 cv=PcPyRyhd c=1 sm=1 tr=0 ts=690bc910 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=eOc_S8C_9ksmbnbMJQMA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12124
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 886BE140015
X-Stat-Signature: 3u37rdktd548wasoxkoz5ic9468c8eej
X-HE-Tag: 1762380056-867700
X-HE-Meta: U2FsdGVkX18s25U4Q4iSNHt4opFRcoMpjYn/hb3hkOXJ9oBAk+VMaWez0PBHYFWJqMI9ApV/9UjRty++D4+KBuYbP7424N7hs4I/zIqV8Uu9L1lWwzHJw5YnS3288grgdBhWMTMkjrpThdAcRIu9CgfDPJQWG27HYYo++/tBtdywiS+szacbn5qj/6gVZ9n1AGIhe719fk8mzjduodo0yr9Tzx5cUmm0SEw4HW77mM+NSKHgHz7KngeE51+oKRzYO1UDBS2cVaEvLEylrBCpc8EM3dJtDJUj1gPeJnpD6ducnYaaFVZfQvmckAYAb/Q6fmT7y45KQdPXnIncJVUAgK/wEiusv4GXYPWMU1+AODWNw2eC5DwET7V85/QIaSZ85v/KT66G5Y2MDt+IZN2jAyVzmIxCYPagStsKTnhFxCsv4CiBo2bLBziySmJGSxbLeSkR9NUnTqRUTohDEYMl2k9XH+ulk4Y60RUdY3Y7sbtPTlnZM7mmVEgoRLJvWUBxcXWeac+3/uc0yqsXkHgxcDtjG8h4IaFx9LZPmRq+Awd1spUKYGBUYQ8VhoF1b4++Ta8m/92xFrFiXYFeSieDFh3LonfmU7w67eScBuJlHJPI9na1bFnGnViJolQ3mWYghyPZmSknJMgQYZJSFNPMjzOBUDlnzPNwJrb6HXPilxPHrk9G/IHbK5boJZ0TFJhgYwcowuHIayfHOhR7gv5/AiSAmTJnzCZobT2lbLo6s77sBwn7+hb3ZRISYzd7qCE2zpJPb+wYwAd1eqGQEcwIsEFuaDkxNFaOadFVxBiJ0vqXCMuCXvcIjFTA+GDnXQ9NevBD1HNuKAAx1iqggFc8PovXJvjz0EoYbgrdRETwO2PN4OZuDODMfDjetjSlvWOGsnYqe+078VfHbZBMyUYlaLWcZq3pKiEGfP83bpFsqowJPW/ZMUCzNPjGPsWVa3o/VlYeZT1XliJZSo+1ct+
 DzlBn4Mz
 pM8tDAMtlb/bknznryRl65NnFUne+mmOQurahHoa27n6omVCvzuvKz2VrxUYMEPptwt16tUCF0FlFDfnu1R8cYpVvRpgBAd5bzlILSE3oSKkognFaq3VTpvAhEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This patch is breaking the build for mm-new with KASAN enabled:

mm/kasan/common.c:587:6: error: no previous prototype for ‘__kasan_unpoison_vmap_areas’ [-Werror=missing-prototypes]
  587 | void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)

Looks to be because CONFIG_KASAN_VMALLOC is not set in my configuration, so you
probably need to do:

#ifdef CONFIG_KASAN_VMALLOC
void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
{
	int area;

	for (area = 0 ; area < nr_vms ; area++) {
		kasan_poison(vms[area]->addr, vms[area]->size,
			     arch_kasan_get_tag(vms[area]->addr), false);
	}
}
#endif

That fixes the build for me.

Andrew - can we maybe apply this just to fix the build as a work around until
Maciej has a chance to see if he agrees with this fix?

Thanks, Lorenzo

On Tue, Nov 04, 2025 at 02:49:08PM +0000, Maciej Wieczor-Retman wrote:
> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>
> A KASAN tag mismatch, possibly causing a kernel panic, can be observed
> on systems with a tag-based KASAN enabled and with multiple NUMA nodes.
> It was reported on arm64 and reproduced on x86. It can be explained in
> the following points:
>
> 	1. There can be more than one virtual memory chunk.
> 	2. Chunk's base address has a tag.
> 	3. The base address points at the first chunk and thus inherits
> 	   the tag of the first chunk.
> 	4. The subsequent chunks will be accessed with the tag from the
> 	   first chunk.
> 	5. Thus, the subsequent chunks need to have their tag set to
> 	   match that of the first chunk.
>
> Refactor code by moving it into a helper in preparation for the actual
> fix.
>
> Fixes: 1d96320f8d53 ("kasan, vmalloc: add vmalloc tagging for SW_TAGS")
> Cc: <stable@vger.kernel.org> # 6.1+
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> Tested-by: Baoquan He <bhe@redhat.com>
> ---
> Changelog v1 (after splitting of from the KASAN series):
> - Rewrite first paragraph of the patch message to point at the user
>   impact of the issue.
> - Move helper to common.c so it can be compiled in all KASAN modes.
>
>  include/linux/kasan.h | 10 ++++++++++
>  mm/kasan/common.c     | 11 +++++++++++
>  mm/vmalloc.c          |  4 +---
>  3 files changed, 22 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index d12e1a5f5a9a..b00849ea8ffd 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -614,6 +614,13 @@ static __always_inline void kasan_poison_vmalloc(const void *start,
>  		__kasan_poison_vmalloc(start, size);
>  }
>
> +void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms);
> +static __always_inline void kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
> +{
> +	if (kasan_enabled())
> +		__kasan_unpoison_vmap_areas(vms, nr_vms);
> +}
> +
>  #else /* CONFIG_KASAN_VMALLOC */
>
>  static inline void kasan_populate_early_vm_area_shadow(void *start,
> @@ -638,6 +645,9 @@ static inline void *kasan_unpoison_vmalloc(const void *start,
>  static inline void kasan_poison_vmalloc(const void *start, unsigned long size)
>  { }
>
> +static inline void kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
> +{ }
> +
>  #endif /* CONFIG_KASAN_VMALLOC */
>
>  #if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && \
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index d4c14359feaf..c63544a98c24 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -28,6 +28,7 @@
>  #include <linux/string.h>
>  #include <linux/types.h>
>  #include <linux/bug.h>
> +#include <linux/vmalloc.h>
>
>  #include "kasan.h"
>  #include "../slab.h"
> @@ -582,3 +583,13 @@ bool __kasan_check_byte(const void *address, unsigned long ip)
>  	}
>  	return true;
>  }
> +
> +void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
> +{
> +	int area;
> +
> +	for (area = 0 ; area < nr_vms ; area++) {
> +		kasan_poison(vms[area]->addr, vms[area]->size,
> +			     arch_kasan_get_tag(vms[area]->addr), false);
> +	}
> +}
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 798b2ed21e46..934c8bfbcebf 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4870,9 +4870,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
>  	 * With hardware tag-based KASAN, marking is skipped for
>  	 * non-VM_ALLOC mappings, see __kasan_unpoison_vmalloc().
>  	 */
> -	for (area = 0; area < nr_vms; area++)
> -		vms[area]->addr = kasan_unpoison_vmalloc(vms[area]->addr,
> -				vms[area]->size, KASAN_VMALLOC_PROT_NORMAL);
> +	kasan_unpoison_vmap_areas(vms, nr_vms);
>
>  	kfree(vas);
>  	return vms;
> --
> 2.51.0
>
>
>

