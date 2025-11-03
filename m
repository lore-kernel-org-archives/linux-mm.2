Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8637DCCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 16:38:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE1308E00AB; Mon,  3 Nov 2025 11:38:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB84A8E0057; Mon,  3 Nov 2025 11:38:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B806B8E00AB; Mon,  3 Nov 2025 11:38:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A43138E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 11:38:58 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 481B0B7915
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:38:58 +0000 (UTC)
X-FDA: 84069855156.30.828C99D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9F63E180012
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:38:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=V1iuzBdn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=0RUMMaO6;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762187934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AGxOSojmRVQkR0bJuQkNRlZstaGEd8AyXbzIDberUws=;
	b=obRuoATnYNktd/dA7NCKZ687cO3USIHF0ASvgWwpsKoau7K+beEotxIrOkvpqUMItTLbio
	E18yQMeVOTNlLuewXBkQHzoufLAXWp1I6SUKW+ktdHHLeTlb1ffyNDSuNKUnPy1TSCcXvz
	Q4pwsYf/m9zypR3U6v/+OPfwBwgscDg=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=V1iuzBdn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=0RUMMaO6;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762187934; a=rsa-sha256;
	cv=pass;
	b=htvWmhh6c7fQWBN8jZGS7Q2poOoFAaO+WBYVxXEsBl6NhZ20fcK3JT5TQH4813WGI+5RbI
	OFCb+rdURJjadU3O2EYCDnEOlwraDTYlnR36Ndv2oZyKswfex2pyvGeVIpghkL8mRte7gC
	du6ZalVLKgQP2LaCveokRqJNWhnKmyw=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A3GTocp007979;
	Mon, 3 Nov 2025 16:38:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=AGxOSojmRVQkR0bJuQkNRlZstaGEd8AyXbzIDberUws=; b=
	V1iuzBdnkpt9HVS/L7boesMSa7xiRhL+5hAKrOzACCw4Avw+TTRYv3NOsNUYAajV
	E9I9lYozHC01knDrKFAuiAhu5fMfmSa4LEiB+zRgRHpbMwkHfPTlTkhfg9ZW3ty0
	2PD5X9sYRfB/MteCvxPwHO7t6ZKuPPb6pTWJ3UW+h1H+dwtijJueYgL72HLQfm85
	YY+KVG6Hu5QxbzKdgLtKvYtTp0tYQHnhl1haXQpbq9N7a7WEtsaz+WlrRsR5ic/P
	AIBVqVqHDIC0vbaA64cAQxurB6ivMaCEPt8XaXp9FIhRumHcfWKzULV1cIXPKeSS
	us7pajoW4CfVq5Wckmx6Dw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a6yy600rt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 16:38:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A3FW5we021076;
	Mon, 3 Nov 2025 16:38:47 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010024.outbound.protection.outlook.com [52.101.56.24])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58n8cu5h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 16:38:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TXxJvLA2xTLrJ5kNKsw5wQ0JzoypwPET6NhGnQ854b//GTNw0xJ6E5n8bWqzq59w3l4VOd1UzB/DFGFCTV/upD0KUbdiG0j59fRLlQpbi8S6jV7HbBO8KtVLqkvDv+QYl9hwYO1PF6+HpgOazHSrpaPdzt9blk21KxKXAuVTTGKTlf4xYMfh+9gsToyB/C5D7kf09nrqalP+RLCvXB9HQ6d8SNhVS7BMReuZjYsWo/x+a8EgG8KkaAwJsmAxaKlhXHQEx4j17RyPQDFuvDdvi8RnUH3Rkf5usOUo26dypBHc2RymiAqv/iTSwZoiGXwlyXxR7y5Y7ysWQQvxjReZnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AGxOSojmRVQkR0bJuQkNRlZstaGEd8AyXbzIDberUws=;
 b=HM8Cb66+MqtQBKmLgOetkeWb6GmDKGiqohhgbsHHQNkxTpZjNJ7G0HSwdAr4y2c2lszLqjTSaSk6Gjp4S54N9JScXVid7n0QOLXzEURUsrkG6o+J3kR0XC6z2h0PJ0pod8cc8jwOqDsD0Dit5oOlnYvMru2s8+BCq6jFJyNBDJe+Ne8U0LZ9EqYotxyE0qKQvwGtgERjtJgiMI1EDTTkufi5ApXFwSWe9nldqXSvHkjsT0613tDAyqdfpVs7v6ISAEVI4fvw4HgxMgf7gQIQZzzIsvH//F9gy1mC3o27WjyjtS//ZQQmuUA+RjcP3cKUr3IY+8jIbfiKIc8vI9dp6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AGxOSojmRVQkR0bJuQkNRlZstaGEd8AyXbzIDberUws=;
 b=0RUMMaO6ykAiknltupRkZEIjyP+fkrNN7umdp7NrXF50SPuJFaYTKqncj2qawYwOWUnnUq+a0/4qPmaVX++2Ok+5PY+j5Ca9g0ZPOo6CK7Y4kCYM09YHB5MZwx9U9/4Bs7qBdIsKLRPJ4Lx2c7mFHbf7RArC44CNZIW4LQsIUOA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA3PR10MB8664.namprd10.prod.outlook.com (2603:10b6:208:577::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Mon, 3 Nov
 2025 16:38:42 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Mon, 3 Nov 2025
 16:38:42 +0000
Date: Mon, 3 Nov 2025 16:38:40 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com,
        ngeoffray@google.com, jannh@google.com,
        David Hildenbrand <david@redhat.com>, Harry Yoo <harry.yoo@oracle.com>,
        Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
        Barry Song <baohua@kernel.org>, SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH 1/2] mm: always call rmap_walk() on locked folios
Message-ID: <b64f0d48-9623-41f8-906f-581d90e864f3@lucifer.local>
References: <20250918055135.2881413-1-lokeshgidra@google.com>
 <20250918055135.2881413-2-lokeshgidra@google.com>
 <0ea92729-2403-4de8-9ddc-a1c7bb2121c3@lucifer.local>
 <CA+EESO7yyhNH6TYza+j7h9JZb1_1eHdd1x3ASmuNga2yYng4JQ@mail.gmail.com>
 <ecfc09fb-cc4a-488a-bd0b-4f5b3af3a2ac@lucifer.local>
 <CA+EESO7F=x0vrrA+K7ajcSyH6tfEtsg9gHVnOZf8U+M7kqcgyw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+EESO7F=x0vrrA+K7ajcSyH6tfEtsg9gHVnOZf8U+M7kqcgyw@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0288.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA3PR10MB8664:EE_
X-MS-Office365-Filtering-Correlation-Id: e9bb0af2-2b78-448b-3336-08de1af77358
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Wm5jSzBZUzVSLzlYQzNrWjhmVDN2eXg1bmd6cmhockRvdzB6NVU1VTdsZjZR?=
 =?utf-8?B?Yll2aXJtek0zeUVJb3A1TTBka2tqRlB4VExib0h2UGYzVzJFekg1bGJ3VzU4?=
 =?utf-8?B?cFJWZ0ZOYkFHVE0vSGFEREdmQnhzaEJsM3NaVjN0ekhyODVURDFVNUc0Vm9R?=
 =?utf-8?B?dzZQNm9hUkZxZHo2ZE1QMnB6Yi9ZRnlqazZTaDFMa3doYmloR2VWUHlrYXNJ?=
 =?utf-8?B?THpmNE9WRTkwbTFueVpXLzNMdStHSU1WSG80SWRQSzVldG1leGpCcFR6cHJP?=
 =?utf-8?B?bkgxUzZJSXRmbXgxcnRHcFhPd1lPSTZqai85TC9yeDhhQkZRV0p0WUJKdmNs?=
 =?utf-8?B?N1RlWS8wcmhNb0lzQzlZSEJNeEZ1SFNtM1A5cTZPQ29vUkZaZFkrMVVQakJ2?=
 =?utf-8?B?MzhYMUtjdVVnUGVLeXNJZXNRcVBZcGwrU1ZFZkxYQmhtZlM3dXZpMUdwejhu?=
 =?utf-8?B?SU44NzBrdFRVMHBjZHJVbnNZcG5SeEZ4SzRaZTVNRWowU29vdkFmTjlJcmtD?=
 =?utf-8?B?MzJBTnE2SlRhVkpUdUwwR0ZDZG1Ud0o1b2xJOUlWYmlRc2FKL2M3TC9keGha?=
 =?utf-8?B?NzRVdVdjb3dieW1sRzVoS0dwbDExU0FpVjBkL2VFMUFTdGJ2NWJqekw5QWh2?=
 =?utf-8?B?dWFtQXNndXZkeDlDcWZqVEVIQWVjM0xUNmZ6cVNTTm42dFBCcW5PcENGZmV6?=
 =?utf-8?B?Q1I3SGN2STduNTAvNWJKVzZDaHZUdWhmS2tVNXZqNlIxbzlpZnJUTnR0aVl0?=
 =?utf-8?B?aGE3RnBUa1I0ejYzeGF0eVJScEdLY2hCb1FZMlpwVnZtUy9UR3Rra0tIaVB2?=
 =?utf-8?B?dXZuM1h4TTFpbzZGUEg4SHUyRFM2clZRVmFoUEhJYVFHaWxpdmJtMHFvR25o?=
 =?utf-8?B?emV0b0puSW96Z2R5KzR0eCtJTVNERTlFV1pTOTlGS2dJUmZmdUR1bnJ2L3Nn?=
 =?utf-8?B?dkM4Y01McXFvNG5RLzc3Y0JZcnVaRnN5VVI4NGtvN0t1c3k2TlZkVTRCZkE2?=
 =?utf-8?B?bm01NzBSNXhYbEZQc1hoUjUxaUtQbkVHM3NtTmpNcklmeEd0dWt2cWhtMWdS?=
 =?utf-8?B?MEo5akRHaUtLcitpQUZnSlNCYnRObFdsNE9lUmFRSnB6YjFyNU1vUFBSeFJK?=
 =?utf-8?B?YTBFcFpsQk9ZMFdUeGtQSktWWWNtUFBybDRIM2NJMnNibkRUb29Fc2UwRVJw?=
 =?utf-8?B?anV5Vm1pNFNGaHVtSTFoT3lLVTJXd3V5aklKRmtVamFSejZFdVBLQU9WQ3JF?=
 =?utf-8?B?bFE2N3BRUzc0UXZURWc5S29EZ1VvanVhc09LTjEyRHovM1k3dU5SN0ptM2do?=
 =?utf-8?B?WTVpM0FQU3lmWUg4YlFYWUtsR3JzY09zNWhpTjJJTjVJSWxiZHZoanBZMnky?=
 =?utf-8?B?aEVYaVZ5ei82eVJDbGJpc2xkblpXa0p6ejFCYWpQUTFmNDhMRHU5SjZJeDkw?=
 =?utf-8?B?K1RDTmtPQ0pxRzY0dVRHdXlPSmd2VHRVcmJoVFMrLzJMN3dDcUtrQ1lheUtY?=
 =?utf-8?B?SUNEdkEzTmJVZkhDSGpESDVNeXdUOUZPTHVDejE5NGxDeVBGRm4yV2lreGxV?=
 =?utf-8?B?SWF3OGtOMC9TQ1RodFYvcUw4V2taVXhtaUxxSXBlY1JoQ1NrSUo5RkY3Y1dL?=
 =?utf-8?B?L1JPbkNvTlVPeHd2RXJydy9mTnhwai9xRkpmMTRvWTZZM0pHbVhwTUNObVNi?=
 =?utf-8?B?WkduM2szOWl0TXBuWnVNbU5uSW53T3cvNHdWNU94T1FXNGxJSmdNaFRVY3lo?=
 =?utf-8?B?aEtqODEwUlNMdHBWWitzU29qLytabTdiUGgzTm5sc29YalE0M0o4RE9ZSUdl?=
 =?utf-8?B?czd5QzByYjVCWCtQTFg4UzNMYzMrTy9ISHJxUGplZksvVW5JTk0vZS93R0NC?=
 =?utf-8?B?SERLVGt4a0k5aXVmWloxem5OVHA3Zm1URDZ5ZVZDditUMk16akNZZktOSXdV?=
 =?utf-8?Q?97AxeK5dswSaBc52X1leVOz8TiJMNBY3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OCtRYkFub3dyTzBrdzM4VjZCRXZsWjBYSVF5aDk4NU1TN1RBblVCaENmWDVS?=
 =?utf-8?B?SUV1ams0anpHNllhMHdEenF5TzZrV2g5VlZyMFZZU0VEK3dBUU1RbUFzR254?=
 =?utf-8?B?bXE0bGRSNHVHaC9UUHkwMEpKS3YrLy9hbEQza3JWRlQxSC82dnhDWlZOODhE?=
 =?utf-8?B?dTNLYktoM29sN212T1ZGcWtNVVhSVW03eHNVRGZQTlZMZGQ1Q3RtakFKcWJ2?=
 =?utf-8?B?Q003MStUay9yMWl4VXlaK2VEbE5pbkxkZ0lnQWxsbExQODArSGhzbEVHdnF3?=
 =?utf-8?B?dW1neGdwVGs3TGtPclY1MUpRVnRrTzJsTklZd0ZQdDgwL1k0U1hvRjd2MlZo?=
 =?utf-8?B?dGJ1RzJvY0lJN0xrRHdVUU16R0NYblhaejF2bE9ZMEdTREdCTlBpRUdCb2gx?=
 =?utf-8?B?NVVtcVF3UWY5REF0dHpkeTljdWlZSDN3Z0M0R2cwcDR1SEN2Y2tCWVhQZ0xM?=
 =?utf-8?B?WGdxZGRadm4vdnl2VGVBUHlRREZlNEsyWjRzbFE2Rm9kU1JNK2tMK0ZWY0c4?=
 =?utf-8?B?TjlGSG9nM3pEaHBhd2d0eW5NR2tCQnl5QmJuYWdrTldDSzFXYjlwb2JBVjcv?=
 =?utf-8?B?WHVkT1JEVkprd1ZRZExNQk90Z3NkSGhvb0lEcDkzL2o5Y1oxcnVLb0s1aU9B?=
 =?utf-8?B?N3ErMDIrNmdlSGdGMEc2MGV2OXpNZHJ2Qm9wNjZ1WlhBLzZQVXlUTi9RL3RZ?=
 =?utf-8?B?dHZ0aGNPVkVua09vRnBjTUhoWE9MTUNJZ2dmVkJVam5FN2FSTERpam1rWDgv?=
 =?utf-8?B?QmhOTWlxWnFuVGpYRXlWWDVYa0dXTHpoUkQzYXVqK3FERW1lTFRXcC9LazFx?=
 =?utf-8?B?SUQrT2tadUlHZnZidE50QXRzbW5WQm5zN2FremtsVjI4S3VGMEJ2VUFIVDNk?=
 =?utf-8?B?NlU0cm5DNndFS1NFYklZcHp3OHBMZkdvZmthWUlmODFCNnUyVEprbjR3QmNQ?=
 =?utf-8?B?WFpqMlVhbjVyQ1VFRTNFNmZIY1ZmbVI1TFFVSytiY0x1dGdLWWNaaElYbUlo?=
 =?utf-8?B?bGw1S29LSnZ6MHRGQ2dkemhTNGJUN0FrS1ozR05NNFhyN2JrbXZKcFhrUDg5?=
 =?utf-8?B?QWNDQWRudSs3TVp4eEhtR2RyVlhrSDMvd3VCWTFqbVFiRDFNQUEzazA3cFY4?=
 =?utf-8?B?ay9VVFE2VXNSbWRnMGpXT3NiMXhDUjNTUjlTVlF5am8zOGsydlNCRytQQVla?=
 =?utf-8?B?d2IvVUp2dTVzNFJocW1yTjBSeWdiQTBPRDlWaWpDSXZsT3g5c1ZuT1FkSlpC?=
 =?utf-8?B?WHJFZ3UvUE9vRGEzTEdwbEJBYVdZMENRMk9YaHZINTRuNWhHaXVKZVZrSHJW?=
 =?utf-8?B?Z2dlS3Q1a055cWFwUzQ5M2tvdkdCQnFDWTYxWXFOMWV1VVNEMHViZzZXdXYz?=
 =?utf-8?B?UWhzenJ3SW1QeUhnYlQvTHVWRktKTUgzRjJRT3JNbjFEZTl3dmJmU2s4bjdt?=
 =?utf-8?B?RE0yNHVRZkFwY2VmOTc4R3lTb0pDQjJSdTl4S3JSZ0xuQVpIbXpqT3lSRjdV?=
 =?utf-8?B?ZGdDdTJteHNkenhNMmN0NVpCN05TRk1Rb21zVlhLVW9HdEl6c3I2KzhwN3lN?=
 =?utf-8?B?b2lKOFlOV3dac2FvTTAxWVI5ZUhCY2UvN3FjYzhhZEI2TWxucTlvbkltTFAx?=
 =?utf-8?B?MTRMd0lCTDBNNllmNkNIVUUzdWNQeTdnNzFSUVpTbTlKdkpIa2ZuMGdXQloz?=
 =?utf-8?B?YVNIOFBzUkZEUllaTzRzVUJwcGltWFZNWE1NT3F3Qkc3WjNMNTZOeG96SUh0?=
 =?utf-8?B?V1ZEblQzWGlwQUhVWUswZlJJeFJLclFDSytoZHh4SHlQc25vTmpxczlwZUhk?=
 =?utf-8?B?d3hlVmFLelo5L1pRRjJsbUxhVk9SZFdRT1VNSEVjNEg2eGRLMHFZSjF5N0xB?=
 =?utf-8?B?TEhQK3VpaWdPc1ZXM3lyWnFPNEZET0JKN0tLVUFsOW1PbDl3OE1EczBxbnc3?=
 =?utf-8?B?NE43dzlGSXJTUENhaWFXMiswWVZzSnFDQWlKL3gvWEg4eElEaTkvUTIwZ1cy?=
 =?utf-8?B?cWtRYTZMbXQvWWNSdlZzc01tdWtIRnByektIOFNsTlR1dTBTcmxBL2VZeEhi?=
 =?utf-8?B?VlFmajBmSnFKUTNsZ0JnazZSdFYvWjFZY21DNmVtV0I4cGVaN2x0ajlndHY0?=
 =?utf-8?B?RFozRlJoaFpTVXErN1l3UlpaaE1xYVdMZ2s1akFKYlBDQlNwWURDcDhoQlZh?=
 =?utf-8?B?b2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EmpL16CU5LFtMc7YD6JFyFN4tna4otOwoSEwCSCvGGcv6dMdt7He5v0r2eMTqlmfpoN0d6ldx/J1XUIDT7lXoyzgQfNQ55wdHm6+tSMZKt4sTvQrUgt4mSgnMPvY+9y1seDcKaHdkhQuXWeL9m/FT+biPZ/WsepakdvaVVqu4yhiaYXSoVcmoS26PkOlUgy1wY/RN/LCUuqp8Ghm7df0EpFdnCz+3YRxBm59SG3ulYj/Qwv7KU16dxwbsEX+JKxW9ZP+frbtslT3bYTkAVZ7H2JULt8G7dpzB/k0RL1g50eX9EJQ2fkVw44OmCozI5jRhNmybzQgedF94hPT8+pbDadXo8mCmST3/l37a3kABsfnY1pKOcvP4Wx35vq8TLOX0Pto4vGDdejlxmuQ+4HSPCrnRxr7KkdypJUtDyNfA4YvY2ffF1RMKomMYsZqM2LLWThWD2fUmdeihKw6erAwi69WT/MEVFAlpYJa7UmWjFBYpjz5TIsSJ5T+UImrUIhtZR7C+9if043Q6IeGt94+lLu72Z0naGvXbYvwjIqd8iF8k72aBYBQOu2It/LaNCiNmiLB/azwA7Se0rQWA7RULRPbOQJBYYQaGZKlOKamrTg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9bb0af2-2b78-448b-3336-08de1af77358
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2025 16:38:42.8278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PTT7FDwmraSuPBFhVGrpEcb0MuPJ/aL0atY699SEvgaVtWY7kScrzf4rwsNfa3Lxl4QE8d6OJUdYrZHUApEdtz2/N6RT7FwSZEnHJeUiERA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8664
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-03_03,2025-11-03_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511030149
X-Proofpoint-GUID: _jfUSbxE2Lq6IAqCT9yKLalri6H9_a2d
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAzMDE0OCBTYWx0ZWRfX3agcdkvEuNyu
 NUONvuG8ZRuMrFNw+HwY8OFuLqvA8we29X2VS7NkmErM5JnCmDuBQ/isFayH/oeJrMx+6cUYigo
 7n88MRdd/SaV92QQ5s2PGDqzGq/liz/BOyfedEjbwIy3ZdTUYr0Rn+7SNKsgZ1WLAhQqC+X/h0A
 SCMisEeXj13TUOfP4iYuJodfedf0InlIICe6pe8uRGs6gVFdcCwHxSYIMWRztdrH5CpGZwATq9S
 IZB2b3A17T9cTANlZ0ylz+aeFMY08cQGz/f+58XTiMCaXSFiS1mHI7SbxJr5uxSkwP26UoEOoI+
 7Va4Npd4XGYWP80n+lfrHe1WL574AF01Dk7iZqiYUGgd/PU9CDHQtwNG93nT+Cm3Znk0AGoHmeq
 LULeBzd1ZH7tRXljL8G5R27xhz2EgQ==
X-Proofpoint-ORIG-GUID: _jfUSbxE2Lq6IAqCT9yKLalri6H9_a2d
X-Authority-Analysis: v=2.4 cv=OuJCCi/t c=1 sm=1 tr=0 ts=6908da98 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=HZPYRRbrX6d0Jd4pDFsA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9F63E180012
X-Stat-Signature: f13x4omdcdwxn1zga88oisnew4db68yd
X-Rspam-User: 
X-HE-Tag: 1762187934-149683
X-HE-Meta: U2FsdGVkX1+cXJxQfI8MzQyG7aoY7UzDwYd4O5HbebbDybV/Q9u0bsdBRSFEUZhVxjTlIC+tPsSZlzLQoOENSlIxEKtfmQhZ/KXkS8EYqkbSJvNAqE2isNiznOjZFx4j9ciuXiu5pMIwRiGFhtuWzRPdMfSkz3+THPOFrT9Sk/HkmOenAbeoXQ3KfCBfyWzdxc7GsL7+bRCbsnQXtmKxZguXmYjWEMqd5gkEFd8e75AihLm6BApbh5xO9x0CIJ+OZ2uTgXoi2qkJowhVj4jwxtzB4POjXMvZjr8YYHpH56e9xF5q4dnRCCtAnaHzsK7W+tPWcZu/d++cLC30QfvXRSYWeHTlZgFuUxojupsc2XD6sTWCLsjiViDSkCrj0KgkioH9bTsneiYtZp2cafzOk4k7JpVneJ60vp9NGkVsvaOjViCx1nH6l/o0MOIJH4aI5a8J8966+6nh9AtgfHt2IJtFyt95d4ecr9EdxUYDGZe+gy104EYpYK98FluHE+XdVkUNAops3QwF6I+n+n5SWBQ+QRiO6ua+orH6ctWXmswCYvItu5jZuQJxSftTp0dmLdFrLdZOaESEcRDvK2MyK1WzJ/mW/zOdc7d+z/h1zgnRgJgCL6lD2IemiQ+AhZOVzw1L85erQ/EV21sJ+LNjSAMgKeXp/wcNL3Ms7A0XNtO6uMa7P1mGfGKHWA/1lN2Y6F1Rw2+QSXuoGWf0wp+J8zy8mdNmZZC4PZtmeT0Q3qhU4H9GUgEuClTshmbtbRHeVkrMwB1aTxaXqMaO/0aTqXDgtGAYMAG+vGet7yiiIpR3+u3yZbFXRyRjsGyvOsELffh+nak/o2QmsnGnejQOYY4Uki6sIkCgrI61Uab4FR1Q5yg4LTyEI5QlkNSMTZdjdDx64XMQZn2whRjuDkVWVIw7ZyFFRzdZYT/6/ZwXYxyFSQMynhsX9DA1k2x33sl5Qy1Uh6v/gyiIHU6cCBx
 ws8MgXKA
 r9Y/XRmYea1FxCjPTxFsgJSFD7QpLQN1Dqbyq02DWl9mIKcqdCG70dQ1p+3p4n3eKSEllsO/nGBJY7eapHYzg+obZLYt0gCrQIIGN28N4kcs2OENNMwaSiQKepfZW0/n6FYFaSGg1ye/WrSuV+1SjTi07ml6XY6hRMcQx68tlCuKbZYJeHq86aktuzToWfGKB/0m4x/cWPwHmnxEcenRZhSUS0yIi0ml9Km2uHpuremZWyyzPPUT4NH1Hd6Ckxj0qvg4TdtRaVgo/RBMmoLnl6CsOp1gTMP/mXrIpn4Yxb8xdvYi4NwZzObiS4knhbMLpz6DnU4V7J9bpIc1338d71PO6RAA6g2ic6t/fTkBU5yIC0S+IQ/WLuvzgoEFY09JmV3Ua8/QYnavANHhgm2eplZu9QBLPv9srDK9BcTtENQ21wHnNvriixbKFyT68k3ftr88+odm0xEV4x1lLV58HVwrG6d1odmHm13vtyAuVd1Xy8psDuTb8Jt5MQTiJ9o1s5znI3QrJstOjHNfjcmSy6gqMSBhHCRgcH+O1Vzjg5M3yHlzpeKKaRfBUk3xdjuYmjCwxfvX+PzYeIcLOvjZ2718KOsRpOG8k3GpvUAklYmQVrSo/Bs/dmrgNqCbhoNxPuq2MRsr1Sz5FIQglER85zO/P+RGXD3MVcgZsLN79SAlDe/gJoc0FwRF4+4eoLKRovXlo3d7ODNrJr/9Anco7fPb6HyUmEFQNfuc9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 07:46:57AM -0800, Lokesh Gidra wrote:
> On Mon, Nov 3, 2025 at 6:59 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Thu, Sep 18, 2025 at 10:45:21PM -0700, Lokesh Gidra wrote:
> > > On Thu, Sep 18, 2025 at 4:57 AM Lorenzo Stoakes
> > > <lorenzo.stoakes@oracle.com> wrote:
> > > >
> > > > On Wed, Sep 17, 2025 at 10:51:34PM -0700, Lokesh Gidra wrote:
> > > > > Guarantee that rmap_walk() is called on locked folios so that threads
> > > > > changing folio->mapping and folio->index for non-KSM anon folios can
> > > > > serialize on fine-grained folio lock rather than anon_vma lock. Other
> > > > > folio types are already always locked before rmap_walk().
> > > >
> > > > Be good to explain why you're doing certain things, like adding the folio
> > > > lock to kill_procs_now().
> > >
> > > Agreed! I'll add in the next version.
> >
> > Hi Lokesh,
> >
> > I realise this was trivial, but it triggered me to hold off on further review on
> > the basis you'd send another version.
> >
> > Are you actually planning to do so? As it seems set to merge without me having
> > completed my review.
> >
> Hi Lorenzo,
>
> I think somehow the v2 fell under your radar. I think I addressed all
> your comments in v2
> (https://lore.kernel.org/all/20250923071019.775806-1-lokeshgidra@google.com/).
> Please let me know if I missed anything.

Doh!

Clearly. Sorry about that, this is my bad.

I have no idea how I missed that...!

>
> > I'll try to get to reviewing the rest of this, I just happened to have a look
> > and wondered why my tags weren't there...
> >
> I was actually wondering why you had not at all responded to v2 :) I
> look forward to you reviewing it. It would be best to have your tags
> on it.

Yeah, this obviously was not on purpose :)

Will take a look at that!

>
> Thanks, Lokesh
>
> > You may as well hold off until I finish review anyway.
> >
> > Thanks, Lorenzo
>

Cheers, Lorenzo

