Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE84ECA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 14:22:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFF6D440009; Fri, 22 Aug 2025 10:22:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD6808E009D; Fri, 22 Aug 2025 10:22:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9F4D440009; Fri, 22 Aug 2025 10:22:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AED518E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:22:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5862C1DAE44
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 14:22:37 +0000 (UTC)
X-FDA: 83804609154.19.8022609
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id D2F74C000D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 14:22:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rrBlt+co;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uAoosnjf;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755872553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+V37MpdOXdLO6C/+40SocHKU6Xbbd0nxZYkX3ArW1eY=;
	b=ia3KuTjU2fqzSCbUXPRRMmKdxvG9942qiRy3K79jzgbTpzM4Vg+hadSd9n05U83PbochWd
	jhhSX73syoGDW5mCiTytYkODZJfxD10zcNCTRgBBZDHg7Rq+Qw2htTlIctX41Ue6wQHs1Y
	yJem5xZ9zomQehP2Wy6UDZPk4GEtvtM=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rrBlt+co;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uAoosnjf;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755872553; a=rsa-sha256;
	cv=pass;
	b=Wvh0CcgDE+1c/EoBJICoIMO+GF2fKWvYOTEJqkaMSD4qhDwbVfdT/MbNrH/VQ/2E//YEWA
	2P7uEkazG1HSi15odPpgW725EfX5jGrCoVHaiq1asijxP/+m5Nk0QvAOJ5YjQWty0WwxAD
	GUHnil/VNEb2dJAmYtOvbI1NZiUISEk=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57MEHnDP022462;
	Fri, 22 Aug 2025 14:22:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+V37MpdOXdLO6C/+40SocHKU6Xbbd0nxZYkX3ArW1eY=; b=
	rrBlt+coAk0F+HCaImKZnJWNetDMExKNt/VM+LCgLSm2yQtSUxptMFrXczJtQyB4
	JVmzEuRZs5iXb6Qoys8ATpczlQwaeh492ScORK+2Qe6q3A5T9dsAl4RipS9FznYG
	5+8bZ5wgqQFXon+8MHkJ1awy0aB8fHJywwMqu5nAvIzNiL8Xhlcs86CVJJe1qJfm
	/caZyFd+wzsue8RI3LZahcCEgC6+BX8p8sJENC24lMYSMJxwsRmIj23uBaOdhD9c
	2yeSHDb1aF/UpFon0mf+qXTb5kVcAccS6PZyNTqMGVswTJEFKJXsQe9vteDoh0Gm
	o2sCBpa/+7aYlUWVlB3PAw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48pabh975y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Aug 2025 14:22:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57MCpZ4s039458;
	Fri, 22 Aug 2025 14:22:10 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3te6s9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Aug 2025 14:22:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C3UggPQTIopBU29kMcZGkrvx0/SJRWZU04mNkiSazMi5QAoWuT8EbXhvOCiOyJvIDQUdBQwI+Y1wyKoNSslAtRTXSCCO84mtjNI3FOr3RiqZnzpt3tI2m7MynsNJoNo1Tr9bQKB/lFY/C/XOJ5tGtDb8gKWSuV2ffKpYwJoTCgIoMsYw71ak8U5jvvd2v3aRTE8sXGiPy4RcuUSyavgcIdQS3II6ChvWdGo4TFWOI1toi9EW4p04M8ZsWlFYdggC1zUYn6An/B5zP8sx4Qi319kxn8jILadWXbrL9kXGhu2crwgzGeH7+sIyLJu/YsnJt9WHx2qKOoytRMMl9IKASw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+V37MpdOXdLO6C/+40SocHKU6Xbbd0nxZYkX3ArW1eY=;
 b=ikeXEcL38GxS1x36PaaGTrsT4YXeSeYlagJeyca8EKRgEOFFCOWPHZjVAoz7Ryhr1LtSLQNtmCEKqa8wnD3NYSFMrtb6pRmu8TiDGTsPoTRgIiWEg8tQFPFqBegJzbul67s7mwRaTBBuN8rkmhvPrtjpGlgBsczNazAQXvP2FnH9fyfMGI5Mh2IYaw7j6AuSxoVpm2hSCUY4D1JJRd3tihOQ9uwexB3lHjIRARj56yd1O+UQLwI73J5Jw3mK32pA03iSq59JHvS63SjhUhj6MqW5A8jx4x7CRqnCrupkxzgNwHI8sgmQLWJ3dUOrPo8B+TKxFS4i53N2FHSkvyOt5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+V37MpdOXdLO6C/+40SocHKU6Xbbd0nxZYkX3ArW1eY=;
 b=uAoosnjf2Y03v2RqrHCITniSwKeGQstY4iBTxT/pjbnPSsxE7VAMbduTnvl2Q3cUvP3q/vXjNZ4TTiy+61dNAkwl3lGB9GeP01dLtyXO6dwIwEtBF9QIFq15qmWGTqEZGOcgC6smaT8vkgHSmBchSUnAWIuzX4i0lLMb6Hk48Po=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BL3PR10MB6020.namprd10.prod.outlook.com (2603:10b6:208:3b3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.21; Fri, 22 Aug
 2025 14:22:06 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.014; Fri, 22 Aug 2025
 14:22:06 +0000
Date: Fri, 22 Aug 2025 15:22:04 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: peterz@infradead.org, bp@alien8.de, dave.hansen@linux.intel.com,
        mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        david@redhat.com, derkling@google.com, junaids@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com,
        rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, x86@kernel.org,
        yosry.ahmed@linux.dev, Matthew Wilcox <willy@infradead.org>,
        Liam Howlett <liam.howlett@oracle.com>,
        "Kirill A. Shutemov" <kas@kernel.org>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Andy Lutomirski <luto@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>
Subject: Re: [Discuss] First steps for ASI (ASI is fast again)
Message-ID: <05c32a14-805c-4603-9afc-80e8f29b7957@lucifer.local>
References: <20250812173109.295750-1-jackmanb@google.com>
 <cdccc1a6-c348-4cae-ab70-92c5bd3bd9fd@lucifer.local>
 <DC83J9RSZZ0E.3VKGEVIDMSA2R@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DC83J9RSZZ0E.3VKGEVIDMSA2R@google.com>
X-ClientProxiedBy: LO4P123CA0513.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:272::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BL3PR10MB6020:EE_
X-MS-Office365-Filtering-Correlation-Id: 567a9789-bb4b-4fe3-ab50-08dde18745e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K1VhUEpsRnV0VzkvMzAxTGV3ZXdyNTluUThJRXBta3B1SXJwOXdoeGszZFJs?=
 =?utf-8?B?TjA2bUZNS2g2dDJXa2R2SlR6OEtzZFRxWDdiTmw0N2Z4MlZGNmxBLzJUbDA3?=
 =?utf-8?B?elNaQU5qQWxVWFZ4QUxFSUxHaUxYQ1pEUEF4cDJKSmIyY1JlZWlRZ080Tkcx?=
 =?utf-8?B?WXNsbXlETXZsTGFWbm5IbVFrRFplemlnZC9MMko2SnUxV1pCZHFXY0FLbXlh?=
 =?utf-8?B?TkEvWWw2RzBMc3QxNXNyalV0R05iQVI5Z0ViZ3FwREloZ0hKdnZ6UzhpejVz?=
 =?utf-8?B?TXV4dy9KTnFGUjZ0UHVPUWZaM3c0TXdkNk1uVWNrcFdwZFBuY2owSVhKM2Mw?=
 =?utf-8?B?UExqbEN4cXdIZVlmYTNDUkh3SkJCS3ZZL0dIMEFuZXlSVWFkaDhrS2kvMGVC?=
 =?utf-8?B?T0J6NlBtZ0dxNE85R3Z4dW1lNjlBOSsyM2VtN3FLbnNwaHVuZzRCZVFpSndB?=
 =?utf-8?B?ZEdsTTBHOXFXVk0zNU9pMTY5K2Zkamk3MTJTNEF4YVVpOFlNT0UyVUwrYjd4?=
 =?utf-8?B?aWFoSGt2SW5CbzNNTW5hY2NhWG1zUWhjNm1SMFA0azlCWlpqOXgrSTZUZUdT?=
 =?utf-8?B?S21XVmpyTkJVc01OMkhhNFg4M21yc0VybElDcUZxZndGRkZwN3ZZR2ZwQTdN?=
 =?utf-8?B?M1EzbWxpajhCVmlVTjl4bjVVb1ZyRWZobjV5QVR1SGFNSWZsa05rWUIvOGgz?=
 =?utf-8?B?VFRjdllkNktYMDNYOEpIblNyejdsWDhFYWxyWXNOYUZKNHBmUlAyWmU0VGM1?=
 =?utf-8?B?bjdtaFZtZFdKTldmbjV0Y0hOdWl3SnFUK1dCdzNWWW9UK0FRb013QzRjWDla?=
 =?utf-8?B?ak5leExSWUZmN0VscWdHTGtBVHd0UEFyekNJa3ErMHpIVWFOYmhINVNiYkpP?=
 =?utf-8?B?Rnlxd1M3NHFPMklqMkczZ1htc09RQlUwS1B1MnBiSlA4M1FPVUxpZHRIbll0?=
 =?utf-8?B?T204SmF2RjhTUXJQSUV6alIvNzUxdnZUTFZYT1lFaXJSVk5ieUZyWkVCamhJ?=
 =?utf-8?B?Vmo1dVl6cG1QbXZ3NHdRcGt1a0dyUHk0NkNteTRJdUlHckphaHRoSTdtS1Vw?=
 =?utf-8?B?eS9NY0hJcllEaitQZE1KRnJiL0Z2ZjB5S2xuMVliQkVaN05JeW9MRWZheVM5?=
 =?utf-8?B?L3FXdlkxYWpzY1p5YXplYjJSeU8rUXJQa3dqeFNDRXBISStZeUxNYnVGMzVV?=
 =?utf-8?B?MDErdXFnOFhvTk5PK3N0cnVBZHFrZmFZbDJ3VnpYY2RZVFh1dW9heXpIa0Z0?=
 =?utf-8?B?T0tJb01hV3o4TlVLMzNvcjdEN3JlUTFmYXU0VFdOZkpwMlhWYzVER1RyNmpT?=
 =?utf-8?B?eHhyeG5GVDY5WjNBaWdlaDJlU2lrQ2V1bGNhcitRZDVscDlaUE9sZFZ4ck1q?=
 =?utf-8?B?a05UclZUaU5GbjFadnJqMGlpU0NNZkplQ2lBY2pzbXZ2VGdadU5CblV6R1pL?=
 =?utf-8?B?N01PN2dZa2djTFljbWVSRXJ0OWVlUDVJQnZsMHNXODB6ai9YT2RLMHFSMnEr?=
 =?utf-8?B?Mm9EVEQ5dHlyK1psQWgrVWxSZSswNEl1dmFGV25ZeStXQnQxbmg5WHU0Mkpm?=
 =?utf-8?B?c3BZV2wyeE5aTnFtUHhNanRxQ1ZjblRxS1NrZEhaRGQzZzZWM29MT1B3N2xY?=
 =?utf-8?B?SDd1NjFITXlUQW1OVnZsRnQ0UG5MRytGODk1bWxOUEdBNWtRUC9INTRCVkh2?=
 =?utf-8?B?MHptUm1mMkt0MCtZTVFlR08xbGRmYnFrc1N2RjZXYTJjS3BBaFFGMEtJZ0Ji?=
 =?utf-8?B?aFA2UDkzM3p6ZVZrMWNBcTUzOEtGYmNKWjN3T3JUQ2lubVJrc0MxQk9YcjlW?=
 =?utf-8?B?amc2RTJzUHprSitYOXlLZm1LeFVlSTlkS0MwejdLL2FGNHMwNjRBOUt2MmVE?=
 =?utf-8?B?SER0VjZEQk5ZNHJCNmNhTmR4Z25CNU04YVBmMHNCbzZwbnZLaDY1Sld1VG1x?=
 =?utf-8?Q?h5brqP5IwF4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QnJDdmUzVFM0YllZWWNXTWNXRG5nTTVGSDRMb3k3dTh2VFRFVVM2YWVnRDVa?=
 =?utf-8?B?cGN3MUQvVXVzYmFKL1ZmT0NZWU4zUExHUDUyREl1Y0FpYmNMa0NuYUpUUG1v?=
 =?utf-8?B?eWVLYUVMWkhrblBvQ0daRXA0TUF3ZmJJNGtVL2NGemlsdzUrdHUxVVEwOStB?=
 =?utf-8?B?VG5MZzVyaGhjRE44OXBLZDNvY254ZzFnVkZ0UGdKazA0UFFaSFljeDhMZ214?=
 =?utf-8?B?eUx5MTJRaDNpVDBtVlEwWDFFb0FMbGhpU0t1OVk0bk1KRG9ZWkYreVhHdDNI?=
 =?utf-8?B?dlZTd1N2NHVvUmVMeDVHOE9wb1hiTGV3S3pLVkFSRGpvSW5NYkJYR0hIYVgv?=
 =?utf-8?B?dks0alQ4L1I3aytHN1h1TmtCQzJOdU40K28xaHhqZGtuWlM2WUQ2NlVIdllQ?=
 =?utf-8?B?WWcwYjRwZG5POG01NzRacTJyWnlCTDYxS1M1NkJyb0FPWlp1L0Jha1M2dURZ?=
 =?utf-8?B?U0JNejluZFBoUndzTU9oeWlLS1p0dWxsdklLRCtnb1BtaWErVGVXdTJ5bmhV?=
 =?utf-8?B?RzUyZklobzlPZTIwYVN0MnNpT2dEVWk2SnJNUkVqcVQ4dENUczAxT3JzVGdk?=
 =?utf-8?B?dlF4alN2N24xOTdEaEtVejg1c2ptZkFCZXIvSlY3bjRJSnp2Sm5BZk5Hc2pN?=
 =?utf-8?B?SzFyRzd5cVlCYUhvellzODdsTC9jZWdaRmhPNWVwY1F2N1owc1Z2MVBBeUNm?=
 =?utf-8?B?NkpxMVpSdXRvSkR5NVlSZUZ0aTV1eVRJTFd6cFRTc29WamRWbnppQUJJM1Zu?=
 =?utf-8?B?b2Q2WlZTZHJIQkpZVW0ySFpGbEUwck9jYnVCL2cxR01XRXhhR3Ztc0gzb0hH?=
 =?utf-8?B?YktsV2NPRzBLeU1oWlJwT0d0UXNCeDZJQVgrWlpCR3AyV0RZWVg3a2FWazlx?=
 =?utf-8?B?TmZnS1dHeWczNUlTK3NaZk1RVy8xQlVwWUdGRnhkKzJYdUpmUFMxMU5zOXF2?=
 =?utf-8?B?K21uT3c5VUJoWHZPcnVRL24rMnpoK3RSWVg5WnhrRjI1QzJjZGpiUHRNT1Av?=
 =?utf-8?B?eGk1NDNpeXAxeTdrcUZNVjBLYitVWnhVNTF5T3F4T0VVSXN5WEllS3V3UUNj?=
 =?utf-8?B?VGVQZjFqaERLNSs5Q3hIcTJZdEROZmswU0dOS0xLRnZVR3djTk96dDUvVzli?=
 =?utf-8?B?TGNGb1ZuU2Z2emNvNmZsNVo1ZUQ3YmFSMXB3TzdDNDlFM1NmSm81alBJbkNi?=
 =?utf-8?B?MGVFWXhzWHk4NEdwTERDc1pwdDB1ZnNGN3pwcDNsVE0ycXBnbm9Gc3ZHczZX?=
 =?utf-8?B?dDhFQzZnbkJvWjhyQlVHbGZLS0xQMGRlWVZsSnc2Zk9RQzJnbU1JN0kySWht?=
 =?utf-8?B?TEh2eElhRFNmamR4YVlpK3N6cnl5c1ZVMzBPSmkvL2lEYytQUjExUWxESWJk?=
 =?utf-8?B?cVpEWjc3OEMybjlJa1N6MW52aEI1VzRZUzNYUXQva0VZbE9PamM1UkVYMGJo?=
 =?utf-8?B?K1FKL2JoT3l0MlZ0eUFmQm5XeER1WlVoYkRPSnJpNk9GTEhDd080aGFWRVlQ?=
 =?utf-8?B?a3M5cjhTM3FmVmVDQ0xlT3FNVkJ6UGVSQ092aTdWQnIxWGszNEVVMTUyZWkx?=
 =?utf-8?B?YmppRjJ5Z2d6aGlKdVZDdGx6SnBPTFROR09wMzN2cUltdjdhTEZBTHJCU0E0?=
 =?utf-8?B?Uk81d1NPR3BnLzZrQWNRU29kWW9QbzN6bFZZZlJLdU14b2tjaSs2YzdXR1g4?=
 =?utf-8?B?d1l4MEJScUhMUGlhelZ1U2I0MHpYSkpkTVNqSGxIRld0SnNXTVROY1RFMUJ3?=
 =?utf-8?B?MnNYbmNUV0lTL000cUNZQTNFYU56Wk15SVpNRTBKU1NpbXRnQXJ1NmR6Uzd2?=
 =?utf-8?B?QVF4VE5GcHFyMi95ZW9HaE5ieVlwZWY3engxQ2xYdTZUVnJUUHNocnlGOHNJ?=
 =?utf-8?B?VDd2MFlpZ0d0dzZGOWZhR3FUTW5MRjJtb21La1NlZmZ6cmg3M3ltWTlHMXVB?=
 =?utf-8?B?U0lpV2VRN2lzbTUrbUdGNFAzcVZYdEhrV2tOVVVzT0dyamZ5SmFLTkw4UDNU?=
 =?utf-8?B?d2FGN3VTbW1JU1dHV3pUQVJSTWtmT3dNT1VCVGRlWXFiUWdDWVV1WkZrUHRh?=
 =?utf-8?B?NGZlQWFsZUtka2ZIZEJFNEZHOWtsczJIWFRaNU8zVUFDOEVxMkZjSm1uSmJn?=
 =?utf-8?B?OTJoM3IxZnhLVzdCVjZVZGg3YW1Wb3Q3RDJkOUtvbUhIN1B3TUZWaXhaYWIv?=
 =?utf-8?B?bFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BqpqiLjCunF4KL4vZMgYGjwOrgQHIlSmmotnfUAKEIhAO86HgiLcWOk9FdX9KfyLx8/hloanR96g9dabTNyU9laN6pORGlZN2Ljb2vXt4hymo10XlsJNb+xq/4CyM5OWl/uSOXOTWHZo1yskcGi+PDWNpgwKgVvqFM2P5f4vkEQCYnd86szaS+5S3NYCuDabAGWP0dEbXLE9qciALyJGgIgnBbIkGaL1Q5zR9xtyzvE/Z9gp7i2aa1DnFINrT5cDYs/6YDRU3BQxcMGW738no5cmWLawoHRHdLJPjTozhurzDwaWaDaOUHl+ASvGcdrgrQN8q21eX9BWTdMbj0K03RdGpICo/kkdaFlzUSiWJrdsSLJERUJdrBqOkIduxJYqN4ljgHBD8gXACv2J8ahnTQadEsRWQSBDpgy5XrkBNkS0B4DxvFCETL3z1OGxf+yTgowfSaubGEtTWEU7dLd9ik1ti57if5Ni/T8fMV00iu/ANVLrSgttekSWO2Cv8m9PLh6wiLePiD3QyuTjQqUNvj46bcL/dfTPBTKDmaZlWhiAtH6eCWAM7bpleM+LjNQLl0keISiRG7flxJZTjax4/JJKuCfTNqLnKUBt22x0NOc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 567a9789-bb4b-4fe3-ab50-08dde18745e1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 14:22:06.7557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hyeEj+ZXguQAmeUwPVS/n0hNsnT5ltczdT0b6kRLq5cgvvQQQ3EQzI/BOmZrTw7sX+mUWSrwA7rjiPvFos+nsBLVayYypK6GVUhG3ARp/HY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6020
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-22_04,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508220128
X-Authority-Analysis: v=2.4 cv=E+aUZadl c=1 sm=1 tr=0 ts=68a87d14 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=6hEFc_dGD_onU11VY2IA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: LQhUxmRynEi8kgPYp8ySr1d4n3slLO42
X-Proofpoint-GUID: LQhUxmRynEi8kgPYp8ySr1d4n3slLO42
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIxMDE3MiBTYWx0ZWRfX0XhCHE7zLMXW
 l0a9aU9VoFjwQ4iKOk69CjwsxfHwsHJktn3j8WaGqD+0GzshoMIkUBmSVgcB8A3si30nV3RCmVT
 NzgZ5pcusG4apSEbb9f0zZFSgksj+unTeGK4kaq6Afoh4/GdwwyWMt5q5a6xCQnvCTr+8wr9Xfd
 30/ieuMKzVGi5Yxxt/W0z2cljiqi8jrctA04u5jlrpnNy76uDioPKyEIOICJsipBz3aiIujbPxG
 KYQmfTmKrp0H47ig1Yrwd+m+ds0wHxmXiFcAMnynqilVhFHuqgjeXYH09k/55L9cQrNnPGAYYim
 dbPvWKr4eDX1FM4PIls90gE7zEmOOYRdtlzaG5k8h4TGIhSypAHxr9Vr2Iob8BTaU+FTJIyXH+R
 FEt9ZQ2/TxNQWhlZkznAg+aj4fwyyQ==
X-Rspamd-Queue-Id: D2F74C000D
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: tzbd98gb5fo9qst9pzynxs613x3e7dia
X-HE-Tag: 1755872553-486385
X-HE-Meta: U2FsdGVkX1+PO7vob5AjkGz0Q+fwD+luV9YAioLRBIxY41MzBZTpNsZkeBB3N1toLSfm9EKDms7UfzVbLlevN+5b+OKe6V9iyjkyNqxYrqB3K+B5Gmvn+0PNtYUe/t9jeVw8xP0EKyPomm+xgn7xMIoQgTf+5M1X59DVaLSjOawGEOVITV3dEj4L8uRHRsGOb0fG/XOzSEPAHHAXH10bi3mr9R55Rrb4CV4kiR2mRvdsgWJbYhWPFNC4tsgCnhADP0jWg2VGbcY3mrR6Ai5Qizemb2lD3BdJkA+sUYDj8uVn65WuliuTU/OSd5mit0a7TgYM+JCatFTGK07VreNqrGXirIfZViuHXRz4n9QI4xdtGe3tx04M2etKQpPR8wy7YMZpKI1nHeUHX39UdCtVIrS27pB6p4kQRSnyvRiqcixeBop2xwjuFAhBxrv8vOmwGvGkp6R3cSZX6Aww4PxQ8z6r3EimvINwFkKe+9lMlm6AQMbCcgfxdH0EFR4aCK4+9KGOd6g90LJRv97vdMthO9QXjJH06TvGmcttfIrbEKnS+ztjqtQR+dcGTTdeAbYqMaY58Nw1OW54NQmkugi/QWg6mOWk2QRzaFYo4E7uDiozKwfGbC8ZnowkBY+uNqcx6ZLWGLpsJ3gROl4YHPWCfgl1U+m2g2BcFOyl6Lnc0cU2bsNozpG1cgaDfHrt3MLh3s6Eh8aZQD2nf1aA2WUW4IGZBuicdLzO8hl3ijEpyOQ7sbJ0YX2MSgoorwLLXL7dvrM/Tp5NkY3OJbi+wtD0cFewTB0YgEzrrZ5DXApIe2QSvN4vbhaLEBHbHkjKwCz0k39iNrHRgwobk1qXvfrS/Y9Ei5H5JapndeBWH7Fl5Z9HYL1TGb1X4vwOimcDZ4kv71ps9wUyZ8vOQfIhZ0ScPAaSOwyO1k05W1/xVIHAycjfNABpOxPkqOYW2sp7RyH416/Se35jP80n9pufsCm
 uaVB8iUo
 8bBUVgwgxyQMPaNDLV/0gEhWynYwB/xt3C44+87M9M11Os7/chQ5vl1g3zvPw+v6R6UrrhOm3N9xKb9iNYjWAbwFOuI3xbbPPybLjLDx7lZaMenSiVOhUaP8vgIsVi8AWjtkjHcrOHrh/SU15cugTexGxJYS64/0ymWeRBS+NI/K/4jyeJNe/WaTAYqYoXH4vHBhYzdGAm1SA5BWyfPgPhlK2vv/fYhq5oAnghFuOquZlDXU8jiCN41y700+Pm/CcTSFMaa6sfuWLaVUx4ro7EJLlrVK9+bFWIs1gCfZK/WQIv2gHOhBFDmyJgukR7Q+ZeTSTUU3IIbVSMBG1mPkv/ybdAQrw8QqXX4v9WB+7HemOnokMA9WYw4nkiI1FZM7CUzxUjKspctn9XQseFgJVNZb78QN1zuTnceB998S186KxXjTTyXTdgQmQNxEmaW4EK2H7Yd7nsj2W7Kb1Tp7wN4OJihDao6NrvjMnQUastRNv1ZB6UQW4lyMSrTfWjd3rg0VFhhGxfP2cPpEd/Ojy4KWjQSOAB1tIfQNxF+IG6mvFrOCOWbhsfIhvdItB/0uPboq+PNb/8zh6h2Y3HdpIKDt0o8AJZCGfJaxZDNYmPehYWVWNeofrExJK/hLkPjGln2znUMeQrwX4B/5JjEVkXA7+KxZq0WNeT2jqZwjrQrZiltCMNbeQbPSPPrOuCVKeTnXGlqBeIfpwhz0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 12:15:04PM +0000, Brendan Jackman wrote:
> > OK I had a bunch of questions here but looked at the code :)
> >
> > So the idea is we have a per-CPU buffer that is equal to the size of the largest
> > possible folio, for each process.
> >
> > I wonder by the way if we can cache page tables rather than alloc on bring
> > up/tear down? Or just zap? That could help things.
>
> Yeah if I'm catching your gist correctly, we have done a bit of this in
> the Google-internal version. In cases where it's fine to fail to map
> stuff (as is the case for ephmap users in this branch) you can just have
> a little pool of pre-allocated pagetables that you can allocate from in
> arbitrary contexts. Maybe the ALLOC_TRYLOCK stuff could also be useful
> here, I haven't explored that.

Yeah nice, seems an easy win!

>
> >>
> >> (You might notice the ephmap is extremely similar to kmap_local_page() - see the
> >> commit that introduces it ("x86: mm: Introduce the ephmap") for discussion).
> >
> > I do wonder if we need to have a separate kmap thing or whether we can just
> > adjust what already exists?
>
> Yeah, I also wondered this. I think we could potentially just change the
> semantics of kmap_local_page() to suit ASI's needs, but I'm not really
> clear if that's consistent with the design or if there are perf
> concerns regarding its existing usecase. I am hoping once we start to
> get the more basic ASI stuff in, this will be a topic that will interest
> the right people, and I'll be able to get some useful input...

I think Matthew again might have some thoughts here.

>
> > Presumably we will restrict ASI support to 64-bit kernels only (starting with
> > and perhaps only for x86-64), so we can avoid the highmem bs.
>
> Yep.

Cool. If only we could move the rest of the kernel to this :)

>
> >>
> >> The ephmap can then be used for accessing file pages. It's also a generic
> >> mechanism for accessing sensitive data, for example it could be used for
> >> zeroing sensitive pages, or if necessary for copy-on-write of user pages.
> >>
> >> .:: State of the branch
> >>
> >> The branch contains:
> >>
> >> - A rebased version of my "ASI integration for the page allocator" RFC [3]. (Up
> >>   to "mm/page_alloc: Add support for ASI-unmapping pages")
> >> - The rest of ASI's basic functionality (up to "mm: asi: Stop ignoring asi=on
> >>   cmdline flag")
> >> - Some test and observability conveniences (up to "mm: asi: Add a tracepoint for
> >>   ASI page faults")
> >> - A prototype of the new performance improvements (the remainder of the
> >>   branch).
> >>
> >> There's a gradient of quality where the earlier patches are closer to "complete"
> >> and the later ones are increasingly messy and hacky. Comments and commit message
> >> describe lots of the hacky elements but the most important things are:
> >>
> >> 1. The logic to take advantage of the ephmap is stuck directly into mm/shmem.c.
> >>    This is just a shortcut to make its behaviour obvious. Since tmpfs is the
> >>    most extreme case of the read/write slowdown this should give us some idea of
> >>    the performance improvements but it obviously hides a lot of important
> >>    complexity wrt how this would be integrated "for real".
> >
> > Right, at what level do you plan to put the 'real' stuff?
> >
> > generic_file_read_iter() + equivalent or something like this? But then you'd
> > miss some fs obv., so I guess filemap_read()?
>
> Yeah, just putting it into these generic stuff seemed like the most
> obvious way, but I was also hoping there could be some more general way
> to integrate it into the page cache or even something like the iov
> system. I did not see anything like this yet, but I don't think I've
> done the full quota of code-gazing that I'd need to come up with the
> best idea here. (Also maybe the solution becomes obvious if I can find
> the right pair of eyes).

I think you'd need filemap_read() and possibly filemap_splcie_read()? Not
sure iterator stuff is right level of abstraction at all as should be
explicitly about page cache, but then maybe we just want to use this
_generally_? Probably a combination of:

- Checking what every filesystem ultimately uses
- Emperically testing different approaches

Is the way to go.

>
> Anyway, my hope is that the number of filesystems that are both a) very
> special implementation-wise and b) dear to the hearts of
> performance-sensitive users is quite small, so maybe just injecting into
> the right pre-existing filemap.c helpers, plus one or two
> filesystem-specific additions, already gets us almost all the way there.

Yeah I think the bulk use some form of generic_*().

>
> >>
> >> 2. The ephmap implementation is extremely stupid. It only works for the simple
> >>    shmem usecase. I don't think this is really important though, whatever we end
> >>    up with needs to be very simple, and it's not even clear that we actually
> >>    want a whole new subsystem anyway. (e.g. maybe it's better to just adapt
> >>    kmap_local_page() itself).
> >
> > Right just testing stuff out, fair enough. Obviously not an upstremable thing
> > but sort of test case right?
>
> Yeah exactly.
>
> Maybe worth adding here that I explored just using vmalloc's allocator
> for this. My experience was that despite looking quite nicely optimised
> re avoiding synchronisation, just the simple fact of traversing its data
> structures is too slow for this usecase (at least, it did poorly on my
> super-sensitive FIO benchmark setup).

Yeah I think honestly vmalloc is fairly unopitimised in many ways, while
Ulad is doing fantastic work, there's a lot of legacy cruft and duplication
there.

>
> >> 3. For software correctness, the ephmap only needs to be TLB-flushed on the
> >>    local CPU. But for CPU vulnerability mitigation, flushes are needed on other
> >>    CPUs too. I believe these flushes should only be needed very infrequently.
> >>    "Add ephmap TLB flushes for mitigating CPU vulns" is an illustrative idea of
> >>    how these flushes could be implemented, but it's a bit of a simplistic
> >>    implementation. The commit message has some more details.
> >
> > Yeah, I am no security/x86 expert so you'll need insight from those with a
> > better understanding of both, but I think it's worth taking the time to have
> > this do the minimum possible that we can prove is necessary in any real-world
> > scenario.
>
> I can also add a bit of colour here in case it piques any interest.
>
> What I think we can do is an mm-global flush whenever there's a
> possibility that the process is losing logical access to a physical
> page. So basically I think that's whenever we evict from the page cache,
> or the user closes a file.
>
> ("Logical access" = we would let them do a read() that gives them the
> contents of the page).
>
> The key insight is that a) those events are reeelatively rare and b)
> already often involve big TLB flushes. So doing global flushes there is
> not that bad, and this allows us to forget about all the particular
> details of which pages might have TLB entries on which CPUs and just say
> "_some_ CPU in this MM might have _some_ stale TLB entry", which is
> simple and efficient to track.

I guess rare to get truncation mid-way through a read(), closing it mid-way
would be... a bug surely? :P

I may be missing context here however.

But yes we can probably not worry at all about perf of _that_

>
> So yeah actually this doesn't really require too much security
> understanding, it's mostly just a job of making sure we don't forget a
> place where the flush would be needed, and then tying it nicely with the
> existing TLB infrastructure so that we can aggregate the flushes and
> avoid redundant IPIs. It's fiddly, but in a fun way. So I think this is
> "the easy bit".
>

Cool.

I guess starting conservative is sensible for security though.

> > It's good to start super conservative though.
> >
> >>
> >> .:: Performance
> >>
> >> This data was gathered using the scripts at [4]. This is running on a Sapphire
> >> Rapids machine, but with setcpuid=retbleed. This introduces an IBPB in
> >> asi_exit(), which dramatically amplifies the performance impact of ASI. We don't
> >> know of any vulns that would necessitate this IBPB, so this is basically a weird
> >> selectively-paranoid configuration of ASI. It doesn't really make sense from a
> >> security perspective. A few years from now (once the security researchers have
> >> had their fun) we'll know what's _really_ needed on this CPU, it's very unlikely
> >> that it turns out to be exactly an IBPB like this, but it's reasonably likely to
> >> be something with a vaguely similar performance overhead.
> >
> > I mean, this all sounds like you should drop this :)
> >
> > What do the numbers look like without it?
>
> Sure, let's see...
>
> (Minor note: I said above that setcpuid=retbleed triggered this IBPB but
> I just noticed that's wrong, in the code I've posted the IBPB is
> hard-coded. So to disable it I'm setting clearcpuid=ibpb).
>
> metric: compile-kernel_elapsed (ns)   |  test: compile-kernel_host
> +---------+---------+--------+--------+--------+------+
> | variant | samples |   mean |    min |    max | Δμ   |
> +---------+---------+--------+--------+--------+------+
> | asi-off |       0 | 35.10s | 35.00s | 35.16s |      |
> | asi-on  |       0 | 36.85s | 36.77s | 37.00s | 5.0% |
> +---------+---------+--------+--------+--------+------+
>
> My first guess at the main source of that 5% would be the address space
> switches themselves. At the moment you'll see that __asi_enter() and
> asi_exit() always clear the noflush bit in CR3 meaning they trash the
> TLB. This is not particularly difficult to address, it just means
> extending all the existing stuff in tlb.c etc to deal with an additional
> address space (this is done in Google's internal version).

Cool, sounds like it would just be a bit fiddly then.

>
> (But getting rid of the asi_exits() completely is the higher-priority
> optimisation. On most CPUs that TLB trashing is gonna be less
> significant than the actual security flushes, which can't be avoided if
> we do transition. This is why I introduced the IBPB, since otherwise
> Sapphire Rapids makes things look a bit too easy. See the bullet points
> below for what I think is needed to eliminate most of the transitions).
>

Ack.

> >> Native FIO randread IOPS on tmpfs (this is where the 70% perf degradation was):
> >> +---------+---------+-----------+---------+-----------+---------------+
> >> | variant | samples |      mean |     min |       max | delta mean    |
> >> +---------+---------+-----------+---------+-----------+---------------+
> >> | asi-off |      10 | 1,003,102 | 981,813 | 1,036,142 |               |
> >> | asi-on  |      10 |   871,928 | 848,362 |   885,622 | -13.1%        |
> >> +---------+---------+-----------+---------+-----------+---------------+
> >>
> >> Native kernel compilation time:
> >> +---------+---------+--------+--------+--------+-------------+
> >> | variant | samples |   mean |    min |    max | delta mean  |
> >> +---------+---------+--------+--------+--------+-------------+
> >> | asi-off |       3 | 34.84s | 34.42s | 35.31s |             |
> >> | asi-on  |       3 | 37.50s | 37.39s | 37.58s | 7.6%        |
> >> +---------+---------+--------+--------+--------+-------------+
> >>
> >> Kernel compilation in a guest VM:
> >> +---------+---------+--------+--------+--------+-------------+
> >> | variant | samples |   mean |    min |    max | delta mean  |
> >> +---------+---------+--------+--------+--------+-------------+
> >> | asi-off |       3 | 52.73s | 52.41s | 53.15s |             |
> >> | asi-on  |       3 | 55.80s | 55.51s | 56.06s | 5.8%        |
> >> +---------+---------+--------+--------+--------+-------------+
> >
> > (tiny nit but I think the bottom two are meant to be negative or the first
> > postiive :P)
>
> The polarities are correct - more FIO IOPS is better, more kernel
> compilation duration is worse. (Maybe I should make my scripts aware of
> which direction is better for each metric!)
>

Ahhh so, right. I just saw it as a raw directional delta so either you
decide +ve or -ve is good. But that makes sense!


> >> Despite my title these numbers are kinda disappointing to be honest, it's not
> >> where I wanted to be by now, but it's still an order-of-magnitude better than
> >> where we were for native FIO a few months ago. I believe almost all of this
> >> remaining slowdown is due to unnecessary ASI exits, the key areas being:
> >
> > Nice, this broad approach does seem simple.
> >
> > Obviously we really do need to see these numbers come down significantly for
> > this to be reasonably workable, as this kind of perf impact could really add up
> > at scale.
> >
> > But from all you say it seems very plausible that we can in fact significant
> > reduce this.
> >
> > Am guessing the below are general issues that are holding back ASI as a whole
> > perf-wise?
> >
> >>
> >> - On every context_switch(). Google's internal implementation has fixed this (we
> >>   only really need it when switching mms).
> >
> > How did you guys fix this?
>
> The only issue here is that it makes CR3 unstable in places where it was
> formerly stable: if you're in the restricted address space, an interrupt
> might show up and cause an asi_exit() at any time. (CR3 is already
> unstable when preemption is on because the PCID can get recycled). So we
> just had to updated the CR3 accessor API and then hunt for places that
> access CR3 directly.

Ack. Doesn't seem... too egregious?

>
> Other than that, we had to fiddle around with the lifetime of struct asi
> a bit (this doesn't really add complexity TBH, we just made it live as
> long as the mm_struct). Then we can stay in the restricted address space
> across context_switch() within the same mm, including to a kthread and
> back.
>
Ugh mm lifetime is already a bit horrendous with the various forking stuff
and exit_mmap() is a horrendous nightmare, ref. Liam's recent RFC on this.

So need to tread carefully :)


> >> - Whenever zeroing sensitive pages from the allocator. This could potentially be
> >>   solved with the ephmap but requires a bit of care to avoid opening CPU attack
> >>   windows.
> >
> > Right, seems that having a per-CPU mapping is a generally useful thing. I wonder
> > if we can actually generalise this past ASI...
> >
> > By the way a random thought, but we really do need some generic page table code,
> > there's mm/pagewalk.c which has install_pte(), but David and I have spoken quite
> > few times about generalising past this (watch this space).
>
> OK good to know, Yosry and I both did some fiddling around trying to
> come up with cute ways to write this kinda code but in the end I think
> the best way is quite dependent on maintainer preference.
>

Yeah, the whole situation is a bit of a mess still tbh. Let's see on review.

> > I do intend to add install_pmd() and install_pud() also for the purposes of one
> > of my currently many pending series :P
> >
> >>
> >> - In copy-on-write for user pages. The ephmap could also help here but the
> >>   current implementation doesn't support it (it only allows one allocation at a
> >>   time per context).
> >
> > Hmm, CoW generally a pain. Could you go into more detail as to what's the issue
> > here?
>
> It's just that you have two user pages that you wanna touch at once
> (src, dst). This crappy ephmap implementation doesn't suppport two
> mappings at once in the same context, so the second allocation fails, so
> you always get an asi_exit().

Right... well like can we just have space for 2 then? ;) it's mappings not
actually allocating pages so... :)

>
> >>
> >> .:: Next steps
> >>
> >> Here's where I'd like to go next:
> >>
> >> 1. Discuss here and get feedback from x86 folks. Dave H said we need "line of
> >>    sight" to a version of ASI that's viable for sandboxing native workloads. I
> >>    don't consider a 13% slowdown "viable" as-is, but I do think this shows we're
> >>    out of the "but what about the page cache" black hole. It seems provably
> >>    solvable now.
> >
> > Yes I agree.
> >
> > Obviously it'd be great to get some insight from x86 guys, but strikes me we're
> > still broadly in mm territory here.
>
> Implementation wise, certainly. It's just that I'd prefer not to take
> up loads of everyone's time hashing out implementation details if
> there's a risk that the x86 guys NAK it when we get to their part.

I think it's better to just go ahead with the series, everybody's super
busy, so you're less likely to get meaningful responses like this by doing
so.

>
> > I do think the next step is to take the original ASI series, make it fully
> > upstremable, and simply introduce the CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
> > flag, default to N of course, without the ephmap work yet in place, rather a
> > minimal implementation.
>
> I think even this would actually be too big, reviewing all that at once
> would be quite unpleasant even in the absolutely minimal case. But yes I
> think we can get a series-of-series that does this :)

Well generally I mean we should just get going with some iterative series :)

>
> > And in the config/docs/commit msgs etc. you can indicate its limitations and
> > perf overhead.
> >
> > I think with numerous RFC's and talks we're good for you to just send that as a
> > normal series and get some proper review going and ideally some bots running
> > with ASI switched on also (all* + random configs should do that for free) + some
> > syzbot action.
> >
> > That way we have the roots in place and can build further upon that, but nobody
> > is impacted unless they decide to consciously opt in despite the documented
> > overhead + limitations.
> >
> >>
> >> 2. Once we have some x86 maintainers saying "yep, it looks like this can work
> >>    and it's something we want", I can start turning my page_alloc RFC [3] into a
> >>    proper patchset (or maybe multiple if I can find a way to break things down
> >>    further).
> >>
> >> Note what I'm NOT proposing is to carry on working on this branch until ASI is
> >> as fast as I am claiming it eventually will be. I would like to avoid doing that
> >> since I believe the biggest unknowns on that path are now solved, and it would
> >> be more useful to start getting down to nuts and bolts, i.e. reviewing real,
> >> PATCH-quality code and merging precursor stuff. I think this will lead to more
> >> useful discussions about the overall design, since so far all my postings have
> >> been so long and rarefied that it's been hard to really get a good conversation
> >> going.
> >
> > Yes absolutely agreed.
> >
> > Send the ASI core series as normal series and let's get the base stuff in tree
> > and some serious review going.
> >
> >>
> >> .:: Conclusion
> >>
> >> So, x86 folks: Does this feel like "line of sight" to you? If not, what would
> >> that look like, what experiments should I run?
> >
> > From an mm point of view, I think obviously the ephmap stuff you have now is
> > hacky (as you point out clearly in [5] yourself :) but the general approach
> > seems sensible.
>
> Great, thanks so much for taking a look!

No problem :)

Cheers, Lorenzo

