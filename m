Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CD1DC87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 18:05:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE01D6B00B1; Thu,  7 Aug 2025 14:05:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A89BB6B00B2; Thu,  7 Aug 2025 14:05:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 929DF6B00BB; Thu,  7 Aug 2025 14:05:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 82C386B00B1
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:05:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 381351DDFCD
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:05:00 +0000 (UTC)
X-FDA: 83750737560.06.4E32F12
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id BACEFC0005
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:04:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bQX8n1iJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=yl0J1oGx;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754589896; a=rsa-sha256;
	cv=pass;
	b=bIG0uhLyHVm8RnCEFGBG1BfApUW891/Pcu5c8G1t9UNeEBP0pslpblc5K98ttADTBa0w56
	ShnP2+Bzr+fnV1RHoF4SqMr7JtOIUUbobcm1zVjKmn9oDLtOA3FA5jiyrsnkILy9BvlHb3
	CCqDHRpC/+qnIWEv6IYpOy87qrFgac4=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bQX8n1iJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=yl0J1oGx;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754589896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ht/vylqH17oUTYQyoBibckdjU+iFtCdqPllzGTPfbbE=;
	b=7q5jwcNCaM5iR2bluo0560HRo0T/E/yBkRc4qQKgM+HNDsyHDM+CPxPPrEqVC7V7gmFOTp
	Om9PYWc1oMZ7H43zdU1E9OBOlvk3YxOodUUyssLKdeSZb6Nf+BaD+c+tz54u+NxBG+cTnt
	549AAPM2txIdvlAtWuSsdeoYd5/VEsE=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 577HC7Hu024922;
	Thu, 7 Aug 2025 18:04:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ht/vylqH17oUTYQyoBibckdjU+iFtCdqPllzGTPfbbE=; b=
	bQX8n1iJIzcC1IhXPvhMwpZgvIKW18qxqmM6d67zQOGfNUDQN49cDStbdcmRpmY1
	HG4kb+XE4kNGm/673PADLzGqr98/9hPxhFLhVveVhuNrKXc1C49zAU3fetpeJUZe
	/iykWI600TpiW9DZ2IrGLOg63D+S0zG7TZOJb6gU3dMNhKfvSL74cE7iKUyNiPDt
	9ta1ZXtsn1+wH6qYTpmkAxHumVu1dmhcH55apbSK8yuUZgf6BlrQzIl0IZVcvEzY
	Z4WMcmqqcGBc7mWsBfuylem4o0Flb9FyPPTSpGa1YwGfEAo2/l5/snCntXfAF+/G
	+LiSetk2B/w6vxlpHRPBxg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpxy4vau-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 18:04:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 577HoCUJ027261;
	Thu, 7 Aug 2025 18:04:30 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwprcrc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 18:04:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VkRASBrLX4af2nLZlxoIQ8gxOuvznKnIT23o/NDdYnX9Ql7Nc/H0pkK4gFjqCIblYPTKjzJ8VTNyqUBzGA08VsckLP/NkZBok6rR5H56caWzvyQC9RbqlW346au520zZcXlsRs88x7fjjdtnYl9TRkETLlg2Yx2B13RivVrTpsDPVUNi+JlucrvTLHbFmjbf6ceMibLcJL4Wokwq2PJEp0LHjZ0EFjjuKkegSbdGSSE42NQiEfY0+EP/4NWC2Ni/9VfVzLwLgXmLQXbWtcBlxRvAKf6umImvQ3ZRoCGKt5kgiDdSTNygywgI/1SJOgp62+92GXCLrr+q6b/R4pkFng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ht/vylqH17oUTYQyoBibckdjU+iFtCdqPllzGTPfbbE=;
 b=JRXFXx/S/X/B00XYVp4jb3kPKXbhNb/ii6ZkhktoXXecnWCtc9cPGEM0FJtiar3TDqYq5NyYqAK2vxgwB7kWl/bTL/NlPCQq3WJySl5/1ZApS+HmfYnJm27cy4S089VdSMly0UMCNMQ5bvje8fwppDX86fo7WXdHWmST/tA+70SLlD0Bxz8rHYIbLarUH5t35EaS+yijZDU4opMzohp9S4O1aHM2/yXky2gX9jK3R2poQ1uC+SuINX9z2HTXe3sYfWy1WZqk9v9qOS/vcNvRyi0/aluJ5Nlj7HZSeeyUXzSEY2GhVyfoId/aeEt40bWtyZRelWdqzfIPqwW0H7ocQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ht/vylqH17oUTYQyoBibckdjU+iFtCdqPllzGTPfbbE=;
 b=yl0J1oGxK29LXP3A7EpLv6DUg5ojEAVuXIBjV6GR7NKpHEdGegsn9po1sY2TxkvlJFVwuCndKxmYGqZ9+aNNC1xaPM3q+ypEmtx0CM+RBbB0jgkkPzHs4i36JlA6X7CE3wwG94J1+J25y6urs14uwde86QTRUOKrBhHxs3XAa1Q=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB6423.namprd10.prod.outlook.com (2603:10b6:a03:44d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Thu, 7 Aug
 2025 18:04:25 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 18:04:25 +0000
Date: Thu, 7 Aug 2025 19:04:21 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>, kernel test robot <oliver.sang@intel.com>,
        Dev Jain <dev.jain@arm.com>, oe-lkp@lists.linux.dev, lkp@intel.com,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Barry Song <baohua@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Bang Li <libang.li@antgroup.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        bibo mao <maobibo@loongson.cn>, Hugh Dickins <hughd@google.com>,
        Ingo Molnar <mingo@kernel.org>, Lance Yang <ioworker0@gmail.com>,
        Liam Howlett <liam.howlett@oracle.com>,
        Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@suse.cz>,
        Yang Shi <yang@os.amperecomputing.com>, Zi Yan <ziy@nvidia.com>,
        linux-mm@kvack.org
Subject: Re: [linus:master] [mm] f822a9a81a:
 stress-ng.bigheap.realloc_calls_per_sec 37.3% regression
Message-ID: <2f0fef16-14ba-4195-b2ec-aabc69f445b1@lucifer.local>
References: <202508071609.4e743d7c-lkp@intel.com>
 <9e3a59b2-11c0-43ca-aff3-414091f04aa4@lucifer.local>
 <CAG48ez3=8f3eShjAe9hrvivP+Dvyisw=X_Tr_phc-OX_4MzeDw@mail.gmail.com>
 <be074809-e1fd-43a2-9396-8f7264532c4d@lucifer.local>
 <CAG48ez3=kLL4wBxAVSa2Ugrws+-RFQMdNY9jx5FAdbhpNt8fGg@mail.gmail.com>
 <e4f5faea-ccec-4cc7-83de-1a3c7013b81b@lucifer.local>
 <cbc2e23d-69ab-4820-9942-c7abf2066ff7@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cbc2e23d-69ab-4820-9942-c7abf2066ff7@redhat.com>
X-ClientProxiedBy: LO4P123CA0612.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB6423:EE_
X-MS-Office365-Filtering-Correlation-Id: a5014d5c-83a4-4ec7-ff23-08ddd5dcd844
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WUNYRmsvdW1HRkZYOGRSdjg3NEdJZmdFbkxiT0JJSDNTOEJSZUNtMjg3VThK?=
 =?utf-8?B?SXV1Uk1tZ1ZvRWxINDZZN3JXZlA0OGxvUnd5TFdYb1BVTmUyeVRteDFFT1B6?=
 =?utf-8?B?WlkvRm8rYXlxeGhsQURtVUtrR29TeTZyZmRTdG5idGtaVm1rRjdRbDZuaTdR?=
 =?utf-8?B?SXY2YUpMbDhoQ0dsMm9LVzJqanFrU0d1Y1hGVmtoRnVjS2Uyb29QdDdNaHNz?=
 =?utf-8?B?Y3U1UW9FKzZaVFRLYzA1aUdGUXFxcENIMVNYOGp6R3VrVENvNlR1RUc1WWJ2?=
 =?utf-8?B?MmlaVGVMMzJPRDNOeHlGYnMwOTVBQmtPUEZRTHZpQTlVLy9xV0xvUGM2Wito?=
 =?utf-8?B?Q1RRSFkyWXZPK2Y4OUV5elhxZ2hvL096WE1Fd0pGTnU1UkF5aXpWeGFvMTVN?=
 =?utf-8?B?ZUJtc3JKVmttdkdKYlpXWkJoWTRaTUJSWXRwN2FLMzQ5dzlLNnVmRnM0b3Ux?=
 =?utf-8?B?VzU0bXo1eEdMVkRHYnJMU0tZR2VSeGJpbUhDRnRkOW9TSW44L1lNTjRCMGxu?=
 =?utf-8?B?VE1ob0xYYjA2K2xvVkZOdmZiMHpKam44cWVTWjV2WEEwZXlnM0JZNE5uVUFY?=
 =?utf-8?B?c29heVMrYVF2ZVZNbjVDVXpvcUZ3WHVRdnpNWGJCRGtIdzJpTmhTNUwzeUY4?=
 =?utf-8?B?SmliaUpLSE92M3hPcFZ1MWlIVFp4aFVWd09xTkdoNjlyTnIvS21BWFhZdlNu?=
 =?utf-8?B?TXJ2TkFzeitDblZYejRBaVBMYWUxWGUvM25iVWZEUUFYY3BsLzNObCt3TVBV?=
 =?utf-8?B?QTFrdmdhYTlJWjFXTnpLZnFDem5abzFxWXYyL2tJbEh0bWZnaDNYcTlpZXhB?=
 =?utf-8?B?cnZabG10QzY4dEl2YXMyelhTbEp4YS9hazllYVQyYmlKRjhDa1ZsYi9uUXc0?=
 =?utf-8?B?L25NNzJvZjdVZjVBWmpwRUROeURscWx6NlBGclprVEVINzBqeFhPUkZLTVJW?=
 =?utf-8?B?VjZvdXdFVGd3ZzA2WlJ1Sk4rbEhQSUMvL3FWSnA2Mll3SkNDNGZRNVVZVGtH?=
 =?utf-8?B?YTZtazZkNzdxQlFHTThiaTdDbmkvZ3lzbUFYVHBLdXFlYXcvbHgwMVJwQkF2?=
 =?utf-8?B?SU4vNkwrblJRSVhyWUhOWU1OOVRrdkZNVWxHQVZWelFTK2s3RGY3SlFMa0FB?=
 =?utf-8?B?dm1mRTZhc1RUV0F6L2p6eXp1U1V3ckkyNkJLeWd6aUttTVpZQnNzNVhVeGRk?=
 =?utf-8?B?WmJLVWFNaWlLdk1IdnQxUC8yY0lGVFZtbzZyNWgwMlMwR3ZMTVVRdzhxd2RP?=
 =?utf-8?B?TVdNbHlmRXVTdXBQYVNNbUpMdS93UnlLZDJPWGFjV0pjY2R4OEc3ajZsTHRt?=
 =?utf-8?B?Vmc3UTA3L3lFZFFXUXVCQlpkalRHZEpDZFltRW9PWmduRjQvaHppZEhWNk1q?=
 =?utf-8?B?RVBPcVVRb1pVM1JSclZ1akZVQlIrV2FDa0hmaFpWQUUrZTJBUW00MVFtb0g1?=
 =?utf-8?B?N3lST3I1cHhPelE1V3IrU012eEVrMExtL3ozZ0I0b2ZNM2x1bVNjQm51RWZa?=
 =?utf-8?B?VGI3U1cxTnhxN2VSU3NNTERmdENVSFpiTklIY1VJaXRrMGlEUXNxY3lEd0tS?=
 =?utf-8?B?bWhrNUVNK2RmcG1aMlFza0d4S25DOEhzZDFlSnVhd2hCVE1uTFNLRFZTYzhp?=
 =?utf-8?B?M0hkUm1mUVM2RnhlZzJjcm9ITFpGWCt0Z2pEZGZzeUxBcXRvN0hEOW5LemV2?=
 =?utf-8?B?Tm05aFlyaW02VHg1a2dFMDd4VXdWeTByMjdPaUtteCszaStrcmZHeENBM2Zq?=
 =?utf-8?B?dWhYQUVoRlBPdWtOOXBsclZiOU1VMHpQSFpNSXlncW1DVElDRUdQZFBSKzh6?=
 =?utf-8?B?MkNOOU9ad1d3ZHJCcXlpSkh6ZDUwMHJFbVNwTGRoemNOZG03Q3N5NUUvdnRo?=
 =?utf-8?B?N1ZIUlBNYjJXSnlzNDJWUE9OKzNvWkMyTWV6RWVBQjRqUjAwSmxyTGRuSjhO?=
 =?utf-8?Q?OZE5R0tP/e8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dVl6Ri90N21uQ3FQelRVRHk5L2RHYjJjbWxEckFuTVRVYmxPcmxDdlExU2xQ?=
 =?utf-8?B?MmdFVkc1cDZFZEphYVhXV1dSaXdYS3J2Uk82Q3ZiT0tMN2luTzhqRklhZDJ4?=
 =?utf-8?B?N1V0S1JTNm5ZYXVqbGs3WnlOMVZrVjBOcnFWalZ3WmhZcTRuOUNob2ZwQU9v?=
 =?utf-8?B?bnBXKzRXVVN0aFVZdXJ6ZllSaE9LR29lYlM1RTJpQncxR003VCtjdHZOaExR?=
 =?utf-8?B?czRGN2VjRmJnU0J6d3kwOXFxVnRrWlRKSHpmWm9LZXJGeTRsMzhZOWlncTNq?=
 =?utf-8?B?VkFXYndoOVhCcUdPSWxzeEtWeWNoSmpqMFBuL3NrNFRSK01XTEFvaUZsc0R1?=
 =?utf-8?B?RjJxZW9qZDJvMFRGSTZYN2pYcEdqMHhSZytxUEJ6VjA4VEdtWGR5alVrWmFU?=
 =?utf-8?B?Wk1ycmFhenc1ZTZrTGx1elhCTmZwMm9FMXB5Nm05Q1BNc0I4WmFhdnJDaHQz?=
 =?utf-8?B?SnVTd05rMXN1VzEzR3BZcDRieERqZklZenlaSVQwa2xlT2RtdDlEYnRrWkc3?=
 =?utf-8?B?czFiOUd3WU5qVkhUemt3dllLaU9mSncrS2swNm5xWkdzY1g0anN3azhvTUV3?=
 =?utf-8?B?WVJFY3p1c0dKS1FjS2M1NEJUamVER3pOcTMyQWhSL2N2KzhVQmptSzd2VWlt?=
 =?utf-8?B?UkZuRDNxZlBtditZQVJzQ005V2E3c09UM1FmcVIvQUVpL2pyREpjQmkyL2lC?=
 =?utf-8?B?dk9Qd1Nsekp6MGg4a2VCWGhES043UUkyK2tqcmtPRXI1TnBPZU4zd3dGbitG?=
 =?utf-8?B?VmhQRm9OdFpEN0d5TzlRS1U5UW4yS2NtbDBzeXBGRlIzbUd0V1pGVFY5TGIr?=
 =?utf-8?B?d3owWEpLcWVMMVBLUzBBUVNMdkVyUGROV0ZoOC9vajhrY3RxS0lteDBBSlFB?=
 =?utf-8?B?QklGU0NvNGxhWENQZUZkUGNLMFN6OTRObFdKNitkNklLN0IvZFBMY1B1NUg5?=
 =?utf-8?B?YXJieHFPQ3JhSGIxNm1UTE5NcXdXWW90T0czTFB5VmRPc2hpUUNKWEpBYW00?=
 =?utf-8?B?VG9ZQ1RTZUE2a1QzRlVGWUJKSk1ZNktmWVo0R2NVWXV3R25LZUp6SzgrcnFQ?=
 =?utf-8?B?a3JKbEhWMW42OWV6ZVNtYWNOd3pQZW14MW1xUGtxRkt5V0NmVk9mZmxvZ2N3?=
 =?utf-8?B?ZTVtQ1lkU3Y2ZHFweFVyVE9ObmVpem1ZZjFWbktDRjJqalF3RFc0ZjlrQ0hQ?=
 =?utf-8?B?a0NZNC9zYXA5RjhIUXVJL0xFMmsyN3JBYnF5cHM0Z3diM0xGWnBJckx1bThB?=
 =?utf-8?B?dVdMU2RsaVJDRnZhNmNlckZHOHNtRzRDWGxYb0VodWQvMm9hMUIvZHg3YzNp?=
 =?utf-8?B?Wk9BMEw5MnRaMGFvM2JrR2RKaDZRVzFjUHdUMjZCOEJEaVI1TURWWjhCeUF0?=
 =?utf-8?B?TDMwa0tCZ2lpNU5WZ3VaTGlGWXJQbzV0cEtGeU5jZjBGdlNpYmd4MFBQeVJ3?=
 =?utf-8?B?eUp1T0tpbjl0T3lpSi8rM1ZOU0oxOWw4T0NCckJCWlhLUWdnQnNoMUhMS2o3?=
 =?utf-8?B?WlFpbnF0TitENlNrUkhxWEdaQW9udDB4eEw3Y3Zna2ROQnJGejRXYlhZK3d0?=
 =?utf-8?B?YjhoTW9hV0hvKy9GbHo2anFSZTFxM1lWT0hlQzBRYWdhaTMzYWhhRjhadWtP?=
 =?utf-8?B?TERpck50c09oMEl6TDhKVmpnWXZuUGhMWlVPT0lyS2c5TnlOd2JEVEVJZTBl?=
 =?utf-8?B?SHlVRTByRUl4R1lPZjFNS3gvdHZOQ0JUZFFURmRCMTBqeXdaci9iMWtNWEFw?=
 =?utf-8?B?all5VWVEdlMxd0E1REM3MXVKbFNFSk04ZldtOGN5TVVHWFVCZCt1QU5PazZp?=
 =?utf-8?B?WjN3bThFMG1tQjI2dFlZYVptK0l2MkJtRzVBOWx0VlZlOWk5Ym1BMzVoa3Nu?=
 =?utf-8?B?aVdLSytiZFQyZFB3R3A3ZlZudFdIOTFZdDQxWUI0TGw4dEVKVE1LMWsyZTdO?=
 =?utf-8?B?ZHdtVSs2QVlrTW1iWHJzWEVweVZPWjY2bVVqQ1ZsTFp1bTVkVEthTTJiOU5V?=
 =?utf-8?B?SkNMUWlQS0FLa0JxZm9nWVRGa094end6Y1ltbmxtK1RVaUVyanpIbTRicmM4?=
 =?utf-8?B?UUFxWDVsNFkrNzRXeU1IWHh6cVNMTUpQTTZyYXl2R3M5UmNqUkJMMDYxV3Rz?=
 =?utf-8?B?L3F3ODV6bjJ0OUZRNDNjT3BCVjhzWVJjelI1RlJFRy9wa3dPT014MGFaNDEx?=
 =?utf-8?B?c1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nf8pb8e6qKakNpTlZSkvryZdTZz3sJ/GqXDH63S6ajvL47/CvZF0CTnpktt2KAgs2PCYtIsmGk6hUPIbobL3x+/rGc09C+qdLgRM5+bzzZjfeuaVjNMTpijxMuNDmNufMgCmhddEbuCZ++f6olaLAh0OCtZQdeZNJ13meV0HE7+tZuoC9xj/7C4DRp+He+NGhYynrmGHpSugVMYzG4LB+DfPXq5eDCaIhNjbb3ikEaPJ6p9666M+njLXt0rDfRBDDycvdy8/no2Z2s+G1RtV7R1QF7L2FTJoPOtc3M0G3UN8Qt22GQyM8wW/1PDeXEi/FcDyfIibOS+IkG2K3ZHOvpi2LSX0ZY+x+/WCUGXXsnquNbCpSEjQq0ST1LZuSxBov5XadhCbEh9NKgrVefw18I5PLK+o6lcqeEx6VcMJnY39aH2aLG8+mXY0BgiZxFpMc0hUMFw/Xt+pLr8oWCFJsA3z+pd7uwHFD83SBYOZCFlRC5mDfNZ0GLs3ZS8lANrMIXP/3CO3m8fKJs+ZTGqREQ2N9M2PNwqguy4+a+tIodJiH5JGrZ4MUlLJxI3s02P4zOk8Zo38fFtJxPntzboNv8fAJi6waAbrrcy43vpQ/TY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5014d5c-83a4-4ec7-ff23-08ddd5dcd844
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 18:04:25.5035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OPGY9SRYhcU5SV89Om1JJOXXhK07JPw6SZDfsYtyVsEeRtd9d8WQ92fbI4Tl0KyeJEdzN/0y4ZcF0IDaV3xPRuxMAiY6+eXFbJ8PAqQ9Pt8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6423
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-07_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508070147
X-Proofpoint-GUID: mBEczwCN48_ywt3UqNZnDHM72ltKfEiE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA3MDE0NyBTYWx0ZWRfX5A7l8EEWy2w3
 wy5fdsL5a10ZmHua2aS8PAqgiJ27jh8k8mtQTt3f6+rzvDgC3MofCYMkNhqEHXhaH6xbmuDTnoo
 d/x5BerJvnFSrb5EJ6RBCXnJXL3LyqM5ffPBgUNtG4us878tJlSlPN5XfpC4MoLe7sp8eoRPwJ2
 30xPnJ3VG/48Sl7SuW4JiQXwAUMpJhvYnTHuYEza3F7wpTu6ZULNXCNjnWCkKJhCVM28W//5FWO
 7S+7LmvdcI4YblY+ey6xUfRTrmtLrjboneZeXpRPemZYZ4CZScVzgf7BIpA8o5iqhkWDKlano5s
 keYUF4ThU4VG8mt+fLlxeMmXCeKCVh/QiXW2qIVKGSR83xV1XAGpU97++GhPNC/RbLc+pVRxcCr
 /8lI3PQjWYO9T4WdsPGNKtxLFOGKimostUU1Gz0s1/uRIeyd7RFkY7sbjLRKf/+HOCihB1uJ
X-Authority-Analysis: v=2.4 cv=Y9/4sgeN c=1 sm=1 tr=0 ts=6894eaaf cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=yPCof4ZbAAAA:8 a=UP7ut5tp85dssmsm4U8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: mBEczwCN48_ywt3UqNZnDHM72ltKfEiE
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BACEFC0005
X-Stat-Signature: 836rg5prx3fwgek6akx1ej1d967c9muu
X-HE-Tag: 1754589896-703523
X-HE-Meta: U2FsdGVkX19mnzoLoQ7bI2hxG+YuDRQLsYFaPTBP9A6zXzlWLU8QEBwqN94jUWKrbBIt6o12oyJEe4JwsRKTSJm0EgEDk4MmF+LTXfSepqvYCWuS4d/dTCZ9N0Wm13g4yqzncx0FXR6n0sWX7e9lnpZP/c+BqvZiQLuqw5KTnsD9zGr7vFs8AEh1N1Ddnaehsq+Ab9f4YDGwSxBP7Jm5Jo5rhC7D/ReLx5eLAXc+a8+j9EjEsgPyxPUlbXOE96JYNhyJ94ONQfvym9L0/f5HIxo5PNUESFaS4F/KjtMfMaV0SuIESvCcxid8BSU4VDINlZLcWTI5V+vga2S4i9xQhwa7mLwdHGeyDKdcD7qJyZcGr2gze3ULg97BkgxHl1SpyDgY/xsFgwAN8O9xliPoT/1qV8GHVyuA2eRLHywULdkyybecKx1MO+Y+93fSGv/rZ5mnEsOo0OBOYnmQ11dWDTbQVwfyJU3hAVDxFCx88ePPWiH3zdMIizsYv35VUxdkY5tz9gKfVdhDcavKdxAKRO+OZ469oinLkoTVjv6ROOEESlCmRziMW0/ViWbofmwCOUx9wYgqndSqc7v9PJzQtWIfe5tMfITX5/NNKbCHQ+6WrLPHqOaxXUDfOEXNW4wud91YHgeJ8TUrIGcjjQK68cbSFPSbES2cjbQ74tU8aYujUFB8WfdcvCLnSavI0Ol0a1ffZqJSTaUaBmGc6h27PbDu4T7Uc+ysrf2b6NRxX9dU+FZTiO7ycy0qRsoB7Kmk7JuM6SMku5VoDJr4wzZptdWeR7cZOxJI2UIBWjeJuklPZIMwXkcVGfDeg4+xVoab+UOILcFqGdB/tmJeu5UTPPxbuqRM3+Uvs33TSymbZB36MltrBHTn9v3g2cWo/hkIXDCzGaIpBlA5JxR6Rpka/nVD7skaBP6yro20WQcgNkoZD/iLCdTm82icg+IWtXcSfcXJltp54qhA1/u0oTq
 Yv/v53om
 A40ce9t7KaEs3qQVhZB9ak6Mj/C/JdTgVkfMi3ZSglWxR14hTlYG2LYUEGI++75Wts2NtPXEbEgOOJNTsupMRBL08QB4nCHb9wBgJmHtFnpx2KeCtO2vq35BeKVAsGCcnMD/n66taJ8+ntbGcnP5cFCehSopYJ1vsuV9XCxDC9D+laZOxqv1OwNXXT2q1S/nafJWbk0gHFNI6KnNiEkVhRegH6DQNCqXLGX4RWayZMY4gUJ32MOhZunR8/VblWCDcErtZALHV8HVu6JkQ+REj8AISVhuZKMGmhgGvaIybSfHH/CEjhV7+U2FkPOVe5B8nd0n8+u+jNoRYpqmzPmg0wiNo/gzHbDJGrC3g3s+i1ySMAFP0T0DTF1aBekuW5ptrvJkrQzAScIWyjTml4sn1Vq+DUYZaOmLN9WutiV6kdWl1bwRTZroTrpssQppiAEGM/200JHBemzfBrC+TEuYKUCqra6EWqoVg8+lJKGBZtGLPizZfUk9CSGzw2wJEID0iOQQMJFzqGiOmj80lyI9rpx9BN9IKipuJ6LkHhMysESFTsvHIbxFDxYT1fPSrvzUpUZxugYgE4YKXQbPJX8o0q1gx1V5ZshG4lA2iTrlEA2YddjhdZ711Qtt4i6OTpdf198pOZ2veVRSzHMUSgKUHlgfPcZbKYU0lMJS6kKxOD5WjQU4O0pi0xtfUG30kdQR0VJqUAM+SyzVTNxyjggaUOs6LTchtJn8NN/wzu/IwRPvIJk6xkDpYczYMo0vhSeveqyXURaG7NPaDFdCHJmpAdGnV+5v2E5ArVGekcX+rZ5fqO+KahB8l+uJblfQx1ttM4prN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 08:01:51PM +0200, David Hildenbrand wrote:
> On 07.08.25 19:51, Lorenzo Stoakes wrote:
> > On Thu, Aug 07, 2025 at 07:46:39PM +0200, Jann Horn wrote:
> > > On Thu, Aug 7, 2025 at 7:41 PM Lorenzo Stoakes
> > > <lorenzo.stoakes@oracle.com> wrote:
> > > > On Thu, Aug 07, 2025 at 07:37:38PM +0200, Jann Horn wrote:
> > > > > On Thu, Aug 7, 2025 at 10:28 AM Lorenzo Stoakes
> > > > > <lorenzo.stoakes@oracle.com> wrote:
> > > > > > On Thu, Aug 07, 2025 at 04:17:09PM +0800, kernel test robot wrote:
> > > > > > > 94dab12d86cf77ff f822a9a81a31311d67f260aea96
> > > > > > > ---------------- ---------------------------
> > > > > > >           %stddev     %change         %stddev
> > > > > > >               \          |                \
> > > > > > >       13777 ą 37%     +45.0%      19979 ą 27%  numa-vmstat.node1.nr_slab_reclaimable
> > > > > > >      367205            +2.3%     375703        vmstat.system.in
> > > > > > >       55106 ą 37%     +45.1%      79971 ą 27%  numa-meminfo.node1.KReclaimable
> > > > > > >       55106 ą 37%     +45.1%      79971 ą 27%  numa-meminfo.node1.SReclaimable
> > > > > > >      559381           -37.3%     350757        stress-ng.bigheap.realloc_calls_per_sec
> > > > > > >       11468            +1.2%      11603        stress-ng.time.system_time
> > > > > > >      296.25            +4.5%     309.70        stress-ng.time.user_time
> > > > > > >        0.81 ą187%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> > > > > > >        9.36 ą165%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> > > > > > >        0.81 ą187%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> > > > > > >        9.36 ą165%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> > > > > > >        5.50 ą 17%    +390.9%      27.00 ą 56%  perf-c2c.DRAM.local
> > > > > > >      388.50 ą 10%    +114.7%     834.17 ą 33%  perf-c2c.DRAM.remote
> > > > > > >        1214 ą 13%    +107.3%       2517 ą 31%  perf-c2c.HITM.local
> > > > > > >      135.00 ą 19%    +130.9%     311.67 ą 32%  perf-c2c.HITM.remote
> > > > > > >        1349 ą 13%    +109.6%       2829 ą 31%  perf-c2c.HITM.total
> > > > > >
> > > > > > Yeah this also looks pretty consistent too...
> > > > >
> > > > > FWIW, HITM hat different meanings depending on exactly which
> > > > > microarchitecture that test happened on; the message says it is from
> > > > > Sapphire Rapids, which is a successor of Ice Lake, so HITM is less
> > > > > meaningful than if it came from a pre-IceLake system (see
> > > > > https://lore.kernel.org/all/CAG48ez3RmV6SsVw9oyTXxQXHp3rqtKDk2qwJWo9TGvXCq7Xr-w@mail.gmail.com/).
> > > > >
> > > > > To me those numbers mainly look like you're accessing a lot more
> > > > > cache-cold data. (On pre-IceLake they would indicate cacheline
> > > > > bouncing, but I guess here they probably don't.) And that makes sense,
> > > > > since before the patch, this path was just moving PTEs around without
> > > > > looking at the associated pages/folios; basically more or less like a
> > > > > memcpy() on x86-64. But after the patch, for every 8 bytes that you
> > > > > copy, you have to load a cacheline from the vmemmap to get the page.
> > > >
> > > > Yup this is representative of what my investigation is showing.
> > > >
> > > > I've narrowed it down but want to wait to report until I'm sure...
> > > >
> > > > But yeah we're doing a _lot_ more work.
> > > >
> > > > I'm leaning towards disabling except for arm64 atm tbh, seems mremap is
> > > > especially sensitive to this (I found issues with this with my abortive mremap
> > > > anon merging stuff too, but really expected it there...)
> > >
> > > Another approach would be to always read and write PTEs in
> > > contpte-sized chunks here, without caring whether they're actually
> > > contiguous or whatever, or something along those lines.
> >
> > Not sure I love that, you'd have to figure out offset without cont pte batch and
> > can it vary? And we're doing this on non-arm64 arches for what reason?
> >
> > And would it solve anything really? We'd still be looking at folio, yes less
> > than now, but uselessly for arches that don't benefit?
> >
> > The basis of this series was (and I did explicitly ask) that it wouldn't harm
> > other arches.
>
> We'd need some hint to detect "this is either small" or "this is
> unbatchable".
>
> Sure, we could use pte_batch_hint(), but I'm curious if x86 would also
> benefit with larger folios (e.g., 64K, 128K) with this patch.

For the record I did think of using this prior to being mentioned, product of
actually trying to get the data to back this up instead of talking...

Anyway, isn't that chicken and egg? We'd have to go get the folio to find out if
large folio and incur the cost before we knew?

So how could we make that workable?

Cheers, Lorenzo

