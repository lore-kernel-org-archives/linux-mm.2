Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19246C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 15:23:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AB2B6B0088; Fri, 25 Jul 2025 11:23:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95B9F6B0089; Fri, 25 Jul 2025 11:23:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 823766B008A; Fri, 25 Jul 2025 11:23:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 730B46B0088
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:23:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 28C7114081A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:23:01 +0000 (UTC)
X-FDA: 83703154962.19.BD42B3D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 96F0E4001B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:22:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RtFU9+oK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jY8lIK1C;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753456977; a=rsa-sha256;
	cv=pass;
	b=8YgSKbuIiXqfYwpudsjdJMfxyFkudJPKuv0wNBWStYI2Q4bbBBPNLfkvqxIMWy4SBvfMgS
	vBJa1r1Nxn3Cxf/W5q3h7STIfQWw6MGbl1w1yoslSn76+EnX58nsvkj9lFu7tAMuoFobFc
	1CHz5jO9IcSirmgPlCrjx8q/S0n+s38=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RtFU9+oK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jY8lIK1C;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753456977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=607fWNSRbFgEWQxH/KCPn/Z3KpMhCz6HoOkEyLIVHIY=;
	b=YlFF46c+w1mb4fauFnD8aWcGXvFkinGT7ZNqirAmCY9BGflIljp50PxFf1BkJxwm4hYX69
	YIt/DuoWhfcBnykdSAJ08kUAElIvq11H+Z6ExrhRjCdDaxlHVWjw4/JWbe95idYVwTpc9o
	PYy1mnHNvtdZgXYdr2Q8Ki6FtNay3Tw=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56PEJ1dA016588;
	Fri, 25 Jul 2025 15:22:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=607fWNSRbFgEWQxH/KCPn/Z3KpMhCz6HoOkEyLIVHIY=; b=
	RtFU9+oKjIsA7JAnG3UkISbmRNSrtuhiLfDgMfBKJskDMKCsSsZRxLh5EaEAmBzt
	ZRtOr++NTEWYqBp7Ln2Pt11Dv6I50SQbj956cd2u414qtriwaXHycwFZKTVBGkYs
	pudthXX5bmb2ScpVt3MuSI9O0bG7yJlhcZkT3BReOZEIphxLHxTVLJNgK1Hb6dcw
	gjzuA3BrTf8tiSdjfDxSIqEoSZY/psOyDONMRlzhB8dvLsJj2gC4g1KfpOHXF7sj
	+/NrisoCXykCUowuPomuC6yPCxBlAMqvRtdbPU9Xpc+kFI44W1ejGUO8gqp5+Eiq
	w4waSxgaT79XKitHZ6xHrQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1k19d9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 15:22:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56PEO5nR014581;
	Fri, 25 Jul 2025 15:22:53 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2060.outbound.protection.outlook.com [40.107.96.60])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tkhfyr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 15:22:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UhNUC5AGnEWKBgUKxtHNU0qUUw6gAdKX2tXDKFViMOBAFtd/yX9ekhwmTPYUFzWO9WR1UHoLALmWGnjYJBULSkHxdGJGdyk3Bk99uhz/R/iS7XAQmJV6Z3IqzQ9WMlhFqdlsTFADkUgxbS7Qne7FI2EFzY2HJyRS1JUBz0ynprbqRzP1PLL0Y6KkV9nbr4NddbjQHZsby0xFCVDW1eYmbZvzvdDXNaHX2lsYd/jLh52W3MBcIweALFt+bLuZOgDMOrk8hR9wBQBjZ/4q+H6BUqsp1D7V+YIBFIO2P+oAHDA6+m6jFpM2GK5V2yJ85bo1Vje8QzNC6UGsu4GqtowlRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=607fWNSRbFgEWQxH/KCPn/Z3KpMhCz6HoOkEyLIVHIY=;
 b=hbCJTMPCdXW02VDEvwU9VJTyGLzjZ7CnhI9thuAE68jIc5098CCFtpqeDn0xZ2jq29o50SlLcl5QKg/DBRuI7cw9PSDrIBmwhxGKeKy+2/IE/XH/CSq5bHsqsRIGHzDE+Y5KEdf6lNR11Y+rPvji19mKr0CoG4cYO1l9P9JCJghb9Wyl9jY81P8IJrO7sf+1jokF5/1RGxbtlp4STfoCdWrB3SUEKlonJFTL4tYesa3Wo3k/8fbTM2ZKDki0TYCe2DJ+ditblaP4LEUglso83a3NKr2Ea1ayJjKTX9WHv4VV57QWHsZLuySOvlxDC6w/KUipTvUksKcsDec9aMP0ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=607fWNSRbFgEWQxH/KCPn/Z3KpMhCz6HoOkEyLIVHIY=;
 b=jY8lIK1Cl/1ybzMODeFG1aaHuNE79VDQazsi1qpoxI4AzZkh3/tDYH747Wql6vzDGs36RMCQLWhGD4HoSFXgctchcijRdm/3CDsiHZjegY6RTfXRJLx78jBpXXjjxEQdxltxgKabRUTaUU4VX4x6apUa0lko5KpRuKxng7F6GHA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV8PR10MB7776.namprd10.prod.outlook.com (2603:10b6:408:1e7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Fri, 25 Jul
 2025 15:22:50 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.023; Fri, 25 Jul 2025
 15:22:50 +0000
Date: Fri, 25 Jul 2025 16:22:48 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Rik van Riel <riel@surriel.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/rmap: Add anon_vma lifetime debug check
Message-ID: <f3e77eed-10b9-4197-b381-91c4ea3fc576@lucifer.local>
References: <20250724-anonvma-uaf-debug-v1-1-29989ddc4e2a@google.com>
 <c3f04c75-a73b-48bb-b56e-7b18e57c2382@lucifer.local>
 <CAG48ez31aVnoBiMMjUczbmThWnRGmod4yppgMVqf2Nu5-hjU2g@mail.gmail.com>
 <50502c3b-903f-4018-b796-4a158f939593@lucifer.local>
 <CAG48ez1TOULrpJGsUYvRSsrdWBepCJf9jh-xPpurRUXbMmAkuA@mail.gmail.com>
 <3cfc1146-1b62-4b04-a2e5-997d10ba4124@lucifer.local>
 <CAG48ez3aiXUmCqu2i7g6qrnVmZ6PRUsA-rQzHX1r8SXeYh2sow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez3aiXUmCqu2i7g6qrnVmZ6PRUsA-rQzHX1r8SXeYh2sow@mail.gmail.com>
X-ClientProxiedBy: AS4P189CA0066.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:659::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV8PR10MB7776:EE_
X-MS-Office365-Filtering-Correlation-Id: dbb80132-ab0a-434e-d0ca-08ddcb8f1e46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Rnc3dU84Mlc0QkZ4SzJMNndURndhbEJCN1RuamhETkxQYlhEWjBlL3lJOHNP?=
 =?utf-8?B?bkEvU25vRGNHdFRXRDJ0bktpTVhYTUNTdVRJcmhhNUw2VUt0cGl1eDI0d2V6?=
 =?utf-8?B?cWhvQnZrang2SmlNTXFYRXYveTJWMG9KalZ3QU5xSWZUSlRUUVlYSjQ5bWY2?=
 =?utf-8?B?MEU2dVRkTG9BS0t5WDUrSk5tdGExQjgzWVA5RHlteXBsS1Uza1JncFV1a2tK?=
 =?utf-8?B?YlpsUlVYQzkzMEhML29SK2hHOHRlbVRId3ZUTFZLSHlLU2NKQ3M1VFFnWkph?=
 =?utf-8?B?WlEvRmhCQjZTQVh3MkFSNzNxazlMd2NiMXhNSTZ3NS9RRVE3TkswUXRBNnla?=
 =?utf-8?B?dFo5UWRwcnVPaWRMWlVSQldqbUdhbE00NmVOSDRrRCt5aklNUUJqT3kwSzNB?=
 =?utf-8?B?K2NhZVN6OS9XS3h0eUtxbTFyUkNBWlBuTGF3YTFrc29Ea0xiRHFDeFg5NEdE?=
 =?utf-8?B?b1N5Q01KbzZkK0piYjVQM3FOeDQwVDBWZlM1Zk1RaTI2TUpHbVA2RjRWckR0?=
 =?utf-8?B?dFdjVzZ4MlM5NFFNd1FJaXlIWUhOTkM2ZDdFdFV5MTZTTExsNlZjSXhJNU9i?=
 =?utf-8?B?V1FDK09NalEvcFFIb2g5czhrbndKdWx2V2hUZTdqekFkY0JtNllzanQyNXVO?=
 =?utf-8?B?UUJMUWZJWG5QbEd5emVyUmJyNjQvSWNBbEo3KzUzODRsbmhTQTBmaXRmSkky?=
 =?utf-8?B?cGEwaWJ4dVd6RUVmRlYrTk5kZHIrTDN4SzkwSXJVRXp3NnRqc0Eyc0hqTEYv?=
 =?utf-8?B?aGhCVnZxeGtoVHVOaVFINHVNUFIwOXlxeUNJZElhK0oxKzVPUWxhbWJFZUFW?=
 =?utf-8?B?a3puaFRjKzRVUFBUZE1OTy94ZGV5NDZ6YkRxVzZoOUgxYmgzZnExVU5vUU5w?=
 =?utf-8?B?eFpVZldQTVBjckZHVUowejBiaUlDL3VmTDRBell0eWJBMEtBRG9IekJkSnZs?=
 =?utf-8?B?M1BPWVlWZlpHelNhS0luS3RFcUduYy9qeDliMVVzdTY4ZjNqVURJTHFyVk81?=
 =?utf-8?B?QVJZT1lNZ2cxN2ZFSzZKTE0xYXQ4dEVPUDlObk1YWWZEUXQ2dzlmYlZYQ1Yr?=
 =?utf-8?B?SWZQTmJKaCsyR1ZJVyt5MXlHNGdtaGt5alc4MHlhZnJlUDh5aTU3NHNxdGpm?=
 =?utf-8?B?NjVsMWk0djNxeFpaemJ3WUVBb2o1bFFaZnd5QWVCcW11RU1Nd3lKRE13blhX?=
 =?utf-8?B?VFhpSWVSbTV1dHZqZGR0bFpiQ0RSQ3lYR1FLUFlVcWx3NHZjM0pCVFNlUi9Z?=
 =?utf-8?B?SW1jbWJHdG5uWTBJclJHTUpzV25kbXlLQlV3ZFE3VFEyV0E3QnlpM0pZNm9l?=
 =?utf-8?B?Q2gxM3pnY0s1RnBCb1hkemtyV2JZTkFtcEpNUURZbWR5NjZ2MlRlUHZnemly?=
 =?utf-8?B?U2gwb2VzWHJmdThuQVR5S2tjN0l3Ty9rbHRsdytOV3pMQ0drRVc4UUQ0S0pO?=
 =?utf-8?B?N3NySi9MWnR2cEhOTG5TUjByUGVjQktzNFpsVGU1NFlKWkFrZjBzd3FjemRn?=
 =?utf-8?B?NVFlNGcyOVB6UHBxRmRaM21VM3JmTFBkUVJUdGJQdFRUSXFPVGVRZHlLT1V0?=
 =?utf-8?B?NlRnUkg5bkZRMW5KTzVBRTNYU0p4aGRBa04zTkR4TXAzSkNTejRSYm4vdW1p?=
 =?utf-8?B?eTUxNG43QnRRS2JOdlUvTGZSTVd1TUo2ekI4bFlaU0pwSDdYM0MyQUY4NGow?=
 =?utf-8?B?WXRYVTk5VlRxOGMrV1JvZVkrYzhBZEV0dFhRZXFsd1FDOFpaK1NSRUlqcVNj?=
 =?utf-8?B?VWk1L2ZQcEVzNSt4OWVtOUdTSXdiZHpGMTQ2anVoOWlPc3JYalpib0d0dUE4?=
 =?utf-8?B?aGFvRjVqUi9YR2lMeEp3ZmYwY2F5S2x4dEJiSWd4dFpjenh6dS9DQ0R5dlFC?=
 =?utf-8?B?MFpNNnN2Z21RSE1wOUx4M2w1RmV0a3I0OEF2VjBscHk0WkFGYWZaRUtRRVpU?=
 =?utf-8?Q?lGpvs5i1RIM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TWtMZ2dYNm1KUENWTW90aEkrakNkblcxTzNMN01XWWdNeVRVazlyL3k2ak1Y?=
 =?utf-8?B?SzFuaFZuTUh2MTRmbzFQcGdUMk5LUXR6bC9OVmNSbWtRU2x0aXlFYm9kSkxa?=
 =?utf-8?B?cWZFT0J2TDJMeHFjUzFpMWIwWjF4UnJKUm05VXUvTXVEL1hoNG9IRFgvNGtt?=
 =?utf-8?B?b1J0dy9qZ21xcG4rZEIxYVg4TEZqMkErRk5WTUtuWmVtUE5JRGtlb0N1QVVV?=
 =?utf-8?B?VWY2SFNkZDBDWkh1Z3Rza0o2Q29lWG4vUjJZRjFtWTN0KzhYYlB3cXZxcis5?=
 =?utf-8?B?WXFQSzZKalRva2s4eUZjajlid09GR0ZaRE5nRzNQOEZObXlnajF0UnlROERR?=
 =?utf-8?B?aXcyYnRuRVFMcU1heTBlZVZqUEVyRDIyWWlnQWsrc2xoT3hlMDNXeHE5cFdy?=
 =?utf-8?B?TnFTU3F2bFZQYks1WlBRNGh4bEVXbFJMT2hxYkllYnBXVUo4L21JMnZOZERC?=
 =?utf-8?B?V3c1aE01anh6UEk5M25OWnZ3Qy9DWHpTSlNzVzlsUEFvWEdkMUNVcGhlQzRh?=
 =?utf-8?B?emhubjVicEdwSFhIOXc2c1pWVHU2S1o4YkRiekdJNjkxazlNOE1ZSUk3R2ln?=
 =?utf-8?B?M0s0b3B3LzFhY0NzQnlDRElzYkdESGM5V0NwZGY0TE9LczlqUzZTaURkYktP?=
 =?utf-8?B?bGNTeFgvOEhrMnVBcjIxS2J6R2x2Y3dDNTRVRFR0Q3l2eDVlbFBsemNJK0d4?=
 =?utf-8?B?Y25BM2NvMHRSSXd1KzhmVFZkYmFBbUtldG1QMHp0eWVzQWtsRU5MU1BpK2s0?=
 =?utf-8?B?VkZWeVR4MlNHTXpJYTM3Z3BYMlFtUENmWFpuK0dFbDBlVUFmdW56c2hLdmJo?=
 =?utf-8?B?TTM1QWI1ZEVoVFdqUG4xNjB2RGIyUUtwN2dHVCsvdWd6Z25IWk9HV0xMODNJ?=
 =?utf-8?B?TnhuNWZHT3BSMUxxNGx4c2F0M3FRSlA1Y2FwV1dTRXN5US9VRFhjcDNFTmhU?=
 =?utf-8?B?dithdVR3SU9XdkRBUzFnclZNY3Z0bWxNWnVTdFg3TmozQnVGOTVZaTBIQWFx?=
 =?utf-8?B?NCtNWEM4VHhYb1U1SjBsTHkxRmMyd0N2ZlRKUTdweTFHMTVaNUJSdnFYdU0r?=
 =?utf-8?B?MDVlL1RacHNaWVFXWW5MMXppSUkyU1lPUExXcmVMM1NtYWk1WWduTStQbGl2?=
 =?utf-8?B?bittTzhIMXo4M0EzZ1crRldUcHR1R2d4MGZEcllDVm1GUkVXRlpRU0pkRDFM?=
 =?utf-8?B?VlZSR3UyRkM1WjBXUU56Tk1TQWJLZW0wZWxDVGVFWSthVE95cGpoTEcrSjY4?=
 =?utf-8?B?WGdXTjNmYjZrS1dZN2ZmQWVHM2h1ZFNWeWJobDB6SlJXTUJEdDZ0ODUwbWV1?=
 =?utf-8?B?VmluZTZ1VFBOWXRIOSs5WG1WeVRQWjRmSnhVYXZZdWVQcjZsSVZWWTgxbUFr?=
 =?utf-8?B?WXI0WFFSMjNQSmZsV1FmS3M1QUJyMW5PaWtGbnh3Q2U3bWgrV0NZUm9IdzEw?=
 =?utf-8?B?cEM0Ni96YXVhb2pTTHA3NWxWTC9ZY1hJVjdIQWdZU094WlFQZ1ZITmlCWVo5?=
 =?utf-8?B?Snc2ZGNFN3Y2YlgzL2hkWDFSN2k4RTJiOXR1VzhEOGdCRXBYcG85V093OS8x?=
 =?utf-8?B?U21HOTdrUDR6SlV2VWwzS3dKM3hwa2NNVk5wRjVOY3JPRlNGVFNWWVBYU0xy?=
 =?utf-8?B?TzlzU0g3SkZCdHhyU3prd2RiNVFhWVErbHJRMVNkdng0cWtUL0RiWDVWYTN3?=
 =?utf-8?B?dmdwM1pYakQvQzh6NmFub245dlV1WmE2YzRLbGc2T2VpMC9DT0NFOFdCNEhw?=
 =?utf-8?B?d0I5TnpqWlgwUjV4L2pPNWdTUnk0SDFsMGQ0WWM3VjJwMDc4SnV0WmxnMVVQ?=
 =?utf-8?B?SWlacXhsVWJpMUk2MVFUL3d0cTd2VDBzUlZYdTJPYVJVejVHcjBRcm10YXh2?=
 =?utf-8?B?OCtxTHBwcDczbWI1RUR6M3JDS2JxSVFGOFV5dmZjRHFWaWpVN1M1b3RiTzVP?=
 =?utf-8?B?TWUxc1ROUWhnSmFaZ1ZrQy9sL09WcXRaTi8yNWM2M1JEejhIUzdkaGRRTyt6?=
 =?utf-8?B?SFV0RDlNc0d2QW1xd2pDcFBEQTY5WnViQnpmR3FtajFncnUxWVNJR250bTRm?=
 =?utf-8?B?NjI1VU4zY0hFdE1sWHo1N2V0Y003N2RDclZxY1NhaWxIcGVmZnUxWWdVQzBy?=
 =?utf-8?B?RmMvUFFlRS9yRWZzdmwzdU4vY1MyRnpDalBWbFVFQmFHbTlXUGY4WUFwZEJv?=
 =?utf-8?B?NFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	utXW9D64arcMzuDO01/6eRH5AIh+hdw3W46PZA+6u3W7eOas8fSiUurwj3xPpGMdb0v0Lg0j8p7RnbB8mqtbyQPCZB0ATjB/vh9WvPUPUpLLqauQYSvr2rcAtWftVZ9ywHp7qF7mFTtp1ROBnBN0gLFCp2VYFZrWUiVZcLSyFMeMoKc+usqZkV27yOSGRJ8NUhfP+UYD41389b40EwohOMsWhAk9LN9IA0VOmmEfJnsnNDw8Vq50BbrtW7duCEWF5jBt+KFpUGcqNybNcg/gvOkDS+aoCaiz5O081wJoz5yhN7EHr9ipxR6x2e3pCK3+WZzLfLwqaqNRlB5KM9Ozxfb1foeeDJVMy/Ax682GxiObSu+Ifhj1vlEWNB82Iu753E0IBnPtRUX1s14SxOJ5FR1DBVMvlXAhF7sx9TYhhyqhBxLvudF3R23LPK1NhE8d7Bg6WcVBeyM18t/3N59hf0T2MB64ve2g7f4Q+yx+OK586OiCqzvid4ZJWnEuqVpDaDkMlo3wMko72+iMlEbz8pVmeaEnqGGRS+Mc15B+1tq1+Swv2BL0eqDuw6fiWyepGMuSuaOnsxwSrgO+vlQeEmJ0Y2wkPMewwkr1rfcjmi8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbb80132-ab0a-434e-d0ca-08ddcb8f1e46
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 15:22:50.5792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c90p+xPgM7kdWfEZPML9dmAhZps5pkKQSML5QLMHvY1mmdxcBzgM2pVqY8pGptAaj7zU9jxyxJubmi4j5NFTIudzA+jFExljx491leeTeTY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7776
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_04,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507250131
X-Proofpoint-GUID: MyPeYKCVz-E04Vi8E4g1MIFMztrI-5mN
X-Authority-Analysis: v=2.4 cv=LYE86ifi c=1 sm=1 tr=0 ts=6883a14e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=yPCof4ZbAAAA:8 a=OWHBf7YWBbbOeOYsqYIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12061
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDEzMiBTYWx0ZWRfXzT51dMt56kWO
 1db7v6nq9ZeksMxcySSF2wjc9DsM6FMwuWnn0rasfZgb5wP7yZq3rAO48lvTjYHocFGEOtTDjHr
 1THKh97NjRZc1FKkG1rCkATcococBXKb5mgMwKmwFlPPSy5u5nDdgg6ojgoYaeeVXwbLMoMbKWF
 n8WoY8r4GSzFj1HKRtQlf3poT8VgbcjHEViKvEQKXlPkyNW/aEuANTpqwRl+mrXEFmWLLgKq18s
 6jan9IkDA33Pi3YcHK+o2JsIhyaKoABqXnUFp3xKtWbBwqcwRKO5614QMzvMnbe7bx97Bww3wzw
 LWNa8oio/5W7hPVOaphExsVClimGQjJd8Ej9FtLyrY8tOsjU+2p7Dal6JeTo+pSEvRJ7UGuMuSr
 EYlYS2F+bRSHAhjVkbX+GMGeIXO7Z4wVT68mCCmDugJzh3ul4mLrHmYNX6ShPzScH7438k5u
X-Proofpoint-ORIG-GUID: MyPeYKCVz-E04Vi8E4g1MIFMztrI-5mN
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 96F0E4001B
X-Stat-Signature: 1uu8es4rkyd9jm76n79nyf3a3pcphyyu
X-HE-Tag: 1753456977-462738
X-HE-Meta: U2FsdGVkX19jy6chmjmTacldbvz1QRlGU0QOs5a9zrMQcEW1EvB9nsEck08+qYRM1Femwz2UNiNGiDbYCqzbftLRSQEzpzk5bPb2Y5UwQUkNw6evzomg6M+VUCaJDoOYw1Pt3FgaInuIydaz+1PtaVNYpgA7gQ+uCPR67ZHMNTM9Ap0PWyMxxeT6C5OIuXo4ucdLpVjQnwhef7BIE59cYrIRqD+2obsBOxUw8YhP8rZ67zCiNDmvfhTVLtv3rUNuKSh4jXwM0TtmaNbNa2FUxEArCsslqqDypLORQ97CIGZhKlISfb8hZaZ02MX4HRAnGxSHAxIYcajZU0meIjkK+YBgScKKEcEND4DFCRNIRjilthuYXij/45FbCoReAsEGpDYtlP+ofaB2egLgpfJsXjfVTZL0GxAiBnoNBzTXhWTdRblX58R8/GA1z8f1+yT5lYQ+GNUi4HLLFZPQraVbiLAkvlO4muHQ+euD34fWGnHPIXMElZDdqZzH5R2zqFaUpIUe4tlrp1ZWvWnrKGs2u6zo8shznkk+vq/ttaAkAf+eyKV56PwKeGVE2uixRxfO07j5mBxIxfSzPMm0k62wzLGZyJeeqDOKUt+B/0Z2khECDZrit5KtUoZzgIrBml8Tcd+gGgMNb2LIrqTO0Ruqwv93R5MdfWGhxHtQKkEnT7dRDoebP6f8DPtMPJI9TGTQDqdhpUxwLPbSkFNQGxzuCF4KvV9hY7uwqqcZ4sw1KOP1rXuFMQ805vYO6Uq4GXMym+dSxFGz2ywX5uSqY0tMpu9VaUKGxPuMx+J+A20n8qCoBb+DqUtQgzT4hawaf38nb8SvdIDlLsCE4BQkK9K73LYvBlQYGIGL3sxHuIlsWXbxst0vcq4eRzthgm6gps4gXHfyENqIfUGkh8nhwEz+2FKaTHsF+rMM1LZrwiEID6gOtSOswG+btpRTQU8leWs52EilVgfLP+tW3mXM7RM
 IqAbl2Rb
 UdsYDFsAhE87LIVe+JotAiDs/TNcKWtAvat3+gqVOauq1kBvZlnLEG1CZDu7L9eM1QwyuWpsFTxTgTqkbObNhvDO5Sk2/DXGD3kfyNzIRKTt/9FGAC3VIgOhNBwe9ZVYBmS0wZwGGh+Q7YNicrd3o37W8Vlh3iLs6YHp5DEFLL9iHaFTEjZyMOoAECn3EUWmDSEcIx3PlW21mhKcc3xRD9X3ogmGFh4g2DkpjOZT1eDO85AxNzcPCHB0Jkc0gngEHJiexn389yga5juNQjH7MVzQndaNHPgs13v//AZNguuxU5UvD57Ok7+vts7m++2xic8b9kDCbf/HuWH4X+lpNM7vKVx2LbR9Yh9v6ef35FuEEYld+Q4z5cDr6PFOAS5xC5wsCItvOwdNy/TB3IUJp6W9loFTmLQsdEqyB+S2NfUt8J9SesPG9IDgwJB3ArUTCvR7Y2hMitGLieHwKHd5Zdac4NrveLko28U6xsw48RvjwsjSKspCnOhEXQQW6EQIKc2tCOfmNuM/R+U1fvhWAYo15QKX3qTsabLbWRA4RiHQ/6y6WNtGBOmj13gWVWauwFHdlz5g+bU0EjeGfEcsx5AtJX+WqIz6oYmT9jK+H/v3UQ6Vg183neF9jmzD+ZLubd9HTOSfpaVCJiAqjYx/Ou+VdVbw8Q9jz0tU+6OICRIdg5Ga3kUgeN9yF1NL//Tz+f7Oex60ftwslxVZLHEdKQfcyM18ClA7kMOLmgEo216C8tEk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 05:15:45PM +0200, Jann Horn wrote:
> On Fri, Jul 25, 2025 at 5:07 PM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> > On Fri, Jul 25, 2025 at 04:48:09PM +0200, Jann Horn wrote:
> > > On Fri, Jul 25, 2025 at 3:49 PM Lorenzo Stoakes
> > > <lorenzo.stoakes@oracle.com> wrote:
> > > > On Fri, Jul 25, 2025 at 02:00:18PM +0200, Jann Horn wrote:
> > > > > > We're sort of relying on this
> > > > > >
> > > > > > a. being a UAF
> > > > > >
> > > > > > b. the thing we're UAF-ing not either corrupting this field or (if that
> > > > > >     memory is actually reused as an anon_vma - I'm not familiar with slab
> > > > > >     caches - so maybe it's quite likely - getting its refcount incremented.
> > > > >
> > > > > KASAN sees the memory read I'm doing with this atomic_read(), so in
> > > > > KASAN builds, if this is a UAF, it should trigger a KASAN splat
> > > > > (modulo KASAN limitations around when UAF can be detected). Basically,
> > > > > in KASAN builds, the actual explicit check I'm doing here is only
> > > > > relevant if the object has not yet been freed. That's why I wrote the
> > > > > comment "Part of the purpose of the atomic_read() is to make KASAN
> > > > > check that the anon_vma is still alive.".
> > > >
> > > > Hm, I'm confused, how can you detect a UAF if the object cannot yet be
> > > > freed? :P
> > > >
> > > > or would that be the case were it not an atomic_read()?
> > > >
> > > > I guess this permits this to be detected in a timely manner.
> > >
> > > If the anon_vma hasn't yet been freed, but its refcount is 0, then
> > > that's still a bug because we rely on the anon_vma to have a nonzero
> > > refcount as long as there are folios with a nonzero mapcount that are
> > > tied to it, and it is likely to allow UAF at a later point.
> >
> > But how is this happening?
> >
> > The only places where we might explicitly manipulate anon_vma->refcount
> > are:
> >
> > - anon_vma_ctor() -> set to 0 on construction used by slab.
> > - folio_lock_anon_vma_read() / put_anon_vma() - both cases call
> >   __put_anon_vma() when 0 to free the anon_vma.
> >
> > So how could we get to a refcount of 0 but the anon_vma still be hanging
> > around, except if it's freshly allocated?
>
> Due to SLAB_TYPESAFE_BY_RCU, the anon_vma is guaranteed to still be
> accessible (possibly post-recycling) for an RCU grace period after its

Right that makes sense.

> refcount drops to zero. Under CONFIG_SLUB_RCU_DEBUG (which you need
> for KASAN to catch UAF in such slabs semi-reliably), from KASAN's
> perspective, the anon_vma is effectively freed after an RCU grace
> period.

By UAF I mean used after kmem_cache_free(), but I hadn't grokked this point but
y'know kinda makes sense given the name...

>
> Basically CONFIG_SLUB_RCU_DEBUG turns kmem_cache_free() on
> SLAB_TYPESAFE_BY_RCU slabs into something like kfree_rcu(), and this
> allows KASAN to catch UAF access.
>
> > It's surely only UAF?
>
> I mean, "UAF" is kind of vague when talking about SLAB_TYPESAFE_BY_RCU
> slabs. I am only using the term "UAF" when talking about a situation
> where accessing the anon_vma object is entirely forbidden because an
> RCU grace period has passed after it was "freed" with
> kmem_cache_free().

Could it not be either case? Or are we sure it's been accessed within that grace
period?

