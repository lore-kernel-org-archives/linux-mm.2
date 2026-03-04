Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BDF1EDEBFC
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 01:06:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 124B66B0088; Tue,  3 Mar 2026 20:06:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D3026B0089; Tue,  3 Mar 2026 20:06:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECBD66B008A; Tue,  3 Mar 2026 20:06:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA3D96B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 20:06:10 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 45CD9B8B9F
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 01:06:10 +0000 (UTC)
X-FDA: 84506589300.02.3B7D472
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id E9C9514000C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 01:06:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PyjKOJHL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rpPqn33O;
	spf=pass (imf23.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772586367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qV0ei1wDlFSL8cqxNYCqoZQJ+BsrHF79kmuD9LgCLE8=;
	b=nGymE57k/C0rQXPg06ExpLXbWkTVkMXJYXhljLvBowKDm9JHea9nbBdhbfFh/gcbyfu2H8
	VpEVjzqCNuObbovmd61TEadOP6LqhzInJH4jtakhHISyuzg6wiskv7FypPJKbe6luF7c/u
	OK1nzku8O1bpRipW9/cuNgJVdWlnCHY=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PyjKOJHL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rpPqn33O;
	spf=pass (imf23.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772586367; a=rsa-sha256;
	cv=pass;
	b=dql2rQQ3/u30wYFiaUXb8/7kqEVIrBEPEcbKGVkliZB81feuDmLiQm/rXr4bUTUugTXW7E
	kHvr1wf5aXDGXfHNam/fRiWBJRSrXCmjuyCJvaZazMI85FGD7jrbmrRiDAniTFHlaRvCUV
	sQIAFr3rLo2KP+qtZq8NExh+cNM3WAA=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62412ZU41548140;
	Wed, 4 Mar 2026 01:06:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=qV0ei1wDlFSL8cqxNY
	CqoZQJ+BsrHF79kmuD9LgCLE8=; b=PyjKOJHL/s6x06Nbz7arIW3RDhU5bSqpRD
	0oPlQuYWhMcjlbKWPt8PBb2XrsavMtQABRbGI3m2BbLzOnihQ5YLuPC4Ewza1+Ow
	XSOMgbdPbTXUIFL+hSbTr3dupRtuDOPZEos7Bu/9yUQMNNk/5UEx1Lc4lA9s6toa
	qtkbP+Q7yyP6uZeqtjO9ukyQO11t1bFSrUZlduiXN1wfOFdUERNkybn4CDLFcmXe
	CZukeebE+03x6Nrfp7DvEytXrFyOApr9nc5VDJLNuE1zQT2Qy6GQARqoDVkojlH5
	L0EN/N5lnNowWnWm0L5tCKNK22NfpDCcN4vJoJ6sp2tfpsAfjIFQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cpaqp002n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 01:05:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 623MVH1n034818;
	Wed, 4 Mar 2026 01:05:59 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010063.outbound.protection.outlook.com [40.93.198.63])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptf3y2t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 01:05:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l+WZYgH3cPjgQl27BSg4+uBZ8GcRNSTSk75ntIVILzUAsGYZvef28J/071wnKUr6+KY31Ig9kuBxkARYXeghBUof1oVd6Qh51Ht7Rctn2mUj3QfhoS66CtVCRUvrLFpWxo2PtxyBbyaAatB4ksnFw6JlaNQEvYwSlV+V39TC3s3YElQbjbqt9XdJ6Xj+MYE1O3gEs4NETtNCQLnrAoZRg9z1JLnIaFesPmd1gTrxXPbEZwEc+sAyDVgP0tJMpIEZxzB+0ZiB8/ikc7BDgp2LpVI6QU2h1fmpWaixLlpcopfi0Z3omwW0Os8jpuwFvLGfqHkjtoTc68cP2FRfqexxnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qV0ei1wDlFSL8cqxNYCqoZQJ+BsrHF79kmuD9LgCLE8=;
 b=C/2XTeQwa5otQ5UXxZOjeUZ9t8ZVrGZvLwIKjowv47mHU63+04ctzzqWy+hx0CNApvQFuMcvqIEP/XxP3pKvZMUXvv74ZWIJqTQtK5NGGgoMZrmwZPPTj963LlBC+AjSyo8xarZHU1K+gM5F1lhnp5IrE7un93bZnEXOYcmdyipwS4sfgLr1dLLdiJLVfpmzsknrQ3Podlu8zROyECbBpeQ6WAExFtSdvdlbyE3ZnrcDP8l9nNhKJi/rTRHnxuzDmHgy95FTflDN6ShypSMwHracX7jY8Fi8Va07VfEO/OGxbysrDwO+5herI/LXs3U0JBDy/BrsLChE8TNrQXXzxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qV0ei1wDlFSL8cqxNYCqoZQJ+BsrHF79kmuD9LgCLE8=;
 b=rpPqn33OjxvONV2TjLOgQFO4lI489tLfl1SZy4C+z/pf8aMlyCkVGNGEQoDe7gv5PLsXxQ3IsZZR7BLtFu412N/dHaaSBtG17bp16ENslegJsWt0MyTWBc1w4Hc9Jq3UWvCjr7HAidE95WwObd2AEoBbcvnkHIYWC2dA9XbDb0Q=
Received: from DS0PR10MB7341.namprd10.prod.outlook.com (2603:10b6:8:f8::22) by
 DS0PR10MB8152.namprd10.prod.outlook.com (2603:10b6:8:1fd::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.22; Wed, 4 Mar 2026 01:05:55 +0000
Received: from DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::81bc:4372:aeda:f71d]) by DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::81bc:4372:aeda:f71d%5]) with mapi id 15.20.9654.022; Wed, 4 Mar 2026
 01:05:55 +0000
Date: Wed, 4 Mar 2026 10:05:27 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Marcelo Tosatti <mtosatti@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: distinguish lock and trylock for sheaf_flush_main()
Message-ID: <aaeFV4TWm2jGzVl6@hyeyoo>
References: <20260211-b4-sheaf-flush-v1-1-4e7f492f0055@suse.cz>
 <c6e94e2a-34ac-4515-b4df-222f2c08c992@kernel.org>
 <3016b42c-643b-4e65-a6aa-67a91676d3f7@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3016b42c-643b-4e65-a6aa-67a91676d3f7@kernel.org>
X-ClientProxiedBy: SEWP216CA0142.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2be::10) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7341:EE_|DS0PR10MB8152:EE_
X-MS-Office365-Filtering-Correlation-Id: afafa9e2-788d-4e48-d65e-08de798a276b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	NZ5sCtX8zYJPlwPDNozsPFuF8Dkyst/HVc0b5MorPsTc0V1HO5r84uoLxTNlVS1tzV3gIZiRAcPBLYkMRYwNLznjLy6lEVaVKtD2zl+7nfluzSJm/NjJLEyY0MXajTyOHi8QYpBtKVs3xSItOmXVOcicribPwTFDR2vFdfWZ2TYTW/sGmeks7W6/imhvWlSuS4a2QW8CCl4nhUCBmj8tYM0gvh8yzEhIKM4bpYpTAbTzs6pITNLCZ3NoNO5vxhv2sR58/Ft1UOLNAlCXQAZjbfieD76I+dDE8L0bT4ZlC/sA/n7a8uJ7Eq9kKO9dfY3osEl8vF4c5LlMvoo9jCePQu3DrqCCD2vTOTn800FkxUpsrT0Bbwn0WjmCtqSuUuYs4e0jtLBJJuQRdldUc4k+UJodta4ZwBd0xkrFCcdooo1S0aQSiq+4bfI28ufk96eVUS8fwM7AzCu43Rwq9ACyv7B/30uNmqtWVXwxnebWe1UxjdTt2Ngc1TgQvoV10ze3EZdu8hF4pzvYlp4JdDgLVUbZfJdEpgxVoRPrPGgwO4w9aEnvJX+GFMDvvFTjSw1sDi8koXR0AsCFlvmaNLnVgBSadT3C+8h4KDu68T8Vgz/MDzoxN2RaDFAQXM7Z5+Mvd2V7be/QfG8asu82CRixTtQUkq2nmQFS0gppio0N4a181+nJSo5bBkoDmxUyLILOoW3bVYW4uz55cN/Ow9uKGOVbfra3S41U2WqkAUtHvyY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7341.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?skptJtEsFD+aUHtYuy2qTYozU/jIC94oAgZjlonRVl4QfP0+xeVFHF9HNdH3?=
 =?us-ascii?Q?FSWYS8jyr80gBv07grqChKy5uEhU1RiPEFQF8/7GLb0rbi91JSv6d9I54zxW?=
 =?us-ascii?Q?Fk0gR+1hGGnbZ4C99rimgkpEpHshn7R6bZpyv6Zz8pLNvJ+LWoLUXCFYF5hK?=
 =?us-ascii?Q?VdeTIs2dlw+3wopk4HfLOpIIFaAc3kqOncJ+2tp5iaG0kwBSpfhOWPd92Iou?=
 =?us-ascii?Q?OZn55wIMjYCjcTgi/plYb4IVvRQrZHLn5qFXdFg4NHlZEAc+R0lyfghLMWMF?=
 =?us-ascii?Q?JEsEK5cIMMLOHOFlqJdJFZQtrsDtM0QMq2+rKECUlf3BIqKDk2DLTRsFkm+8?=
 =?us-ascii?Q?Cm/cQFtFHTLbcz/eOdYBMU+TCbH9Gq7R1NlmDnaW78oE4RDkOxN7FkAGqMxf?=
 =?us-ascii?Q?M8Qy1C5WM8GeD9VJ7xUBjusZr7DRJ1UlXUfi40+x5/+Tj4ehMAk9V0KS1OBS?=
 =?us-ascii?Q?Ou3Er8ihM2OCRIWX9Nx8XFRouIghOqiaYTX9Azo8VE4uhv4Mh0hXeyi5L8/+?=
 =?us-ascii?Q?sQDtUJk6wwGz9+a69ji4ETedQIECiblZ6kau847SjP0c7p5C2r92oGv6Fg3E?=
 =?us-ascii?Q?ULXqm3YP7Y294pEUy/acLdG0zAzJTlwJ7dwyZPuIP9b8ZdHPYh46j4AwjvZ3?=
 =?us-ascii?Q?Rm/G0h3ZIjwpr7K4+mLQCJGZlDcwtdznRuhzGx+Ww0MFbqLqY2OhhF/IaTb4?=
 =?us-ascii?Q?9d+mO1pIAgJZ0HTMIwfss3FzRgZzF/RBLAvKe9XHPHRRVrUdVRtrwHAWUk9H?=
 =?us-ascii?Q?lc/W0AIAaRVtjCQlThWYQ7tiBiVpsEN/Rb931s7n3AzAlDlbqERJUWfXEshE?=
 =?us-ascii?Q?LBmp7JIUzbCeYcc66McYTgyDhDdkqPgz0scbtQQdP9yyrxEw27xRg6nKAIKa?=
 =?us-ascii?Q?nZm3FvG4OQJI7UDHM0FQll9DkC55xiYrUfugjgrjktlfXlmf7EWLjPWnnZt6?=
 =?us-ascii?Q?vHWyvMHfypJl5A1eZzgyw/uK6gvvmBHDnhoW7c2koCtjgGKxpmLZaFFnisTU?=
 =?us-ascii?Q?LG+kZXIha03w7AX61hWDAuUX0mbnaZQJfkA/QhbmvEiZ1sVZAhKCwq3vvL/g?=
 =?us-ascii?Q?F/6xq1bjkwauiqWdT+G/PoWnAYQhDuGnqABz5qWaKn/zu6ds84WknfKjRo/8?=
 =?us-ascii?Q?+4NRLmLNEmfmunyM6MGeBz4A+WiSg5QzRxwqL1b3+HT6m5LJfETpeQseazgi?=
 =?us-ascii?Q?INFrnd6pySK0BSyqZ0AqtNKTszsI2DSWEz2+olcTobQOygDtfhpR3Kmkgwus?=
 =?us-ascii?Q?eZL5qtlTZHa4Z1npcrcbGNUTzwHPYO7AVO0ag0jaIN1GfuAJ0WtB2EJvF3y3?=
 =?us-ascii?Q?wUNRK99+E8MsFy6vAqoLKq2C1yAVRUXXnMGzh13vpvT03pSbSUbcQbMAtHa2?=
 =?us-ascii?Q?xy2h+hMKYgwXX21SMjWfGeNtf3BqyyoKEFv4FC2sbJvuedWFU+rUnsQuElLO?=
 =?us-ascii?Q?eG6nlwn7Uu132uA8qb2bgnuj2U3OI31nucJethENeYGyVfUnAfvPTUvhETHH?=
 =?us-ascii?Q?ZbcgFSEgIhSiAaFfH/AN3ZEhAPcb86rbYKpq5eiNL2EGGCsulxNjQWP0Dc4O?=
 =?us-ascii?Q?wxnEgzXX1InyGfPrp2BkA8PuQNIULNsnWwPHUr8Iid+tLGrszJeljHo4jNcR?=
 =?us-ascii?Q?2liveRuoqc31sWsLXG+OoobilGuL+mjn+uqtFRw+FZIzygwMHL9/zQuLBiYk?=
 =?us-ascii?Q?xjyWFmLiNv4Dk88fyHUQA7TUoGZGQpbGZqizkPaoJbn+GWaicWQH6ebI9iCy?=
 =?us-ascii?Q?8XpPTpQR8Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	U2weStOHUIMQtWm3jrkvTslc4oTpi4vVwRDTdaEg1ai1UTjK9Lo5aa1SlmVJH6CkN3B3Ebw941iqzrqwvTEyU6TutVdGmv9ymNI6fnzWoAiPeM3xl10ks3XTXvHq1R8fx7ufcepVVM/e7KUkQsOEH2E0lSdcPrrLzy4NGs7ucrqr9kp249CKj5Y7U6jeLTCzbjnvquU0Aa/ygZaMTZGOB01uA51MiLnu/gzluXA6LFRB8/2JmplaSf3wuELhWY+DndaUahrVJtfO/jp97DNnWgadMpg4gas1lIy+6seW0fKN5/ktpwTrhDGqLWrY7GwNB4Ye0NUAGoCHOlv6xdg3gKn/wdWF+fKxe6+wzXwaHTvXmnGWb5iiFOV6HgcljBCDYCNyPcTt7vxsI1XDrRV3P1AQD2calpUE/11YLDy3ufXkHe4T1Q/J8kBZklbZlM+dNVObDHXUpY2M1g87lf9jmMkaxbvDIxIn/lXC1rhLc1vWZ+cL+wf4c/nSqnQm2JBBqIZJRWXjNlhjXPIHOUR3MxUG6hKAK1u82gQp9jPPducGTky19CMxvUBnEw0/rB1pmJFQM5dpCGB4gib2f1IPamimtR/ZhHsYSsMPrw+Uj3o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afafa9e2-788d-4e48-d65e-08de798a276b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 01:05:54.9549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VgbYEmmZBtJXD2swuVLy163Y3W60x2fA2MjAVus8a+INinDFN0vrKL3Oa8FwGSQFti+Awy7F7X78gGwBQeHAuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8152
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-03_03,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 mlxlogscore=760 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603040007
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDAwNiBTYWx0ZWRfX+njuHyBmr8pT
 PKId4UMewG/rToOkV9jOTnL6FTvJ+gOTEmaB2XhqxM/JWjMBUHZ9WkG80l++T6hUnHrDB1zubmF
 xK5Sn1uqwRusniFmsPbrdTuiBR1Su3mMPxztsM09ZlBJdu6ixvGC96P8JCiLlEJIbexQr8zozPe
 2G643KOdz4vae0Lo35Zt5j3PizRr6lxqc36N3UEWXDZpOc+kVFGHGeWoKEVsqMzLsYPEyxZmByT
 PtseqzXMUtyqALEJi4tN0j7/ILR4l3WwlCjtl38Xk3vTBJLmZNbhwBIJ0zoC2lu4NpGaNCUH/Qu
 rnhijUtq+4DQYxJAbOn9z0GBYzJjZV/QtmE6upBF1+GKSo/zff+7luQI2VknDzenACBBwl3IFaW
 pLfqZYBHrtU5n9HRTx4ttR5zUYH5daHTVRXC5iIRfWGsvSfbVlJRqJ72jjQ2YvVWMI679vPOr3W
 AVYlmy+TvyrcejiYtI+WVbe0yh7OUK0GOqK7+2CU=
X-Authority-Analysis: v=2.4 cv=AujjHe9P c=1 sm=1 tr=0 ts=69a78577 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=zu07dnAEB-2FCKhnw-8A:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12266
X-Proofpoint-GUID: pH1BJlJWG_05jgugKhDBbAB280T7j0jD
X-Proofpoint-ORIG-GUID: pH1BJlJWG_05jgugKhDBbAB280T7j0jD
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E9C9514000C
X-Stat-Signature: n3bjxizkr7zw3uyrupygm61zne14e18z
X-Rspam-User: 
X-HE-Tag: 1772586366-118293
X-HE-Meta: U2FsdGVkX1+OYx39rPTt4ocB2e1X6TYr8tgRlEBIIIPW8CUb+Lgc4s6QnraehTqzVswy8iC1P9aWP24hjO81+YBCZB0Zt2oWyqNQM/emqpBrFA9SDNUCt6744eyDgtN/T/GenRoh0ntpnkJtA4kj3Jsi6gv1xquQ1mTsuagZGLwlmLdh8NHlECCrfDVFE7xNQqKEZo2o2kZRiq38yTpLOMdMT+Lo1s8sVA6X4Nxff6Lo1kPqpYNUX7MXrlZm83aTuXjQ0AOowvRl6sxhaKfHGsrZwB4pDf3PJaAv10xpfWxQbbAuyQUdr9tgPHtL785s4hprIVZa2drEiJ3VDN4YKpBZbeaYDt7purxQ9DUS+FMKBX2fdpsJ3n59anMpV5U5v00V9ff2P1fJNIORpe0Bl6TDhXSlTpp5DHtVahdBsNg9qzUzwNhDKX3NR083upz8QZlSoxqnXmXYfvYQ8KGVqg2hou3LKx8vimc8o1tkoBhZy07VRyL7uasBS6UDSccrQrwO4lZXlnoWgYhkAy/+QMmNX0TQiCzM2121WZJ6jDq+EYhY9+pR5LjS+ugzm5AdsidbNfinBhE59xISpOZpGxsID+TkJnKkbdCba1EdpDJhwVTAve3BPs0v1wBDBp+J0sAcLCNRUCq7iePXTKNwJBEIK1T+Vg5kkJ04pyLGb4uO12AA++ajVCVqkVtbtNNMUsk1fcqmOEfhXdsA2nbrtlWikR2s1i6KLuqMMuHE3SQFm4PxLJWLfTOwE86thb4yra7KtR0EvvoMSSHYDzYqwxL6Ngsx1zBRPKnCAzwce8FMyrSE5C34ZtU4zcPm/2z3YcFRSCEKVY7XAsuiV6SKVAkC/0k4BQ4j8YRL4IjgncQhGIIt76r4ctBNBliI5pTxU69lO1mMWcZezXpC/bxgLRiFLaZzx6Adi8sdgqa/K7SoCydnEvU+GJqdBAhfiIGFDSo0wSQ191IYjbXB6Qt
 WwnguAjy
 7DObWfblM1KMrgLdGgyjFkHEZ0z8YU64IMGqqj+JwFjOYA19x72TAbf6PiMAdpQDtKwA15NZEcX+LJhDgrZ5zLSGr5vASIyYD2f1TwKPPuGw/M+5+3cV0vl1Nt/yRg+pDyahCdXzHVxRf92Vm+TLTbmvE2yE0L5Je98gMFoJRdzJIXeRMVNSUGZJXcJP10o9JLyclaHjk0RkMIW2ctY6/F9Iiz2y4/znXrqwRNC5blP596zN2g1lFBSnno0XpaMCpBcZFWhPyfcJinrdKepWJLWOdLpMUmtBkdN7PrQOzaL49YujN+3SJeutSiyj85DVkfUkn9ybG4ijGYLKyazZIDJcI4mtbIgH23jRPylJULXMa+K3pUPOL8jZnFokV8ZDakHGeyZB3kOMpsfsZUPVUUZsi5fpMQ8tJBnTmkkE3lR7fMFJNuFi6qQVMXkvu9vCbyqrRhdZi+liL9M65N1obc35S7Fnzu4AG0GJAGBVl573vou6YdXUQNOXgOHM9/ey+2V2SUGksGaCyTiHpHj/YqxDJJXCHmvrzMtjbhsa7nOS2Enq6VeiPqAGS7vRu9QafdMB2SBLrQowZk8OTgGtyD7ZBWZ32WydZXKjgTkrSpHAPNxdY0NhW2TRGu3MtyQfmNwizMy0BN6oSR8fxnUf34XlKaoEzbK0SuGiVJxAZdEEg6kcWJoiXmcC888/Y+BWQlFihYeh1yNanlL0FN+hRIjDSKDPQ0MqlPJ5Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 10:56:44AM +0100, Vlastimil Babka (SUSE) wrote:
> On 2/26/26 15:50, Vlastimil Babka (SUSE) wrote:
> > On 2/11/26 10:42, Vlastimil Babka wrote:
> >> sheaf_flush_main() can be called from __pcs_replace_full_main() where
> >> the trylock can in theory fail, and pcs_flush_all() where it's not
> >> expected to and it would be actually a problem if it failed and left the
> >> main sheaf not flushed.
> > 
> > Thinking about this more, I now think it's not a theoretical issue because
> > on PREEMPT_RT I think pcs_flush_all() can preempt someone holding the lock

Agreed!

> > (on PREEMPT_RT it doesn't have to be an irq handler preempting a holder),
> > and then fail to flush the main sheaf silently.
> >
> > The impact is probably limited though - if this failure to flush happens in
> > __kmem_cache_shutdown(), it means someone was destroying a cache while using
> > it, so that was already buggy. slab_mem_going_offline_callback() could be
> > where this matters although it's unlikely someone would do memory hotplug
> > together with PREEMPT_RT.
> > 
> > But maybe still worth tagging this as Fixes: 2d517aa09bbc ("slab: add opt-in
> > caching layer of percpu sheaves") and Cc stable and sending it as a hotfix.
> 
> Added to slab/for-next-fixes with adjusted changelog:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/commit/?h=slab*for-next-fixes&id=48647d3f9a644d1e81af6558102d43cdb260597b

-- 
Cheers,
Harry / Hyeonggon

