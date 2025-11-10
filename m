Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 471A9CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 13:54:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A75A18E0006; Mon, 10 Nov 2025 08:54:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4D158E0002; Mon, 10 Nov 2025 08:54:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9149E8E0006; Mon, 10 Nov 2025 08:54:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 781EE8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:54:44 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 347605D5E7
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:54:44 +0000 (UTC)
X-FDA: 84094842888.12.30665BA
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id C77E240013
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:54:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OFU0s504;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rRHnzvin;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762782881; a=rsa-sha256;
	cv=pass;
	b=CR7mqG5bJlwsHSNRdxZ9L+lCf/Vvkk4v6V5zblNdqntmq1Pich93XakhdeMcE+zhFyBgbA
	O62D7Jepa2+elvvJWoFh0fhum1izV50O73WppVLSA5SwACjEalBh3OwW1KcvsWqfaHOQn+
	izMGqW7KlWBabGmkCYZoYb3yFuBlIuU=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OFU0s504;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rRHnzvin;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762782881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iC2s76TZhSqG9VO/PpmRZmj+s3DgG+16W+SGvWRRVFg=;
	b=g3RF/UZgvqgb4SFi3aQVQrbJIh9telxls31AVEECrhxW7A5bQM9qxvKeMWt7ncUU7/QpMU
	jyGK52NJdYLOeTBq6R6rG3v69ynr+LEqfE5EdvNyq4EcfYMGilxbGDJ4X/6MsnWTWExUVe
	u7cBGi0wv5zZS4ICnAiXZYu58uWZ1fg=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AADj7Jm021571;
	Mon, 10 Nov 2025 13:54:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=iC2s76TZhSqG9VO/Pp
	mRZmj+s3DgG+16W+SGvWRRVFg=; b=OFU0s504QfP0XcVtcNPtAaJZ4SdkFnd5eY
	awCFgz9QL17X+qg2MTmCqZB9ZCFu7Ba0Hu26fT9FviKpe017MpJ0fmEXQWCzxeJE
	2zyaJG+KHkqg1iYyIsmN/QofdvG6StYTdU0gg0S4Y/7DylAr8x1l8dKywAZhnlff
	A3TDcXu9eoEZcI66zJNKqiX0skBQFW0N2dBboY8mANxZxzGSzjn2QjEf5peIDpQh
	BrdVMdq29ATemNv0sxdFn31iENXL5yDgn0/6fvwhEu4KMtHFMsX0XmPtyczjr5UJ
	IaTmrOVsNmVqGto5B10M9ZTPI0cwhSovVyBJgdRE4mN1TD8RR9DQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abh7700sr-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 13:54:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AABpW2F012544;
	Mon, 10 Nov 2025 13:36:17 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011058.outbound.protection.outlook.com [40.93.194.58])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vabn92w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 13:36:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vTvSibMo0SDhmWw/tZlDiBVrS5wrDyRpsKpuFjRC/xyym+xApgN0j2mPY3VJ5BjOqS7/ZtkkYNeB2BymK2OPIGueK8SzVtbZBX8uaBIHxfCMzZspGD2kkflf6g/WMSfJdsAGtY8WVcLPBJaUHD3CnPnJEEZTJubcm3zqx3TqDoNUJT0bHUw1YaFF66B4lJMosc6dKda0bowozec2yznHtapulBV4mKRbGcYzroE34CDDEjdBCqA0AlKNDefje1qjUE4Arjo7gO3aGfX3/pXHsNW9cU1CPiRhUu5ee9FkR8zbiy4tV/fbaQ/modTG8lGzWtDVG+nPjCJBiIyd+nbDgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iC2s76TZhSqG9VO/PpmRZmj+s3DgG+16W+SGvWRRVFg=;
 b=dSDdw4DyoTNOw/GOkB7gGU+q1UWWgXvFjBP2pGFRoXOd8hjkVKUl/Py5Lx33pCLPlKcCm0NvX16VJEFNtfU25StSex6AksOTh49gTJ8ygprHDwSqDy+R5n2FR6+2ZwyBX3ZgPT5+si0jnSob8LukHrRB9k2rVWWStqUYeLjw+H6f7ZfrBh9pyOUwlsC3hIJSr8R9BYm5BBGzUFAkzktkRK9aFT1TSTU43MbpXXsW8hZKV+33XJljr1S81BY/ngxRu4emNL1TFqUvSBptM2YJVOf080burx9E8yO2jwZciuTwVBakJrsZvP9jPesWDH/JQjE1AJkjY9qeekrk3LLX1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iC2s76TZhSqG9VO/PpmRZmj+s3DgG+16W+SGvWRRVFg=;
 b=rRHnzvin8sSYsGms4cYmuxdkCaTJ1bWJd+dDd5DsWaOFH4utrEEic30xJpSalC2aRLz7DQOmVm4VBnZjzIgY2ULrAo49kb5ceeUeQuOXyKrfL6j4uLY9e09g941fRV1IKSPeOq1fZmM2O+85iSsWeUSaDUbmzDSHPWHh8ttq6xI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA4PR10MB8398.namprd10.prod.outlook.com (2603:10b6:208:56d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 13:36:12 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Mon, 10 Nov 2025
 13:36:12 +0000
Date: Mon, 10 Nov 2025 13:36:10 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Shivank Garg <shivankg@amd.com>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        Branden Moore <Branden.Moore@amd.com>
Subject: Re: [PATCH 1/2] mm/khugepaged: do synchronous writeback for
 MADV_COLLAPSE
Message-ID: <312bfcbd-d31a-40d3-8b9c-edc7b6166113@lucifer.local>
References: <20251110113254.77822-1-shivankg@amd.com>
 <f21b37bb-7a2b-412b-be76-e8968b4c375d@lucifer.local>
 <3f5f8a48-fa3b-4985-95e1-dd0ac21b5dcc@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f5f8a48-fa3b-4985-95e1-dd0ac21b5dcc@arm.com>
X-ClientProxiedBy: LO4P123CA0143.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::22) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA4PR10MB8398:EE_
X-MS-Office365-Filtering-Correlation-Id: cd79a80f-517c-465f-d226-08de205e1d1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VzcCA9fq4tmHSS80/PFpfMu5RMhmbMkFEzWgI66mlMjLs/C/SUxpItLpIcoQ?=
 =?us-ascii?Q?PUiiPuxO72cSy6LEZMFRseSHNAwUBFCoMx9LYcMHQliUT/Ob5JvSpeEON2nJ?=
 =?us-ascii?Q?y3JA8FI4Nw/cRmd9wxKrJFb6dFlrX1zEvYt0nuh0gP8393PEwkGaLx6P+bI2?=
 =?us-ascii?Q?rpctAGjV8YADtkfglCY2ajS5d1lBL0tlbfeuA8YWucGqrkTFlS2G4pEdw2Ug?=
 =?us-ascii?Q?Zqbv18/kU4p5U33TiISjwRswcNNCU+YgQbfuUonixrqNgF4BmuHNNihzHQ5e?=
 =?us-ascii?Q?fkJmgckCQ1SgffofVDDlrQqjRebCq0YxtUjCnHd5gN58gqnCuJLM0tQGZUed?=
 =?us-ascii?Q?GhORbuzLQ3+JTOWZZsZSDbWUIYtvfrzLmOcj6cIZrReAg/gFp1BP5ig0VORg?=
 =?us-ascii?Q?FLjz+aukry1q8Zgc6uay9egtofq9sbNjb7IndMW/A8vqmVkzI3uoQo9F5WsZ?=
 =?us-ascii?Q?RZ4+mzWTEaNoA2v4OKaEfJm2qUT92o+WiHmIAdPKKltEwev/utR8Q5eWwm5g?=
 =?us-ascii?Q?oFGyFSY1jv2HoM6uDp4T98WoXcdlvP114OJ5mmqfHfogVcduc2ki+6fPJ+5+?=
 =?us-ascii?Q?Z27vQgIQNdID+ouEJAH6ovpQxgq8vFdEyLt+bNb2IuPKEOjLnjgDrdlu3n/D?=
 =?us-ascii?Q?JYgzmd1PUJPkr2Xf0m85gZMxr9GvgG4Cv4fvinanHaiSxRQK1qlkfdMyVeRf?=
 =?us-ascii?Q?Ig3y7vkeV5QvSBIDXXOSxpYFSPu1xfcqcZs2f1ePr79BKsqqX0mRSJ8Tfqjg?=
 =?us-ascii?Q?B3noOMCkJO8F5cJVmMXdayaR6kjOkuYkY8WxGnC1nlKObjZovho8aQPY9Mcz?=
 =?us-ascii?Q?Rv+lIwowoI4XADVnkZlqscg1SxvnVMsC7f5UGQ3SH9TnMAVAKgetGuNBuHE2?=
 =?us-ascii?Q?Wk5EebO91pdwPgaZqXVa7gh3ap3nRwSl89bgIzuuoZzYl9FXjwpdZhuCSaLx?=
 =?us-ascii?Q?RRblsd8pPfzc+XoraD/scFzvamXRjm6h6ceS0DOc7ooFq+OkSQ6XEw9O5103?=
 =?us-ascii?Q?O0cOcYBEzw/MQgnPKZ06vakedujD9vcf6JosDZa8AlBnAEVshWr8uKBzNZDR?=
 =?us-ascii?Q?4nGzNZCky+up/K7Tbi6+6JK80UVCOGYKKtO3t+/pMiE9b+2aMyRq5yJZJ39o?=
 =?us-ascii?Q?IqhOgsSX4x4i4FKYuMwROV4QU8NqFmygsE9HiCz3Q405ZHdAB91P4T4N40HV?=
 =?us-ascii?Q?ZAnCWwU8x1pB8P7E761ywuMDgSlX4dn1sYILaickcO1zYfGWS8zQkIaUxjRK?=
 =?us-ascii?Q?k2mf4CJ10M5+cyCRK2LFhAZuQ8EYK8/LPJh8C88ShkSsR9aT7juVRRR0QtrN?=
 =?us-ascii?Q?LyIwdIDp8aldQt+9shDSZqo28yrd+pkdT6+jIio0t2ATSIfl7+EUrmAqmaYP?=
 =?us-ascii?Q?c+zh2sJL4hp65Ad1VfUM0rttPpYjVesVQ0pQb0AL188nNZb+pTgKFre1Suds?=
 =?us-ascii?Q?eV17KLvppyRPACUXHEyr48mH+3HXR7xg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pihkEvpYSEkdKzyvhZ94xmHNRpJzgmP5x1vSRqJLBVW+Nln7xUYpEcoS5+tm?=
 =?us-ascii?Q?v7f6ygOIUKTvCtSR1mte6HtqLpp0x6dTlmYNs4My81bLTnZibNu4td+U6v0v?=
 =?us-ascii?Q?girPQR5AeEmcC7xW1EUv4/lPQHS0NTvzulMjiemN0hFppwW427f8Nmik0Wen?=
 =?us-ascii?Q?9TkXckmml1LhF+a5ZKcLi0HhmOsKOVGJLdExljmlNkIohXW5ronREEFjCcgm?=
 =?us-ascii?Q?7MuzyL0hESOJcNIythPJWfQufMLnd8ukqFDiUqCE3tI9wMfsIlWj4GK7P2Ed?=
 =?us-ascii?Q?iLUOwe5RNkSfxrW7DP8H0zW87hzGVLaYN1HvTDwVwlIJlz0YEoDeoX3cdzvR?=
 =?us-ascii?Q?pHsA5fkL2mlefI+ZE6aazF0yPHfCrsmlewikfwQD1xozlM0BCfUW/wlvtTxH?=
 =?us-ascii?Q?XFwpFatie59032RnsicINixNbKCiLo1mZLskxxl9gxYDNPe1ku0OUv66Km22?=
 =?us-ascii?Q?VlYEVUiD/QldDVYZc7l46y1TS0BlpWnnlG8V6P8aJsafnyubzw/+fj3Unip1?=
 =?us-ascii?Q?LGbg5FPWudZWNwLXvPqdnvLpBmVAJ3tzE4vTkdukqWFJ3pTqvwFEKjeoG7xW?=
 =?us-ascii?Q?QflIRS/NK5nJseTaNyPydcbOO+xLtMmKC5c1O1pii5TMbStUT3PT2b6KTbDl?=
 =?us-ascii?Q?41VuGNZoV10y1P+2hTWIpUCmBOiaqx55neHfgJ8F54wcCzkRnJfSvCOSUX52?=
 =?us-ascii?Q?UtSGsKu1HUVoy0SnYKFauQn0q1FRzzcZLuJbv6AoZ6P/fMbEyJe1F/zuvL0C?=
 =?us-ascii?Q?60mcKDFAXUhhXKK/UYM62ziOewW4R/1KMXbykx3NUjw0CT6M3YbIpYzIPbeH?=
 =?us-ascii?Q?HImITTpR/UxkpG6PuartPIAOz3NaBAYavpmVV+rD139J7hmb7/Hu025WKFuY?=
 =?us-ascii?Q?zLY/iilbWSLVYB+HRumOev9Pr4eLwumqVW6Nohnm8K1zX1U0bDKwZemMlg5n?=
 =?us-ascii?Q?8vNlUdcNOfE/yi936jZzc44VMgog4bRXAOPC/dD2kVBL4/NDVNoAjxCR7pXD?=
 =?us-ascii?Q?0YeAmtN+AR3xRhjD7bIPzNVrX13PjZXWtmMhIvZ/+aw0NT3aT/PySvnxM4zE?=
 =?us-ascii?Q?VR+OOxijBndrNcQMuYtvjri6UMlIw3lqCMK5uNeunWXc/vmBF1gJFi+uxf/P?=
 =?us-ascii?Q?9fhneC0CYRWD5pqUMTvJpHrHN7QefuPO2ksDK8+17l/gLCbRCqRBSaScu1qe?=
 =?us-ascii?Q?hftVsKPz0i6J+I8QsH4iooN3mknYtohCzOMMueeGBSem6+7rgU+UzIkhoK2W?=
 =?us-ascii?Q?Jn7ltlzURPUflrmuB8f9gzeApHv+o1qNxuTF0HNlG8z800DhSbPYiHTAC2Qv?=
 =?us-ascii?Q?eL3k/FFSQFMEtPDnlyet7OEgdKvJLAx4k+bkuR8N0z3GZ5MYurH3hOvqhE9H?=
 =?us-ascii?Q?YiBJg9kUPKQJn04SNQPDE/waX8vDODYnQarikTf137cq6G3phOYJsi/mD92M?=
 =?us-ascii?Q?N0IMQfrKm+lcoDnfIt5JlmWFb5z/V+s2szUeWXf7WBrXodb+ns79PNV7kpF3?=
 =?us-ascii?Q?nr5T1KAX6pF3munnoZ+JqkQU4KdLQBghZ4xuBp4m5mpcefFK6kCCQgqWDQC1?=
 =?us-ascii?Q?XI0/3lpI5xc4HeiWoEdEGwNnvGhvGah5n2TbDQsIP+4LU3BvLUsN1mX7r88M?=
 =?us-ascii?Q?Cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xPL3YlikUcgGmFFtKUZuws1VXc0ElxlV8SHkv789FW+wedYo3bWIL6iPPZd72U2TImWb7dE8sH+jgPtQx3/m9Jqqz0swuJhhYCAF6ebG7/xgJV7mF9vo0S5hLpk3GXziNDSmlKxHAwxcV0krrOWOl9lfsDlAxz7sPsg15qLVafobBB0ux3K76QJUfWUvee9MthvCuMURDMm5eYjX2DEQAZpRfn9HXQsd5ckb0mySv8YYYb0L6204gddFMPvW8BWXWroNkVNgEeL9KgajM2tC4lf7Qr3ygx00xwVMtl1BC3HLMbJf2BRmB8TGzjHxVx9VqQhN9odbtSQ/K3nP6ZvoCsw1JInm1niClqGMWReWZRWKN39BpIp35KXm9cV0Xlkym3PMs6FcXFgFO1bfP2grJvlWJpIRBAN0j75o9REe5Nx/85Kf+XA4p38vtOdaT36MDyats13Nzl1hWVvO08yPFQnx4bvGTKl5LAtzG6o/jBPFZ75Dn9DE84gM1Eid8gKu8eaPfLV49Brl+LUwgiFeRyM8Wu9Au0lc+E1c2nOs2V3tGwTPWMVunckVAwT6xKfM2bRc0TtMFWGc9MNTNFnK0rR3tm/SDz348nWJ2vYbVHU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd79a80f-517c-465f-d226-08de205e1d1d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 13:36:12.2290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i1RZmVaAf8QPuTXorpWjCYNC+L/yQaR7zw2P+vRzgvGV0HpsT3V0sR8vkXFhgUtPhftjtUqkrFbTtd/3c/Xm0pub5v+18ISTQZNJLwEVD58=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8398
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_05,2025-11-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=422 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511100118
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDExOSBTYWx0ZWRfX9PsYdLpfDFW0
 6RiBjBwsAKGFr85o9CZQ/crRI7qILS7vyVIlPsKhVjirGq1FjxxNS1cfJHkuVdnP3Rm1i2nDrf4
 NiaatfpEm7ep4b9XO8CmbWSjMOItilxDRAfvF+QRttIAW7EEY5YsmYwyntcvkTHgJcLLxxJ+FbZ
 pbPaMjDqO2bQJCxSQnwBLqoFW66TRLZc83ECxU/skE7ENHDGq7UrJBmNxSMt5F6sVnhDS+M/lhj
 Q5oX4gk4CRkV1jikjr298xEF13PcdzzPF9I07X1Ne8e450WojAo8IDNytC561OhzwOM2rVf+DVm
 eGn2OXloJj5WTXUhWIgmkn/pHOdslrYB7kEQQWZVL/lPFfppBYAUOdonkcbAJ1RgF+yq9FlDUkK
 EgXM6lRFymbaULx+SHlXaxz3b/AtVutYfPOb3/CM2YJGw+Q/n1Y=
X-Proofpoint-GUID: BPjEZmrBajVvCgEW2gtfRxDE6VTV6Trs
X-Proofpoint-ORIG-GUID: BPjEZmrBajVvCgEW2gtfRxDE6VTV6Trs
X-Authority-Analysis: v=2.4 cv=YMWSCBGx c=1 sm=1 tr=0 ts=6911ee96 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=IRMTovPIFS4hysGKdU8A:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12099
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C77E240013
X-Stat-Signature: is3f7bt7rnosdba5czifx9ua8e3pzu6t
X-HE-Tag: 1762782880-168231
X-HE-Meta: U2FsdGVkX1/VLKoGoJX0S5wfAuiK/VpwKDLfmRRVdO/N8Xhyu5MfAcacMzoDDjkbPeRuLRnro9XyuIgH9e7+e2dxLP+7pJxmuKIqCO6dyWm0clhzXBEUOUYSYuxf7/cj3xwdqqiozfKy9/AMHRamx6lnbcajITCdlLuUzrPFQ+JM2gzStKDJeLrZmFQl2KO2/ymcnLnDPaFqzkexOidFoH81wChvJtGLV7fheTW4Sbtp53UC8dsPUSSHRDDZ6Ccvz7Ll0c8axq2ZnzAmSFnwWrrd6IIVQthqXgeZjvgWYSRBfhtbFxautXwjWhVo1FVgejkz4SmEJDHoKQaXEdJy4mHbQWlLAcdZNhBDFHRt1uAxe32kRkzKbelZvpvXfX9WyqOgYj+QN5mH1NMnm5KrzGROdq1JA3BSDx0zmyj9cvI5LDukL5PUYb32XehmvI4q3QntrelZajiz6xL3xAHv+71vaUliTH5KjiDqSs4xMaYJjTxw82+5L/a5QiawL6B2yZmUbUpoLgQ7CJmPw+q+wokLgTPEtW7AMhLCgox5dvKiIFZYz2pkyYhvnYjnfJFRLyubAqbQBQUpYaQSd96d7TbdvmHQlaOA9+CkiyAT8BIpUiRM5pZb7GryDHIx2ThkHUqn1FlHd0toZ/JEiw9N4jf/9WzCZMFmYyOk5YdR72yy1IfKUwzpFCM5ObY5cYO70AxNbWAm7Q0gsbzFjP/yhRBwETFniU+LVUDUnVE73PjnQy0zxbwsqG9RBR8UJw2JWjBshFYMa+eE95pzDbIl58MXvg9bG0JoPdg8ZTqerNSh3F8BemezPxV6ynRbrAd9XQA4MXnZi0wMbhxDLSamU4ppsbBokWGarRIedXrdHHGhkT0ZNVlnCdg4ilDJVl2FeKvoFFaHF33OA2qALVHJw5MWGdcSbqKvZk/2n6j7p35EbHf2KKaoHnLI4mH9X4uaQjoeaRb5xLq9WccPrWM
 7zlRhduf
 lB+lYt1vskkGPs3CYx4LrGhNRd2wZtFIibqzY/LCJ1JhJMSo6rrRaAG1N2fZq4cNZjhJG6rfH4uNMS1YtsgNClYydOsUYVTL7foRXtI/OnudkaML3JjULOXmEeyXyF5tHB+KPyphlf7MVtN8G1AxI++nBo5t0Unsbzkzs/06Nj4+JH4Sk1F4ctemR+cfSAyrmpZWC+tHhdiFpMHUNcEi4B9br0Jcwr9Tmd3Ovsx0dcIeY4GcBBc2UxGv+Nmr8wIatKDYSkVZoR3lHtWEJR+1C0JkqraIkdMF4l41gFomYnsg98BZ/y43nueLhl85dv9pbvw6xxAvf9yBAYC3dHxYHuDTceS7EXmlFjgxxgLgG3UKxjtVsVdlE0vTvnQ/JCBZtv1HY+ANHB5/lxlx5vvSWUEDqeEQUjgHA3R/6zs2T/gDRDrK67Cys46hgcRzzb6t2Xrwv65hrFrnrLD2Z4zGiT9NofToocJaVfXFDFmLJqF3jgXzVKptkUdkeUB2auQQ6j3xNjcsa+YE57zUKjrWiQdeuO8OwzyVSuksfHw0P90Rsd43rgaV+HLKz0XxeLZG4VbXZFQuxGo/apeyUl4drmauo3vhO86jauUhlkdv3t7DXp9D6F8BPh6U1jwr8fHvxo3scs5uixO0RIL8DuxcwEH+l1g+EQpsSw0xaRZK9hnG0yKk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 06:54:57PM +0530, Dev Jain wrote:
>
> On 10/11/25 5:31 pm, Lorenzo Stoakes wrote:
> >
> > ofc you are addressing this with the !cc->is_khugepaged, but feels like we'd be
> > better off just doing it in madvise_collapse().
>
> I suppose the common case is that writeback is not needed, and I don't know what
> is the overhead of filemap_write_and_wait_range() in that case, but your

Low.

> suggestion will force that unconditional overhead and skip all the early exits
> possible in hpage_collapse_scan_file()?

Which are?

PMD-mapped folio at start of range, scan abort, non-LRU, spurious ref count

I don't think this matters.

And we're trading for putting _yet more_ logic that belongs elsewhere in the
wrong place.

I mean I'd actually be pretty good with us putting it literally in madvise.c,
but since we defer the collapse to khugepaged.c then madvise_collapse().

>
> > I wonder also if doing I/O without getting the mmap lock again and revalidating
> > is wise, as the state of things might have changed significantly.
> >
> > So maybe need a hugepage_vma_revalidate() as well?
>
> The file collapse path (apart from collapse_pte_mapped_thp) is solely concerned
> about doing the collapse in the page cache, for which information about the mm or
> the vma is not needed, that is why no locking is required. The get_file() in

The user has asked specifically to collapse pages in a VMA's range. Yes you can
go check the mapping of a pinned file which you're keeping pinned during this
operation (wise? Not sure it is).

This would be the first time in this operation we are doing a _synchronous_ I/O
operation where we sleep holding a pin.

So no, I think we really do need to revalidate.

'Collapse some random file we no longer map at this address' is probably not
great semantics, also of course, we are revalidating at each PMD anyway.

Maybe even do a addr -= HPAGE_PMD_SIZE; continue + take it from the top?

Maybe David has thoughts...

> khugepaged_scan_mm_slot() seems to be serving the same function as maybe_unlock_mmap_for_io().
> So I don't think this is needed?

We're talking about the MADV_COLLAPSE case so don't understand this? I may be
missing something here (happens a lot ;)!


>
> >
> >
> > > +
> > >   	result = alloc_charge_folio(&new_folio, mm, cc);
> > >   	if (result != SCAN_SUCCEED)
> > >   		goto out;
> > >
> > > base-commit: e9a6fb0bcdd7609be6969112f3fbfcce3b1d4a7c
> > > --
> > > 2.43.0
> > >
> > Thanks, Lorenzo

Cheers, Lorenzo

