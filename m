Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C994CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 08:35:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5BDE8E005A; Fri, 24 Oct 2025 04:35:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A33888E0042; Fri, 24 Oct 2025 04:35:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FB1D8E005A; Fri, 24 Oct 2025 04:35:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 766578E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 04:35:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1C7F612A17A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:35:37 +0000 (UTC)
X-FDA: 84032349114.21.A064D0B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 934CAC0006
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:35:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gtI6TdUs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HjXtzDMn;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf28.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761294933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+p9Gym+5Y+1Uk7UIcPelC0ZieZxC/i6aOKV1VjFu9lU=;
	b=znw9F03RZ5OhH2CRPoqsECVB7OhmZ/kEHzhiTc4MEuVjAyAf2NUXxaod/o7Gmq/ClNHdso
	Ktxz+bK0WetmZqVh4gBeeXO0j4uFh+ZNAs7tGfgKJ/teuUc1rIGSMj9YDC56uSiGaJw627
	PIr8z+Q8ruKMv+7pQnaKtqDhrELhou4=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gtI6TdUs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HjXtzDMn;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf28.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761294933; a=rsa-sha256;
	cv=pass;
	b=hQa4dJF29//idQjqUyraic0ohCnMGNe8eonwaM2BASLvpg6graHWWhOq9xzNb0TrJqFmnt
	8HdubNb4jvvBTAiAbSjTPT/8yIqXnnyLxNZx0H5U4hpZGSz9mHHHOmPEkURJbXgS1v4HNw
	WVyQ/ydtlUKSfKDlfaSjz5nxkBLgDLs=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59O3OEni014739;
	Fri, 24 Oct 2025 08:35:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+p9Gym+5Y+1Uk7UIcPelC0ZieZxC/i6aOKV1VjFu9lU=; b=
	gtI6TdUsc45ZcOty4LFQAEiCPmksLq13jZWipOY3iBaTwOQDAXwv+TeG5lH3PIt+
	6Cpif99b4mbl0cvF6YrC10P9NAA9jhn8gboPhH51qTUsgFshcq3dgGfw3W8oEHAG
	TffBgNZgmRoBhLVTh+QXk+jgTK5FLdb86VTpWiiQtfilFSXQA12rzgnIkFMlZG5Y
	z3O6uUA9L5NZhiPvlK1JsXvnpZJYWWClrKUsVqNOoFb9VNi6vJ7rz0GngQ9uzdeU
	FnfIdxFdMZp4ZNnRxO7JqrdAHxmqIdqqmTF4K7l8XteYusF9BEPi0B1jFzf2q1ro
	z8bpUakms79iiIh4CcJAAg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xstymgdk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 08:35:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59O7XSM2035776;
	Fri, 24 Oct 2025 08:35:25 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010027.outbound.protection.outlook.com [52.101.193.27])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bgns3c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 08:35:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ht5lJfbuyUowFCScZsrTzbH8hmF56eRSYkV8eoIPikxSrjMGaL6c0nn3hrUnbqzK/yJd8m+48I37DhAQOuSypmJDsiUP5FxDOtNcvq88111Ag0Xx/nc85+08/i2b0iY/crgXKnuSFWhjybBtxwusQPpr0OhnBafFEY+8437OsU7mMxIx5qlWOjtdKcGt1IZUiBACpEkFFWasjCT/+cJicDDqtob59ndqdO7DzZUfnMFSgm/f8Q5WLCur0mF6ne2Gtx/cuiWURL2WiKFYOwUIY+Uw1YeuBGP9jOVkSBW6UynhUj/LQh3mDJdr09Xi+JdgxRM5i862Iw5U4mbY21hZLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+p9Gym+5Y+1Uk7UIcPelC0ZieZxC/i6aOKV1VjFu9lU=;
 b=SxvQE3hyDnG3i8NQskE0LZ93XX4Hl593JMcYNWQ3nXSVKYkpEBgK1D+sFyw6n6GYVFPDi/u2cPA4ZiTUukOOfNyzx3kPi22AlpTx9Ip8i7MYYSxaNn4ghM8PRTr5bKPEgT0owrsb9jM1xveXw2woDilyPOvn/jWaTboSVdFjaMwzPjk0anKfYohXas3wQW1N2IsY9mWkD5vTmDscQLTVSV7CtAVoQlROsFckOaK7WuYDXkFCaLmzwbSDANbTuvcljKCvBJjOnS2p5ND3vLq4TGohcqNrE1NP7K0Bt72SpiH5l4+YZT49KJv2KAVyjhJIb66H8DQkS01p0LO4C50W1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+p9Gym+5Y+1Uk7UIcPelC0ZieZxC/i6aOKV1VjFu9lU=;
 b=HjXtzDMn7MfhCctAymgw31sqULrvv5m2UK/ggfbLN/Rh6y+QI+8bp20DXI/HMzk5GyBUuID3T1J9REsmWzY0GHDA1Q3fChFmRo5UfZFgC5HV+pC/vbqr3lLdTHZ8+o+aEsdKt1FR5tkkTjbdI/s4+KqhtLlj/nzBTZIxExEy+i0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MW5PR10MB5874.namprd10.prod.outlook.com (2603:10b6:303:19c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 08:35:22 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 08:35:22 +0000
Date: Fri, 24 Oct 2025 17:35:13 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, David Rientjes <rientjes@google.com>,
        Alexander Potapenko <glider@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Feng Tang <feng.79.tang@gmail.com>, Christoph Lameter <cl@gentwo.org>,
        Dmitry Vyukov <dvyukov@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm/slab: ensure all metadata in slab object are
 word-aligned
Message-ID: <aPs6Na_GUhRzPW7v@hyeyoo>
References: <20251023131600.1103431-1-harry.yoo@oracle.com>
 <aPrLF0OUK651M4dk@hyeyoo>
 <CA+fCnZezoWn40BaS3cgmCeLwjT+5AndzcQLc=wH3BjMCu6_YCw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+fCnZezoWn40BaS3cgmCeLwjT+5AndzcQLc=wH3BjMCu6_YCw@mail.gmail.com>
X-ClientProxiedBy: SE2P216CA0067.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:118::9) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MW5PR10MB5874:EE_
X-MS-Office365-Filtering-Correlation-Id: fe9f2715-2468-42d7-07be-08de12d84527
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z01IUGV2WlJubzNXSG53QnNiNHZFTlA0N0hJSURQTTJwTzJVVFY3T3Z3ME9x?=
 =?utf-8?B?L2c2SVE5VC9NNUhDelJCU2JVYi9LaXRzOEMzTmZFNHVYUlIrTEE3RGNDaVVj?=
 =?utf-8?B?ck04M2ZkNmtxNG9oMkxDai9jdUhmQXB4NDRZQWducTdMQVp3a3E4T2UrNVBR?=
 =?utf-8?B?YlcwNCtIT0lXNDBmaktkL09aWFNrTnZjQlpPNkpRYUpSZmRJUHQ0bnRPcGNt?=
 =?utf-8?B?cldhSFBDQjgvR1JEMXRzei9HVVFGdklSNTlTYjNqVUR0ckxpdEZzNGl5NHpN?=
 =?utf-8?B?czNLU2UzMzVEM1BiYWxGd09QODd6WEVkeUtGZzBMNUNSUG8vTkFyWVZWaFg4?=
 =?utf-8?B?aGdPbFd0cDFaVkI0U085THNUeXpleC9MZUdaSVorT2EzdEtKWSs0dnpsWHdp?=
 =?utf-8?B?TlAwbzZDdTh0MGZ6Q1UyRnFoMDNPOXU3ZktITmRiNys4M3hGTUtrdTVzSlY0?=
 =?utf-8?B?QktBclluZHpoRG5tcDVqSjBYTzFvYTJsWUF6anAwNTlXS1BxdjNkanpSWVZp?=
 =?utf-8?B?TDJWc1lyQTl4eGVKSU5GTWZ5WTdrT01iUFlVSjZWL2F1QzVVMnlDQ0tvV2tx?=
 =?utf-8?B?NkZuZ2ZHUk5pcTh4dXNiUk5xbW9IekRKdStTQ2kvalk2TkwwWEVZWnk2MzhZ?=
 =?utf-8?B?dGV2SW12c1o3M1JvWHN1ZGduYmM4UWwxUktzQS9HTytZOTIySC9xcjMvRTV4?=
 =?utf-8?B?NGZOMU1XWG1TZTREcm9qemg0N2p1eExHcUVMMUIrVDNGeWpkb0xTb1JLcDVX?=
 =?utf-8?B?bnVTRVk3NTg0b1dXS1M3Sko5S3RVaTVtSWJwYjBtSy9jWjAwaVJ4aUROMWtk?=
 =?utf-8?B?RVpXam9zSVQwdXJsa1J1N2w3aXBDMXk5cnZzMm9nRHdTZTU1NGhxekFmUitB?=
 =?utf-8?B?QWVKcWY0bXI1RGJrckJTeERqVGtxWkdBck5ZMTViUkFwYUVLcERjbjZPVzlC?=
 =?utf-8?B?ei9xQnc5TFpOSDVCWWMvUUdObGlrRFBzV2NnWTFuTHc1bkI4b2NTZVl2NjlR?=
 =?utf-8?B?dEN5ckVNKzRub1lkVld1QWZGeEUvWlFwVkg3N0FDZXg5blZtK0hEb2JQOGRD?=
 =?utf-8?B?dEc4OTVGajBqOUJmRE9yUW9SWFR6a2FpcExyUWV3N21iMDFiOGZ6a2dLejgr?=
 =?utf-8?B?RFMvS3ZiOWZGa3d2Rnl4enJkb2ZnM1FEWjhzU1VXMkhsMTRZOGhId2J0R2VO?=
 =?utf-8?B?U0JBbDJKN1BSWUJSekw4Q1poOFZWeGhHRnc1OWFtL01Cd0ltZElZNmdTR3FS?=
 =?utf-8?B?UTJvZDJQb3lKUWxqR2tqSmRDaHB6UzVYbUlLMmRZNHJJTWdqSmp4QmhXTCs0?=
 =?utf-8?B?eDQyQVExbmhPbDVkQnVmWjA0V2hhb051U1lBQXpLRGdDb0ZPSHQyTjEwM0xF?=
 =?utf-8?B?blJGVVBEY2FKeUhpQmZZZFVPczRzbmdMSG91b0hwNFRSZjdOWDBKUEJjTmhD?=
 =?utf-8?B?Q0k4Rzc1NzlPY0Irc1NOSDJYaEZwWmVZSTBIbEdnZlNKR1l5dVhmek1mMzhH?=
 =?utf-8?B?WmptYkhqdVJLL1VxZjUzdTVDRkRVOHFxNHFId1VBQkJVWXdUTkdWY0drbDFj?=
 =?utf-8?B?WEdJOHNVYzlmemdLREtHZzV1SzdTU2ZtWGVhUElNVDVGQ00zTFJTUVhJWUVu?=
 =?utf-8?B?UjcyRGp3WGlyU1l2MmsrTEtzMHF0eGRtdHNBTlRNNmxWZm8vZ2k2SWo4U3dj?=
 =?utf-8?B?RncxTUZjU3RwOXY2aDVSR1YzNm9wMkE2Yi83bER6TUNqTHFnVVp1UnhTcDlX?=
 =?utf-8?B?UkNuS0huUnlJaWFOblJjemR0MnR5UjFQMUFhVmU5Y2htRmVWL3lTNXgrSjZW?=
 =?utf-8?B?VHFZSUxjWGQzYi9iVzRaUWYzTGJpOXpxc2lNWE9HcExKRHg0NFJndXJ6ZVJ0?=
 =?utf-8?B?SU5mUko2citreDVxUXJQRXlxaGhoTmRvQzR6SHdOWG5RRTJOSUNucEYxUG0w?=
 =?utf-8?Q?tuUZ2UkzYFLq94CIHos6qfrpOH6oWviW?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OU9pS2luU0hidE9JWDNiSFliMlRTeUduL1I1QnlOQlpBL3VPVEFEdUsyYzhL?=
 =?utf-8?B?cDZ5ZFB4R1lGMTNyMmxBcXh6UWJUVW9UZXlSWFU2TlBVYWtpTUY3RmNwZjMy?=
 =?utf-8?B?aFpGQmRheHErbzFnUC8ybVRoRHZCMGE2R2EvUFV3N2NsTDdqUVVFY3dJdU95?=
 =?utf-8?B?TGg0enliaW04QkxxaGtzU1o1NzN5RzFKWEdTbXhwMjBQa2REV0xPd0I5ZDJz?=
 =?utf-8?B?QUNQcEl3VXlyQmhEQXpqVGdJeFdzSnR2ZmV0YlBISDA2OXlpamJxU2JTaXRX?=
 =?utf-8?B?NVUreUE4UjBBWHBRVE80bmRRN3kwNWlVWGFNcWUvVG9YOTVYditGcXc4R2JY?=
 =?utf-8?B?RXN0emtycFJxbkhaekxWVFRraFZkYmdYNTJ6eVl1TllnQWRpTDdacUJZeEZH?=
 =?utf-8?B?Y0NVME52bkZ2dHZ3SExSVXdUTWtuMTRBV1g1MzNiOVY4VS9mbll6MTM2ME9n?=
 =?utf-8?B?bXViSnFJYVZtbWIrOXNnSGRpNDF3R28zNUo5d3lEQWN2cUdMMklSYTB4TGxY?=
 =?utf-8?B?RG9XcXJBekFsUExBQVV5WTNJSUIyUjBsc1U0RkZCOHZwZ2JWVGw4bUd5dVQx?=
 =?utf-8?B?U1pTeGprd1VZYjVwOEU4WUo3a3MzZDJ0UnRvdklWUzBhK3hUQkJ5Z2tRdnQ0?=
 =?utf-8?B?SVlyQ1BIc1l6RDQ2MVVGbUo0Z3RpUlVBSVBiQXJteFRHdnZZQUNsTXJrN3E1?=
 =?utf-8?B?OFFQTUVVaURENG9VWkFZWTEzTXpBeDE2SnUvZTVxSEQ3N3RpSTNYVTUvRFV2?=
 =?utf-8?B?Q1FKeVFmUHFXYkpSZTZnUklvRSs4RkJjdjl3cXNhd0hTRklOY0lFVitMNGxS?=
 =?utf-8?B?eHZ2eVBlcS9IbUYyWFRKWXYvdit3amE2cFNoeVZqMHdEMlc2TEwyUnpjSG44?=
 =?utf-8?B?ZUNENGJweTRuUm1SMXpBanNGYVIzUHRmV0FiQ1BJVHdWNjNqL3AxTlZXRW1T?=
 =?utf-8?B?dE1MZ0lMSkhJamRrYjg2M2RsSXc1NVFhcnBzQllJemx0YzROMStiS3Z6aDRr?=
 =?utf-8?B?SUdwZGgwdDJIbTRYSXJSbWNsODZYUmlNcllUWmEyRE4rQTN5UVBtQ3BsTFNu?=
 =?utf-8?B?R3BsZUEzR0xoVzVtRkYzektTSzlNMGpiTGdqOWZtVStzZzFlM3N6WUw3T2px?=
 =?utf-8?B?U2Q3VG9heGVYUUUwc1B5WEJBYW9GRmdLL2gxK0ZzTitUaEhrdm1zNTY4RVVp?=
 =?utf-8?B?OWpteGtmOTNjVG5yaENWYno2Z3hkWEo5azIwdnhuMno2TGI0ckw1R0Y3cHhG?=
 =?utf-8?B?WE5rcHQxSERJVkV2ZXF3Z1owbkM3M1YySGl0M3VoNk5SZ2RXRDNxT25UZ3Y3?=
 =?utf-8?B?NG9FcHJNb0lGN1V4T21FeHJPWm85c3dkdVJreWFld3h6dEhMeVVyb1kzL2pr?=
 =?utf-8?B?eW1Id01iK3Z0Z2xaNDU2NGRmSTYxQkhoc1hDRkpic3Z1S0hOcE9KTjJQTFRD?=
 =?utf-8?B?MnA3NDVhbEJ0R0dCS3ZnTGZqb1lwdWRiK3N5RUZBT1Y1MUFxdkEyN2RpTG4y?=
 =?utf-8?B?VWhoS09RSW90RGJXdUd0cTBoV0duTkg0eG1EcVlxbVFKSUZTUXcxdTJFeTVy?=
 =?utf-8?B?TGcxUHJKRFdSM3U5VVhDcC8vMWVndTFuZml5TkVXUUNmeC95ZFZmay8vV1NV?=
 =?utf-8?B?cXRobjc5SnhIK01IamczRnNRdjZ4enh1SWJnQjh4Q01EYW5VZmxsL3ljcjFl?=
 =?utf-8?B?c0ZCemNTY2c3RHZ5TVdMWWg0U0NRcFo5b3NNU3ZUOUtuOGtiYmloRG5wUkpy?=
 =?utf-8?B?eEwwNDErWE1ZMUNTRGMxTHU0RFY0clRKUmZ2TEV1S1hQc2NjbGlnMmQ5ZGlh?=
 =?utf-8?B?RHBuSFFxUnhuNFQwcEs2aERNM0dDMHNKU3JRWFM1dXA4akE4WlRLNkpYV0tn?=
 =?utf-8?B?N283YmgrRDNUUHBIOVNvWkRHZmRWc1ZJc3RTaHRyVVRsZXFnNVp4ak5hZDd0?=
 =?utf-8?B?ZWdYcUxoMVUrWGhadVg2VUx0SWdYZ3FiUnpTSVArR1RZMk1BajBtQ2F3TnY4?=
 =?utf-8?B?d2FoMFJ1RHcvVDBWQ09HdURhbDRhcVNhZFdKcUplY1hqeWZiQVA5cWFZd01J?=
 =?utf-8?B?N0R6cnBveXBhbVBXQXN1YXgwM1NQaktVell6dW1NUGFoa3R3WE1XcXFnSmJM?=
 =?utf-8?Q?74nRXuyhiRpA5aYeVNi0NO20E?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7M2npsE5zeBSm+vwCH6m7VyV40lNA5aTb5xhK3xh2zysQ0q80lb5vrM4gykKkkm1T70uvS9dAA4ju++nH5trOkARwjaVL0sCRZL8eT6tK2GnzYuOWaA//NqL3VNyCEfrioRK3PiBwpjWe1CtflREmd3T2bJHUO2j8Z0LGBpxD4gEznnutvVgp7ix9bUNTaPo6oHTl/ZBdlRb0LFP1FPwe0XXf2DD5kF0q02oDmIfJHUQXnO4oEOJNgGBUnhw9TgLQwmikpBsjPxRrIbv37yUSy5xloN+tFBJXHKvekP3NhkkLGQIhcQHJsswLvHQ14o6nvKAyXk+eIp1zMLSZ9OpAA3ZBJ0B0hZ4joXIJ7XTjkrtg4YL4gLFWXbGi8ggkukQfzLpXEJhxjHWYrSM3xC/DooA9B94Q9nkDesYEhS/QUpH67eEdPE1u64OogVCpGn7cwRf79RtpezV5kGed9mjZBwoGFcjfNkOPwrSm/ll+zd0b8Wr5mho0XaBRqNGiLCZXTuW3Qv/vrpnxIL/fBZVlD5NyMLbS3ovLmg+ex7Cpz2iRcS3dG9N5jJFwPSHrzZI0BsZPNMX7u4uaaJc7ckHruSm69YVjWGevxngns+e2oA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe9f2715-2468-42d7-07be-08de12d84527
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 08:35:22.4481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fKvDs7UGmYuFT/e9B9rIJog73RDn/0bTtv4/2EzQBeAEqKvncefKKGJl6LjqaUKL3nONpRijbzX8KHV4ioalYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5874
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-23_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510240075
X-Proofpoint-GUID: GoFMKc1ub7D9hokuS11Gm9zpEFDaQbpc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA1MCBTYWx0ZWRfX+hFOe5rU/2+d
 5VV1RsLjkr2WUoZsZ5QdA0eDYN6U7f8lqtwW3jKJ1wXqDbEI7DWjrajm+jfC5u1Oxiwoa6gUCD/
 yQB+372NYAqx4X6/iy/YZ8bvtev9JpDscq22JYWb5q7BWnnBQFX+G/13MQxHuBiaQW552GFssKn
 /zLLnzP/VMGxBIoYwPxrnrz8ZsCHjMuVOney0mDITueo3nEAK6V/X682vIK0Eb4mGABvKwDd+p5
 v22JMrhaKA2yutiSI6+vHGORZJa0RMyehaXklHcu+CdEeOIKAJw6TKYhOElBS/aeQ+9Qb73el8N
 XwaDe5DvE2+ntJNP28RCKKkFl1hNJNj+hIf94YBxCXAdT+MniWursl6BYBTDqBv4qfgWs08nyQw
 yr96JK8mtYwrIDncBR0XOpVcQKQy9rUfwjEpDcOQxikJbHBFy0E=
X-Authority-Analysis: v=2.4 cv=OdeVzxTY c=1 sm=1 tr=0 ts=68fb3a4e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=o8YoIOa_OKiR2ZH5ht8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12091
X-Proofpoint-ORIG-GUID: GoFMKc1ub7D9hokuS11Gm9zpEFDaQbpc
X-Rspam-User: 
X-Rspamd-Queue-Id: 934CAC0006
X-Rspamd-Server: rspam03
X-Stat-Signature: iwqfi8q77gp5imcaop97rxnas3h7t7co
X-HE-Tag: 1761294933-120160
X-HE-Meta: U2FsdGVkX19Dw69HFCHEzpoTMJOKA0ucW7Zx2qEyJBpp+00T54ZUF5lQ3E+dlhIF7C5cKMGo54NMDvV7FfLUjEDj9C2BQvnmdiDyAx1O/bxXbFFowC7E5tAEdZ8wVZCuiKHpKZeONYue/S1HAcHHFrc+dyUYvMyp2/p0N6NxW6VmXQxnzEHTllwFbAz/5DzH7sqcNlFskhR+X6fmeNoLL6HYBuPnVQoGcqt1UgdfIvb/pK2YoxW2A1++sbqY68CgOEYxNGB/vYGq/lYjhHrrT18rEM1xr5tWvmp6eK07suycp2OGOvt45KUngJdj0nb3l1nIYufqvg/bUw8mUh9MHx1O0cw/mQ6EPUOwpwDXLKwwyoZp5hZ/1zmi81/CohVCXsYwse6lymp3yLZcvQGtUpJzIhi+VOXSLVvZSPm8WEoDJ/YwcT4C8zfXG/s35X8/muTOMHrDunmO9V9WksDryF/nXhVVSpt0JexCNIl1S+nAguywdLV6JXG0v2OsNvVUGQl0HM+BhxhKxqiB/qFW+U1Hc8AuyHs+6XS6TvbzV7pegrMUhKeoGz/jWGIw5pPrXDCtKZJ2gqbiYKBlqzvDg/xOdU2+d6p7ncCqHQFVW4lilLG3gbqoIduB+ITN0SdUbQQ72G/NyF1YfA1lpi2ZXwqF45J7OiSOmbNurKnof4iDBCKP8ML3x1RcrXHDcMaTozrvbQUrtaOLgTgbXYMC8P+is3il7HHTfMXRTuuOMIpigafAphmTRYj5gu0BT47s/c2uXlxUw4m76OaU8esYyP1OD9LI8W7gVda4hNc84OOFItVXF2x9n3T94NpVKJE3lW3tfHwPNYSgiL5HVJO1iLx1dfCqAMVuQbalUYwIUMqODQVg85DKgJKjtqvLf1pOHa8UH9vwOmp5R55UuA2IAwV2oI/M9WvopN4TNe0vvLv7jCPAyIYuKe5CdwX9fBVpP6WYvNlqQMEy7Oc+hKx
 ZgaC3T7m
 Jxo+x1J32O36k9/Kfg7/idDFbOfAHwBevpMCw7hdWTGNn+Z8bdgejiUQfd6P3Gj2qdDCK9b4qITw9I/W1BlN8WpenNoCALkx0OrsSsdc63pU2te1wAacG+DEiqJtpAOo9JqF3bihMU3rXFic1c7SbFMQvHaAnT6aH4p9XIoaIzKduYjcFmRZ0tl8FJlRtOHcmmWYC8kHGohgjXxm2hjw/tyBRSK8aM0qe9ToDDwsQsoeW9nOWu/d3Tf23xCK8MWYVEOtAVRIKol7YZRWb8yM2k0Y7JSMI2FRAMe1qfsfFEDYkKJCzBFTa2Nr7tSI6O9ckr16AFyX+eZ4qA8PnE/U7kybZBfrEx1rYc1Jr4H+7PWw6lexP0wpJH7PMxm0lir57DyAzhh/DTJX/EM6a7FFNjkM6o6+lLh7zek8Mv5BHBh/9bV9+EPJINcBGQ1HV+rPSKoqp48t/eDZ5BcPUUq2H6rJDA6fXJb1DbquXirUqtrv12IPeWVyMahs5G4oOkN3jEI5z4fCjEQOwYhtvKLCNbvRmLTTyeTlOhlf7IBKBI+CgfW2s2hPp3ar0kjWF7WElz/fR2Yce9UeTnrHMi/g0cnfla4IG09AniuOsYeoUpHkLKFb5OSyrkW5BwNDCTZhQL8wsWZ8k6gnzNM0LxtgUqx7uL22UUyZvXpSufifhAD4UatdHjvABZ9Hw42Ah3SZJSPx6Go26yOwbEPXO7MB802QV9E5ohRPjDNA6iC/IiqdP078f1o0v2syVoh+Ik81+aIwbBXlDF4YhVlO0HtQuj+6Crg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 03:19:57AM +0200, Andrey Konovalov wrote:
> On Fri, Oct 24, 2025 at 2:41 AM Harry Yoo <harry.yoo@oracle.com> wrote:
> >
> > Adding more details on how I discovered this and why I care:
> >
> > I was developing a feature that uses unused bytes in s->size as the
> > slabobj_ext metadata. Unlike other metadata where slab disables KASAN
> > when accessing it, this should be unpoisoned to avoid adding complexity
> > and overhead when accessing it.
> 
> Generally, unpoisoining parts of slabs that should not be accessed by
> non-slab code is undesirable - this would prevent KASAN from detecting
> OOB accesses into that memory.
> 
> An alternative to unpoisoning or disabling KASAN could be to add
> helper functions annotated with __no_sanitize_address that do the
> required accesses. And make them inlined when KASAN is disabled to
> avoid the performance hit.

This sounds reasonable, let me try this instead of unpoisoning
metadata. Thanks.

> On a side note, you might also need to check whether SW_TAGS KASAN and
> KMSAN would be unhappy with your changes:
> 
> - When we do kasan_disable_current() or metadata_access_enable(), we
> also do kasan_reset_tag();
> - In metadata_access_enable(), we disable KMSAN as well.

Thanks for pointing this out!

Just to clarify, by calling kasan_reset_tag() we clear tag from the address
so that SW or HW tag based KASAN won't report access violation? (because
there is no valid tag in the address?)

-- 
Cheers,
Harry / Hyeonggon

