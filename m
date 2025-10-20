Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 734CBCCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 13:53:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D35EE8E000E; Mon, 20 Oct 2025 09:53:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0D218E0002; Mon, 20 Oct 2025 09:53:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD4F18E000E; Mon, 20 Oct 2025 09:53:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A66788E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:53:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 51D781A0156
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:53:44 +0000 (UTC)
X-FDA: 84018635568.23.58AF477
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 394BC180005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:53:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=i6tJHcSn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iu8RRxal;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760968421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=alUf3wuhRl4j8k/+tTMDuCOOn3TW5BSIf3662csJvbM=;
	b=w1xzX3sVrqAhcoetr8UgeA3RVCZtxNX2Dsimi3gEqsDhGqfBg7FU8zz8kkUG7r9oFTUo7M
	VEMZTM+P5T9hZF+/riMdCwiJjMlMUe1l6YE+1Mck1zB+TF1xyx7LDA46aeScQ+/pYMD8w9
	IS3KbgJY+WHhWnWO0uWIOM7stLl74fU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760968421; a=rsa-sha256;
	cv=pass;
	b=p2+qlennJ/GXfW/FvbHbFD4cenTeUVaH+nw8YEh5imkBGsKNOq3KhNyfovm5Mpn8SXYdc+
	l7E0wUaPG02BnzmP9ljToS3+laH1IP4wo+w4gIoTrENfWemXQ6iK/jVuWzE0Dwb+KhEsGB
	e/bNrUnzuNFOlM3JBMR/hPS4YH5su8M=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=i6tJHcSn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iu8RRxal;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59K8Rpse027572;
	Mon, 20 Oct 2025 13:53:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=alUf3wuhRl4j8k/+tT
	MDuCOOn3TW5BSIf3662csJvbM=; b=i6tJHcSnvMbjbOhINvfEoAGveKNjteTLQK
	vJot6szlBivtGBCNk0I2sSnX4xQKEt36bpZHbo2vLXnyYGPUxW4o2YmHl+mIy0G0
	ivWgZEYgjGOh6xc4B1wKPTOM5MhAIVnvrMKwIHiSybvQd7HdhJTy7NbAEtg9zMVu
	66mTCcEfo7wFwNuPW1DDtf7ZFX6DieL6Y5sPQfHscunze7ZhYAEjI2JUmU0p8EFK
	rbOu7SmAo/otz3qij4jxfIlMJAyZQyketHYpf522D+ewIr4B225aw6G+BqDvT2uo
	SFMAED1Md3D+Ylsf3lFAChVAFan1FZx2aY9d8/IS77mREhMuwYWA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2yptbu4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 13:53:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59KD9Zar009376;
	Mon, 20 Oct 2025 13:53:34 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013053.outbound.protection.outlook.com [40.93.196.53])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bby5ds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 13:53:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iSBg6C8LoptCB/oXDmzcd9VC271wabHeB+9mgDvhbd5q+sSVqEe5i3ZF4hxrbXUV1oyRhNVM4/p0j/DrEcUZeesW0LbVj4XPvfkTxj8ZZr1YSULSGcoIWwTL8Ee21E0RXgZ7NwE7ncFTy/aTnUkigyFu6x1iLHxCv6YiCxGg+qZ0of3GHuIfHfstoDgt1gj1W8MZpTstTa/95RQ1b5643SYFeuviWuu7Ke86sfz0ieO2R+R0GhO1M/zpp0WgqpQFLn4tGwktrbNs+CLMuIcOKVptfXwX0uCWHkEKdq2O+xby5AP8uB/XzexPr+xk3CyQkl7gaUQ1e1tKbpX6TWsMjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=alUf3wuhRl4j8k/+tTMDuCOOn3TW5BSIf3662csJvbM=;
 b=V8ra/dGu20xsIEedcXEn+sm0/j3hDdLPqmDiy7whUhOw77bbMfkawGAhc3uRCjY1/BPohOiDIWB0wYF/lhx7bMfXUjXgykIIazL4kkaxO5u5W7ZoL3Krkh3wrRNB1Um1XZFeH46S6cEcj1gg0HO8UISpRphe8ebxUOtJpq8zPVdfwkFXQCJLOj4nqHsmMq9kcq+Al1UKnlIvyfCSAb6o04ptNdyRh7OqZbCi5Sd/ZV0q2dpdmSfTOeh5lNzAjsvaTTO06UE+LFVce10MtcvK+W17+ywbUoSCXEn7kcmxWAbxS0xaPKBow8tRwwkMmxuNYSsMVo7NVhmPd9xwR0Zabw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=alUf3wuhRl4j8k/+tTMDuCOOn3TW5BSIf3662csJvbM=;
 b=iu8RRxalJB+v8NPeVV+T98NCOW9NtJSWGVVMCmGHIlEnlpv3elvPI83fu3TLbhHmK0V6mte48WPQhqfy1jIBifFf9cCf4ImPaXftMhL7jMmFTg+4lj73DFBkDQpKhQ6HueAEI74E6ayL/920Mw84x+qM8pv0LAJOKynm7K8IsTY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BLAPR10MB4962.namprd10.prod.outlook.com (2603:10b6:208:327::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Mon, 20 Oct
 2025 13:53:31 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 13:53:31 +0000
Date: Mon, 20 Oct 2025 14:53:28 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Leon Hwang <leon.hwang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-new 1/1] mm/khugepaged: Factor out common logic in
 [scan,alloc]_sleep_millisecs_store()
Message-ID: <7d9b4ac6-b0c2-4a0e-bee1-23f7a82eea72@lucifer.local>
References: <20251020115350.8175-1-leon.hwang@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020115350.8175-1-leon.hwang@linux.dev>
X-ClientProxiedBy: LO4P123CA0630.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:294::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BLAPR10MB4962:EE_
X-MS-Office365-Filtering-Correlation-Id: 0209f237-866f-4eb6-ee36-08de0fe00de6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?f8EYULL/J/DpmTogDmgdDUfSqkQ0CoplmCg+wTE2AycO04zVSVC2clrDkW2I?=
 =?us-ascii?Q?KyaP8AmgQI6V/qhyZnfucyIM1X5I2ZxygNIS08q3gmhrxKVZzpg5ClEKMx9J?=
 =?us-ascii?Q?dqzrRKcCsmmTV4t/kRCIvtQiPnLuFf8dSKFGlOduHc3WmctPMS1SDCNuj+wP?=
 =?us-ascii?Q?zFY6Or9ELV9NYMtb0jcETDGyqahfly/DqSoAiuLdeBKSdOlYKIhmgh4kQYkm?=
 =?us-ascii?Q?RzRiZNftjwqzh/a8JaMIDJm030mjcctql+4k0+68/Z0SsaBddBzvW/zOlOmo?=
 =?us-ascii?Q?1Y7OEQFuBUnU72WkbrO7kDCWF6MmO+oCyhFsncJ1z4wUFznaR0UlO1ExQy1c?=
 =?us-ascii?Q?A5o9qRTQ4HbBXZ4rrh/kgV1S77plhw/WgSh7y/uiTFog1Kx+N+6zy+t7meYo?=
 =?us-ascii?Q?BS4eAVMrrIP09Jbo/vyeYZGt+0ABstyuxRr/qBX+rgCJJl1JMxtn/zPl9vk4?=
 =?us-ascii?Q?Ggsy7HDHGhy368NVGA7GjM3DE+duIZNlRWxdmsVWgOZ2vkm9IQHVJfKJs4gT?=
 =?us-ascii?Q?h8e7DSbEX7NTsTp4eeyt4qnm6YVvvIKDWmhFQ7esloqA/uUcck6PKB8+pZ9z?=
 =?us-ascii?Q?k6UdTwWEeiPAkOCjex4eRrBV6ckFRaF5VSqGapE1iOuMqxu4e0G1YhNTtZLm?=
 =?us-ascii?Q?EGTEOpvXinJ+zQFhbcI9J8qQY4ynx3Qtx5p5DicIvgQIfW9vmL7kPl1/RcFs?=
 =?us-ascii?Q?dcykhAYVhtEYO/3+gX1r3PDooHoEiQwAyk2Tkuvt+vIDv/rEYTp0VKpEcLOz?=
 =?us-ascii?Q?4CvLtW0JGIV12JKrLOwzBR5owLt+b4X3W4cp3zolIgkwjgx973nVXRpoGvO2?=
 =?us-ascii?Q?/Asg1e4qQHh8+dYaRMFoWyrhrxkGEkGz8EzrSxqg0n9vr7mvnjpWUSd0/bhl?=
 =?us-ascii?Q?XDV2dJx15liUEoJnCkdW/d1BgcdxDeRjnucFvy09bNJn+3Ndv46NZoY62QIG?=
 =?us-ascii?Q?jpNozh3t2dZjc8ghOjnKfAthkSIDHKTjxJt6BnxZK4h7ZXT+DP2m3sv+2bgn?=
 =?us-ascii?Q?KaGh952P7XxHJxOsMUb8mF06prphiUOLBreKqvl2CAnGR3fGeWkXM89uZWSt?=
 =?us-ascii?Q?UtZKRJxPTgV0gqw5Kke14LJ0IFGRvl/Hrfb1glEz0WBVROXUsbypWtmXtcd3?=
 =?us-ascii?Q?yvGKaqvuKCg0KPNQpiZRrqv1tIY/KwxVWAN1Xld3E+HKI0tmE7zjPdt4yMko?=
 =?us-ascii?Q?+aECIewIw7gnEhJ2w6x58aMnQvLIk1PM7fo+pWUbODUYEZmHK5RnFy92RuTY?=
 =?us-ascii?Q?TtndabfhEjylGiVng3oQWcjQ80XozZv0kqlWizn8QHfbqHxmgfgHhjOPz1Yl?=
 =?us-ascii?Q?NOgy1zoyEm7suYwUpu1hGXVvmHokfu8eS5+6H/3tTuoBYYaGDKkobddpViuP?=
 =?us-ascii?Q?p3ynN3WYSk5f+MvfHXNOP4rz/xwFLqXiwbtt6LUGCieNDKavwy9DujDVJT4C?=
 =?us-ascii?Q?hnr+e74GhSGul5JxqI5giDWXJ3Aixc7g?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5iUU1gYPkSyFwwCdeOsKKynQKu4upfHp5uppVbFnLBIz1WhAnsLomw8GjnIM?=
 =?us-ascii?Q?Czv6hDMVOg4ZJ+eRtxE1zoaVQAQ6YUhNPpbUfXVHmRUeXlqCPpRdPe5Sv6r5?=
 =?us-ascii?Q?a5eFsJB0ovIO80z06Ax8EOC25Cx7OsWirOfjYYgRNSze0rPsJq0K9APo8J4T?=
 =?us-ascii?Q?26RZJeooTrK5OxauvP3RqKoAjVj3dYWLvIRv/2iHBxBmC4/Aa6TfncjdMrFU?=
 =?us-ascii?Q?K75OuzkfGfPWhCGuzupIXNRFHVUj/bdJ0Qg6oJsPfbs4nszYXIdBJRdo3r8Z?=
 =?us-ascii?Q?+N2mjZds0g6I1NM/mA+ref+lxTZy7mD5BXJrSa2bUSKlEStaH2PkIo5FO2UJ?=
 =?us-ascii?Q?AZuFA01t6vB6LvV8SkIS+mVpQULlvlrtB7T3iUsNs9HeNG0n4C3QldwOICy9?=
 =?us-ascii?Q?kqmBz0Mx85VY0FsTdTxXy543LAJ4/3diqv7a1fIKazMox64XYfttV1x2Gg7d?=
 =?us-ascii?Q?VNZYfvGuCbpIj0j/gblhSKgtzcFAnfr9BM2NOKXbmXG8FvMpvJM7Imy9saEc?=
 =?us-ascii?Q?nCw7pJd3btCC/xykamt7peLMpBPCVSA/XlbHtY0qDydOKbXENduKhrFbbNuf?=
 =?us-ascii?Q?0kbHEG6GKlxNWEUwRPWQ2KrfL3lVTQ87Mch/A9FIgRGX4Zc9An3jayNR9K5r?=
 =?us-ascii?Q?bW0PZuMPyWyzl07uJKjB30qTmDeV8brYx9m2HX3YXsbZcd/3pRbse/uPfwWW?=
 =?us-ascii?Q?24S8E5WdEXbQgjUOar4AaNRyyHQ39KdlgRoYwnftYRirx38l/0jnhj+goSdQ?=
 =?us-ascii?Q?YOqExcijL419YxVtfDq3wA+WER1JdwaBOgzWWqJBCFg7wBBg0shDTJSOBw8X?=
 =?us-ascii?Q?ZLNkjOzUhJwZjX8+9EZ4izzNWLELwKkvQNtZCHoLUatwnfVKRJxq1N58GYuN?=
 =?us-ascii?Q?6hpc1kBadL18CY7+uU3JvrXJc9G1n7tTa4Xnx1I6AYwVCpSFQsVm3v3RSrtI?=
 =?us-ascii?Q?zVE8SLskie4NX8a/jSlx6Acn8yTP0p6R+mibWcIBOSaZVZfwKv2Qvevh4NB7?=
 =?us-ascii?Q?/GmiSITbeSHZUnqb8aHKU0ER6JAp6iULDlZSK0Mc1aQwBiNRpOv+clovqbs1?=
 =?us-ascii?Q?KqB2ROgqY3sHtesNRvPezmkHzgOVVRoKhUAF8NnF0osdLp1oliL/R7Ng5tru?=
 =?us-ascii?Q?fvdQjoL0VmN/q+vCFDZB/Bc8cTiJjh+OvqXJND8DyodXZyl+jrexigwx+k3O?=
 =?us-ascii?Q?G0xZNE/5BCNOLaU19HAR1EYp2HjprPHik26L3V0MR88abdv/PTJByOQMp/tg?=
 =?us-ascii?Q?BZe7M4OWJISt1NzZSunRvP4Yy/GkdwJAkyeoQqPvcNGmpyN7SRiym7kCHwz2?=
 =?us-ascii?Q?tsrlTav4hwon1DJTDtwPr+JA9wuQFaD0wUsfbNICDrc7KaMvS9EY2a+f9x9y?=
 =?us-ascii?Q?rtVmCSGJUiBNiEBBHWFdoO7jCIooU2DKK6pW90mubo9lBw36xLg+qSMMPdTc?=
 =?us-ascii?Q?YtJPisjn+tJs1GPNSbU6nARsb0N5+Xd18Fl3slzpO0pJA61iZ1jr80PEJ1rC?=
 =?us-ascii?Q?QBym5ZohYUdij7y0LFrZ9ptYZN9+5zhUqDympf6CpZtb5hsi9RKwPFH251Co?=
 =?us-ascii?Q?jsMyUtPgpk2PCIg0TTf6Jeb3Eols6hwv34rXlq6JTROGC6ykcA+8IukHePvg?=
 =?us-ascii?Q?9Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Y2X1YUiJFApWnXQNQyhzWlCjaGuyJzpGhn3SS3DRZUAa1/0Cj/0b0HbapN3ApQiqBTvULLtU+FNLJf3RT/pgh944Q9wIY5PiLw/izM1L3aZt9NDCriveWwIMGG0/BZSn9TjpzIG6o9RMonbD0cmuoVtWKZ3xPPF+OgKq/G8vFgnxqDCstU53RwdTSVd5tcZilsnsbkKj88ATgBpqx/6cpWBp77J05dHjywjwLXCtT250ZNwQhpc6XqShozExvbbGAd4pIZ8MifUuJSowvY3ZHy9123kubVECPty6miG1hjP3r3Kho6TMvfRqhKavKOgHO49yfnvYa9sUMUoEdSd7OFzFUq/2tWPo2lOah1Ive0F/BzwqEwrKOmjwBJORYqWn3A9ZsNnEcmkELQ99llAUMdIfc6n0yYwIcMnWhr0yr0eeRVkR27G4pktkcC4+R5/ja2BX8twjdGTUcXkwZmqtSBh6YbDxnWhmbRbLmvubYRXWOr3onKsc0MZYSkVADdFfJEaxC4ZJBix4R7ylq3hY1ZSbty9g8aUlTzKXL0Mk2LD6pEq7eT0KnHn43pEQsQQjZgWxcUg+iad95Rw2DQxlR7rZ0zfdAiZ3ELyfjL1taIg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0209f237-866f-4eb6-ee36-08de0fe00de6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 13:53:31.4176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rNyNokpX11cDT3UIMJHYjQBwYMbiYS7z3vHJ06mK6iltxT/576haNHIWIe23+N6nHitnzGGyWs0xLW0megPRWhxifTJeWptkZqUjcpKXp98=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4962
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510200115
X-Proofpoint-GUID: 5Z7pwZA7sklm_ktJfHeTKh5YinRr-BAi
X-Proofpoint-ORIG-GUID: 5Z7pwZA7sklm_ktJfHeTKh5YinRr-BAi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX9IsPWLqI9a2G
 DtwQD1b9h17FEyqxYaslsdqTGXKKt+ib/lHLkwMis2ebrAZizMEfNBOE9zJFZRYCzvcdVsgZuCA
 R/0EN7Eit8PjNV51h5m3Gae8VLZz7ZJlBHWuMs9eloUFcsLLz1+YJ8M3HK8bbK2O0KUttt0BQcD
 r+jzCa6kMq6aql1riDf6mHDCE9NNmWLtCDOozDG0opyeoo7ifYDqHZBvc9bUsAPy/0/TNwVX0CB
 9G94lDM8DyqJP/D2Fmd7vzUDmsRtofYuZArPeQjmN1hDIDudGMfa7JBU9qUE/346iYouFP/CGwg
 j7Fxr1NoTzXeXI4pekmFX2fDfyY1aGd9D0XxvUxGGFdbhYTb/Wxe9OXIPo6uKn2troz4cpiH2NZ
 j1m4dBHUngoDpE5L8RTGxqtVoDivEW3l8+iiUz4dogHi31vkSWM=
X-Authority-Analysis: v=2.4 cv=Nu7cssdJ c=1 sm=1 tr=0 ts=68f63edf b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=fNIs08VP5SmSpcT3g-oA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12092
X-Rspam-User: 
X-Rspamd-Queue-Id: 394BC180005
X-Rspamd-Server: rspam02
X-Stat-Signature: 4hi9fq915rneton3j8pu65in8hierjkg
X-HE-Tag: 1760968421-836984
X-HE-Meta: U2FsdGVkX18yDD86Td2UzJ5LlkFJ2OBt9Ok6I7fnsN+WtUXgkUpaBSjYO4a0Jp1PtJopmEMz2HpDASz4twhubkaiOETLZnFFiq31OIZ/3Vcu+ZE9FwVYw/AggwxD/71q3TotpUvdqF7ScCqMf0h+e+mZtSOfcVrBeOcyPxQ8OlQ8sLIclpxVmkNvS+OWJMXcYN4GOEBub+tJSgXaTf2nfooH33tswweiYTfUFXHIEGe3k9raNuzNNE2d95zVcyihtxIFOWFOqH4TplNQ2cCEjBIg4fYLmGKqeKmgWxwXK4LqyUnUldiT3NlhWqOeGseUYHKr5/PWKoXAAm1l+U+teI5hbphRQGnZ0uHDwcH2ObMMkyOSiZ80MelzQebWmvl3jASmYRAB7AHAPPhOsmrSok9pRWpOJ/CkA8dTY9FU2ctvvC6Jv4iwveZjbxN0Iw7InS2vpONcaG/hTtBmuL+iJeWHbt4sO+w0RWhxNIslF0+tdD5B+LGu8Ydu+t+XXedYXu0z8tgsNicZgRiWEB9ReSRA9SUieJFpKgsUShwJafuBbXjS1K7PLD1Zabbb6hmpNFFuQ59dAFerl4k7mB8m+QTpwOf2+lfLgUaG1x1GWPJ5QfsfCiUQIwKBdTmZfPob7yNYVKveBiF6fgbKIl8J4PhbL9nEUWTehJGljHIWiNn85Ibja1NXgn/iQcVSUygoF/LYAjz2ELkT452MdJmTEh20K4huPwdx42bMMCHMRBlkw32qz6e8qmmkrdaFXbO06UAyuJNI2VW2B1P9WRAy2V70ZaUPsiiANpwDDaPMBRUuT6kYcVvW7k0vmwIwoVsiLrQsoMiR703VRCXQGch2T4GEwFiHnHQMM7vWowzreWQPC9a7TAWPPQJel7oYQ9Vv1ciHDeYYH+4lSjs+VnV6yWbPJEC/0kviMPtnRSlCvwGMkvnl/gwyRqO4xCMqbpVT5M4GQVv7rBRC0BdOS2i
 2eIJEkzF
 jmJtStOlsDf3dDxjKzkgpjRBFbUxsViWtwb6OCDWRTEBebeJqfwAOtC+SawVoxVwcGaVxTlWjZHuaX+A+EUS+Vuh34w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 07:53:50PM +0800, Leon Hwang wrote:
> Both scan_sleep_millisecs_store() and alloc_sleep_millisecs_store()
> perform the same operations: parse the input value, update their
> respective sleep interval, reset khugepaged_sleep_expire, and wake up
> the khugepaged thread.
>
> Factor out this duplicated logic into a helper function
> __sleep_millisecs_store(), and simplify both store functions.
>
> No functional change intended.
>
> Signed-off-by: Leon Hwang <leon.hwang@linux.dev>

Thanks this is a decent cleanup, with the nit(s0 below addressed LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/khugepaged.c | 29 ++++++++++++++---------------
>  1 file changed, 14 insertions(+), 15 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 0341c3d13e9e..0b7915015e9e 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -129,9 +129,8 @@ static ssize_t scan_sleep_millisecs_show(struct kobject *kobj,
>  	return sysfs_emit(buf, "%u\n", khugepaged_scan_sleep_millisecs);
>  }
>
> -static ssize_t scan_sleep_millisecs_store(struct kobject *kobj,
> -					  struct kobj_attribute *attr,
> -					  const char *buf, size_t count)
> +static ssize_t __sleep_millisecs_store(const char *buf, size_t count,
> +				       unsigned int *millisecs)
>  {
>  	unsigned int msecs;
>  	int err;
> @@ -140,12 +139,21 @@ static ssize_t scan_sleep_millisecs_store(struct kobject *kobj,
>  	if (err)
>  		return -EINVAL;
>
> -	khugepaged_scan_sleep_millisecs = msecs;
> +	*millisecs = msecs;
>  	khugepaged_sleep_expire = 0;
>  	wake_up_interruptible(&khugepaged_wait);
>
>  	return count;
>  }
> +
> +static ssize_t scan_sleep_millisecs_store(struct kobject *kobj,
> +					  struct kobj_attribute *attr,
> +					  const char *buf, size_t count)
> +{
> +	unsigned int *millisecs = &khugepaged_scan_sleep_millisecs;
> +
> +	return __sleep_millisecs_store(buf, count, millisecs);

I think this'd be much clearer as:

return __sleep_millisecs_store(buf, count, &khugepaged_alloc_scan_millisecs);

> +}
>  static struct kobj_attribute scan_sleep_millisecs_attr =
>  	__ATTR_RW(scan_sleep_millisecs);
>
> @@ -160,18 +168,9 @@ static ssize_t alloc_sleep_millisecs_store(struct kobject *kobj,
>  					   struct kobj_attribute *attr,
>  					   const char *buf, size_t count)
>  {
> -	unsigned int msecs;
> -	int err;
> -
> -	err = kstrtouint(buf, 10, &msecs);
> -	if (err)
> -		return -EINVAL;
> +	unsigned int *millisecs = &khugepaged_alloc_sleep_millisecs;
>
> -	khugepaged_alloc_sleep_millisecs = msecs;
> -	khugepaged_sleep_expire = 0;
> -	wake_up_interruptible(&khugepaged_wait);
> -
> -	return count;
> +	return __sleep_millisecs_store(buf, count, millisecs);
>  }

I think this'd be much clearer as:

return __sleep_millisecs_store(buf, count, &khugepaged_alloc_sleep_millisecs);

>  static struct kobj_attribute alloc_sleep_millisecs_attr =
>  	__ATTR_RW(alloc_sleep_millisecs);
> --
> 2.51.0
>

