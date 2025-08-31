Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16550CA0EFF
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 04:01:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EB5D6B0007; Sun, 31 Aug 2025 00:01:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C3B06B000C; Sun, 31 Aug 2025 00:01:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 164156B000D; Sun, 31 Aug 2025 00:01:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F03A26B0007
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 00:01:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 35C5984E46
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 04:01:19 +0000 (UTC)
X-FDA: 83835702678.21.63083E7
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id C68E8100006
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 04:01:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XJXySVkx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=J1BR0+EN;
	spf=pass (imf05.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756612875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SkJNz7GLorTVElb0+nrZeGsl+mgxBtL5Zeua7Lo/KY0=;
	b=wOLTgQuy4rrjfi4S31991MtvWzzxOaaBD1cTGgI0U+hSe+3CwbRDGHDLH5EjSIKmkujNAj
	tmkGD4udYDWpA81DLQRKbjMz4JBIPPiH9Wu4lAALiU9H35ZoEAdm1HY1zRsBJQkZbscUBK
	rqd3HjZNpAZQ4I62foo77igzZl9ENtM=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XJXySVkx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=J1BR0+EN;
	spf=pass (imf05.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756612875; a=rsa-sha256;
	cv=pass;
	b=QahhGpDfenyWqoQE0C7LQ3LdFQ0Hl15ixklnOiGfGMcvvkYSUCBcxRKEweSQg5kEAGh0Yx
	BW161P7dVfI7iAWxXv4bMJTe++XiyI4yF4HFf4EWn8gUe4e539MYDyidaM94X6ViWNxL4p
	xu41aVMTRsJA4MzBBKm/RHzPZCM7IfI=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57V3YIKv003073;
	Sun, 31 Aug 2025 04:01:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=SkJNz7GLorTVElb0+nrZeGsl+mgxBtL5Zeua7Lo/KY0=; b=
	XJXySVkxdgh2RBY7qAw24/9BoM0i0QKSPNm9hVxQSbMWy13xH4R9Mkm3v0mTS7ZV
	nZtoLyRN4yK1SLgKuZ8CszY4uhwoZj30s4ivMhe0eXGML+t54ww6tctdmHw5jGSp
	e3nji6E0UhCu560WO23qCvTKy3Hhl2wCT5o4JlPUgK3HobfS2Lk4NZ97lhJZAfjC
	eXpQL0c28yuaugNgi/y8QRaMPvtD/nr7pqnGksJQTmQlfMOafJlg9g6rdQJ3focb
	rF1Wi8H8aw4+o/zvc76XLGoIai5/hkna6krzgISzOPcJo8YQcLKSOY99Ny57SKO+
	cK5gY6geCXFPrmkRExWCug==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48usmb8npt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 04:01:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57V2ULGd011668;
	Sun, 31 Aug 2025 04:01:05 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrd46kh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 04:01:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GygbFurgyNSoW4Zwkv4R30XEUptU2yYFaOi//tngX1AOaSRcf2lX8TZzQWcm98iKityHBvVjGPsOkM65isB3/1n0BTgHvGgaeFrNtfUJAWx5FbcuTpiPJ2CQ+DGkj4Zw1B59iAPjhnVMSKvbGEBBlCpfCP8+unpqQYUWud/CaAQPIU7pUXcMnNKCbrrqxGjxacAYumz7tRCZvZRYoaPHj7N+gxIXrcrlUegsnoX0hyGKkslbyGKDEmN9+nx0NbMIY78fFI9/QVhKBZvJ2sl5Wz7pgqXaSE+WggPBLPTH6k7Ki8YL2YCdmrhZrX+U5UnMWH3p+m/RiLBcEGqZ42pDLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SkJNz7GLorTVElb0+nrZeGsl+mgxBtL5Zeua7Lo/KY0=;
 b=STA4OpJW5RSgjafNIAxw73rxUeHJTDQCBysh7tP5BVtYUPtOAhhGMaRizqqJ8A27mtuCzIaFF9yZ2l2VuKvpZvzaqLZR0y+c8n1Nt64F9Z6d1Nsg8sLeB9euKfW5mYLe7mWGvkIzWZYTWu4BKofuMDtPTILDCXYhqWntE/+EnzuVtPXqvR50hjcuxCDz4UZQw27kYOkbQw+BTf7F0Cw3uX/x83YnlUeVJYgOl6BVh8Vp1MBci4VIw1kR7W7epFzwPPZUNjudu/VBHfg4dvnQr+/PqtVU2gWTP+4M+sCqqU/cOJX5riRq3jN+JTKcpA3mO7qfiRjyVpoOtDuNHRV7bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SkJNz7GLorTVElb0+nrZeGsl+mgxBtL5Zeua7Lo/KY0=;
 b=J1BR0+ENXfNWhgavWTiDGVSbHeH9B+eGz48s+Z7yCyCVFsxv+mdFix1fywS7JjQhqBcOHiS5uUre9QxneqKYa10L5XbTE4ytGCWUiR4nz49hQfOCw4SfD8GT3btkV3Qp0WxxZchChgpvVOEJGGaBF1XrFsTqoaCnTmshmRCf2GE=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ0PR10MB4557.namprd10.prod.outlook.com (2603:10b6:a03:2d4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.21; Sun, 31 Aug
 2025 04:01:02 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9073.021; Sun, 31 Aug 2025
 04:01:02 +0000
Date: Sun, 31 Aug 2025 13:00:47 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Yunseong Kim <ysk@kzalloc.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-rt-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        Yeoreum Yun <yeoreum.yun@arm.com>, Byungchul Park <byungchul@sk.com>,
        "max.byungchul.park@gmail.com" <max.byungchul.park@gmail.com>,
        vvghjk1234@gmail.com
Subject: Re: [BUG] mm/slub: Contention caused by kmem_cache_node->list_lock
 on PREEMPT_RT
Message-ID: <aLPI77sNG6IKlZjj@harry>
References: <f564f596-577e-4a66-a501-033c68765bf4@kzalloc.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f564f596-577e-4a66-a501-033c68765bf4@kzalloc.com>
X-ClientProxiedBy: SEWP216CA0083.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bc::8) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ0PR10MB4557:EE_
X-MS-Office365-Filtering-Correlation-Id: 5266b9f5-d4c0-419e-d380-08dde842ffcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TmljKzZPUlhlYUV6Y3pabEIwRTBqWGVQTk9QMXQrNTVWMVRUdFczUjljNVVX?=
 =?utf-8?B?dEhQcEkwZGFaQUw2b1FNUVduRzlRS1oyRWM1R1NsdW93RzBHcDR3RlR0R2o0?=
 =?utf-8?B?ME9YeUNvL2FMakxEcHJNaU9PYm9sbC9UOWZmakY2am9HVFI2NjJCcmd1VGR4?=
 =?utf-8?B?M0FZK2xpL0ZxQjZrMGJJT0dMd0UvN21ndHhpN3ZGUzhVOHdSY3F5K212blU1?=
 =?utf-8?B?TWdLNVdUam1GSGhLZ0ZzK20rNnZwck16K2RjN0U3WlplaTBFS0pmQm45eWo2?=
 =?utf-8?B?aXEzbTZyRjFMZE5YSWFRbmpyU2VHU1ZES3F6LzZETmI0Z2tweFVwbk81THUw?=
 =?utf-8?B?RFRYbWVHT1U1WU5VVnlGTTg2c1M0OWFqT05oeDRta0dab25FeWNqYzBETWVB?=
 =?utf-8?B?RHQ0LythZ1AxTVN3UFlGNDY2R29POThZeTNLRlRpWUtVVmlZVmI2TERvMGZy?=
 =?utf-8?B?WERQdE1HYXVqRS82QThOZ0FoeGorTHQvMkpPRWN3cnluYUkvT2tTY3NsWk9P?=
 =?utf-8?B?REZPaVpkbzVpYnhteEtiaHFCRHo5M0dMbEw4TUU2RkFnYUd1SUhTQUpuTEJh?=
 =?utf-8?B?c25Yejc3UkEwMExSZWtJd2hTWk1WUnBsWnplZjFUMnhJRERTck1FNDlFcTd4?=
 =?utf-8?B?V3EwdEw2S0czQXFNc25UWVpOaWtRVm1lY21uTGhJcERjSk9KemxSS1ZiWm56?=
 =?utf-8?B?MSs1M3BwMWxMdzFUS2M2QW5QYWRNTnZVWFgzRW9ZaHNjeTRQdmtrTW5GSklC?=
 =?utf-8?B?dk9laXNVTGNPL1hZdU5sVWFJSnIrY09BMm1UVExUV2hsOTZGOGd3VUM3UG5N?=
 =?utf-8?B?Y1AvSGRJQXdvSCtTTGwvYjFnZE00TjZrR2psZDJkU3VrU3h3YTM5SjFubndO?=
 =?utf-8?B?a1NWVlR2NWxXbWhpOXJ1OVU0TGxESjhoditvb0grSko3VzZFTWIxMnRLd3RR?=
 =?utf-8?B?TVpjT1JsRVRWQkZNVjd5b0JuMWV6TnoyZmNaUm9NODd0aGhnd08ramhvZmsv?=
 =?utf-8?B?eEZxckR1YWNKWEdBUTBqazJTTitoRG5aMkIxZXhtek5EYlBnZE40VUFrWG05?=
 =?utf-8?B?QkozcE9pMlVYVTdabU9Jb0h6TFkvUUs1WDdkRmNrNFI5N1g1Nk02cW5uTHI2?=
 =?utf-8?B?ZXkxc0NZSkhMNzl5RFhETHZCR3ZNVE9OOEJVbmxmRURDQzVWWFZhRzFLZ0dS?=
 =?utf-8?B?anJqZ0Z0cUdPRDFoZG9WSEh6YUR5OWFCTmhNb1BNbWNNRkdibU5ZZmJjUU1P?=
 =?utf-8?B?Q2tEWnZvclptdmNseHBvSGFqREF1SWhZcW1UeE1hQmt2bFg1U3VmcVBWQW5s?=
 =?utf-8?B?eE16SmdWTEhzWXFrOS9XbkNXL083RktsR1JKOXdxRjZaUU1HVnpTWElVdmh0?=
 =?utf-8?B?WEVYRkdObUtnNG5YOG9KbDBFZkJNQmVTamFDc1FvL2JDZXVpTm1FTlF6OVhr?=
 =?utf-8?B?RlA0cGtiU09wUDVydkpERmJCL3p3MnV6d0NQOU9ycS9VRE1GYWtCSnhweUhH?=
 =?utf-8?B?alBhQ2NBUjZGS2wvZjJIcGx3aDF0SWVrTDJYSjRSdEZ0YVJ6U296WFBJc2Va?=
 =?utf-8?B?NjZOWFNYRVFJYW9LUVRvYkhSQTFaRmxpUG1PZSsxclU4R2JseGFVUEVuVzJ6?=
 =?utf-8?B?UlRxVEJ4Q0VoU0MyWVR3QmtOYmI0blQwUDQ5eEhRVHhWQmNuS1R1UGVkNEZ2?=
 =?utf-8?B?RzlOS2pad080OTkwaTlHMmNqSXZRMWZXOGRrZWhYb2FkNFlLN2plYVh4Tjh6?=
 =?utf-8?B?QVZQc3RIcGlqd1Y0YjAxTlQrRnA5d3JleEN6L1BGSGdiU3c5TGw4OWlsYVkx?=
 =?utf-8?B?TlRCMGQ5WGV6TTR1d0hLdjVVWTNSdFhjck1iWkl5bXJTNi82SVhlLy81SHJC?=
 =?utf-8?B?Vm02dWhXU0ZMZXE4ZmoxbHlHa1ZKWlgzaStjbDRRS1RrbWtESC9kOU1XSStC?=
 =?utf-8?Q?Dx3WHoDsyc0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ckVyWlVNS2RCRFB5Ryt1cUUrR29LUG51a3p5dURyOCthT0hta3NkeklSTXhV?=
 =?utf-8?B?ckN4L2N3UnZuTHY3NWVoSndNcmtwWXRTK1BXQnd0YXBlNmdmRkdlQSt2OHlW?=
 =?utf-8?B?NDE3WjY5TWRTV083aWU1M29Na0lzWjZveFNSVlo1K1JNVlR4ZTQ1cSsxZHVW?=
 =?utf-8?B?MnRHb0lCc3N5bXFwa0I4VkhGT3R5dkdzNkFqOVQ0bTdPeC85dkJCTk54VjNW?=
 =?utf-8?B?aEd6RytJblBvQ1J3aHIyTjVFUUIvcTZGZ2R2cFlla01XVGdkVk1SZEFYMnJt?=
 =?utf-8?B?a2x2c2JlRWtkVWlER252ekhMd0ZDcWw1M0pucHlvTjNjNU5IWndRdUZOVk1C?=
 =?utf-8?B?QjhrdmhZWlJHbVZxWE5GckU1UkxTUExKcWZwREhNQWNZT3RwcFR3N2JjSjVm?=
 =?utf-8?B?U1lhbkRCT3U3TmlUU0hsOEc2MUhSdWV6VUhqM1I1dlNGeG5Ma1djV09aUmJH?=
 =?utf-8?B?b2ZPWFhnNk5yVHgvbjNDUzRFN29mM0tkRjd6aGhmRFhZNEdzMmJpYUp3VlQr?=
 =?utf-8?B?U0NWbm1BVTlSTTU0dFZWVHdEeE5BL05BaXNSUWRlTmMybkhGRTBKb3NoVW44?=
 =?utf-8?B?bVprNmE1OXcwbFBFbWVRTU5nUnlLeGZldnIvV0JhbSt1bVlBT29XWDd5YnMx?=
 =?utf-8?B?T3dRcXpPM3dhUE1zNk9ZbjdSUlBUc1FXb3dXdjdwbHY3aXNaRmhMWThKZWhC?=
 =?utf-8?B?L1pZQUJDL2hXR0VkczRwRzlUeS9uTkg4RHNqa0xzTmdpaVJCZmsvRExyVDA5?=
 =?utf-8?B?ekdxS0lERENjalB6endLMWlzOUt1cmNESE5VRjBCQVFkRUlyUlZhczE5OFJE?=
 =?utf-8?B?aDlncmt5UjhXb1NscmplSnNNUWJjeGJ4ZE0yTzl0MlcvVlBPcVV3cE1uYmZT?=
 =?utf-8?B?VVNOOXFZdTVYVnhPdWh1eHplbzFsRktxaFBIaG8xdS95T3BRNWdQWERzYWtq?=
 =?utf-8?B?VFlMQXQ0SCtwdStmMG9oZmhYWXRwSHV2RFVLSGFpcEJLY2pENGw3ZWdOdzZ4?=
 =?utf-8?B?QUJtZjhBOG83L0pFQ0k4aGs3K3p3WGZzalFVZ25hdmwzd09wOUJsQktrZjVX?=
 =?utf-8?B?UllLTHF5c3J6eGNDSXdhQVpKRDZSenVUQkxPN3lLOVBHY1dTYUNMV0JyK2Nm?=
 =?utf-8?B?ekJJZkMzbVp3bHpIeTBHN2ZSbHNhTlZraU1YUDZKUjFORGw2Q1l1NGExN29k?=
 =?utf-8?B?WWMxUzF2bVhTOUJxVnhpK3RBeDNGOVZVamVYVkMxYmdFWWIzOU1nTWpFeVlW?=
 =?utf-8?B?TTVVLy9sMlRXdjIrYitLbkRkRFpWMGtyNEZEamw0VE1NcndHbXg4NUFVaDFX?=
 =?utf-8?B?Q1Z0UTdZMHFObW5LMU14S1hNbG1BV0g0dmszcldodUloclFmbFVvNmJKa25n?=
 =?utf-8?B?YlNZVytMdWhJMDdTQmMwdUM5ZTg1cUg3T0NyNDNYSjZPUWFmazNVYzN3eS9T?=
 =?utf-8?B?MUxYMWw5dkttUmlHYjQ3dnMyMkJyWCsvRGxtU2R3ajlmSVJ4UC9xN1ZISXp4?=
 =?utf-8?B?TXdBanRFai81eTA2SUlyQmE0cnlUckVndzkzMnFkWDljZ2dYZzlHc29iL04y?=
 =?utf-8?B?SjQyTDA5K2F3T1pmbHpxRzNQay9RMzg4NnJ5Vngxc1RRNXZuZUVOcXBXWlBJ?=
 =?utf-8?B?SVhpVTBRRnF5dC9wTkE5TDlBcy9SV29JcExCSzBwekZGeWFxbGtNaE5PajB3?=
 =?utf-8?B?N1AySkd3OHVhQ2N2N215UU5ILzhVamJDRHI0Q2RkSE1sQldsd0QrYmd0dU0y?=
 =?utf-8?B?cTJ6T3d3a3N3ZFFlcUhRWWJjMUFieU56emxRWFJ6NGo4SjhOMGM4MGZKNTMr?=
 =?utf-8?B?K3hSWDRMTk5qdmZOOURaKzIwRTg2OEF2T29IeVE4VXhLOGQyNXFPaTFiSkpx?=
 =?utf-8?B?V2JWeXFSOXdwbjRsWE9ZaUNpVVpkT09vRnFzNEsrTHlhWlc3b0hodENPUzFq?=
 =?utf-8?B?c0xGcmVBcW9hQlpyWXNlN2FPSHhCL1BCL3lmMWExaTFla0hpdnRjWjV5Vk9N?=
 =?utf-8?B?dlU3MTRrK2tiVTlEc1ZzVmp4RDdBRWtoVG9ndW94cldiQmExY1c1ejUyRXZp?=
 =?utf-8?B?bzVadHRjVXFtS1NJTkhMVld3eitHRVo1WE9Dcm9IYTR0dHNFYzJRenExSVpu?=
 =?utf-8?B?TXBYTGNuWTZHcjZuR2k4NlVyRnlUYXRwQWJXNDhWSnpHUXVKUDkvL3V1MExD?=
 =?utf-8?Q?lzZ/548Q1s3IqN+kfWMUVuqIq7eZAWbbAnz6S5fdrb4n?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SheF1D1xhILpbim86Ru9Cq9NwncXQVEARlKPPOHL6JdUJCtSGHYIGJFHainrAXomtwW3WQ/bOu7WC7OP6A3D5NXXLnnSNvOepIGo9QBIJvOyWuB+vPIcs9rkRBJgmKE9OzbUh2Mm+OewcN5d1TMkJ5EAC8RCS5Lm6VqL5f1ZuWwRtIpJI4MeYw5WwDwLgmLd921zrAr5Cfi0zNy+ZPX3cIK5oARo9XrJZUVvmDIurHilzsxqYGx56GqzZL0IiPauodQccs2ufzNyQh42RlbK4YNrGGrbD4cWCT1mYssbGMceHNJkJCp+qDpd4hY0B0PfRd1a6plhMHpXguqpcYQ1dnuN/CKJyL59jYYAsCUr4zQWuAAuVtIBlTqKzrkimfLYZelPaeBaXeJNGLz38dTcM/jYY4aiaTdWR0gj3YE0T3SwJvvdjoQlcpFenIGxHQwRt2n9vco9pnGIQJN0zGcTtb73adDDlt/YOJv5Dpfv4YmGc2KyebOg42uEsNG9Nb4t+b9xuxsGEEUYz8oHzGro1mAhC2CMwVKDrwEVkK6x6CSp4QHIHoKvd2qcCJAIMgUUdHYbOeYvtaNlTRLou9avfMfC5V9q2slYLI3y1oQpDZk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5266b9f5-d4c0-419e-d380-08dde842ffcf
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2025 04:01:02.1327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rilXQP84utJyLwVn/oYxvoOb+BuPHW9yffUK89QW0wLJd3Wy7R8y+4wgIveN52opcLfrbX1fsrhntAmcsgNsGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4557
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-31_02,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508310037
X-Proofpoint-ORIG-GUID: awRAkG-N10ZrcC3g-uyI0cMgMFXpN98n
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMiBTYWx0ZWRfX2g3ijAWL+BNa
 QPC8ej7QTJwDRoHQaKCHJBluxxw5zv8M+Z8Xr9t9F4Iuw5OZhT30QTaUH8vhBaZDh5j6caDEfFw
 sS3IGmb+0J2ZDG/MBiet/PGvH75e2GiN1HGtrkkzdfkYwM/vImyVthR3HVJdtAwKTDPGsRiKUUR
 31RnwDXDjTiMW9YuD3NRHXvOPbI9xz00rDock0qNAox/KoBRDXg9cRU5XYqcJBD5wgDp5u1phDP
 Mu47kdbKCt8aGTkpPpXa8RdzXIXzXlAeqSXKpICm8ofJuHp3rhGh+uAFku8ZgAgcp/bCNzDTJWE
 NGi5XTHtRDZzbJ0PJXsYOUDuU+9JG1EJzY/yOBNHNKtMw2dlIZrgOUy3T9UfZwNqKTrY82Zx9cQ
 z04aK3K3C1v8XbkjhLJhOnsonmw6cQ==
X-Authority-Analysis: v=2.4 cv=KORaDEFo c=1 sm=1 tr=0 ts=68b3c902 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=QORQ5vcAr9oiJYc73lMA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12068
X-Proofpoint-GUID: awRAkG-N10ZrcC3g-uyI0cMgMFXpN98n
X-Rspamd-Queue-Id: C68E8100006
X-Rspam-User: 
X-Stat-Signature: 7ajxibmb3f3as8nnip3fuhe7jn8m9xrc
X-Rspamd-Server: rspam09
X-HE-Tag: 1756612875-57345
X-HE-Meta: U2FsdGVkX18q5seG5JCmsxXNnLjRR4SCCnAWFS0IDxTC0j2RJ+FKjSxHA2qpmxDXlL6e+pvD3T/77aFPp0vQIglGtnRRISCTJXVFFX+oW3gJpJDAXwK5oydTsf0IxfW14XE25jbXj3RYMFl1J5hdsqCZkfosiE7IlRLsygLIC40ZBhvh7+SWnmO/ONXLbOlZ1MX8sTN2yd+YBzofipi2KPnagswaX4wtReSsRbf8VJnyIzs0OwkvP6UmLfnS4eiKuBPoV9PBwMK2L8zqIUC5ToC08WL7cYRGl0E4o976+OVw1q5XpDyUf4jIWZX3BlIXSkpqvsMksn0qYjp3IXcyGdjC2bV8fdj3M3RkohU1WjWKvIo0vCRoKukO3W+bDwf6RcnTmNxjmh/zLrs0Ch+jMfazWxDobrUEWot/P62pTAKWLtoWkM8JXUHKYZB8Gmd5xGGHng43YuBa9tDAmGTA91G+f6ENnnlY3ZL4IqK6eeeh9xpRGhWCUQzA8LXEXa7bxwdpWLxEIlFgr6XfANmuZ1RojudRpchG5AEIL1Ewa5qD5mkm6YUaWkqAZob3DkGXeSIW9j5SQluIklr+33czilIlpF+ozahVE4PBFWoqepwBFIIQe0U5tXFpoSTK/YQesVXP1MsDJb5Rq6craOvWRMAFK+xxM/YhjsYaF8oWTruPIkbcjtWgDzMQ9kGPcdF/HEsjNod9D2/5pfWoWzWPaRIjHYavQyAXHJT/K14eJqtdcuDh7dmm83fmJd/CMifpnxQMSM+TuCqjjE07/psiK9T0rk6/oo5u7Vt4wXizcxgvddpUuMN3ztM8bbtjRz4Y4yTK1TdJEgCYs8gqIy2ResWUc4jUw8QhmTICxfcywqLtX7vIcmnWPUxMtaw5Na2K1++TveuKYhlj4Z+Ks1OPabCjdKeQKEh5opIeMgho/HPd+oyiByiAx0OcCyzyQdeB434lfjFri7K7Omb6CCw
 zPxM0Ptf
 jfmakTzG3bzO/28WBwcbVatorY5v+FS9nauAsnRQbCjwFZbjSLG0u7h/CZcoiuDB/ay9iGLSyIeXWs19ZFuejdjUfyZJwriNccBxnZH6bWqL6TYcHlm3VIYGxfN3anjZiysS1ym90t/TM0bwnMzM2ika1a7BQ1Hc9zM5ijWPiKq4sa9slrfA8cC3IjN9oFG/ltLVKy0sfu9i2i/91BGC3UsBHdge1MNMIucPFrgn7scU02RlmmnMsCvH62NotOv4yNqYObXUHIODsWvn9/bDcAh8/e/0WqmKliR+LLoFIOEskZvJnnBajSye0enmK5D1XzZoI9j0zxe3H49GYSMd293Qis8OgOLvxVatP5zeGuicYSaJ5nI2JjuARQWAtbdTU3GTEe28Nk2AdWw6pI80G9RuZE55DL4pQ9bknDhC+QEGR9/G5L8UA6qh1Qu1RvHN/ViUZHtITryT1PefsL/DycppBVyXZ07Wrru7y1G7fXprlfuFW60QNjR9JWSpzDiTTo8TPyFLJ6Kt1T2jaMJfh+P77Z0ejbzcWAtw+8gapC4s22tQPW+XrAK7JDzjRoDaqPHmxD/N7Ub1S+3+1pb6g/OPkQDc0yK/ZRN70nz5SUdyPwa616n7i3/Je9ZYWP7EvuydcCiMFeNoUJ08eCR2CaTAAOyZ5+MiRB94zdNrvzF/B66xUVCwlx8KyqzC3Dc4mPazB0i/5fhot8vVHTvggXOz9D9hFDsC99FOry5IkOyM0iTO+iZCs7ltHVtRhSI9TQ19+jsugB/wIU+7jdEIi9Q9oIsheXEkrNLSJnkInfHWd45JqxCoc3FuIdTgZn8a0dgR6zU8R8FK6cyg1vZJrfMXTSzWLLp8fhadshGbOPhDW2rshvuIqD5NN9L3ouUaxaHcM1rK0U3OybhU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 31, 2025 at 10:28:26AM +0900, Yunseong Kim wrote:
> I've been analyzing a system critical contention observed on a PREEMPT_RT
> enabled kernel (based on v6.17-rc3). The issue stems from internal lock
> contention within the SLUB allocator, particularly under high memory
> pressure scenarios such as massive RCU callback processing.
> 
> In PREEMPT_RT configurations, spinlock_t is implemented as a sleepable
> RT-Mutex. The kmem_cache_node->list_lock in SLUB protects the node-level
> partial slab lists and is a very hot lock, frequently accessed during the
> memory freeing path.
> 
> When multiple CPUs contend heavily for this lock, the overhead associated
> with RT-Mutexes (context switching, priority inheritance, sleeping/waking)
> causes severe stagnation in the memory subsystem's progress.
> 
> I observed a scenario where a task performing memory compaction became
> indefinitely stuck waiting for a folio lock.

Waiting for 143 seconds for a folio lock sounds pretty wild.
(Yunseong told me in an off-list conversation that he turned a couple of
debug options, though)

> It appears the owner of the folio lock was also stalled due to the contention
> on SLUB's list_lock, resulting in a system-wide contention.

Based on the stack traces you provided, I don't think we can conclude
that "the folio lock was stalled because of the contention on SLUB's
list_lock".

It's both true that 1) the task is stuck waiting for the folio lock and
2) other CPUs were processing RCU callbacks, but there is no data that
indicates how much node->list_lock contention contributed to the stall.

...and since there are only 4 CPUs in the reported system, I don't think
it's enough to cause a stall this long.

> The task is stuck in migrate_pages_batch waiting for a folio lock during 
> memory compaction:
> 
>  INFO: task hung in migrate_pages_batch
>  INFO: task syz.7.2768:30677 blocked for more than 143 seconds.
>        Not tainted 6.17.0-rc3-00269-g11e7861d680c-dirty #73
>  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>  task:syz.7.2768      state:D stack:0     pid:30677 tgid:30673 ppid:20684  task_flags:0x400040 flags:0x00000011
>  Call trace:
>   __switch_to+0x2b4/0x474 arch/arm64/kernel/process.c:741 (T)
>   context_switch kernel/sched/core.c:5357 [inline]
>   __schedule+0x6c4/0xe2c kernel/sched/core.c:6961
>   __schedule_loop kernel/sched/core.c:7043 [inline]
>   schedule+0x50/0xf0 kernel/sched/core.c:7058
>   io_schedule+0x38/0xa0 kernel/sched/core.c:7903
>   folio_wait_bit_common+0x360/0x698 mm/filemap.c:1317
>   __folio_lock+0x2c/0x3c mm/filemap.c:1675
>   folio_lock include/linux/pagemap.h:1133 [inline]
>   migrate_folio_unmap mm/migrate.c:1246 [inline]
>   migrate_pages_batch+0x448/0x1a80 mm/migrate.c:1873
>   migrate_pages_sync mm/migrate.c:2023 [inline]
>   migrate_pages+0x101c/0x14f4 mm/migrate.c:2105
>   compact_zone+0x1044/0x1ae8 mm/compaction.c:2647
>   compact_node mm/compaction.c:2916 [inline]
>   compact_nodes mm/compaction.c:2938 [inline]
>   sysctl_compaction_handler+0x244/0x3f4 mm/compaction.c:2989
>   proc_sys_call_handler+0x224/0x3fc fs/proc/proc_sysctl.c:600
>   proc_sys_write+0x2c/0x3c fs/proc/proc_sysctl.c:626
>   do_iter_readv_writev+0x314/0x3e0 fs/read_write.c:-1
>   vfs_writev+0x194/0x470 fs/read_write.c:1057
>   do_pwritev fs/read_write.c:1153 [inline]
>   __do_sys_pwritev2 fs/read_write.c:1211 [inline]
>   __se_sys_pwritev2 fs/read_write.c:1202 [inline]
>   __arm64_sys_pwritev2+0xf0/0x194 fs/read_write.c:1202
>   __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>   invoke_syscall+0x64/0x168 arch/arm64/kernel/syscall.c:49
>   el0_svc_common+0xb4/0x164 arch/arm64/kernel/syscall.c:132
>   do_el0_svc+0x2c/0x3c arch/arm64/kernel/syscall.c:151
>   el0_svc+0x40/0x144 arch/arm64/kernel/entry-common.c:879
>   el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
>   el0t_64_sync+0x1b8/0x1bc arch/arm64/kernel/entry.S:596

This is stuck while waiting for the folio to be unlocked.

>  NMI backtrace for cpu 0
>  CPU: 0 UID: 0 PID: 55 Comm: khungtaskd Kdump: loaded Not tainted 6.17.0-rc3-00269-g11e7861d680c-dirty #73 PREEMPT_{RT,(full)} 
>  Hardware name: QEMU KVM Virtual Machine, BIOS 2025.02-8ubuntu1 06/11/2025
>  Call trace:
>   show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
>   __dump_stack+0x30/0x40 lib/dump_stack.c:94
>   dump_stack_lvl+0x148/0x1d8 lib/dump_stack.c:120
>   dump_stack+0x1c/0x3c lib/dump_stack.c:129
>   nmi_cpu_backtrace+0x278/0x31c lib/nmi_backtrace.c:113
>   nmi_trigger_cpumask_backtrace+0x134/0x2cc lib/nmi_backtrace.c:62
>   arch_trigger_cpumask_backtrace+0x30/0x40 arch/arm64/kernel/smp.c:936
>   trigger_all_cpu_backtrace include/linux/nmi.h:160 [inline]
>   check_hung_uninterruptible_tasks kernel/hung_task.c:328 [inline]
>   watchdog+0x858/0x890 kernel/hung_task.c:491
>   kthread+0x314/0x384 kernel/kthread.c:463
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:844

>  Sending NMI from CPU 0 to CPUs 1-3:
>  NMI backtrace for cpu 1
>  CPU: 1 UID: 0 PID: 28 Comm: rcuc/1 Kdump: loaded Not tainted 6.17.0-rc3-00269-g11e7861d680c-dirty #73 PREEMPT_{RT,(full)} 
>  Hardware name: QEMU KVM Virtual Machine, BIOS 2025.02-8ubuntu1 06/11/2025
>  pstate: 63400005 (nZCv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
>  pc : __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:160 [inline]
>  pc : _raw_spin_unlock_irq+0x18/0x70 kernel/locking/spinlock.c:202
>  lr : __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:158 [inline]
>  lr : _raw_spin_unlock_irq+0x10/0x70 kernel/locking/spinlock.c:202
>  sp : ffff800089f0fa40
>  x29: ffff800089f0fa40 x28: ffff0000c0004640 x27: 0000000000000000
>  x26: 0000000000000000 x25: 0000000000001000 x24: ffff8000855f169c
>  x23: 0000000000000001 x22: ffff800089f0fa68 x21: ffff800089f0fb48
>  x20: ffff0000c11e6440 x19: ffff0000c0004640 x18: 000000651c596d12
>  x17: 0000000000000000 x16: 0000000000000008 x15: 0000000000000000
>  x14: 0000000000000000 x13: 0000000000000010 x12: ffff80008b0cfa68
>  x11: 0000000000000008 x10: 00000000ffffffff x9 : ffffffffffffffff
>  x8 : 0000000000000000 x7 : bbbbbbbbbbbbbbbb x6 : 392e39383520205b
>  x5 : ffff8000806849f4 x4 : 0000000000000001 x3 : 0000000000000010
>  x2 : ffff800089f0fa68 x1 : ffff0000c11e6440 x0 : ffff0000c0004640
>  Call trace:
>   __daif_local_irq_enable arch/arm64/include/asm/irqflags.h:26 [inline] (P)
>   arch_local_irq_enable arch/arm64/include/asm/irqflags.h:48 [inline] (P)
>   __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline] (P)
>   _raw_spin_unlock_irq+0x18/0x70 kernel/locking/spinlock.c:202 (P)
>   raw_spin_unlock_irq_wake include/linux/sched/wake_q.h:82 [inline]
>   rtlock_slowlock_locked+0xcb0/0xe0c kernel/locking/rtmutex.c:1864
>   rtlock_slowlock kernel/locking/rtmutex.c:1895 [inline]

This is rtmutex slowpath.

>   rtlock_lock kernel/locking/spinlock_rt.c:43 [inline]
>   __rt_spin_lock kernel/locking/spinlock_rt.c:49 [inline]
>   rt_spin_lock+0x6c/0xe0 kernel/locking/spinlock_rt.c:57
>   spin_lock include/linux/spinlock_rt.h:44 [inline]
>   free_to_partial_list+0x74/0x5bc mm/slub.c:4427
>   __slab_free+0x208/0x254 mm/slub.c:4498
>   do_slab_free mm/slub.c:4632 [inline]
>   slab_free mm/slub.c:4681 [inline]
>   kmem_cache_free+0x320/0x5f0 mm/slub.c:4782
>   mem_pool_free mm/kmemleak.c:508 [inline]
>   free_object_rcu+0x104/0x11c mm/kmemleak.c:536
>   rcu_do_batch kernel/rcu/tree.c:2605 [inline]
>   rcu_core kernel/rcu/tree.c:2861 [inline]
>   rcu_cpu_kthread+0x404/0xcd0 kernel/rcu/tree.c:2949
>   smpboot_thread_fn+0x270/0x474 kernel/smpboot.c:160
>   kthread+0x314/0x384 kernel/kthread.c:463
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:844

>  NMI backtrace for cpu 3
>  CPU: 3 UID: 0 PID: 44 Comm: rcuc/3 Kdump: loaded Not tainted 6.17.0-rc3-00269-g11e7861d680c-dirty #73 PREEMPT_{RT,(full)} 
>  Hardware name: QEMU KVM Virtual Machine, BIOS 2025.02-8ubuntu1 06/11/2025
>  pstate: 03400005 (nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
>  pc : finish_task_switch+0xb0/0x308 kernel/sched/core.c:5225
>  lr : raw_spin_rq_unlock kernel/sched/core.c:680 [inline]
>  lr : raw_spin_rq_unlock_irq kernel/sched/sched.h:1530 [inline]
>  lr : finish_lock_switch kernel/sched/core.c:5105 [inline]
>  lr : finish_task_switch+0xa8/0x308 kernel/sched/core.c:5223
>  sp : ffff80008b0cf940
>  x29: ffff80008b0cf950 x28: ffff0000c11fab28 x27: ffff800088169df0
>  x26: ffff0000c11fa440 x25: ffff8000855e93b4 x24: ffff800088169df0
>  x23: 0000000000001000 x22: 0000000000000000 x21: bcf48000855e8a30
>  x20: ffff0000c11fa440 x19: ffff0000c1301440 x18: 00000062aca2a5d2
>  x17: fffffffffffff63c x16: 0000000000200b20 x15: 0000000000135c81
>  x14: ffff800088169df0 x13: 000000000132d6aa x12: 00000000001f4245
>  x11: 0000000000000000 x10: 00000000ffffffff x9 : 0000000000000001
>  x8 : 0000000100000001 x7 : bbbbbbbbbbbbbbbb x6 : ffff8000a954fd48
>  x5 : 0000000000000001 x4 : 0000000000001000 x3 : ffff0000c11fa440
>  x2 : 0000000000000001 x1 : ffff80008741f318 x0 : 0000000000000001
>  Call trace:
>   __daif_local_irq_enable arch/arm64/include/asm/irqflags.h:26 [inline] (P)
>   arch_local_irq_enable arch/arm64/include/asm/irqflags.h:48 [inline] (P)
>   raw_spin_rq_unlock_irq kernel/sched/sched.h:1531 [inline] (P)
>   finish_lock_switch kernel/sched/core.c:5105 [inline] (P)
>   finish_task_switch+0xb0/0x308 kernel/sched/core.c:5223 (P)
>   context_switch kernel/sched/core.c:5360 [inline]
>   __schedule+0x6c8/0xe2c kernel/sched/core.c:6961
>   __schedule_loop kernel/sched/core.c:7043 [inline]
>   schedule_rtlock+0x24/0x44 kernel/sched/core.c:7122
>   rtlock_slowlock_locked+0xd20/0xe0c kernel/locking/rtmutex.c:1868
>   rtlock_slowlock kernel/locking/rtmutex.c:1895 [inline]
>   rtlock_lock kernel/locking/spinlock_rt.c:43 [inline]

This is also rtmutex slowpath.

>   __rt_spin_lock kernel/locking/spinlock_rt.c:49 [inline]
>   rt_spin_lock+0x6c/0xe0 kernel/locking/spinlock_rt.c:57
>   spin_lock include/linux/spinlock_rt.h:44 [inline]
>   free_to_partial_list+0x74/0x5bc mm/slub.c:4427
>   __slab_free+0x208/0x254 mm/slub.c:4498
>   do_slab_free mm/slub.c:4632 [inline]
>   slab_free mm/slub.c:4681 [inline]
>   kmem_cache_free+0x320/0x5f0 mm/slub.c:4782
>   mem_pool_free mm/kmemleak.c:508 [inline]
>   free_object_rcu+0x104/0x11c mm/kmemleak.c:536
>   rcu_do_batch kernel/rcu/tree.c:2605 [inline]
>   rcu_core kernel/rcu/tree.c:2861 [inline]
>   rcu_cpu_kthread+0x404/0xcd0 kernel/rcu/tree.c:2949
>   smpboot_thread_fn+0x270/0x474 kernel/smpboot.c:160
>   kthread+0x314/0x384 kernel/kthread.c:463
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:844
>  NMI backtrace for cpu 2
>  CPU: 2 UID: 0 PID: 36 Comm: rcuc/2 Kdump: loaded Not tainted 6.17.0-rc3-00269-g11e7861d680c-dirty #73 PREEMPT_{RT,(full)} 
>  Hardware name: QEMU KVM Virtual Machine, BIOS 2025.02-8ubuntu1 06/11/2025
>  pstate: 63400005 (nZCv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
>  pc : __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:152 [inline]
>  pc : _raw_spin_unlock_irqrestore+0x2c/0x80 kernel/locking/spinlock.c:194
>  lr : __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:150 [inline]
>  lr : _raw_spin_unlock_irqrestore+0x18/0x80 kernel/locking/spinlock.c:194
>  sp : ffff80008afafa80
>  x29: ffff80008afafa80 x28: ffff0000c0004640 x27: 0000000000000000
>  x26: ffff8000806849f4 x25: ffff8002cf620000 x24: ffff0000c11f0440
>  x23: 0000000000000000 x22: 0000000000000000 x21: ffff0000c11fad30
>  x20: 0000000000000008 x19: 0000000000000000 x18: ffff80008565bf38
>  x17: 0000000000000006 x16: 0000000000000010 x15: 0000000000000000
>  x14: ffff800088169df0 x13: 0000000000000130 x12: 0000000000000110
>  x11: 0000000000000000 x10: 00000000ffffffff x9 : ffffffffffffffff
>  x8 : 00000000000000c0 x7 : bbbbbbbbbbbbbbbb x6 : 000000000000003f
>  x5 : 0000000000000001 x4 : 000000895af9d556 x3 : 0000000000000004
>  x2 : 0000000000000001 x1 : 0000000000000000 x0 : ffff0000c11fad30
>  Call trace:
>   __daif_local_irq_restore arch/arm64/include/asm/irqflags.h:175 [inline] (P)
>   arch_local_irq_restore arch/arm64/include/asm/irqflags.h:195 [inline] (P)
>   __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:151 [inline] (P)
>   _raw_spin_unlock_irqrestore+0x2c/0x80 kernel/locking/spinlock.c:194 (P)
>   class_raw_spinlock_irqsave_destructor include/linux/spinlock.h:557 [inline]
>   try_to_wake_up+0x3b0/0x7e0 kernel/sched/core.c:4216
>   wake_up_state+0x14/0x20 kernel/sched/core.c:4465
>   rt_mutex_wake_up_q kernel/locking/rtmutex.c:566 [inline]
>   rt_mutex_slowunlock+0x16c/0x2ac kernel/locking/rtmutex.c:1469
>   rt_spin_unlock+0x24/0x34 kernel/locking/spinlock_rt.c:85
>   spin_unlock_irqrestore include/linux/spinlock_rt.h:122 [inline]
>   free_to_partial_list+0x2b8/0x5bc mm/slub.c:4466
>   __slab_free+0x208/0x254 mm/slub.c:4498
>   do_slab_free mm/slub.c:4632 [inline]
>   slab_free mm/slub.c:4681 [inline]
>   kmem_cache_free+0x320/0x5f0 mm/slub.c:4782
>   mem_pool_free mm/kmemleak.c:508 [inline]
>   free_object_rcu+0x104/0x11c mm/kmemleak.c:536
>   rcu_do_batch kernel/rcu/tree.c:2605 [inline]
>   rcu_core kernel/rcu/tree.c:2861 [inline]
>   rcu_cpu_kthread+0x404/0xcd0 kernel/rcu/tree.c:2949
>   smpboot_thread_fn+0x270/0x474 kernel/smpboot.c:160
>   kthread+0x314/0x384 kernel/kthread.c:463
>   ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:844

This task is holding the rtmutex, and it's just about to release the lock.

So.. I think the right questions to ask for further investigation is:

1. Which task locked the folio and why is it holding the lock for so long?
2. How severe is the memory pressure?
3. How much does debug options contribute to the stall?

> NMI Backtrace shows RCU threads (rcuc/X) on multiple CPUs are experiencing
> severe contention while trying to acquire the RT-Mutex in
> free_to_partial_list(). Similar contention traces were observed on other
> CPUs.

I wouldn't say it's a severe lock contention. One task is holding the lock,
and two tasks are waiting for the lock. We don't know how much these
tasks are waiting for the lock, but presumably not for too long as only
three tasks are using the lock.

Cheers,
Harry / Hyeonggon

> The core issue is that kmem_cache_node->list_lock is too hot to operate as
> a sleeping lock (RT-Mutex) under high contention scenarios. I've seeking
> community feedback on the best approach to ensure system stability while
> maintaining RT guarantees. Here’s my thought on a possible direction:
> 
> 1. Convert list_lock to raw_spinlock_t (Immediate Fix)
> 
>  The most straightforward solution is to change kmem_cache_node->list_lock
>  from spinlock_t to raw_spinlock_t. This ensures the lock remains a
>  non-sleeping spinlock even on PREEMPT_RT.
> 
>    - Pros:
>      Reliably resolves the deadlock by eliminating the RT-Mutex overhead.
>      Minimal code changes required.
> 
>    - Cons:
>      Reintroduces a traditional spinlock, which could theoretically
>      slightly increase latency for high-priority RT tasks. However, given
>      the very short critical section protected by this lock, this may be a
>      reasonable trade-off for stability.
> 
> 2. Reducing Lock Contention
> 
>  Instead of changing the lock type, we could reduce the frequency of
>  acquiring the node-level list_lock. Contention primarily occurs when
>  per-CPU partial lists (kmem_cache_cpu->partial) are flushed to the node
>  list (kmem_cache_node->partial).
>  Tuning and Batching: We could adjust the thresholds in flush_cpu_slab()
>  or enhance batch processing when moving slabs to reduce the number of
>  lock acquisitions.
> 
>    - Pros:
>      Improves overall SLUB scalability while maintaining PREEMPT_RT locking
>      semantics (using RT-Mutexes).
> 
>    - Cons:
>      Implementation and tuning are complex. It may increase per-CPU memory
>      usage and might not entirely resolve contention under extreme loads.
> 
> 3. Deferring Node List Updates
> 
>  A structural change to avoid acquiring the list_lock (RT-Mutex) in the
>  memory freeing fast path. Instead of moving slabs to the node list
>  immediately by the task freeing the memory (especially in RCU callback
>  context), this work could be deferred to a dedicated workqueue or kthread.
> 
>    - Pros:
>      Removes heavy RT-Mutex acquisition from the fast path, potentially
>      improving response times.
> 
>    - Cons:
>      Adds significant complexity to the SLUB architecture. It might impact
>      performance in non-RT environments or delay memory reclamation.
> 
> Given the severity of the observed deadlock, Option 1 using raw_spinlock_t
> appears to be the most pragmatic and immediate solution to guarantee system
> stability. However, I would like to hear the community's opinion on whether
> this is the best approach aligned with PREEMPT_RT goals, or if the MM/RT
> community prefers a longer-term structural improvement like Option 2 or 3.
> 
> Please let me know if further adjustments, testing, or reproduction are
> needed. Welcome any feedback or suggestions regarding this issue.
> 
> Best regards.
> Yunseong Kim

