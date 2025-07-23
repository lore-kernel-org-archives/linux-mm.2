Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9021AC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 04:49:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 179696B0088; Wed, 23 Jul 2025 00:49:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 151866B0089; Wed, 23 Jul 2025 00:49:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0197F6B0099; Wed, 23 Jul 2025 00:49:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E44466B0088
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 00:49:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 866CA8039B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:49:15 +0000 (UTC)
X-FDA: 83694300270.16.FAF1EF6
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3AA511A0005
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:49:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ASZOmamh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Ytprlpeu;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753246152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j7mjHLU6Yvmnzok4wYU3L88pVKidK5O51T0kKh/nBRM=;
	b=liDXS9gJqt1y8yfBbz5jtEFrwJk7PypMKrsxxKLRxFdNKKRNkVLDseqcYsbdfC6EgO+Gcj
	tx6osTFd8jqlZ52WLwY/LaZll3xJD3O6WtdawU/losfgeP2Xlq1TwfV10xDHa1zuBrw/9V
	x4GjU4bp+GfL8GcnABs0U9s8nuJG3jM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753246152; a=rsa-sha256;
	cv=pass;
	b=vqKvONzx8zjkBHpEuVmidz34VQLkvbU0k3j2ZI2Mq2NKonUF+uWt5dBGk+Ku8H5QZ4NbgN
	Ba+zRbUPxx4+TxjEjqPZjTa31b2SRi1RAie+wYfUflLwJPYTR7MxqlJgOSArp5ZDWugFj2
	bS+CLZcdbC/h6N88LPp3eOqsIgcfSyY=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ASZOmamh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Ytprlpeu;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56MMQmKo021733;
	Wed, 23 Jul 2025 04:49:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=j7mjHLU6Yvmnzok4wYU3L88pVKidK5O51T0kKh/nBRM=; b=
	ASZOmamhqGt0bMgjtmIuDrkYbdk8nN/VfxXR79IymkIfCyAhoBBC+4HQyXKmmr1M
	DzYcj7TPv6iDXHyN6FReRG01Ne26F+FxPydx0DQs2tr0yPwGKIFqp2AJYb93U4r3
	TGZuVb5gPvqGUNJG+oh1kZDkRCdk9ob359FQBQWzDKJukV3eNfXJxUsxtsWrOdrR
	Ex5GPDA0HK1DdoBqxz77G1SVLfXANlZZBOCD/K8eOqaQ1agp4VX3bAjiUKobmrZz
	k5Qoza4scxkCrf1USgxOUhduErlxsPwSLyjuc69Fi1UzIron0SJKvE33VaKML2Js
	Rm7MZLCiczrhlvrrqMgWQQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 482cwhs74y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 04:49:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56N4XQBR010475;
	Wed, 23 Jul 2025 04:49:04 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2050.outbound.protection.outlook.com [40.107.220.50])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801ta4t8m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 04:49:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NxqMI3OxuO0xsFlFEOaBehmsp3L3KWGLLyYsnfkjwrfB6AvV8pey9wmkZpghJFCLzbES+FwYhid7/QdZWczxtURR38DtCHvMSbRXpvtuHMOmmhMX+iwrJutbKPLyY0Mb4heF17qChtEnfgps8lX4WrlBOXMOugmLRDABZWcRjICYA8N+9M22nogQsTlAY61/pGWSx+qvMwtWDdHfek7vLwRCDGmrKCb+UzrtwzzG4Lg1uG439R3uX+ez/5k2ujaw39w7Ppn9KgQHKGKihTdHfwMOB3lGVszmIZWRNOh/5UBiV+7wtjoNYkd2hebvIylVkT1wVl2jmwb+yNNG6vjEpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j7mjHLU6Yvmnzok4wYU3L88pVKidK5O51T0kKh/nBRM=;
 b=ne7Kwmnx5y/w+H95XiHav3f9l6YOUTuRlpFmCWPHKa+tMgXseBcAKR2WAfuUPUpWRWN9saWXHp9xHqWy1J7GETYEjDZ4ZVi3E5El3ggbHXYVk4r1/jmqGCRbDGitdhj2KxtOeZ8ccdPuPRqb/k03m24UqchpuEdI/FjXdaVVJXGl4OIgldIKACTCp+YhFWLd2oyBv7VBbsTCdDNGE6ZzCUWTjB4UZ83ijKikxFwNa8vvIRl3oyKPZ42s1N2SJNx8ZyOeHHPAHXKjwr/ejmJ248FXjkf9sKMIao4B37fBBjQA7o08hg59gkd5hutyIJIJDdm2kwWob0RSaqDtTa4URw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j7mjHLU6Yvmnzok4wYU3L88pVKidK5O51T0kKh/nBRM=;
 b=YtprlpeuPtT4X8HTdcOzYxq0bUeUTiUz9XuMK3lbzLW9UBEhO8ITBtpouoDiGT5U+gxj3TVriqUmuM7RIpQO8lzgOfGeBjsQrYGi/lWh5I99br43IJcmwcGVcyIWOpraMKyopbvl5KFTOT44O1Vlz4jXZXzDiW6HUjHlE4DB/tw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB8030.namprd10.prod.outlook.com (2603:10b6:8:1f7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Wed, 23 Jul
 2025 04:49:02 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%4]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 04:49:02 +0000
Date: Wed, 23 Jul 2025 05:48:58 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: add missing mm_slot.h file THP section
Message-ID: <0712de1f-6a45-42de-ad3e-2522dd437737@lucifer.local>
References: <20250722171904.142306-1-lorenzo.stoakes@oracle.com>
 <CAA1CXcBY4rFLkNqJM2Dj-EajPw9TMTHNcYapw9P=U0bo=QNqkw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1CXcBY4rFLkNqJM2Dj-EajPw9TMTHNcYapw9P=U0bo=QNqkw@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0639.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB8030:EE_
X-MS-Office365-Filtering-Correlation-Id: fdf51fe2-9cb7-4869-1264-08ddc9a43eea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ckFDamhpWktKeU9ndEIyRjM2Vy9JVXg0allVN09Vc2FhL3AxdHBHM0xJdTFD?=
 =?utf-8?B?VU5ZOW93M0NWTnkzY3Q5ZG85RUhiWm1xVnBNSDJxS2xKRWEvY2VmL3JtK3hI?=
 =?utf-8?B?VWJVRC9oT0FhZk9SVlBUeFZuRm9PNnVIdTY3bmhwQjF0Z0ZZOEdWWFVxUnZs?=
 =?utf-8?B?ajRzdGpKWnEwRjZ4L2JkeEJ5Q2hHRkVSNUhLejl0RUlMb1lKZVZPRXc2Y3Q1?=
 =?utf-8?B?cFJodHpKUUN6RU5KWUtrS3UwMWlYK3BBY3lpb094allEZXArWXl4VG0zYlB5?=
 =?utf-8?B?djdNZ1ppeW9yWlVIUU5hcjNKL25FZDZQK1dWRmZkZXBCY1VBbTBtS1dXUjZT?=
 =?utf-8?B?aElFbTA1Rmk2V0NPR3JIeXphQVRIZEdNZGZhN2djZk9TbnpSVlJFZWU3ODZr?=
 =?utf-8?B?UDlBaGtUOVFVdFkyallTaEx4UnFPSi94aHZqRWRZRDNYYlY0OXdUU2RSSHY1?=
 =?utf-8?B?ZVdqdXdUVERscU93WGlLMUwvOW1sRHpucGxMN0ZsOWZBYWp3MWoxZnVNTnRp?=
 =?utf-8?B?Qnl5c01reTlRMWhVczhaVGI3MHk2dUlac2VXcndmREd0anZzaGJIYnM3VTNm?=
 =?utf-8?B?QXFYeWZOOURCQ3BpY3c2eTFLa0xGR09DT1MxbVZxTTNqWDNlSU41WkVFUTJ4?=
 =?utf-8?B?UzloSTFLOVJRRWdMR0pYanVrRTlDTzVvZnFWRFhDY3pPRnZFNmExeHZaOVI5?=
 =?utf-8?B?cW5UWlZ5MVVGZDNzN09PYTNNaE9HU09DQ3NjODNYUDNONUM3bXlKU1JKWGtQ?=
 =?utf-8?B?WVEyazM3eHNZbzhySXZ6WndDOHRrUUM0Qk9iRkVPblFXZWJXWXQ1ZUtDditW?=
 =?utf-8?B?QkI1dnBDZnBSK2NNcE9SWTQ1QTNWNmNpM0Q5WEN1cnZYVGltaHd1bEdTSmZJ?=
 =?utf-8?B?MHJwVkNCcGtlNEZERUNndSsvZDIzTXFpN3RlSmQ2MHoxTGYxVkNxaGNlQ1Z1?=
 =?utf-8?B?ak16RmM0Z1BCM3h2Skl1Sk5oY0NzN2pkRDNzQTlkeExvWlArMVN4OHBzTmMy?=
 =?utf-8?B?bDNBNmNMV3ltdEt2M0I0dkdLUDhnM0loaGliMFVJU29wY1NoZjgzdFEvakM4?=
 =?utf-8?B?MFpWNHJ5TUJ3SzJsNnE5MDN5Nmg4a1dyRVVuUUNiWmFSRElWY3F0VW1nZDJr?=
 =?utf-8?B?Z0VxNWU5M1h3ZWFoamtSTWFweHUvVUd5K3BkQ0tZSk03OGxMamNJYlo0dyth?=
 =?utf-8?B?UHpoZkQxQitwZVRlNmlMeDdNc3M5SGJBVHNBQXdDSWlDeitaKzF1ZmdGNGhN?=
 =?utf-8?B?aHF0WEVGc05pK3MxTUI0OENSSUU3TFVLemxGdlNTSHVhS3lCR2d5b1Z1Vzl3?=
 =?utf-8?B?Q3NGZGVaaUhpRkk1WHRDNkZnbXoyZzBhSkZDVVNUVzB3VmNlT05STFB6Rkg4?=
 =?utf-8?B?aFFVNS9Ldm04WkNXVXF5SXpQd243a2lQUEVZVC9Ud2RsK2lQakdqMU01a0Jz?=
 =?utf-8?B?ZmNTUU00NzlEdFJJblFLL0hMNHFNL2xWR0J4RTY2cnJvUXhKbUljVkVQVGJL?=
 =?utf-8?B?bWdTRTM1NXVta2NvZ0RLcjZ2NVhVMDRxRHFCdmpKb3JNcy94b2RsVUhhWDM2?=
 =?utf-8?B?S29kaVBQRjAvY21oTkZld0JDVnJsMUR3Nm1aV0dYT2YyMFRtbzJ0OFZVbFZB?=
 =?utf-8?B?QmxlcmpJYWJwQ2U4TVhEUS9Sais4dGtRZ0p6SGZTTHhoWDEvYVlIbC9oRTF0?=
 =?utf-8?B?cWRCNFJkVTd4aUdCVW5vaHNxeEdQSDBTdUJBbWFleXlCTDJiSE51VzJsQXh4?=
 =?utf-8?B?ZU5SeEhrVytSNHlmekFYR2JETGpIR3gwUmFLeXdUbE5pV2lHdXJsK251TVJX?=
 =?utf-8?B?aDhNeXJaVkpFYnA2VVVQL0gwSkNieTgwQzdQN0d2WmlJZ1M2eHphaU0vclBF?=
 =?utf-8?B?d1VqR2kzOGZaNk1PYmNpT2U4UGpXRi9FWWdaamlOcUVkNFlNa1ZvVzJFZnVO?=
 =?utf-8?Q?BphSlB3A4YA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUNiV3RDOXZRYUVHbCtYZG1QWVRwMEVPRG9XY2JCL3d5Qk5KTzVtK0tyNlpq?=
 =?utf-8?B?RGVoMkJoYlJDa1NNaG5tSkI0VjZWMnV2VWErU21RL1Q2MVlPRGg2WWJLNTMy?=
 =?utf-8?B?a3o2cXZwR0NuTGJTSEpLbEVqWGRSa0YxWTI0WjR3WEdPRzEwRHNmVVVOdSti?=
 =?utf-8?B?bmZiZDBYSDA5ZVUydG10SktqQ1oxOXNWN1VzbzFVSCtkM3hTK2NhWUNyRkdp?=
 =?utf-8?B?NDNqZlYyVVptejRIMjJzN2piaWJKV21keUgxUDRFeXp3TXQ3V0pCRnhMZDg0?=
 =?utf-8?B?aEloOVdnWHFxUGJkei9UdjRiMGJNbnlQMFlBaThJKy9taDB1a1dVdjFkMWhk?=
 =?utf-8?B?YUg4VkhJT1BqN1RDZmZHSHJ5TVNFODhOVHhmcFRpMGhoK2pDNHdJcXdibCtT?=
 =?utf-8?B?UmNRb040OXdzYnUvQmxtbEprYlVuSHpjYmdSWWphb2k1Y21uMzFwSlJna2Y3?=
 =?utf-8?B?YmU2NDZQcXFqeG1VMnBmR0pETG1Mc0pheDl6Q0t3amlFRkRZRTBhUDJXai8w?=
 =?utf-8?B?VW9TWUhZUzk4Um8zbk9xLzlYUTBZcHNFeUtzNHVFeFkyVVpUcit3RFFZd2ZJ?=
 =?utf-8?B?QU5VaWJDZXZCekgrOVYzclFaM2hsNDRsSGZsL2dHeDVJbzQvSWx6cUxYbXZT?=
 =?utf-8?B?K0hGV0Vld0c0T0llaDFnTXF4d0R2VGgxWVkzeThPWlZZRzFuRkJwYnlVOENC?=
 =?utf-8?B?S0hSZm8rMFUvSUVCa3lZc0tsTjJYM21qdTZCd3pESi9keUNKZVoyS1ZQRnVm?=
 =?utf-8?B?THVLN2R6MDVrWm5kT2cvYk1zMmZSR2xvNDYxeXptd0tsQUltQUJ2OUE5YlBu?=
 =?utf-8?B?aFNjdU85ZXVkTGROQm80TndocDhLMlNUUjFjd1VVVlRXMWZYQ1ZiWnYxelJR?=
 =?utf-8?B?KzNVQWpLK3NKdllmTG4ybDRlMHo4UEFTaUZ1ZEJZWGQ1Ky9VM1hSVU9vSS9N?=
 =?utf-8?B?Wk43N2RwYk16eGNGeXFxTEVReHBwMTJPazFhOXVDeVJpOFZsNmdHYXlyb2Va?=
 =?utf-8?B?MGRtdE5JMHBLMGhLWnIwbWp4cHREZ2FZRjdrSUpDMXVWZ2pSQzBYTjM1WjFX?=
 =?utf-8?B?ZlFvaStmeUtoWTFEZ1FuVnZzTDF1U1pTbStrVVdmT3ZvWFprc1hXLzVCZWky?=
 =?utf-8?B?eVRlQ2hCbEE3Q0pieUx6MVNTeFc2T2dJSjVDcDZTRlYyb3NhOVNENk1nMy8z?=
 =?utf-8?B?azFvWDFoWURaVjVrK1dDaGpTN1V3NnFYMDFBQSthUjBFeE9RWFdmR3VWOHBO?=
 =?utf-8?B?YkYyMTlrbkpqZUIrMXMxWUc0QTRRUnNuTm9aNm9XV2h1MHN3c29LOVl3YUdZ?=
 =?utf-8?B?TkNsY21sdFJUMjRuSWp3VUZMLzArcDg5TEZLaU9MMHV3ZjhLWVV0OWNNQzNu?=
 =?utf-8?B?VE5CVmtGRER6MUc1b1VxSllvWFArR3FXbGIyNVZxazJ1US9vMUhOTktZQWQw?=
 =?utf-8?B?Nm9rS2x0QVBFSHM2NmV3WkdYL1VEUlhiTnJWeU5hQng5aXR4N0kyR0Z5b3dv?=
 =?utf-8?B?Mis2S2F4RzgrUnRFeDJzdHdTSmR0Nmw0N0Zrbi92eVl5VEJMWjU1ekR5aWtu?=
 =?utf-8?B?ejhnV1UvTk5GRHlIT2tMZk5PczdqNkVPc2crNXpmdmVidEM0Vm1Cdy9QaUJv?=
 =?utf-8?B?Um9DeUF2K2FqSHpyN244djdWLzYxTk95cE40Zy9Xc1RSbkk3dktOSzR6UHdP?=
 =?utf-8?B?cmlKR3BJc2JRREFmbWxxWTVCcFN3YS9neFZDM0czVXk2cndxVENiTFhvdnRn?=
 =?utf-8?B?Vk0rMVBGTFBrMFV6SVlGNUQyS3licXhreXJ2WlY4M2FUZXM2eVZZZzJsZ1Fo?=
 =?utf-8?B?YmdYRWxnTXA2Wko2TEhVTWtjZW5QMittcUxzZ0U4dVBEazR6Q2JtZ1NjWjBm?=
 =?utf-8?B?QUIzcWFrZHZ2YUFyeEEyVXpKMVg4ZHlQZUxXNU5PR0V3cGhDbk5pKzAzcS96?=
 =?utf-8?B?TVR1ZjFaclVBazYzQlZpSFNPbHU2eHRpT2haakRDQkJ5SVVKdi9jSXFxTmxx?=
 =?utf-8?B?dktsSU0wQ3FMYndrWi9ITVFHQS9rL1J5K1ZVV2pUVDgwTmN0NnZuTWtxb08r?=
 =?utf-8?B?NGk1YzNqeU51aE9QVXBRYlBLV1NCbmtyVGppUGo3RWZ5dWVHQUpVVks0d2py?=
 =?utf-8?B?Tk81Y1ova1BJd1lFNW90Y28rRndhU2JBQWJRQUFqckxnNnhxcEVDWkhBcklG?=
 =?utf-8?B?ZVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	l+ca7KrtPPQ5ErJYTTYrIRpoXv74JlWyxiOw/6EYW6I18y5x/gi/7w3hY1PcgNaDkvrCwYNuARtuJcXAOombxqaSMFY4Q7YyfGzGoarArPwsz7cLxOHtv1Uu8TsAyG9EKJ75/fP5tOdF+0WBmIkFjCS0AcMi1Jp1IN2FgW0Rmn75facKrJE6SQAxP7UuJ37gWxQ7kbnr5iQeaESPT1GDxHYNYI0LGW4Xb1glfqZ3YgldyA128SDJm8nmvBKla41XMjye/pE4evDa0L+VYYqXI2U+KRdanPg2vva3yF8kjuEA3y/XMNoJMjZ/LoS+GsE4ts/kDYmeH0f7hLtd7Qx+URmMef7fvLmqaiMAOueXErxxBu0u4cpyYgOCtIPYEtAfbvrkdLL/CzEjbTqGaKBwF1gKQCBL9gyENJlv8tDqUEI8W2m37WbzyOY3zfxJtf0wPlDYCSBMlGIPP9I2ansKMTNhPpuT14+eyi+B+9cayyjvkKBafgRUpeT2zhItpxjiiW8KDdWcUf7SP1NAHq6ZXK68NbwI9Q2OWie/wtn482Faik+qZiezKsQwx3fzbGeEUvsiRN9uZKXnDT3duIYKdRaQPUvjPymH1pKSH/92eUA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdf51fe2-9cb7-4869-1264-08ddc9a43eea
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 04:49:02.4395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0zVqsq8cYUyDKMsv+QsyFtjiR59T3d6tRFzkc4T/X2jahp7QGzlEh8TOP3eYPxLdwIB2kR7ekeT+hOXZqbgXAAHBvhaDrmZDlYmqdNYuJEM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8030
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_01,2025-07-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507230038
X-Proofpoint-GUID: m4rfa3SoE-NLWgogg_sKsiC0L08LCdJV
X-Proofpoint-ORIG-GUID: m4rfa3SoE-NLWgogg_sKsiC0L08LCdJV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDAzNyBTYWx0ZWRfX5d2gbxLtB83p
 xcrV3GGPyYpoGdKWd1ruCQWpzmRZL+wRvIfFZ3GgWdYOGIuh0ulcds6D1CX66sMzzP9Xb1Cc0QB
 7T8fe1Juwc3yB64BVgn4yA939cFYVT3613Ln2C73g0w9Ooj+CfEuQVvJUlCOdfsYphS15zbJwbF
 0LabjEcJ2N2vTen4pMjUgXMBforwKn7CTSnQi/UmF8u0ZO+PCuXjXJVGZu+rfDn6Dqa4p2IH8FW
 K/7223na/ygjM/cdHDX1QcgVuDQ7/rZwWgYhhcIvQrV/MYt1+x7D2tfEhESQ2Yel/Ck8eSz2swf
 tqp607JtObGMsHfyo+v1NZd21lqE2lOKNI0eb4iGv8g0PiW4rmzh51fQsNbcMiwu5DcmIzb5vWK
 A19XTKBMz1/doZjLF0ZXhonRmlAvFvRR+vN55x81cISbHA15d6iT9VmctGfYhEluus2WrUh6
X-Authority-Analysis: v=2.4 cv=IPoCChvG c=1 sm=1 tr=0 ts=688069c1 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=LsFlvV74n0Hn42QnFawA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Stat-Signature: idcw554hb16x8xsuwqtfgdd3qu4kipyn
X-Rspamd-Queue-Id: 3AA511A0005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753246152-583760
X-HE-Meta: U2FsdGVkX192U5CdmmwzbuslM/Qu+/PvNSpFSymVQIJFrkndS0LwqSwLJPFqb7L/5s6xwvjaYimJ1kCM2PVN6mrNFZ//1XBAjNdI2mWvnNOWXOKqLC3NBRj+c81bescwqa0Gxc+PkU9686vZFdl4bgU3mZrZWXQzW3hgLxagEdSpBWY/v4xlbsIOMTUwO/fbGFnKQO9jPNffoEHSPsiTnN1WhEN7P3Kfog5kStWi40bgz/vxdnXq02Cfa67V/2S/c/nK/KQga3lZKK+Y8adzQCln6T8u3bY2HERqE24sI5sOCSy+xLEGaYRPri+xvubddg0+l7kMUyM7Gg19VoWnTORvipUd5V0QzUr0ohA8NqY8ti1+h8EE9KWhLtHXk9wgosF1NQYiLCfmapTKl3GLbk6QNyuy5cwYL5NMoOUtDMOc+4ViN9R0pDiSx7KqBNX6dYS+T1SdSAhfyOPgW3PjfFkC1mjZHbq+EEJwDgdEKVbhxQGjkgM/l0etkRfF9Dym4rj0jrRI/k/gA7HmpFhqq7N5ogqBD1Er4MvQfBU0QOSzEttl393svHRaBybwZKhdlgS8tZtePhf1bi6tIkYxD/7x86/srpOFoZoB++ClvWnv6Ac6bLvcNA3KXQKr9LtuQ/mqtJ3LJ2aWXSf6PgdBYufa877Oubrrb01bPuyW7yij9eDM7wx/PXDgScvyfULFICSVPr9D46nfOoiYDmO0TvRRan0fPniYzJQl0bO/XTzhYDrVb/QrGVDeGnEJW4iQPNYwQF+2nNGN61xsOndeQs5GKQdQS01eNXnfMdGAkT+2akRkWc2LUbTmfDr8gZ6S9rh2LzGwd13yy2zjcZOmYz22BvNoS2SDKHWCLAdhChfQPydhVkW9IMRRGspiTB1MQS8p6g16xr3wqMiawMVgB1PIyBx5YcAFOCwDqNcPz3cnlrSZsmyfVxpTLIafYN7QZ+ZGjsmQjveETxTgvzR
 g6In1itM
 pVnIb8SdaAPCSyNTVuIlGpH/heRHHLa+BhAb7+8BAPfXVI5KvDEm4wjgNkYLJgwnGfQ1xmu4Vh7xWGlDoSBDzYgoW4IuKxri3zdHo69owj0i1xL3SLQbxIrxnDrS2MRwz2eD8+ngWfHWwSpIlESJxc2KP7xz+I8LGk5jBYXd51jNuYtMAqH5dIdAQhb60DHz0832aKtCY3ly1ybwBKEW8b7Fx4NJBv9JgU4Q73mI/Vd1cH0/2fdPaPslpQ9kqGZyOdzlvKlBNRyV7FFXvjtCtReX4kHQfQSq0r1FRmvlkPfJg1DQgk1Yk/wIvFieRppT8+61wD4hzLpkurBRSjPM5xa8lZBROVWQmwYsErohxeK6Q4NUFccdAh3o77r5r5oT5lK3oQKaxUXM0CF4s8a7x1XmuMdzmYMWx2T5MAo4smEDuiIUvKMenqQemjNBqTa9UGTasmDkXPgJ1Ef0GLK5czcyCnhzi/Yv6ROjEI+TUFMar9kTlTpvwfEGRnIbAs0rdreFU31PDmZWVzx5GN8+8Xje4G2M8bbFSeeIRJXWGctWxZHSHzvRhNI2T5/IfRRtVs/JQamOrVQgGcKiteTUfBxzX58Pl7OgPMWbhxArREFtE4k0bvJDU3MPGhfCwav7S7293uUEQg1uzbFK3toTtHiY41UqGGLu39Lp0CsO0GOBWcHn8HRcYtEUb10pl26i71bylvTS0jmGa2J0+mIeKIsDZ8QGbGl4UPCybX+VGGyEoprGXZnuAa77V6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 11:43:04AM -0600, Nico Pache wrote:
> On Tue, Jul 22, 2025 at 11:19 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > This seems to be the most appropriate place for this file.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
> >  MAINTAINERS | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 837bc5cd6166..3f83fb317f51 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -15966,6 +15966,7 @@ F:      include/linux/khugepaged.h
> >  F:     include/trace/events/huge_memory.h
> >  F:     mm/huge_memory.c
> >  F:     mm/khugepaged.c
> > +F:     mm/mm_slot.h
> >  F:     tools/testing/selftests/mm/khugepaged.c
> >  F:     tools/testing/selftests/mm/split_huge_page_test.c
> >  F:     tools/testing/selftests/mm/transhuge-stress.c
> > --
> > 2.50.1
> It might also be worth adding it to the KSM section since both of them
> utilize it.

Good idea, will send a fix-patch to do so!

>
> Acked-by: Nico Pache <npache@redhat.com>

Thanks!

