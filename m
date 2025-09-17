Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18B11CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 07:07:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 728DB8E000B; Wed, 17 Sep 2025 03:07:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7000E8E0001; Wed, 17 Sep 2025 03:07:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C81F8E000B; Wed, 17 Sep 2025 03:07:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B1128E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:07:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C88FF11A0D5
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:07:50 +0000 (UTC)
X-FDA: 83897862300.15.CDC7475
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4661480002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:07:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cmXahzmZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=d9pO28jz;
	spf=pass (imf02.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758092867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JiL1y7WQGcTO2mGMxiLo2Jmy98O1+MAx2KGFpQG86kQ=;
	b=KCSvM51SDJhKv1NgJJKZOtrMWe3dfcdK4kHjQsGM7u66Yi8k0layjMtuiBr88U6kXc+jHd
	qYrCQ3mFJCCiv+7TLA9N+r0w/xcAxllA3H8vMFMgxcIooDPMXbZOZfyZBC0DUCYHbTVRI1
	yCVb144QZhwoJhnEtbXCAhWCTZTSbuo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758092867; a=rsa-sha256;
	cv=pass;
	b=TAA0p4gWEVb3nZhuiynVIulNiuq0qhJnzmWLrQF2znOBjXc+Cq4+fIr4By1NnpHUTqIICS
	gVT1zynOk3v/rEQoVAprIsafQQPHgfVKjKsqIN3jEq2SZJvIhwnVh4jIc3m2TTdEgvvrqh
	CbDN0FepvpVZc+Pw8pDMaqCkllutbgA=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cmXahzmZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=d9pO28jz;
	spf=pass (imf02.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GLZRLe013176;
	Wed, 17 Sep 2025 07:06:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JiL1y7WQGcTO2mGMxiLo2Jmy98O1+MAx2KGFpQG86kQ=; b=
	cmXahzmZcgMx3IDsXHWr1/jdbK4+kukdvEvCpcisB4P0KmqXC9rOsyYjp3862565
	6LbFxgYzaOGNc5NSx/3PzvJwr8bttyEoRV2q1aOuZzILaXl3ecCCAPthCg26kXwx
	ypM72MFY16vZN1kFRTWn3HPK5V4GJhjgbuCBExVa4LNq6HC1+U3hKoqw8m4YgVpW
	czQUw2oSZZPUZWoi2dlUyFuksM+Smx3yOTjTJKka0cY8Ki/TTzDWhVgQ+xTXJZ6Y
	RMmtiYxtK5ZPfeWq4C7NZQDmr563XgmXW3Y1+8ahGmDSjJsNC2FlHeC372lADhwH
	UcD0P+SIZuMs8bZzHgovDA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx9rjfd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 07:06:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58H5uJVs035204;
	Wed, 17 Sep 2025 07:06:53 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010019.outbound.protection.outlook.com [52.101.201.19])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2kpavm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 07:06:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KXd9sLvJDP8/nxtV88PF64wxxgfV68PBu63NyQWFGqWFH0elAavkPD+587ph7KwL43dzVNIQAJtjIxtu2n+ohnapIyqfVtWNKNDsfhHmKBgcYIJ7wd5DEoz38g1ExxYNfR3aVaB+/4MF5OD0+E4+KIcPRYiLplHaj5xKghR2MmAF7Xyla5ffWIbyaVkwIXu2wwTeNxCfnGCS8BRmveLZztsniugSwMoXAz7yIwFBiBdR9du1OrxZUJMEGo1EGP/ZzXjpwsJUcVS2SifQU/fh1QfekSu58uq7ZtR5UmKYjbe9wOmhDjCPWBgj87VHwdAjZNAT6ZVRsexv7p4n2Dx/NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JiL1y7WQGcTO2mGMxiLo2Jmy98O1+MAx2KGFpQG86kQ=;
 b=Ih67ndUEY/lPyhPkjwREGUn9Yvhbh0PuHRHqv5CUpsc8m+S0A4FvxSfW1EsXekom8JLQGfLqE/+TnMVQOj1HYHNna+2CgveDzU3Mo9UQBg5rBYw9SWOpLWJhFrjEi5IN8ysWoQrzSUPdMdtbi5s+HycJfhkbo0OuxpHcJ2gmeuuWU9PlKSe40tvsuvHtm7JTyF5jC2kOPCZyjP/Uri1h3lycvaEpHBybDyuuzQdWs3fL92JVAjXLHBNnxx43WeSyFj4KmCfCN1QvXmmuSD+0Le8rMYU4kQ6MVKUI88A/zohCLEJkT7T9sdfpFxr6b6+imdjH6lbPTi4CTIXfgXUo4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JiL1y7WQGcTO2mGMxiLo2Jmy98O1+MAx2KGFpQG86kQ=;
 b=d9pO28jzbRxslsJzMJhdj0YqNvSXCMpnj3gI8Q2U9CgY6+bcl1ZAcZ7VJjUZ5Lpt+63ZvbxhpGuXZ2twt/kLf1g0vauZV9ReLY69jjPPeZRBw1djhAmf1lGX/C1RGbitXGvlPld1rsuNm07a0jX83JTdoGdHV4rGRFJvnf2GTi0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ5PPFCC6481C4C.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7cf) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Wed, 17 Sep
 2025 07:06:47 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9115.018; Wed, 17 Sep 2025
 07:06:47 +0000
Date: Wed, 17 Sep 2025 16:06:40 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, bpf <bpf@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Shakeel Butt <shakeel.butt@linux.dev>,
        Michal Hocko <mhocko@suse.com>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH slab] slab: Disallow kprobes in ___slab_alloc()
Message-ID: <aMpeADsz1Znaz8AU@hyeyoo>
References: <20250916022140.60269-1-alexei.starovoitov@gmail.com>
 <47aca3ca-a65b-4c0b-aaff-3a7bb6e484fe@suse.cz>
 <aMlZ8Au2MBikJgta@hyeyoo>
 <e7d1c20c-7164-4319-ac7e-9df0072a12ad@suse.cz>
 <CAADnVQLNm+0ZwX2MN_JK3ookGxpOGxEdwaaroQk+rGB401E8Jg@mail.gmail.com>
 <0beac436-1905-4542-aebe-92074aaea54f@suse.cz>
 <CAADnVQJbj3OqS9x6MOmnmHa=69ACVEKa=QX-KVAncyocjCn1AQ@mail.gmail.com>
 <c370486e-cb8f-4201-b70e-2bdddab9e642@suse.cz>
 <CAADnVQL6xGz8=NTDs=3wPfaEqxUjfQE98h5Q2ex-iyRs4yemiw@mail.gmail.com>
 <aMpdAVKZBLltOElH@hyeyoo>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aMpdAVKZBLltOElH@hyeyoo>
X-ClientProxiedBy: SL2PR04CA0024.apcprd04.prod.outlook.com
 (2603:1096:100:2d::36) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ5PPFCC6481C4C:EE_
X-MS-Office365-Filtering-Correlation-Id: c7a767ee-271a-408c-514d-08ddf5b8c438
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UU9DcjJIOG1QdWlnZTZSOW0wUTVVQy9PMWVPRC9PK0RpVkVLaFdGODRDMmsy?=
 =?utf-8?B?OW9KbTNrQ3V2RWlvdGdQWjBucmdWT29VQVpZQmxMK2pRaHU3SGZPOEkvZXNG?=
 =?utf-8?B?cTl1c2dOV01wS285enl1UnhjeG9VWmpWOG1zZEcrcXBtUzFTQXEydFFvYVV5?=
 =?utf-8?B?YUIzTnlBZERpZUZXNzM4cFZHTjZlT2dXTTBTeW05TlJvYzRxODRBeFRqeStG?=
 =?utf-8?B?dU1EalBqbmdtNFJoeGJjK3lCMW1NekdWNVFyMk9uZWYyZHYvenFja25TYTA2?=
 =?utf-8?B?ekRJaWY2ZXRrRTlZMHFvSjZQMjRzMTArTStHUXowS0xSdE55Rk4zN0VDQ3Za?=
 =?utf-8?B?NDhmUHNnNFpYOWJyUmZ4dWFFaklMemd1MU4rSm1PVnJjZHFlaldIVFozZk5O?=
 =?utf-8?B?L3dBNnBNeHBWQUVUeEVnRGlqL2Nmb2Frc0JIVXV5djNiVk1VTkozYnVxTkdY?=
 =?utf-8?B?WVJhL08vWUdBNmFoUDZBRktXc1NGQnJ3Y2R3eU15S2xxU3pBamxrUzJEMklX?=
 =?utf-8?B?aHJnYXF4UVhobFN0WXB0dWRDWm51OGpaK3NEaDN5SEtWM0svR3FXUHRtMnd3?=
 =?utf-8?B?SnEvZVFIbThLT3VoR241a1ZaTDJFVkhWcjJ1RmVKV1hmUGwvNG9QUVI2NitI?=
 =?utf-8?B?TFEzUXBLajRERFJ0a1BYMFdValBoTVhLMGEyNTk4anUybitSN21rdDRJR2FD?=
 =?utf-8?B?WnJTVVBwaHc1YUtad3Nybnoxem1GV0RCRWwzeGdIR05uL2RFQUZNQUlqME82?=
 =?utf-8?B?YjJ4NDJnN2hLcDVxQmVtRWlVaVErbG1oYW0weWNTdkU5Y0wyTTg0cXdtWWVL?=
 =?utf-8?B?bXkxZUNGdXEyZGtOczlacTBwZTBSVDE1cVRvazZjMzVzektFeW81Vmt4VXpZ?=
 =?utf-8?B?aDhEdDZmV25DVytVdml3RzNXU0phWFppT05WalArcHFXVzdsT2VzQlJ6RFJv?=
 =?utf-8?B?Vm54ZGFGZXA2SzZRTUlQWW9QN3J3WmZMR2JwZzVxdG1FYlhHbFppQTVRU0Mr?=
 =?utf-8?B?SC94TkV6dVVBQlhNRnBQd1J0NWZ5blFKL2phUkxwekJjZjFJcWthZm1Wc0d5?=
 =?utf-8?B?SCtibmJFNTFXK01xbG9aNXF0UEQxL2FFNnRPNzREUk1Cdm9md003Ty9XL0JM?=
 =?utf-8?B?QzdXdTVEcVNINGtjUTlCMzgrZEFFcXF2LzVWc3lBQlJXRFd0b1NXL1pnNVoz?=
 =?utf-8?B?M0d0Z1NlZExtRWFHVllhdGtCVUF2Sm96WVpERU1Xc0c5YnNiYjlhMmxCWTc0?=
 =?utf-8?B?b3dFc0JvRi82eGVEa1h5ZEQwSDlKUFVzR1FDMFExNU82SVFDNUUrZitDbC9X?=
 =?utf-8?B?T1hRNkdURXBaVHdsc2tPUXNId0ZsWjNCMW8wRHpLTlZLZmx4TjhzZG5nL0RB?=
 =?utf-8?B?RDROb1I1LzRyWDJPbVR2OGw1K202NllhY2tRWHo1ek9Pb0l2VXVGVElrcGFQ?=
 =?utf-8?B?cS8zUVdTak50dWNjOTQ5TnQ2REYybWx5MnN6eGtJUGQ4TFFsT0JqVGtJY0d0?=
 =?utf-8?B?cXlSeHFBQjJoSmlwUFhRQStzNGdNS1ZZWjhVdmdkdDBtcHNhRUsvRzI1WERR?=
 =?utf-8?B?Qys0NGxLQ3RLbmZrSmV2MlAzS3p3a0wvQ0NaSnQ2aXptWWxvQ2pUWXlScGN0?=
 =?utf-8?B?MmV1UnJ2VHYxMi9UK2pvOWU2eFErd2xueUF3cTNpTkdHN09Yd3g2TVpOZnNK?=
 =?utf-8?B?SEQreFNidVZWUnRmWHpoK243MFVUSytHVnFaM0Y2MUkvMUUrdHJMLzZQTE9T?=
 =?utf-8?B?ZEYydXRhbGFBRlo3RElwNVJSTWhPM0FCcHRUODJKTEpHSlk1Y1dmalhxU0RK?=
 =?utf-8?B?N0JtUE54TjFydUFHbnNXZTZvbml5ZWNSMis5VkFHVTQvTmg5aG1vVUlWNlpz?=
 =?utf-8?B?NW1URUNJY0J5cFpLWkV5OGV3OGFtM2xoOWRNeW1iNzNML3RwOW5KVHJNVVJM?=
 =?utf-8?Q?Vr/T73OfPDw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QWQ3VE1wWGV5SUFzMUNuUVp5cWZoK25hWUhaWVEyUkwrbW5WYnhEd0IxZVFm?=
 =?utf-8?B?YVhjVUVmeVB3NFU0dXc2YjVSUzBybHQzZzN5dHlmSVAxdmwrOW1CeVBmd0h6?=
 =?utf-8?B?ZXNIZDlnNzdpZVNURjhjTCthVnk3ZzJLUWtjcGJLMWVhc3ByQlRJbmdKb0lm?=
 =?utf-8?B?d1M4bFBUd296OVExNCttYlJFMEMvNUJsYnBTaFQ1ajNoanNjZlNwY1FUM2NK?=
 =?utf-8?B?N2lXY3dnVFVnMXdRZFBSaFlhMHhCbDlEZGZDcWVNNDNjcGU3Tjl5YTRadVdR?=
 =?utf-8?B?OXNQYlZRM1c1VjVYRGdLY3dweDhRYXhkSEYrcGhUNVlYTm0vTHZHK0NEUGhV?=
 =?utf-8?B?dnZJQjRpbHpXRUx0emNGWkFsMDlXa0VlYURaZGp5S01oaVNkT2xvcTZzUW1z?=
 =?utf-8?B?b0FkKzZGRmltN2tMWWtmdTlNYjJDLzgvYm1ZZEhqRjU2ME56YVQ1a3NydnB2?=
 =?utf-8?B?R1YxUTlnUjlWOWZvMlhMSDk2ZTQ5Z3N5YThRbW1hOHhDekFIL0k4TDVkcmcx?=
 =?utf-8?B?SjVwZU5sWXpvaWlPTjZ6N2hVZWVwdW9JV3JNVFROcWxER29wZTFJOXpuVE1V?=
 =?utf-8?B?bktQYmtRUC8wN1pOcGlwNHk5MGxxOC9GSzlqME1LNElBbWRvYkJvdStleTlH?=
 =?utf-8?B?aEtmUVZNcFVDbHVTSUptbXIvdlpRQzhHc2VNZGQwdG4za1AzaWVNaEFKZlM3?=
 =?utf-8?B?YW83empqMzgzZU4wMEh4TXNZcFQrbnNKT3FOUlJDRmhLazBtbytTYnNqdmZw?=
 =?utf-8?B?N0t0RmJyTzd5UDN0Mkc4eTZNYnNNaW54ZHF6OFdzWDE3dkhhbzVQQk1IVXFS?=
 =?utf-8?B?V2JrN2p5UVdlR3JjVHNDYlRUZEZLVHJCY1QxZEk1L0ZUMExhVGFWYXhDK2Rm?=
 =?utf-8?B?WGVqRURjeWJLSVgrVWhJWjZwM0lOd1B1Vld3NGFDN0NnTitLS0lpZGFLZ3ZS?=
 =?utf-8?B?Qi9LYXJrS080ZCtMVi9DcWlQS1ZFQ1JYb2lId25ZSWpFSUh0UDVsNUViUUhB?=
 =?utf-8?B?dkgxL2VPMVhGTXBMYWJ4amtKc1VEd0lJbWREV2t5VUtNMzVvTVZ2d2NHYVJP?=
 =?utf-8?B?MEJyZ1E5RkVhVWpidDJxbWhUcjk3cjFiMFZnc0cvM0tvblR5MUxKcG52emw2?=
 =?utf-8?B?R2duUlBKTm1ma3I4WmplbjN5NDU4Rk5wYjlIa2FLK2g0WE04Uy9sb0hXOG9D?=
 =?utf-8?B?aFZRWk82STZlWkVRK3hFeW5VbWs0N041OVpxdFBFSllKV3dzRWZVdVVRVklQ?=
 =?utf-8?B?MXVKU1JjcHlZTFFEV1paS2hEelhLQTk2am1jK2RqdVcvRmxSaGFZOVhQWWZm?=
 =?utf-8?B?bEJMSVFNczBJcytlSlpibllQUkRQZ1VjYUZzcUlzdWRJbWU4RTdBRldQd2tM?=
 =?utf-8?B?SGFiS2dzUENYa2tBYS9NWXBDT2luTUV0L1J6VFVSS0VCMkpnVkJpQVdjUDZw?=
 =?utf-8?B?MzZRdkJKOUdLNEFLNEJuWnZhTmZOaXhRYXB2VVNHb0ZNNkVYWUNxS1NsMWsy?=
 =?utf-8?B?VmFJTWROM256aHArNU1nMkpmR24wdHNTZUZYd3I2cmRlUzZHWlF1SWhWRDFi?=
 =?utf-8?B?Mi9CZ0VLbWliUzlIS3o3Q1J2ZGRkcEZzaGFHQlpqOVhEa1ZYdEhUN2xyeWIr?=
 =?utf-8?B?ZUQ0N3oxeWswa0ZHUUI5a0YxSDBubE9HcHdzRElsU09Nd2pzcnU1d1c2SXB1?=
 =?utf-8?B?QU1sVEI4emlSRDBpUTBkZWYrRWlETHdDZ25vUEg1UllvN0NUOWp1dkcrczBD?=
 =?utf-8?B?T1JYTGROQjh4SlpiR080MDZNYzkwdHNpT1RvNUNXeW9xS3B0aEp1Z1F4SExQ?=
 =?utf-8?B?a1ZWS0d1Q3dOVERBMmc1dFZPWkN4ZldUb0pjeWFqQTV4TWFxbDRqTVd1dlFY?=
 =?utf-8?B?RVpER3JDZ3RqMlNONjd4a0pSb251Ni9XQVBZK3pSTVh2SUpQZzlMUU44T3ND?=
 =?utf-8?B?N01sZ3lvTWlzeExuMHNNMy9wTkE5dm5mOFFrSFdxWVlzcTFRWWxjTGNGU0ZV?=
 =?utf-8?B?TE5aTzJsYUl6bUt4Z2RxMEJwRmZwbk5NTmZHS2NUTW1UWXVhOEVZdXdKVmo1?=
 =?utf-8?B?blNQTzgzeEQ3ZGJCZ2E4Tm5URzhXZmt0SjROdGg5QXBSRGdpUUVOL2lwK29L?=
 =?utf-8?Q?mgeDKkc4YfoWXZbKyOpupdddl?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/hJbMn7eMjUKxyRBUsJjs8uDKPFz185stbogVQli9t8wP4aZlc3Vaw04aHB2IB7z2ZNhUoWDRAnBFZ/AMaYZYUEl4LUsdOLiDo43tmYziUtDPUAmM1IP6c6Tc6GSIxafv8qsYKSlfIwTW5uGi91noz9r54xwQmNCQwuz7HuLTp9jO5pF+sS4w4vt00iRhFz2V8GwpkzEgwTVqCe3CPWnGPi8/5U+PQMDgKqLZoxH0H5DQwEDb//TnYaW6jacZzoGUFIDIczsYs6tZzVzBJG72hZHswIa9q9CrTWlxF6AKq1CnpvnsxYfHz0zv1p2b1CfUfJHg0ms5ksiYbrlVhG7LDXlGsC8uRj+AZmL+fuest+4kbqzcKmBmLlh5fLIdG+WoyVAxPi08oG6R7IBustrEDggvb16CuFkJg/0kegbPOkAyyw202mtSgyHdNd599ce106PpNVRZp5dKIlNppfPkaJ1pNT5w9rc+95G1/JDbSN8meOkve/d67rl36CCHed2/Eh5Ycf2eheJ3akWhQiaaD2VjKL5yAcGGWz15tpq3wtbanj6TrZjcFeSW30kFR3fRWTRnUeYdms5amYbsWdXpVNkhOIxKiuoiCiq1P7fu8Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7a767ee-271a-408c-514d-08ddf5b8c438
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 07:06:47.4528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IK3AEgeXUTb5/0nBtXdMAQDR7gsloKLZax9YwvE0iV/GUxkaqxASpz7U481D3FjdjuAvFDmY6n60GAhxjP28Rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFCC6481C4C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-16_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 bulkscore=0 suspectscore=0 mlxlogscore=746 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509170067
X-Proofpoint-ORIG-GUID: xk4yHq_v-G9eQNYeWJHezz5grZARkHs4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX5f0ANeqGgNi7
 K9glAzRFbxu2RRFNa4QjAA3gRD6TyNZafjL8JWE3qrEfE4qtCp86Iy+/zH79sLtlWJ5rba6kDuI
 7yyXCvED4AXa8NLlJn5HNUpi+9Y0X9K9cCaEjYfeS74Ay2va4nVOyXAquUBIHYpONXfXXBodVKN
 4/gj9R0CholJ1VLN01DotMSymXalyZT/zIEBlNNarhoatnRcgTjwS0WzWJlW5qcSLo/Up++b3ww
 Pw68s7onC53PdkCjkIXMIwvKfrWOtqNENXyPdbwtVFEvzQTfbkOOaV4q++IlEcnPbD+yoQkcJ+i
 OElMuo66owsKlLUuJWjMIMTyAv1aOnKjlZnXGo4G184fyAVJjx2guvqHs/CHEQ1jI728WAm12S/
 HcyecES5cgK7+tyUlB7wIPIab0goOg==
X-Proofpoint-GUID: xk4yHq_v-G9eQNYeWJHezz5grZARkHs4
X-Authority-Analysis: v=2.4 cv=C7vpyRP+ c=1 sm=1 tr=0 ts=68ca5e0e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=JQq-sXXh_NJ9pcysW_AA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13614
X-Rspamd-Queue-Id: 4661480002
X-Stat-Signature: c8sposiz7w5tcohpg9jgacrmh74b9kw3
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758092867-764656
X-HE-Meta: U2FsdGVkX1+sx4tvwnyX1p8IEWimexTRyDdTir+rJhJOlnQZtK79fIt6/ocSLoXtyOiFU4jH+Cn9TonQIN5shnjBqFJUAMSjw5KmefZXibwSkf7YyHPBT7tC0EHGZz9ynhISpyUdRjNDS9U7Gm61vEYxe+f/MTF2rVVkdmgmFdpGpMnKJlV/F1QuH/6JyEWeSxZ5jxPsNQYp0N/jTottQ5qLLgzEYcu4XZW2k18CxxaZ0d7KScr5cAICx0Us9IkRtNrM8S8E/v/Kj0+CC7LhiB0nCCt5XIwIo9P/E6ff9jtIZZwKvuHgG5Sy9pvB/iPpiPMoC+hzYaptB2bfe1cIes6wVV6yEhEGeGNhgOtixED/dswDp13bC9mhSbjWc5GdSGqOAKnKUyBoZ2twWq55nCUYpABkq3ufy3QaNLFy5qFBjpn94fDmGBJpc7PYk5zqDcYmyEQ+QrzkaY2HyZ2sCJRF3KLV1VmGkT/Wd8pJZxckyCovzW8D6C1LLzBvAz1kSJYvGd/BnUiGYiHamximG6eJmi9ju3IrcO+Fhg3JmvmuLFVbexh9LWa2eKkglEAxDQtqCrgJ7hgh4RlbdLaQEIagg7dz7A4SMe//Sm+PfbT4UCoji/XGMkhHJLlMOTTBnHongt78b2NBc5IkO9+P89eFHbgwjlCVBBtdeP+7scqG9L4133/AWvw68cFa1vYIdy3CEH6XuXJesk/GwZc5B2lmr0BHsgaGxiOXbUvw4KmQkZv26Cj1gIQDS9/5+84yi/SI4lK+wCyLOZswttXqDl/MH8qHoylPzo1q2MdiajXvrWUC7MCer1e6ED+3Tmqs527Qpa+iqvB2Wlpi+V+Xo2bTPWyszkFm9SXzJu+NvapstMUqxXtt3nH3ccLWfg1rijtCRPwrYJhNB95dX2qVJi+LR10sIsCIqT4gtYm3j1Q+S3kuiNKVroDhk+vyXd8idrrayY+CeOTCGy5NsJ1
 QY7uzJIm
 xocOtGO/sux2H1bleDM4zVBgiVQUvnU99h4m/5PRR2TaHdQwUwCgHM9HYuPgfD3CjYZkSnvw1safzt2KKoIGVhL5onRzlJTD+WNnrxO1rTzJO8bNedTwkFCMlBp4dr/4rtm14fh7mJxKxdOdSOjh7V/Q72lrV2+v2lYoK3g5fm/IOXKOQw+Vpn4Ccv3SawWex2pGhGFR9MylKyAY+QjlaoFi6hi9BK8ZMxOo2k+ZcxTJ6AD2bp4c05MOfCMscqgDX6ZxEdXIwfDXUEGCIHteEd8Tebo10xF7sGgFq3JaFlxKhs/B1vrUW67fi4QEbVCNQ+DMlbF4HlDDdSy8M8xDBAh5Pb1Gq5LOpNODNq9MjaWAzBTzbhMoiCrjUC/pARfbZMD6eDQW7epMwUd7T9ciYd8cx/5JSYaqcBg1GhWwKo4pIAPs7yrc2IYkwbdgrGaWnVfIOV0eWnXdJ28CXfNpWEQOZE0Bcaw29nGppOD5N65oZp+vUsFQ/pbxo2dbMXY7Sh7foYx1yoxZ634yUXgFyX090PifZ/twzFU9dZOEJsO0wEm012m4KN8Y2UVcN9P7ZkIhNiaEdMFije7Q4mp42vMU+QKQhp+GiPcnO3eCtKE5hWqsxf0C4MI45chtcWjVAm+Bng+85W8DfZioFa4Vvf3S5PTNPAtg7eU2mGvcRBLhg9svloZpzZ3vmaJZpa3ze8czWFFm4WTusjMWX82mP6cwjupWWIMg6k13pRoURsMAt+nSiJC0YZTvoMjTPJZ+6z0ERMZCaa2OI+Y6lmBwuA1BfAkQLZUhoXx9KCNJkjRMzX3amQ/avadv7qQ3Gd26P0cQu3GDO507TvJrbDSB8cJuFuYA/Y43/Xbqz/8NRcRHIH8dSr0y917UGc6xDs6WbSaMfNNB3cW1ferw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 04:02:25PM +0900, Harry Yoo wrote:
> On Tue, Sep 16, 2025 at 01:26:53PM -0700, Alexei Starovoitov wrote:
> > On Tue, Sep 16, 2025 at 12:06 PM Vlastimil Babka <vbabka@suse.cz> wrote:
> > > > It's ok to call __update_cpu_freelist_fast(). It won't break anything.
> > > > Because only nmi can make this cpu to be in the middle of freelist update.
> > >
> > > You're right, freeing uses the "slowpath" (local_lock protected instead of
> > > cmpxchg16b) c->freelist manipulation only on RT. So we can't preempt it with
> > > a kprobe on !RT because it doesn't exist there at all.
> 
> Right.
> 
> > > The only one is in ___slab_alloc() and that's covered.
> 
> Right.
> 
> and this is a question not relevant to reentrant kmalloc:
> 
> On PREEMPT_RT, disabling fastpath in the alloc path makes sense because
> both paths updates c->freelist, but in the free path, by disabling the
> lockless fastpath, what are we protecting against?
> 
> the free fastpath updates c->freelist but not slab->freelist, and
> the free slowpath updates slab->freelist but not c->freelist?
> 
> I failed to imagine how things can go wrong if we enable the lockless
> fastpath in the free path.

Oops, sorry. it slipped my mind. Things can go wrong if the free fastpath
is executed while the alloc slowpath is executing and gets preempted.

-- 
Cheers,
Harry / Hyeonggon

