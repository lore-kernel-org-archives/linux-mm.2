Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A4EDCE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 11:33:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4F518E0023; Mon, 17 Nov 2025 06:33:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFFA28E0003; Mon, 17 Nov 2025 06:33:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C796C8E0023; Mon, 17 Nov 2025 06:33:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AEF388E0003
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:33:42 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 67C6C12F805
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:33:42 +0000 (UTC)
X-FDA: 84119889084.08.22E3E4E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id BEA624000F
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:33:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=U+XFCFis;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DrgE2Pcm;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763379219; a=rsa-sha256;
	cv=pass;
	b=l+mz3YnSHifc72mMMejFmYORDoqCYA2bI/PqytUn8Y8x1hJxtcWeKbHMZd6Kr5JEH/HMlt
	WYYYUqZNMfULJSw1bRDRScabvpCLDNmpsNuKDCbIay4Ab5LxAYn33dMTDeDpuWHCdxXHDJ
	gol4X46Cr79jlfEOpr8Cg9U09KU5Rvs=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=U+XFCFis;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DrgE2Pcm;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763379219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JqxW6TkRc/PJ8khqTvV6mW6+Kt/0NXL/ISmkLwNfTk4=;
	b=xcGH7cCsaBb6vcxGVOf/Ak9Yh16LFW2Sa3XlbOPE0Cgu9haLBrfQENeKzEtAXW4cpBvqd+
	HnduNTTygol6HOu4m3hRiI39rtko+DIA20MD7xgPMwdw7qIMYGALBzM2DkutfKuyVtBKy6
	7Gbe8MtGVChfcbVIlTQ/BtqlvqsjWgc=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHBNWxM003130;
	Mon, 17 Nov 2025 11:33:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JqxW6TkRc/PJ8khqTvV6mW6+Kt/0NXL/ISmkLwNfTk4=; b=
	U+XFCFisJ+mcXPD2ZiNRXoDdlwl+5tpCG5cSPe7i5NTtYfAnuh1uthoKtD3hSlRO
	wUnL2b+NWxQZhPFfAnPD7KygvglF4vfJGPKRJMUYi7AA6h2PvmBSfcdi7Vo9kAlM
	jgJGhBpfCNu3QXinqX/V6jKf3S+4f2AQO1kSc6MxS1wlvOxW8zG+ZdAAzI5rvrtX
	t6l6Ug5wKCtCKOWov04mWRfziK4DpMD/ytHd5p6j0hul+gZ+W+lS7jR0oSc077yK
	FDF5FNw2tgkbkwhSqLUrXNrg4uUxPlP7E9/YACTpbsTVZba0itoZ5PTLfj08UpOk
	GmtTUjKd+2RYvoQF4Fsddw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejd1a7p8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 11:33:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHBTHo1005110;
	Mon, 17 Nov 2025 11:33:32 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011036.outbound.protection.outlook.com [40.93.194.36])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefy7a0h4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 11:33:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BfxeVNKURUCerDlnL7gEoLTVMCLlS67pLqbTpAIAISUBVZgZePrEj2wtC87DxddOnErB0E5w3WoZP9regMnDwQgKtKig5e/oOrtp39ykxqx1fzM342g8OY+9+wT9x7G96ePV2wSd0AwJXNstHi/puS81DN70bFPPze5g76CZMkVZjHf71AczXAS7+pvALOancf+n01Z7UynqgkVkl/XRRFAKWmhPdI8/F6HAmYNV/npZsZTaYChXopONh/Yk9XOLRplv5Q9Mp0UQuQmgVYsHkxbLxHt2eGsZloJcvSAutQpvdn5yubkdWT+e8doe5FAEaaNphYb7Kn1AEpgKEpS3Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JqxW6TkRc/PJ8khqTvV6mW6+Kt/0NXL/ISmkLwNfTk4=;
 b=EYD/bqYAhp+SsYJYMI3XqyxNsfEZaqr0g9+fUmyH66X31Yuv4eMmQ7bFYdB4xGy8FnWztrnLUC3QILSpkWe7CGQFiKXsaMoEmhVYX0RtGsLq+HZ65z708xLN/11tBY717sDRudqbsE8mr5V24tns2lrsykA4vFw3kjG/HK3XQbYFgwaMoB4ZBbqeH9Havn2OmLY1sA+1YWj1Cl1q0s2LZ3wnoY0vmSj0YQHe3sjqiAVqGuPfVWQ4ngfaJtj5voRxSlf1Xnc42JjVmYdiDPy2Yi4AfCP3Jg9yadpIo+eH5K7s/3ebsDDU/XEqfw3J3YSD8FM+Xfk59lK0U2NbEtBoig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JqxW6TkRc/PJ8khqTvV6mW6+Kt/0NXL/ISmkLwNfTk4=;
 b=DrgE2PcmSZ8poJ7TdKHXMvaM+1+QmVYddC+mqCTDBQJjQPBzb5zNZqtHJfuNFWk/1w0hxtf9pQgkC/C7blcGm1dBqJi9168t/E5KB4bZCEM7DJAGBFXi1ijGs530e+SzY2q6hlUu0ZaDXFmm2Cfm+GmBTkCGKQzy35wUS9gMS6c=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA4PR10MB8422.namprd10.prod.outlook.com (2603:10b6:208:561::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Mon, 17 Nov
 2025 11:33:28 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 11:33:28 +0000
Date: Mon, 17 Nov 2025 11:32:55 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrei Vagin <avagin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, criu@lists.linux.dev
Subject: Re: [PATCH 0/2] make VM_SOFTDIRTY a sticky VMA flag
Message-ID: <1c20ec44-0775-47e0-aabb-e1cf1f38ce94@lucifer.local>
References: <cover.1763142412.git.lorenzo.stoakes@oracle.com>
 <CANaxB-yqsphFXvY0diEaHL+Bg4eJ+z_mqezxen9xVyoyL+4NMw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANaxB-yqsphFXvY0diEaHL+Bg4eJ+z_mqezxen9xVyoyL+4NMw@mail.gmail.com>
X-ClientProxiedBy: LO4P265CA0043.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ac::22) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA4PR10MB8422:EE_
X-MS-Office365-Filtering-Correlation-Id: 51c52fc7-3f79-450f-8f65-08de25cd2026
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?by9qOXE0N1ErWkYreTZCQmVaWUhITC9hb0ZIVGRYN3hPNXB2dUo1QktYM1B2?=
 =?utf-8?B?ZVdrY0VuQ3BnaGFHZXpBMjkxRFNpeEZ4WlZXNkZWNTVrZjdsK2kyTjBZM3o5?=
 =?utf-8?B?ckRlcis2eDlDbE1CT1luVDV5UTdsa3NyODNTTUZla1RLeWJyRnIrZ3pHejBX?=
 =?utf-8?B?WjNEMWIzcVpENGRVZjRyWldKSU1ISXVWSTM0RkRIS09IM2p3V1Uybm92VkM3?=
 =?utf-8?B?VzBhaTNZcnhyL2JwWG9nekR0RXFUMk5tUVNXbERIRFJjc210OFpaWWJuYzEx?=
 =?utf-8?B?d2ZtVXEvK2swSXRvOEtYVS9pZWJLNXBsK25wbFRMbUZlTmVqSnF1bTZLRjNG?=
 =?utf-8?B?cndkQitHYXVUZkkrRDkyUVpYQysrbHJEanVqZHpjeTZCcWhJYll5OUNmbmcr?=
 =?utf-8?B?c0dnbXkyQVMzVHEzeVdxckwvajR5WGtzbkFTZlpnRE9RaHhEMjhTTGtqWitj?=
 =?utf-8?B?emkzU0ppM28xbGFvUUdWWjFxTjgyekNEVmZ1eW9NeGw1aHQxR3E5b0ttT2cz?=
 =?utf-8?B?UmpZQm56Q1I0a0NMQzA3N09lWEE2clBOczFwWnlEcnBwL0VtNzllelRFMXNj?=
 =?utf-8?B?YlltV0l5V0RSUGhKNWZQdm9JRU5tMEFDN3h4YjU5NUYzZmNteDRmYU53ZDFV?=
 =?utf-8?B?ZkUxZXVOWmlaSmxUTGZHMXFDUURLYlA4d09FU2ZyMnpFZ2xsWUNMM2taYmEr?=
 =?utf-8?B?RUtMcWxCSjJpUU53aVJUVWJYNTBhM2YwTkd1eDRGYUhNN2VqL3FUaHMrYW5o?=
 =?utf-8?B?dlhRdWhiZWkxZlRmcmcxb1YyRk53eUREdVJhbTJpcDFLd1JqTTR0QnN2YzBj?=
 =?utf-8?B?aEx0aHlsNXcvZm10S3FvNU81Q3dPbjN3aUFHV0xaTDYrK1hibUhBYTFOV3Fu?=
 =?utf-8?B?RG9Pck93Vm1BeEdtMzBlMmk5TEduWDBJdGdXVmFlMDJyQkYwd1QvN2JvKytw?=
 =?utf-8?B?N1NEampSVEN3YldhcmdvVzZaYy9Eb2JZbGp6VlhEcnNObzRVREd2SldyeWVv?=
 =?utf-8?B?WWVNdVJNNmUrZjBNc2pnNmZBVkpqYWtaUnRPTXNnbHVnOVhHTW5ZM3QrNUdq?=
 =?utf-8?B?ZVBkU04zWjZVNUYzeW5uQjV2YWpDZlVMM2ZLNzN4RmpVbE1JTlZSdDNsSEhh?=
 =?utf-8?B?QUs1U3hiZGt1c0NLUTVIazJhUlFxV3FuU1czeUNPdVllMmZyYTlkUWNOSENj?=
 =?utf-8?B?MVJjcGphNVNhQzJpQnNFQW5DckM3NFdZL2M2bzJCLzZBK2VwaXdMOXNqdlFw?=
 =?utf-8?B?ekw2MVg1Ti96WnV1dDdHOXJ1b1hqRm5ybkhvQmtDZjFNdkRnbnp4SEJUYnNC?=
 =?utf-8?B?b0VnMCtGVXdFbGtmOHNLT0xIUzJxSTRvekFWTitOVmlMNkxHRU5GdWVTdjJ3?=
 =?utf-8?B?dFhUQ2pFOUxGUm9tbHc0bzNSeHppa3dCOUZ4cU5rcjE5MUYzUk40NHBoL3lR?=
 =?utf-8?B?a2FlQkllWUM4OXRldEZFR0U0TWpoSEQ5aVh1Q2NNUDlzYVNiNzJNQXc3T2tM?=
 =?utf-8?B?Rk5zWmhxTE1RZkxOZ3AwUjk0VVl4SEI3ak9BaXAzTnRKSmMzcjk3MElobmxj?=
 =?utf-8?B?Mzc1Z0l1L1BQRVBxdVpQUG5BY3RxWTVDZlVUYmdxQW40TUtCTjlLVWp4MDB5?=
 =?utf-8?B?NytrOWpmR3lJNk9KaGhQU1VXWTJmc0k4QzkxTHArQUtGU3ljNSthZVl3V3FC?=
 =?utf-8?B?NnhyWk41blJ4ekM0bkJ1eU1Ia1Y0NGhTaDc5Y053Q2RrTXRjSzVvQ1VJL21W?=
 =?utf-8?B?amNvU2I2NDdOaHpvTVNuRlZjOTBSM0I3MjExeHBrMHg4NE1sV05JdkhJbm5n?=
 =?utf-8?B?YnNXMzlaZER0TThvYktvMk9qcm1PMmlka2hsVTZiU0ZLZVlBT1BDaXlXTE1S?=
 =?utf-8?B?dk1iNWkxQkNkZGYxTThIVVNjL2g4Z3BxOGlKLzRQUDgvV1dHWmJwTk5xSDdT?=
 =?utf-8?Q?oobLpSqhjPj1hbSt/HvFWCPZLacpXY/r?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WkxUT21pRmEyWmd1S0ZaSWZMQ3ZqcG83c01NNmJJdlhlZWNCdm16N05NcCs3?=
 =?utf-8?B?SWIwWmtGQjJrcXlsbDA1ZEljN0VpWmZoT1ZBYnkxdlkvRU1RS2RRTlN2azh5?=
 =?utf-8?B?d3hxaXFBaXhKdFlvRDNhT1hCa2cwQ05ONGlWNHRzNnRWaHFRT3lNK3dFYVFm?=
 =?utf-8?B?L3E4YXBNQTY3TkZJaEJKOE50WXo0VS9ZSGdZK1FGUWE5aW9wWGd1eHBCR01i?=
 =?utf-8?B?UVZRSTZaMVdzUkFjT1paL25IYW9jc1RnMzhkSlByMW4rS2MwMEVEWENwUmdF?=
 =?utf-8?B?bW1HVEdvVjNjYUhLY3BGRGM2VmZjbWI1MzZ1NUhWQnIxbEExV1hwMnJTekJ1?=
 =?utf-8?B?bDVQRDI5TTB5TEJEcGxJT3ZyOGpFZUdRN1dhbnM4RnRzbk0wQkUzYnlxUy91?=
 =?utf-8?B?QWtQUjlRa1RaaHI4T1BzeEdwWUZ2SFZhSzUyTlkxaTJwL0VFRjNiT0kvQ2ty?=
 =?utf-8?B?aGp5WU9LRU1CRGVMV0wvdzRGOXZWM1BaRFBtT0F6UlVvVERKODFMaDR2bXlO?=
 =?utf-8?B?Z2RPWXExcUhvL21NN21tVDBKeVBxVDZub3JMUHFvMUJwOVFjR2EwR2ZmcXFw?=
 =?utf-8?B?dHVGUnl2eDEwTi9rZllSVStXMFZ5a1Q5N0ZnZklVdm5zdUdnc3Z6RFJPUlZU?=
 =?utf-8?B?QWhXa1FacWt4RHZtS1VEZDdSTEZvUWFTbGVsOElES0NXdzlJSXdHT3o0bll0?=
 =?utf-8?B?cjliaGlzQnhacHljMnNNdldJUUZMcFhrYkhyaVN3L2c3cWU1Z3JQSDRQQm1J?=
 =?utf-8?B?eUFTSE94YVVDaUVjRjV0dTBnbDNZOWJtMklwa3Q0WC9tdWZLdi90emJzcEQ0?=
 =?utf-8?B?YmoyeUZlYlFsWjlSN0M5RHZLRks1OWdlZzNiS2hrQS9EVmZqb2V1dHE0eVoy?=
 =?utf-8?B?RzhycmN5amIzYWZUKzJsWGUvaldCcGUrSU05UGEwdzV6N09HWHBaUnRuQjVT?=
 =?utf-8?B?bzJxeUhuMmpDbUxBcERzRkl3Z3g0VzVmMFlGeHArbDgyb1pIMmtxSkoyaXVE?=
 =?utf-8?B?UkRzRVd6UzVCZzdkSnNSbE0yUHhKcUFuMERLSExuT2Q1cVQ0VWZjMkk3Q1lq?=
 =?utf-8?B?SkFmRW5CMzVIbGp1R1BDRi9MVWU5UFo1TnhabjJvbVNyYjIxdmtNYnB0dUZB?=
 =?utf-8?B?MlNtOFRocDhoY3lMdFlJUzl0U0pYT2NtOHB3WWszSDl1SlhGRTlEYUNyVHFh?=
 =?utf-8?B?TW5GRUc4b2Y3cDNWcGtPNUVkd2FGb1V4aWRXSEF4eDRIMFJob3NSQndpcFI0?=
 =?utf-8?B?eFVkL1FsekNjcEtpM1c3eHdsNnhSbldqT1JEWDBpV1Vqb0VTSlUvbnJnR21S?=
 =?utf-8?B?b1NyNjF4T2NQVENQdWtVL3ZYUXByQXdDMnNpTnp1MWFSUTRYVGJyVndTYjBR?=
 =?utf-8?B?UFhxZTRJYUI3YWI1V2lUbVoxOFpkT1oxUERiMlVpb0ZPUlNtVmZyTGFMWmFl?=
 =?utf-8?B?QWQyVjRlK0tRRnRYTTVEVE52SG5UbmI3NGdYUlliVmVscU1FeTdkQUdCV0d5?=
 =?utf-8?B?dVZjNjVzK09aME1pOXlmK2xCT2x0MVI0UDVnakFsaElQNHg3d3NGN0ZMMy8w?=
 =?utf-8?B?UFZCNnBYWVJkblFUcFBTMmN1UklvMnJLeHN2M3g1MTRGZzJFOTNyTDVEajh6?=
 =?utf-8?B?U2Zub1hFQ3RkckZ2eXQyZ2lRWTRDRkNQb3krMWdubXJER2xpOS9rbW1kU0J3?=
 =?utf-8?B?NERNYmg0RWVqam9EZjBSVTlZQUVKSi9iMDBEVmVqeEthR290UjBsek0yd1JY?=
 =?utf-8?B?cXVWM3Fyd1BDYTJTZ1c5cXJVYkRscDQ3a003M3A2bXRMVDNPUUEwd01Fcm5i?=
 =?utf-8?B?NjhJY3ZZLy9mc0RxU3JtOG83Z2RkSDFIUkY3Y2JYaW10QVZ1bm4vRTZPaGw4?=
 =?utf-8?B?K2NlcEkwTktRSWpQbFNFbXRtdThvYkFyWlA0UDduYUtmWE1iWXJab2lKZUhr?=
 =?utf-8?B?ZjBkeXFJaHlUaEtlc01Ma1hESldzbzhyTG5GRkJORm9jbjBHSTdrZnhsanVJ?=
 =?utf-8?B?d05SemFZQnFybjdSWHM4cXR2b3dtRVdLWWhoQnJ1VXNpektNRmVUNHdTVEVZ?=
 =?utf-8?B?dis5R1dvSUtvTTRFK3ZscU1scG8rSTJhendTTkx0U0xmUlIycmwvWTZES2dG?=
 =?utf-8?B?T0QrcXJrOHJ3VVhidzVDT28xcUsvdWVJSmpRcnN0Z3JKNVlWdm9TbFFGZE5r?=
 =?utf-8?B?YlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CesUxIfq88aSsgHPkVOFpHT2Oy0W3jCiftokIRuyPziyyxMIL2Nu4x4jPZZNa6F7XaqG/QFY5A4pI7ZiAQFyv5cl6pOq//y4Fc+bNP+GXY5g9uxc0JodJNwNJCenjxA2P9s7s/WHsVivnrDEHR2SPbnSIGZZhdT2EP5l3wxpuwxh2g0qxI+jKju6xo+6LFT4dfIeYWKyQ/czNK56xU63CFpSw+1TWedpblUkGzjFhN8zhU5ySJ2yLQIC3sAPN42Hgxvjxbw61nDq4k0+0MvknGgRx5X/2g1XZu1VfZWoZzQ6zSKo80yeBBS/qZVAZ6PQVucMgRnBPsyVDiDCzNOGSQnyX0puf+op6Ct7e5wgrVSwKpnvqwPy1f3h2McAn6NyGYBObXaVknx46VVpcHkG/bBilbrjfYLf/bEK9BTBDh/+mn7gsSr5IS1TtcvYJY8E9sEhpp+eC+HwzGMnj3ata2yWf0f8Tk3V/4KztXNfwr96Jxg0sRcjPXqI3G8kMUxn4Ep3HAnSzm65ctu2RAFjmIvBQK545C24ZaUajeREjndsEVS81Lkp2/WpQT4oFgtAZxRR8wmaZslA7ZNP8DggUH0pt9h9Ml+bZJX2TBc21Lk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51c52fc7-3f79-450f-8f65-08de25cd2026
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 11:33:28.4734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: In5xoDoNZKTKcWXvK5a2pk5W1W5xD8kpQPQ4XfT2SxDCKqnaxTUZrNlolMONgvJctEwJNnoSMrJp/Hc4aDb9E7v4Fn+SR8z+teeY411U9qY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8422
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_02,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511170097
X-Proofpoint-GUID: uS7pP_hImw81jyY3BpKSdSfwg-ZoNLdC
X-Authority-Analysis: v=2.4 cv=Z/jh3XRA c=1 sm=1 tr=0 ts=691b080d cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=vUaSe5M6C45CQBOiVPQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX9QPBc34x7U80
 7q2eAUs13wTZtpaibm4k6WQPDLqeRQf9l9ESTi55BYykEcSm2skA5KnCh2qC8yE2HbiErGTMMbb
 eS2muuIbrbuzDO/ZPW9IQGcCL7parb4gb5ZAKVq3ncv5ptM21PkV9BNhYrBEk8YpwfkLYY4bfwH
 YH8x4P9Y9mW4nYd4VBPHqnCX0soRRxvfFlX6FMXw53b4Qt0j3ZOt+b3+yeazbo2yAc3pPR7m387
 XxAwaBwb32O8O/dgMQ+wJ8SUVw+GqpbssI0afQ62G4eBaDbK28D9J6tdLTT5tdkpWBl6+y+G84f
 OR3eID4WZkqe+t4dEB42MI/ODQlMQcV+h4slBBeiR+y56AA19B2FweEy7DSlxjqs1nEhRVYOdvG
 s4XQHqc5oTTbLD7VcieS8vYUlPsXZg==
X-Proofpoint-ORIG-GUID: uS7pP_hImw81jyY3BpKSdSfwg-ZoNLdC
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BEA624000F
X-Stat-Signature: 53tbgoqduzzg1u1x5wkd6awc9w4gpi3w
X-Rspam-User: 
X-HE-Tag: 1763379218-301896
X-HE-Meta: U2FsdGVkX1+QdsmNRetQoq9LPNAV4RNOR1eytZeRpzSl7PpNBhmc6LxSPqJ3jP3iOJhTMfYuloGTTFdX0GevXsF0GJzq4WpeC/frKy2m25f7XFMvmMJU3Emdk/K6cgGFDEeJMR0o9oBkuLYsIjsKikCTih83KafGg9TFNyFZLjqeRlY0MeSolKnHvS8AMToN9Cvdfyf1wtCUBisv1vD43VVpBkADlfzaRbuQq+xBgYZuqmFHZCZZVBRypfdyH51Vphknzar14jHOgqmM8iBDHSx5QOzPppWS0n+tifWND7Uw8nHW4qAOC/9YBRIbiiRovxybGkuwcSFuQOzSSmV2+sMJelcWDMjwy2RfPt8O88ZnSQPmmuLDnXu/7kMlg3jUtwIS1+XQgHmYpZhA3kj3GKHqbSC3WVJtjNcoK5bIQu90dxHwSAG9Isr2TbM5HXkZWNjkP+RoBFqavx24N0TGbR6zeelT4dZpcTpdkdOoWlnGuDBD9UZRNP953vMwFhlVpNR89BwlLyhX70gERjVON3242TjCKttFYMM+xvLKNTGoEoyAtH/DZkO2OuhIt4y04TBo50HYT9bHh2G+9PCZpEJ5Q6LF91Uc/buCNWYg7tYcOOWptMwGWIsCl3sBYCwZ/uDAP2hV7YAk0v8OJWAD95zn6xAm1jCXcb9obtEKURcsYxE2lfyu5mrnzxhxL40KfvHqiXEb+Rf0Q43mVAOaasBapv/tIm40fRbhRE/6emG2LW/5edL1HGzo2DUAXVgTXgblWS+nE8Sc5Q0ua8/ZtfRaG3oO8GBiAqdW8VyzZy+oKk+OgSimhzTnm2nhr0rNWf2rKS2wxDcO/sTXvPiE2Fx5eyaSfwuI9nAIiMWlYLUsxueJrzIoY+VO49WvFWiyH+XxW+DHdbZJWHCxzP4G1NC06Uu6a+TLUc53Zq3FCJp25+EzBoClZIr8EKIpYllsvO/iyo9wUzdHuWl93Cq
 nxeiMpRX
 edIW3wcY3H97sb4X+hZTNMmSe018nZ/6WjM8uRom4jzXMugcU+IR4KbmQPYPZELj05/p+a+I5IruB1D30xw5Ypoqpn1f7WeBd1L++c65jtGX21nueC4j1pT1F5QWTHEEJZrCNHESMKShxWUxR7XJmompE/gBUssNPyTGOK2CR6wcmC07pdObrM/7rOHaUMYM28plpUt4pxb7fiRdF+CQeDPLBMKsgopJserpvUpWR5H/tSmAJnxrRgccO6igLpy3WRBIzM76yNfzSTDZcTVtte/KQzODJ+pePSD3jSB0CE06hqMPOKA2fTV2Y8ky/V33YqFvqRFQbqSD3EpntQZD/r91cQj2C/LZge3gXq/KIEuG7BG0s1Ubb6+t9rdemwgIo9Q5BxMTAxbQkOPnkdSIZzvGIIdbyHYSywhZwtwrgdRCQc7RJbSwWeARFbED5N4YNIVCnZzskf00BTz/pfo4si46sTn/Vfndrq8ocpnhUCw/OpMp5Z4Pk300QQGRaHHOlS57vJp8nTy/ihvyA6hXZEr276sgmuxcVv/O9kJpXviSw8h0RhC4EoRMsx27C6nocPTWwR+yghaQ2atsp+5rr0pOMF4l4L1niRJIIL4V9HngcSpBDKSyG+YFJqr8IjfXtMVx0+EmN9NWtyazwAQUE1sWAHzV8z2IbQbxsXYUKLmKOyqdqlqUWorGCgQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 16, 2025 at 04:53:36PM -0800, Andrei Vagin wrote:
> On Fri, Nov 14, 2025 at 9:59 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
> > establishing a new VMA, or via merge) as implemented in __mmap_complete()
> > and do_brk_flags().
> >
> > However, when performing a merge of existing mappings such as when
> > performing mprotect(), we may lose the VM_SOFTDIRTY flag.
>
> Losing VM_SOFTDIRTY is definitely a bug, thank you for fixing it.
>
> A separate concern is whether merging two VMAs should be permitted when
> one has the VM_SOFTDIRTY flag set and another does not. I think the
> merging operation should be disallowed.The  issue is that


This patch doesn't change anything in terms of merging, it only _correctly_
marks VMAs as soft-dirty where certain, very specific, circumstances might
result in a merged VMA being incorrectly indicated to not be soft-dirty
when it in fact contains pages which are.

Since VMA fragmentation is an issue that impacts non-softydirty users, I'm
afraid we cannot split on this parameter.

It'd also be a user-visible change that could cause breaking issues
(mremap() for instances in _most_ cases requires that it operates on a
single VMA).

So this isn't possible.


> PAGE_IS_SOFT_DIRTY will be reported for every page in the resulting VMA.
> Consider a scenario where a large VMA has only a small number of pages
> marked SOFT_DIRTY. If we merge it with a smaller VMA that does have
> VM_SOFTDIRTY, all pages in the originally large VMA will subsequently be
> reported as SOFT_DIRTY. As a result, CRIU will needlessly dump all of
> these pages again, even though the vast majority of them were unchanged
> since the prior checkpoint iteration.

I think there's some confusion about what is possible here.

Currently if you don't invoke /proc/$pid/clear_refs, all VMAs will have
soft-dirty set until you do.

So this is a situation that _already exists_.

And intentionally so - we default all VMAs to soft-dirty so users can
detect new mappings in order not to perceive e.g. mmap()'ing over an
existing range as as being no change.

OK so what if you clear references? Considering:

1. Map large VMA
2. Clear references
3. Dirty several pages (VM_SOFTDIRTY clear)
4. Map new VMA immediately _after_ it (VM_SOFTDIRTY set)
5. Merge - Before this patch: VM_SOFTDIRTY bit cleared on merge BUT SET
   AGAIN due to it being an mmap() invocation. After this patch:
   VM_SOFTDIRTY bit retained on merge but also set again due to it being an
   mmap() invocation.

So this kind of merge has no change in behaviour.

And again, it's correct - the user needs to be able to identify what's
changed.

This change fixes this behaviour to be consistent for other types of merge,
when previously it was not.

In the past, you'd get soft-dirty set/not set _depending on the type of
merge_. So if the target VMA had the flag set, you'd have it marked
soft-dirty, otherwise not.

Since it's unacceptabale to fragment VMAs on the basis of soft-dirty, we're
_only_ improving correctness here, and this patch is a net good no matter
what.


>
> Thanks,
> Andrei
>
> >
> >
> > Lorenzo Stoakes (2):
> >   mm: propagate VM_SOFTDIRTY on merge
> >   testing/selftests/mm: add soft-dirty merge self-test
> >
> >  include/linux/mm.h                      | 23 ++++++-----
> >  tools/testing/selftests/mm/soft-dirty.c | 51 ++++++++++++++++++++++++-
> >  tools/testing/vma/vma_internal.h        | 23 ++++++-----
> >  3 files changed, 72 insertions(+), 25 deletions(-)
> >
> > --
> > 2.51.0
> >

Cheers, Lorenzo

