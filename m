Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B349ECF6BF0
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 06:02:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A1EE6B0005; Wed,  7 Jan 2026 01:02:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94ECC6B0092; Wed,  7 Jan 2026 01:02:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 806666B0093; Wed,  7 Jan 2026 01:02:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6B12D6B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 01:02:31 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 40CF9B5FCC
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 06:02:31 +0000 (UTC)
X-FDA: 84304123302.20.B6C9D11
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id EC10320008
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 06:02:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PfnXRBz9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qEoYF2TK;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767765748; a=rsa-sha256;
	cv=pass;
	b=xlDgfwVbR9XS8w4skXp9zTeqFNsLkVqxT1TWVVpSDERHqHSoX8T/Yc67E6+VEAEfnTiF33
	7/Wd07GVdN8LTOmVBo1c43acLS3tpflOF7+zSlSnMBoNalOKudJjmkLuZcXwnqIpQ+4kFw
	/EYT/tYWiKkisWh0xE2nPChCd1So//o=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PfnXRBz9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qEoYF2TK;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767765748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4juV7m5Vr0JXXkMi3SEZHqcIjrKQfNXFjjPqFP04t+A=;
	b=nvoaU7aHzPkhahEwg1oYplAsHt5v6kP+0ux76dEbX+WV9a7iDQgRKB2+5E2y68nj2rLmc+
	Kd7Qh1f67efJ00YdEYoVAAqZADDdIZ8WY745s1EW3fb+jmMOMT3vYkotf7cJ2AOnbfP6np
	OmApNRFHZVpXvpc6GhaUswcHHlmS3zk=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6074KTqZ1673967;
	Wed, 7 Jan 2026 06:02:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=4juV7m5Vr0JXXkMi3S
	EZHqcIjrKQfNXFjjPqFP04t+A=; b=PfnXRBz9iWgAEQwdAzBYbt1VO1/VUT6IGb
	5qATUz0vxG4enxoopOwJapXX2EPxrMdE/iYqxC3tEwVYfOzXtMDnAFvKs54O/nEL
	ow0g7YeO54dqS65j32E6xGUlI5CbmnA1kZSes2cU3ZT2PVgnAZLaorsIwUGSUORV
	957aMnNYLyQuE8ESYlIyI4ikkLN5OTSsuNgnLmHjv3mrke18zEObKS2vVXsGfIsC
	ZHb/ie3KI9BBc3CIVvyBB51CAL+tZ1RRqSEw9H1Sp7Zu/3K03auY8njrompn45FZ
	/zS0tPyGClwJjOyLvz5Hlmbs/gwHpzFTXP9asfk21GSF4922jkXA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bhgcf0238-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 06:02:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6073XE0K030721;
	Wed, 7 Jan 2026 06:02:15 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011024.outbound.protection.outlook.com [40.93.194.24])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjdg0jn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 06:02:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aawuepj61Elnq0RzGWk+K4R7IHCH6LIHjKEE9pA9trTNKcktPcvD2q3Oq605MShHPrdiQguytdtnHQG9VWK2tzNTqWS0iWTB0KjqcDtVvZkTXAoqfKi/KFcY9wMr3kd1MFxF8aS/qRWWgYO4YvQ+XM+1jJE6H5Or61aQHMP5PEi+0wVB89AMJ0U0neI+ZRYAEOo3PQArstOkvfo2O98zYUyZElENpIdi907fSdOUtE57y+4do2HyxI8Wy2kUR7JM7N7aKF8HxH8x4KMKV4mAFAU6LHNLcl/ObPmxwv9VUiHH/EDYMvln5I7ZJCelpORqkfb0Fmp5p5N/uB/yMeB3Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4juV7m5Vr0JXXkMi3SEZHqcIjrKQfNXFjjPqFP04t+A=;
 b=YOOvAgQebdfWK986RV2ZXX4b+mV7EYpbcCGXhT7QW+a4S2GkTKJ0Pet58cDBzRbywZcQntDSPHpNzfdXoUPQJ5M4l1ihW4tBquSIgTYrbty8U/8B1XQop3bhZhsMRooQk9LApKGly5PPrx1h8wWj0exfgqU94SBr9fkGlZFtUXxjJImm7hwgejSx6LUrLYuXHkswRol34y94vUnyKe9njQ4MNRPMSF2A9uHAJhoJy0AqgGQTgW/SwX7dR6crFIs15Lo8BR8dSyJjV7cXImKFBJGYi7gquZCNwQJicsGV1cUh170jE+etC/fkBlBCTC/64gGtNLa1HkPKCs+pkbousA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4juV7m5Vr0JXXkMi3SEZHqcIjrKQfNXFjjPqFP04t+A=;
 b=qEoYF2TKzLud08NvbMRICLC0ckJVSv5gqD+7KvWEm/WjQUhJwYTAjv+ZBHH6t+M8WJmXJFNO80pKGspqvT8tzxbSxm0umqDM5Q9j9fz4yGfIaOLlgH354kGQClNduoT4w1hqndJb1l/PlZeM7K56pAIqfApppinW6O//B1doO1A=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH8PR10MB6386.namprd10.prod.outlook.com (2603:10b6:510:1c1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Wed, 7 Jan
 2026 06:02:10 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 06:02:10 +0000
Date: Wed, 7 Jan 2026 15:01:59 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com,
        will@kernel.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, riel@surriel.com, jannh@google.com,
        willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/5] mm: rmap: support batched checks of the
 references for large folios
Message-ID: <aV321zAn3xRhkBRt@hyeyoo>
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <18b3eb9c730d16756e5d23c7be22efe2f6219911.1766631066.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18b3eb9c730d16756e5d23c7be22efe2f6219911.1766631066.git.baolin.wang@linux.alibaba.com>
X-ClientProxiedBy: SL2PR01CA0021.apcprd01.prod.exchangelabs.com
 (2603:1096:100:41::33) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH8PR10MB6386:EE_
X-MS-Office365-Filtering-Correlation-Id: b4fa368b-27fa-4637-1721-08de4db24b76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aGPIoSqeuOrKmLQjtk2lhDLN06KyDMD+XukKU/yWM4a3QoNCUaDG4nuxcj7X?=
 =?us-ascii?Q?rfjDd8ramSxgY911B3lsmzYkuKgTeHqZ6VcvJndxq700gLmkYLXmaOQIZbWr?=
 =?us-ascii?Q?Uz33mpLtDQk6C+0NfKjPxTDxIYnLzW1zHeHitMNBOcRYVTo3NQaoHzV6AH1I?=
 =?us-ascii?Q?7N799pfeXVxlcxH2MGAfay6koiSdcS4nnKZ0M+t7/Z8mJwwg/VyFbhcz2Aav?=
 =?us-ascii?Q?y3u8fLgmjm3FDLohw9QosppDSmA0d5U5pvnfJNUTzfmVos1e7m6PfnLzA1dx?=
 =?us-ascii?Q?3Z0A5gV09kiiWS4I1t1ysH2fLMvMODDKrUexgxZ+jRXCWyXeJ5MNgo0v3jxz?=
 =?us-ascii?Q?5W3wWrgi/SVxR1GWeghtUAGuTJ/rY2tN5CDyjTpEzc0HT0YvkaLV9foTVzgq?=
 =?us-ascii?Q?I9UpkdatzM4CGS8/SplmkieIOqkSKpNcA6YzoVNUVdYFwPA134XdDNHYouln?=
 =?us-ascii?Q?KkFsiB4nc/TBjS1A9Oj+EIeZDSZY2I01urDuRU7PSBW7HiltOogaVq8SQLBi?=
 =?us-ascii?Q?gN5gl5om5/FAqopbX/Ns9R6NcERYOLmDsJznrpGvGM91eRwytncJeg83a7aM?=
 =?us-ascii?Q?7LrD6hUV6WAU0mwRKR/k3p/VpKp9PeUZZjReGct9bVZiJU4UwY3saPn9rMMK?=
 =?us-ascii?Q?w1ZarG7s237H8f5x9N07VexBE4iFwHBzJ32X+6y2AoJNYT4LyLyLqnjv52LQ?=
 =?us-ascii?Q?fVeKVMf7e18Va4x2uiY505pxK4tejD3KR5NTzjzVtMkPmsIQNj0Q6MslGI1x?=
 =?us-ascii?Q?dJUSavnteghUR4/pAa0jR1/J3EB7NVw74VCmT+FeREpzHr1+dgYO9ZWxcSKg?=
 =?us-ascii?Q?dqkzCaYYsn4UK0Tp5qkb6XZEX4y3zF/FmpKiVgwVM+WMI2Wr6k6POKjelH4D?=
 =?us-ascii?Q?kX4UT0GLtTUXUllpa70rUwwvwCLSgeg1JCoSZ6QjDorkgEaoS5z9Dj76mSo0?=
 =?us-ascii?Q?IVOHscmWXh2K9U9MWKHzWF7sEZIGUsUD/TVTT1QsST+57tbfTUJXCJOcIbQJ?=
 =?us-ascii?Q?ZDZPR5oM59cp/5u4vElYSI4r75Ge2hMgy6iH21bHFfj9IuoidUOR9BKb17P6?=
 =?us-ascii?Q?sYr7Tagi5D1njypIssGlHJES5ZwPzu/gwfI4W+mCy2Facx6nO44XruqkYpyQ?=
 =?us-ascii?Q?nC/J4cTN9Ug7he6a73I2wGIfmgkUKlMEMCtBvpqXWjejug9uS5dphR/we3fR?=
 =?us-ascii?Q?mBx1GHAWRHF7dbJ5pPUX3WcVVwStkKkVWnW8N9cHL+8s2TUkIQX1WNKuf+41?=
 =?us-ascii?Q?MeSSUI17eYzodG/9JNlrLUPlwBtyXoZiaT187TSmb9l9IdB7ywp+RdYpLxrd?=
 =?us-ascii?Q?uBhD3NDNVnyw6upEyBW5llF5NKKLzjvhqThrBLwfTvqzpre9XHKTygwVQC6d?=
 =?us-ascii?Q?VYG5i4scVy0SmZUxFhtuJn65cqTUfYkA/5wI0uIsJ+KicEulesFTibOo767i?=
 =?us-ascii?Q?5OgyKR0GtIwSEJofLCTh16J5CHiIS73V?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?b3bu990pwzXWQcB+VVbLonWu0c3F4tm8egbB+RZXCp/G2zWDQknPUygasdWB?=
 =?us-ascii?Q?ZpS2jF0t7KIEQKk5TQ33ojXgxV2DklGE0qjWlfWNKPLttakGofrrUrnKokh4?=
 =?us-ascii?Q?rBNbBUpx12Z1X0a8iHkAgkQ30nfVCvHCsi6/0cNRnxECHT6vi853dD0kjdiw?=
 =?us-ascii?Q?ZnXHI1AeJSMhsjNjBtNcDxu4yRTqqrd5p5bh+y8M3pgHRGT8ygGmdOsZZ8bB?=
 =?us-ascii?Q?s1ppmMPhsFm+gsGDmcD9qFqrcQfMgbrAcImIIMUQ+dEO/9bxEX94S15cX1Kk?=
 =?us-ascii?Q?CqF83MiX4qgZbGVew5lv/VxSjecO+4BoTCYkcPw0Mgvd1q3b5OIf70HM7lkp?=
 =?us-ascii?Q?oreV8juSPOx5fXKFvyFzrZMo2bzM4sB5jHU9hwrvY3KfctOROMm9F2aHcwFM?=
 =?us-ascii?Q?43edknkasTVQwZi6wSGOKD5we4RfWwS0fiFCaKOqjHvmXSSRDgpU4zkGOfjc?=
 =?us-ascii?Q?aICZnYInhuvGCV8QttyxUCNbtGnl2yWFA4rBtK1teeV0Zyq0V9UTm+pz8n3Z?=
 =?us-ascii?Q?QgYjYchFmY13w7n/Y4+6eALYtMdpctEEkECq0lzQOiR7VMZ/SbKSYWtreGwj?=
 =?us-ascii?Q?QPanJUKflGPkMiIEamXqakcQEQBb1naqpxWZK5YkT4brSal9gr1DOu4F+iKv?=
 =?us-ascii?Q?uEG0CUd165lwrI6d2ak+ElQoK+I4rJYZbMXTIbL1Kt/N26d2b2pv/rR/lK+W?=
 =?us-ascii?Q?3T+qWMcFwXY0rrsCjvjXTFNrolI+j8TSyNbGFWn0A8A3g2dL+aTXvIWOt9qo?=
 =?us-ascii?Q?Qwx4e0gq9C45xfIJcKg0XCgQ1saTO6mS8LeNohbkrrIbB1202DTRt35fSPjy?=
 =?us-ascii?Q?ZSDu/HFyS/hUhBV1MADi/+LbxTdLDtwRPp7QQZQSDrN+rVNfMbWjTVA4g6SW?=
 =?us-ascii?Q?g/4yF2kMb+nc8HDzNtii2ElhgxCHs4BrcEEhnVdiGuZ5LESmDAkzSvk/FizL?=
 =?us-ascii?Q?8e00uPOFBF3qRgMhKEOTbhoAYDeWTCRTB22xB7h+qm6jC2duA+7PZPt1E1B8?=
 =?us-ascii?Q?ArEDVvym12AvmKg63SJBp+z3yocPwOoSsl6ZQSs2VyPZHXCE5O5gyf/AltKJ?=
 =?us-ascii?Q?8AN7eAD4KqptzsJx7GpxNeCwp47/ujbdquiUnGL9prUQGKBXNKthGK/5/0aS?=
 =?us-ascii?Q?CbyO4fEKj3Kvim2b4WnwyUCU4pdaS44P7bCBb2uukZXryWHkmeF0rgd2HiSv?=
 =?us-ascii?Q?R3LRNz2G5/U73vDSJP6TEYcJV8XoYjDxEYoZIL1Xj+iWTc7i1ZXv8OtO2sQw?=
 =?us-ascii?Q?m3MGPV5/bO+UJSSNCOx8w8eb+Dapy7/EPahNGhRED9RXUs4vmDLOlIsvR3ZW?=
 =?us-ascii?Q?4a1Ew8P6Io+d3AVlijvSONrpZKD4PSRoJ6CckzIKE1ScLlipBgL8nyAz9iie?=
 =?us-ascii?Q?IkMrAG1YRDV5AwShx5iYf+6fx6Aj+XwkE8Zl+PfBvHebF5sL9uYxybsw4UdG?=
 =?us-ascii?Q?aY+wFamU+GU2b5JEhhd3LQSJwViFB5RDC8XpguCDNhF3b55SD9H37/hKfh6V?=
 =?us-ascii?Q?+7ZQ8kdhDa8VL7WoG1NL1RxCEHLzM8n4m6KLDseTXrkWySAulXVRMOv0Kgp2?=
 =?us-ascii?Q?YLvpAvSQTjB2wZSAokEH9D1JIYHlgSu0AXgz8IULLWde9UPIT+KwY9tSadSj?=
 =?us-ascii?Q?7odb0Rqk2YsR+uGbxEXJNRaliIliSEURtaJqstniaiI+ejhjspBJL74v+5JG?=
 =?us-ascii?Q?Nu6DMwvDr0bicwLdXelA9yCg7TgLio3B8Ff1k8B+XahVrvh6eXPObitqaYoL?=
 =?us-ascii?Q?27Dh9vfFCw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	K0ewaB9oOhlCMxlBbVCyj93VzsIqJPRnsa/kECVe5CSfBwJ88geEMLPGTmSx6wpHlE03x9ZDccW/XBNTbR6UXOevklU3YtAvgxu/WUFuALY7d2gUDYnpwGFx+1slzF2udlZa++PmAisDZ2bAjFgsjWnYlDOdUO+mJvuCmiHpby+1wmDhP+52Ikm400a9A093Y+xKkRWayrDrzWBe6xB22iZFk7oYh6pnlcGlp4IL/HmAmmHKTksJ3J83hWSW94tBjBePo/H/IY0H0GoFTZ2Ry4Okp+72WplCFaZewk9WHylg8v1Q21bsNBqlpZD70GIf0XYCb++zgu9dQFHxgcBH0BgDd44ImCpiUGGAE41Yqtp7SghWJquosGcSRtntVsMA9xvgozO8yA+HQJddbHyFxdFDCosKc+2Y9qCuA7iUyLAlxCCTX12ffFpIkXHPn3vFM7ZwuDI1FNGiRYtErZyKixz2t7H4rNTHW/XWjI9lA6BNHCnRKamvud+a3ziXE193sEQfHiZgaG/11zP5ZhfCC1a7FQAD3BGg0ZnT7PTOxj6B0fMIpY5RKd1trX4w+ZuE1kBuIj/SjuzX16furyZ8pcsnbamRdDR42MYYIdXFIRQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4fa368b-27fa-4637-1721-08de4db24b76
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 06:02:10.2085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aHogSQ+cpSKNtDKEYcyoM9v4KV7meQjv6dESBm+Q0E17+Kchr+y6Yc5D8p+jTGth7I1L4Fr3mu4RUzMk8DRqLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6386
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_03,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601070046
X-Authority-Analysis: v=2.4 cv=V/9wEOni c=1 sm=1 tr=0 ts=695df6e7 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7CQSdrXTAAAA:8 a=SRrdq9N9AAAA:8 a=yPCof4ZbAAAA:8 a=R29F1XmW-H53_fAgWU0A:9
 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:13654
X-Proofpoint-ORIG-GUID: y8KtTKTO1SDBgD-uCMjHPWMC_Hq7K8l2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDA0NyBTYWx0ZWRfX+tagP2CNS8HJ
 nyTf/mxKSlwFyZx585d+lh+fHdIYM5VMomr2vbJ0186xCFFGX44F9xafH9t0RaSYTDPSBU11KHq
 j4k27Mr6KTzG10LkrZkX89gH5npSHcGFnTkXJ4TOhKwrKoEYmNMOXqTcmBDa6T+dgwkAr50f1rB
 WZiIdO/iWl+50g6dtFdKudroZi7QzmtqmzerC5W2Cz7a8Lc3tnBG+l30voLxcj3qwqz9dYpVygE
 rEGFzscXJ3DeKaoTzp84q7f1Uqqa5goB/Avkiz8A90A4OsFdpdQbvzo6pejmrHRVdS1jo4NIAZG
 SITQYYUiwsHbNURkDwc9CxHAgfI2/WmbkwpSkpmPB1wFgol1svbOw6FHwUNroMC9cLYzQ3+/d8a
 hRiDCH0dlEiKO15eUQAuQ3rB/SQEqcs4pvEb+/dA8mvT6H5mUZV5qMHfvF7KiSfRIUA9wWCYS4X
 rLMzjT3NInDmgl5HZJUDZIaTvcN+pXV+v/hloC7s=
X-Proofpoint-GUID: y8KtTKTO1SDBgD-uCMjHPWMC_Hq7K8l2
X-Rspam-User: 
X-Rspamd-Queue-Id: EC10320008
X-Rspamd-Server: rspam10
X-Stat-Signature: fnasfobogp5fsksibopfm77tbeu66deh
X-HE-Tag: 1767765747-588251
X-HE-Meta: U2FsdGVkX18rg1Fw8/MgjNnZnNkkrKuqOE3IhIyRo+ISybd+wGGgG/NHM86FVzG7Ia36g8thIP7JTzgx6CIGzx0naQ/nDP4Y2M6odwlYvZ56zWKj3UyN7lzmJxPml+2UUNcNpR7iubNaunYOgWaR4V6UDGHK8FG71PezqAIldHMoxmd+MMHhyHb8LXevTEqwNe5sAURVL7rDbLXXK81LfjAEvCA/YfyGNTs17PiDctcoXw+wBopk0nLc7GDuLxJpIwIVwmSQKfnYh3GFg0aSCuVnfEwj4TzGvtQnyEKxQNzv8hemSOb3+aeu4V18hyFLfxpygaIPtsy+kduFWkTdg4MBT6d6teGeUVOvUldFhuo/NlaAaArVvTOEsvQj9Cz4jE6prkZ3JFAYDbahtFCdBi09tUYk82zqoKXRu6Llm69ff/f2RdJAY1po/M8NuIyBnRRMt1H/ZP6BMKoAEPm0WBSxRstKiywU5cOECc+H20sh/7xtUGMqE1aw4ghLl05X4tXwOeS7rClf+WqfWNXzMMVd+X7C3l5aY5mbk8AjG0BMLqnHdVRS4OywiduOMcgRU1//mItZ+9jPTSTHFUXnbzv0Sb7R+Sa94uNVn/OqS1scp1P/w48kwZmxqbMfeB1SfvNujjyFETn+kU85lJYYblXxIC2rCL8Tz3nzlE5rQGsVLWi1MNz8f8LZrh0hpC9i6YAhtIdwxlWSOAzeHL6QutLzF9qXU39JsG9m/4YjEORAouGS6skmlmMeQGl0qx4IY5I445HeiIl/oDbhBddTz5R2UBGd1uHs1Q8l0EPH39MfQ/aQg1uKzzJ+YHNLiVmNwjix1wYwOJ1W9W7OrJVyGy2+MRBbxRWsCqbHCk65BvJsdMXRydMLs4zENsJLIBjHZ+iwl+8vJv0IuMJ7gWsjCJXztGytUZ85l/DYOXA8VJ/pybwQHJ6bQM1z34KDnF86CM/xP7VkMXeNFHX/tny
 mz7T7mTH
 dhvmhjkqaox44UAELTyeavnviwYoe0a3aHW4z9qjKdHW+bJ57Y081wG/IyB0dLttRoICsTvyV9qE2AdX6aD+O55qWO8koE+HaLBoMu7IvuwQjnIhiWwHhE5zRP7q4zs6fI0b4jR8caQavN79sPQGEw/pxVRAVdrxU4QBKEPGa2yKADuAkAwsf48ZfsPIqGFUtx+T6Vd1mUfXM9PZcJnFIiPvaUBILpymQiEXIFIBvx54Wc3Voaaa7kUUdjUuVj722EPpiN4ELf9e8HQExx9WNcFlsinQRrD8YLcjDErxS0o6wsWfB7fIUvipVuUicz6gaQDXgrjVwcGwgQwDf6CSd7sRmfvZFLvtnr8AZLvLbTcfkdYXOqSIRAR/t0r+lh0dxIDJ5nkIknDbrKHV0Bq83Fd+JJ7Mr2xwgP3TGYUJmjhlo6MpWx8QEhz/Zy21rSnXYIx5qVabXoKVq+6aj7nc1iRuCt1D6I3tyYZjsyBZYBBkW46iVgIfSZVBxZCVBG7bOwLQPcr1aAkXl97JPlJh/7hAU00mLBrE2RhzYFylcFTyXNr9HyJGAlO+0IjOvNwGd+7AapnoL3Kno17HKTVmG6kZnp6KbVTVz38ryTllBrEer+IItIUHZbR1vcW3egC16b3Cmb9IdvlXMK/7yfh3VqpJA9bIVzsV5V0ZF8Yg8GmQjuvDHeAm2J1kwvv0Vi54e/+Lt91VJV3ZbfvVNAr5CvfIOz0/Ro590CNak1O7PmEI0ZmC7zoIz7wOXoIH1BZnoqCECJwaHg65BNZQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 26, 2025 at 02:07:55PM +0800, Baolin Wang wrote:
> Currently, folio_referenced_one() always checks the young flag for each PTE
> sequentially, which is inefficient for large folios. This inefficiency is
> especially noticeable when reclaiming clean file-backed large folios, where
> folio_referenced() is observed as a significant performance hotspot.
> 
> Moreover, on Arm64 architecture, which supports contiguous PTEs, there is already
> an optimization to clear the young flags for PTEs within a contiguous range.
> However, this is not sufficient. We can extend this to perform batched operations
> for the entire large folio (which might exceed the contiguous range: CONT_PTE_SIZE).
> 
> Introduce a new API: clear_flush_young_ptes() to facilitate batched checking
> of the young flags and flushing TLB entries, thereby improving performance
> during large folio reclamation. And it will be overridden by the architecture
> that implements a more efficient batch operation in the following patches.
> 
> While we are at it, rename ptep_clear_flush_young_notify() to
> clear_flush_young_ptes_notify() to indicate that this is a batch operation.
> 
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---

Looks good to me, so:
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

