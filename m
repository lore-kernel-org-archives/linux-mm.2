Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BBF1D64095
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 08:51:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7BA06B009B; Wed, 17 Dec 2025 03:51:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FF696B009D; Wed, 17 Dec 2025 03:51:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87E7D6B009E; Wed, 17 Dec 2025 03:51:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7052B6B009B
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 03:51:22 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1FAF713BE97
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 08:51:22 +0000 (UTC)
X-FDA: 84228344004.07.6F2E914
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id BD1E0A0009
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 08:51:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ni94a0RE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ldCw6QUx;
	spf=pass (imf25.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765961478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ObwUcktFVF6Ptz/49/fC7VcwQF+FqZc4pTQfd6J6mvY=;
	b=jB3uPDsnI2a40SULhhPC+LyP22EPM3gjVTcU8bSZel7yxs9p+3jV2YtZqbjA3uHOK2uffJ
	PrHyNUjE2XFuPXbTYbnkxFfhweYTIcPA7l1Bc5nHNJhqHfSGk9AIj1KdGxm/WdRguc/wpX
	+NkAXLNeMpQDGEERjGxCM57rlvH63IY=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ni94a0RE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ldCw6QUx;
	spf=pass (imf25.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765961478; a=rsa-sha256;
	cv=pass;
	b=CTZd1Mg0wrxVM7pcjJygD25V7k1Wb1oOhi/QxuU2vnTzse9exgHVdp3SWU6RNQ5yzr3ojY
	e2EiU0GT0/q3hDTr9n3mCBkLNDwZWABnYV5tIB28g/9jcBPMYHisUXbVShiZN0AYQDmDM+
	LQ39iUJ8G1wzSOLBw9aGNNjdIhJfwGQ=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BH6Nwf62144013;
	Wed, 17 Dec 2025 08:50:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ObwUcktFVF6Ptz/49/
	fC7VcwQF+FqZc4pTQfd6J6mvY=; b=Ni94a0RExNydw1ca8eVD2EqZxwZqypggTB
	uzgEineYx+aokopPHwrvbMJfQ27yCV2PrdOT5bDObKaH66lSlWJsHVcVOkVck/Y4
	NdEtcOQqGnI5PsjJ6RUXZSjkUU7r+6dr2If6VBJVrgZXt0zb4oDpl4y85dmGIN8X
	9/pjl/mT9mocExhyUS3KoAk4b9zu13LqEBYvztYi1TTWGViZp+gQ97vrr41w9fNF
	ZJr8g/98+NsDOL96zApjjbp08FtpF+10Nwde6TeVhnc2xa/llGGbp8t5V252Fhg8
	v5tajKcoWUAegKt1RUuMJ/Sh9IbjJQmOIEuWGQDdyRoauG/4XxPQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0yrunewr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 08:50:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BH6ZuDd024709;
	Wed, 17 Dec 2025 08:50:51 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012035.outbound.protection.outlook.com [40.107.200.35])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkb8x9w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 08:50:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=llKD+02U0zIzTsxIGdEJzkXdGOzdRChWcor+80y3+0BaGPSitwkKykQ999py+ZDpTj3ErNBH9A38NZClpM30LajYTK1BZ+93Ltt7ccfFMXnG+bL36HZYlP1AdNrIpp/9VrfLeDFBX5c6reqmGD3mhtT/cocN6sSa/6l6Z1ZbBHPfIUfhGpUrKBCWDiarYQgrFDxMmJs5+Y0tadjBGioQP/QjLC3f60TS3HQNUS/DLJWRiFlhTgb0z9NQugHsKrtPFZdUz7xcVXPNgILSd9Qk7dVAw2QsUkYO8gtX46q6Udhbl3CFLoVvSDoa+SxLlOKoDBbyN5G4GJwErj+W16CYLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ObwUcktFVF6Ptz/49/fC7VcwQF+FqZc4pTQfd6J6mvY=;
 b=HCxed/hPSZI3QxfR6+JugiA22DEduv5nQhy6EEK8+nRiyTR50VMpex0bNROOzzlIEQRSrlF8qlL5F+bOLGfevyNQPeE18H6oek+Wlppgq8X5K9g9vRbDnJhIQmhYh7oSw84ERjOHtYh35Y3oiydhqROolbTEz8nymCavWlL3DRmQf+nblGrWFdRyhgAEykj0WcN6Rwg/IWEBxpseDWyL397cng2eeeYWvhLwwwtloqDWYVrikuM1PaoF/NWeg+8dfz1Gw38KcAVPHMDVkhiNMlZsNxWeE8oK+nfd2IuGiFIp5uZVtdN3dHXy1ZNAoWgpFqii4XfGRTN3ocZIzuyKxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ObwUcktFVF6Ptz/49/fC7VcwQF+FqZc4pTQfd6J6mvY=;
 b=ldCw6QUxcdt1fvE5zJnjs4jLD/nquyqLuFfRVPE8hy2CQRDjzK3eeMW67UHsVsq/bRIYgdXfHoTaCpoWvG2VtSyHJtt9fFk+UZFCEA7DwzfxZmaxe3EGvWYQn0njVxVEU3PCl7EtT+gnClDfY8r0K/uyEpYlIpqL7JhN4NlyEpc=
Received: from DM8PR10MB5416.namprd10.prod.outlook.com (2603:10b6:8:3f::19) by
 PH8PR10MB6672.namprd10.prod.outlook.com (2603:10b6:510:216::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.13; Wed, 17 Dec 2025 08:50:48 +0000
Received: from DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::c8c3:861e:be9b:fa6]) by DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::c8c3:861e:be9b:fa6%6]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 08:50:47 +0000
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
 <20251215204922.475324-8-ankur.a.arora@oracle.com>
 <20251215184413.19589400a74c2aadb42a2eca@linux-foundation.org>
 <874ipqexai.fsf@oracle.com>
 <20251216071250.e49ecf7490acf7f377dbfdc0@linux-foundation.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH v10 7/8] mm, folio_zero_user: support clearing page ranges
In-reply-to: <20251216071250.e49ecf7490acf7f377dbfdc0@linux-foundation.org>
Message-ID: <87fr994hot.fsf@oracle.com>
Date: Wed, 17 Dec 2025 00:48:50 -0800
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0232.namprd03.prod.outlook.com
 (2603:10b6:303:b9::27) To DM8PR10MB5416.namprd10.prod.outlook.com
 (2603:10b6:8:3f::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR10MB5416:EE_|PH8PR10MB6672:EE_
X-MS-Office365-Filtering-Correlation-Id: dce08f9c-1f8f-43b3-4cf9-08de3d495f43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?u1Q9YwzAUWdJKyuMkQB1bMRve6OligtkJBBHkUweVm/0rRl/QcEfGmtx4IC3?=
 =?us-ascii?Q?B5neDsw9CkI8yG/zaaOkTqkDI0Zynuj3lvQrd5mFGkfR8Pg47e6fTjzIWu0p?=
 =?us-ascii?Q?guEAe+pi//iWevdHVxX7sdaWhR6041WZUAhXA4bMEAu53RNz2ELNVBe94dft?=
 =?us-ascii?Q?sogx2pF2X4tUE0IpgpjfS5Ek1gSFs8mvHs/5R6wUqxAUe/Ajm1Bb/Xeuzgbc?=
 =?us-ascii?Q?91VSEJIpT1ml9KT51+Z4WNsvYMWfQ4MTjeNjjP8zernLOUZYs0LyJ5C8MiCR?=
 =?us-ascii?Q?GifpWDx6J8tGtiLNAlr5wqu2yITxh+xbIrVw1I9OZG1MZuFjI2LWRfzoD1xA?=
 =?us-ascii?Q?3uWweYBX2c2KiHYczeA4L742BfJyj5ht2Av2IUfITakx9em3z7HSS3kAXO5/?=
 =?us-ascii?Q?f34FWmxm70dEd6aLnlo+RpStsNEXvct+YImMm6qn0VNEiNjP3ib2i6RGSddX?=
 =?us-ascii?Q?etTHdNNOxSP5xX04J3St41fWruNRubKtO1TkQHji8Rna21K8uxALtKxUI/cJ?=
 =?us-ascii?Q?0I3BkzJBbEa3kGbaySxa3CvNJLr+XZd4UBU4VoNLPa/8y5g53natTERtF0Pn?=
 =?us-ascii?Q?5AXd2anWHm9dYWmAp93oqJhB2EQAtIH+beW3Hd2gPBdV6SEjH/9EZ3Y53q2i?=
 =?us-ascii?Q?xQKUn1XcxgryNJun9C3bG0WomBb0J2Rne43Ke7G82e5x96iMbzLKr4ByHJ0f?=
 =?us-ascii?Q?RBPq2PdiGKlzKQwSRiS1KqM5IYS0vR+Sw9G8BAGnxVrvGkmCZe5yREEwmEeY?=
 =?us-ascii?Q?Kvp/io9JivSAkycrx61/z7vDQHiVxSegFdDq3WQr2gHkHv7b2toj889pk3Cn?=
 =?us-ascii?Q?/yeUniME+Q7MrgMRJrF9EBduh8w19PtomhWLZuhANkAcmS7LVwlVhx3Vn3LO?=
 =?us-ascii?Q?YPr4hbr+CF+E33NigKafrkGTtSQJ3VqrlFig4ZNhyBQneIkYIfBuTFVb/KVs?=
 =?us-ascii?Q?LiZdA5RiEUDuB/X7lRCcltPVUZrj38j485RfDr6iFZBVAw85Zn23Id1CX57c?=
 =?us-ascii?Q?ulVJpbGEBEtjBgZTj1S32C5fK7lkCXBpLLAwnBXQXU4PM38oqZLu5NmSaZrk?=
 =?us-ascii?Q?ngFzNqP/dfjxxKHWHzfRSsGKhNOGX0FpgPuqHJXasojaU9goqYG7nPhcttVV?=
 =?us-ascii?Q?aWPMzUjk8nlRieVZHtGiXc8y4jMfdRquZQRQbkLpK4qkKBTkxkVJUm/SZV+z?=
 =?us-ascii?Q?rvqqGftfUldyXN+EbXcPn2ZprXXQU/9gr8j5kAQXH6zpN0qaQDFNQ4R8bVBr?=
 =?us-ascii?Q?CRiZ+fRpT+Myke6HVdZCpwuo5nAXu08CYm3JVQH3ObOVmuSb7C44o5lhs5Nd?=
 =?us-ascii?Q?kc5qFfsWHbCbJyrPBNUnI+wqnGoNYNb26Ff1RM6U8VZ/IDnxRUMcRpLnFUdq?=
 =?us-ascii?Q?xg6Xe+C+RgqoFyn9dw4XV19ONTkrtr7Z/1PN9gOkyqK9xcihOj/d6ItMlxkU?=
 =?us-ascii?Q?MC2IHJODFpYqZ+c55yzytTrOpO5j5amq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR10MB5416.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iQBTlFFP6gYoZfn6WTnjz3vGwC7+i18pmdaXdoZfa/FhWoANvm2LPEzi2Afi?=
 =?us-ascii?Q?9uIvgxun+GNMuSBHi2z4JySMWEhSDaKoOznOp7Te8RZAf/gD2AV7+++9YuAz?=
 =?us-ascii?Q?Uojf8o4zX6sBcVniZ9Osw96sMT17VF9eGRj6QHbIPC+b3Fn8JXNketctDdUL?=
 =?us-ascii?Q?qsRu13uxLwHsOOQsU3ClEEQCEeA2noF+fibfIn6u5Fj0siaTXdtR2PmBM/cu?=
 =?us-ascii?Q?JFHFYkjk2o2aQfpOBj8d2lRhRB3AysTbBMfM4WccogJQn1mw1BWvAJAPHzh+?=
 =?us-ascii?Q?e9Np53gaDYPQf5AVqiV9bDcKN2ASset0FMMkKk8saF8BMZFKrW9eGyES+Xkc?=
 =?us-ascii?Q?fnIwrwJavN2L35HxLR/pqouPYDJdd1pSs9BHf8eA3PMHYouMW8JXULM3kqB2?=
 =?us-ascii?Q?LawKBE5OYh4SnrF4wTzz5ahHuPs2Ut6W27Fs3n2ThAvCMyBbaO9WDclzYfJs?=
 =?us-ascii?Q?avc2IZ8jQrp3NoO3GWz7Uqf3Gw+9xlVVzTSJHT7egI6UET5v8UUvgkLKTZ0u?=
 =?us-ascii?Q?CBBgMa+R1OA+SbgeRHyI3BnLkaiOESTXKDe6FJ0A0+fURI43zdLUtDJmaggx?=
 =?us-ascii?Q?E5Uxurp0UE42McHN0lZQqfSnwl0jBn9P3VXb14MMIcRoCTitNoaEWFWKyHKN?=
 =?us-ascii?Q?i3v2Bo/rRsTPubbPLUj5kjHK4V0iHYBtibOvxYAalO9/UG5dLSkgASUvDO2R?=
 =?us-ascii?Q?jLwV+Q8VFE/J3mbw7hoe6akyXPe04UrKBLV34HpYbJSCuwy2BmE6d4jJ1AgK?=
 =?us-ascii?Q?xkRgcKwDHjxgs6Wi/O88WwFHVpUCYP/8O8HFj3XvXAHqLwkdOuogoVYbfC8y?=
 =?us-ascii?Q?cF2bnwn9NN32wGRIej3jQsLBaAwzGc5mBcN8FnYgZK+/9ZqLe/b0SJBtXtXd?=
 =?us-ascii?Q?Gu4e9FPasr6ou671J1dMZi7lCjKWA5+rf0/HI8ERof+j52AOSnmrG5rIpy2f?=
 =?us-ascii?Q?H0svFNg8vhUCdhbnWEkk6uJ6bZrFPeA66Md679xqW9svd1XSI0NEhppvKfoN?=
 =?us-ascii?Q?DlomusJtIC1D4mPKZ2ENVc6KtWh4aYb1Im0nbUgDgEpINL7JYuSsKzTmqfDc?=
 =?us-ascii?Q?mq1TU+5vfkBkvXy+y3EOmhhkWALDxTGYegkC2y8BtW/L+j0GdE/yc+Wpf28h?=
 =?us-ascii?Q?vVj7dWIVp/vHSkMqA5lxYUQP89R3SJGILIr+MCLtpiphQT0S6fPfOVff0v8r?=
 =?us-ascii?Q?qdyC2lGiJSsqL+dg7RaVtPuCT1SFnHY9yiFupkbuJLi/WDuyg4sd1SnX/O2r?=
 =?us-ascii?Q?HWMo+JU6W61nJr3JFiIOWkwaUBaf+92/hBd567TI1X/eqYk/IYLo1Xify7Bd?=
 =?us-ascii?Q?iVmrMd6NbPs+qCd+AqPSy6tWiu8z1e6Taa+wtd39jnn7ociNfi/qXrlfwMA8?=
 =?us-ascii?Q?wDfxd7d5leShoHdLPdnMgnhvIyk2PjNxBe6f37EtLHPh+3O50lEGVNdZ5QIU?=
 =?us-ascii?Q?g7UOpTsS1jHcLV/KxVh1ehSasz2XUWFMkxWct1FBFmLcm0jBeyy55K+ehVkD?=
 =?us-ascii?Q?FSfKP60gkS9iEPfjmA3FOxiUVjUj/OE7+FJFO0yCZlq2+rScoQ6xG7HyTxPe?=
 =?us-ascii?Q?Gjh1zfccSWfu5EloKcPvUYaG91sTxVqn/wFK21FGM+0x1pAAb2IfOJ+9kgLq?=
 =?us-ascii?Q?cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VCcVPg8Gzbctr/OGJ3CTmvqUnJrE1X2f6MA4dBpwqD3kCxtYrEU+iJQlIrw7aKCugjf7rNNu2kDP+DKiWcmAbN8mrA9UAYLI/9snchepkCrqzSii4xcSJ+Pp1Tux9v8QsxYQrreG5ouuyJt94aFkj7JFoUWXzW+ICFp2bBP07GgwP3RPXoANPyDAOJ56QvycY66/zq4Zfao9+0eSL/KMmbWLhhVq91eJO2eFRf+jAyI8RD8tJvmY38F2jIjUwjx36y3drYR2rHswG767QaQPJk6iXwopmKMmLLvz4yCIWlBp/L6DAC5Vg/nPVi2H8VDeeHq2hCJQW58dCnmZ+lnXmW4PYcIq0y9r40vgUTJjd4P0Gk2dmMUEdYIgjzjsJRO9bmoouVLlFI6QOjZnvScu2lJEzdOP7hWvIJJUgdYLLQfRajR6MhWbc7fOEh3ozjpIpk3fpudytPcAzVtuAOh7OqahuEHFneEXS4e1pt6Za1erKLoEfuVqf83lCUjekWPtYpBuNQZnExK/HX9FBATDJnJs7OCWBdRMHhQ9QjDcI/khnPY4wc70gI3jvZOwy2TLDif7mcyYRrIY3NUQv5eZeiGfIjuc3Kt+T7crwf7l2SU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dce08f9c-1f8f-43b3-4cf9-08de3d495f43
X-MS-Exchange-CrossTenant-AuthSource: DM8PR10MB5416.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 08:50:47.7441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jGrJh+VK0e5fYxMN51X++oEpIw7SwKddp8/UabYsx15Y/M6rU/XQby/UXTbJFG4ESoBj4rx+0EcptXfecey56d7F5jHfMwZgtDQ7KPjK8mE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6672
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-17_01,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170069
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDA2OSBTYWx0ZWRfX3DKB2c0jfD5m
 IB/sfuuKyikaf0PbZTyWgoxotFKMtSxkCS3FLfav5+bIXJ32Pq3kLf8TvLF717pyCAvpXD2qUwj
 DJIFbL3HzJVNyXN/6Yost/u5SOw30gaVf0dbVK3m6D0F2MtTWMVYyrGnsfWEyU8IKEC6uhyG3eF
 MCkAQLYtNMsHd5x7qRLQO9GWv3jOKTxIwbeUlMBlNKtwXspD7axTXncbiK4hR3hgUdckQ3IoaD/
 w7YCyxmctpGYvVaK2DDmRVPOn8xUYlfjHHvA7Bat0D3OTC/VNjUc5GVWw6OXpmxgWOBvBpiIlxZ
 AukUA6fvS62AWkNWMyDDBremyZwlXpBwNZ6HuTmkKMDQIgqbQCrQMq8PNjI2yYQCdzXfYdX5VHg
 1NWHKMqJk5ok6+lJKogdHp7JeB1cyg==
X-Authority-Analysis: v=2.4 cv=TL9Iilla c=1 sm=1 tr=0 ts=69426eec b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z4Rwk6OoAAAA:8 a=yPCof4ZbAAAA:8
 a=i-MaQjc-Vo6fM3VmFeAA:9 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-GUID: SWGwx5eQWjwipZxtvIxGeLuNDJ4c7cVF
X-Proofpoint-ORIG-GUID: SWGwx5eQWjwipZxtvIxGeLuNDJ4c7cVF
X-Rspamd-Server: rspam02
X-Stat-Signature: 7jyg63bwsg94sbzyqy39hzsbwez5btre
X-Rspam-User: 
X-Rspamd-Queue-Id: BD1E0A0009
X-HE-Tag: 1765961478-632936
X-HE-Meta: U2FsdGVkX18tEc/4AJKI3XUyUBgkidxvl84YZ9ql1o6IKImu5w16q8QteHNSuHFaz5wDndkSEgtA+OddAyAewR7l9dUtMQCtPXUDO2P22hE1jn+UAVOaxUun0dr4nA5W3qODsia7zsBPZyf0QZw1AUMSZ3DmFnwl9CQpSsHaVCVcGWRtFOPbKgmPeYvOFILHlPGZhcUKL8PSBlhAMlwSwJmXT8Qw20oodgWLjgSLlGJJ595lnse1fVYh9eZGQdUJDZN4KYNIdYwVuHXkneGQWOkmjm3ABN+/RtBxyYmdDmwBYInt1g2ODTaO33NTCE05TgJQJG6LCVqJn8HD25HJ8M3NSLnydcu3Ag2sYlboiN3YWWu8nxmr+LMx14CMLTz6Xfc+rKfYVWHAO1yEi/657Xyn22fS/ruMhwim+c6Gzo2Tef4SwBmNLPeQb3QeXJbbYpjBIZNkOoz+aMNFEyctfeRlvooh5j9BztvLs6RCvogCkK3lnaakR4ewm71xz1CxdQfYXqxEE9PQ/VBGUfmNIfCrTHty/nYiYJW6G4KKp0UIGNvyx5RvGWeO0VKxA8OGKJWDPQTUSq78b4kJhwAMjnz3MTYRVDTYWCua2xRiSxx9ahixJmrqT8GCY510N8czSXwPT0MNlvMzFwdVN4eD/5w1Fj2b1TfmUYcF8XO3cqJ6UUVU2JpX9ZXIEzWfFFutJsZ8F7Mm0W0g9dCINO9CGmy8vQVoRwR+/rVAYH5cKid6Ug962tgnyFsAe8V8NAiok0TNGfTZglP7ad3RVduuO3Tq6V4UCdNavfzwJES6SZOsxV4JzT+GgTAlv9+J5Q3Mt5Yt07cyqpKgRy/vXEDdp17IK+V0o34b36i2PF+/HMCdM7xoiccAuxxtnkQwzreNIY94EwXFYYR6BSIxQaqnoTgUWapn8jTudqUHZP4ncP4A+Ne/ZHySNgi79TonBpHpeIzXWslk6g7FPz3nEYM
 kqQhKHKk
 tH4agM8gopqFe85AiZcd1yPBt0g7aPGmJ668dvK/AguxS2azDjg0gWOB+nyNFQNeY7QOXi4rTL84ENDG0X6a6zFEk3KpeNj7Nip5/o2DNYexufVBfc773BwBF3Gol7OEM9xlBO9lOLXByU1DqU5UA2mD3k9FdO+FwtFIW9sTqUlFFjirGPSInYE2w6X4rQqQUeNVF7jP7ECuNoAR1GKbA5g5sVX40cc0Dcqv40KBU5g1yszE/7iXW5hnAbw51F1L+Cd628PvZJcduJsAQs8v7EBS0Eghxr+eVZ/24v3KiKNiHnbvmLT+vHJaB53EcpLQV9OteUKZ0Og8S+CKlBQ2K6WMTvkDhJuPBzu3Mwe0HVgc9psvjLBPeJhNNQRp2cpEuTk8ftHNIKtQ4MEM29jE4ycWuYSR5TP0RerUL1OySiJwg0ENoRCrQifUbKJdZ1SvbKNCPqs1N6uaRX8X5HFSMK4HAprac++Wy3B7m0nLKPebYu5ErnCisaevCSAA7iafrctKwx79jiyN21kvdpsj5dTxQnacC9GbCqbJfVxsBAgKK7o0BPm12gpDY4NLl/6VpSfIJuORmxEkMd2VkCgG/GuHZF48SRLJi8wBaHWOTX0v0rpEdmeNsjcRiHYEWWOrtK+Uou/qth8xzaUwY2GHyWvpf/9EktZMrWasJ1nyvrnrmA+xD1sVDO3e/lJHpulnefTnA5H9TuUjHd+M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Andrew Morton <akpm@linux-foundation.org> writes:

> On Mon, 15 Dec 2025 22:49:25 -0800 Ankur Arora <ankur.a.arora@oracle.com> wrote:
>
>> >>  [#] Notice that we perform much better with preempt=full|lazy. As
>> >>   mentioned above, preemptible models not needing explicit invocations
>> >>   of cond_resched() allow clearing of the full extent (1GB) as a
>> >>   single unit.
>> >>   In comparison the maximum extent used for preempt=none|voluntary is
>> >>   PROCESS_PAGES_NON_PREEMPT_BATCH (8MB).
>> >>
>> >>   The larger extent allows the processor to elide cacheline
>> >>   allocation (on Milan the threshold is LLC-size=32MB.)
>> >
>> > It is this?
>>
>> Yeah I think so. For size >= 32MB, the microcoder can really just elide
>> cacheline allocation, and with the foreknowledge of the extent can perhaps
>> optimize on cache coherence traffic (this last one is my speculation).
>>
>> On cacheline allocation elision, compare the L1-dcache-load in the two versions
>> below:
>>
>> pg-sz=1GB:
>>   -  9,250,034,512      cycles                           #    2.418 GHz                         ( +-  0.43% )  (46.16%)
>>   -    544,878,976      instructions                     #    0.06  insn per cycle
>>   -  2,331,332,516      L1-dcache-loads                  #  609.471 M/sec                       ( +-  0.03% )  (46.16%)
>>   -  1,075,122,960      L1-dcache-load-misses            #   46.12% of all L1-dcache accesses   ( +-  0.01% )  (46.15%)
>>
>>   +  3,688,681,006      cycles                           #    2.420 GHz                         ( +-  3.48% )  (46.01%)
>>   +     10,979,121      instructions                     #    0.00  insn per cycle
>>   +     31,829,258      L1-dcache-loads                  #   20.881 M/sec                       ( +-  4.92% )  (46.34%)
>>   +     13,677,295      L1-dcache-load-misses            #   42.97% of all L1-dcache accesses   ( +-  6.15% )  (46.32%)
>>
>
> That says L1 d-cache loads went from 600 million/sec down to 20
> million/sec when using 32MB chunks?

Sorry, should have mentioned that that run was with preempt=full/lazy.
For those the chunk size is the whole page (GB page in that case).

The context for 32MB was that that's the LLC-size for these systems.
And, from observed behaviour the cacheline allocation elision
optimization only happens when the chunk size used is larger than that.

> Do you know what happens to preemption latency if you increase that
> chunk size from 8MB to 32MB?

So, I gathered some numbers on a Zen4/Genoa system. The ones above are
from Zen3/Milan.

region-sz=64GB, loop-count=3 (total region-size=3*64GB):

                                Bandwidth    L1-dcache-loads

    pg-sz=2MB, batch-sz= 8MB   25.10 GB/s    6,745,859,855  # 2.00 L1-dcache-loads/64B
       # pg-sz=2MB for context

    pg-sz=1GB, batch-sz= 8MB   26.88 GB/s    6,469,900,728  # 2.00 L1-dcache-loads/64B
    pg-sz=1GB, batch-sz=32MB   38.69 GB/s    2,559,249,546  # 0.79 L1-dcache-loads/64B
    pg-sz=1GB, batch-sz=64MB   46.91 GB/s      919,539,544  # 0.28 L1-dcache-loads/64B

    pg-sz=1GB, batch-sz= 1GB   58.68 GB/s       79,458,439  # 0.024 L1-dcache-loads/64B

All of these are for preempt=none, and with boost=0. (With boost=1 the
BW increases by ~25%.)

So, I wasn't quite right about the LLC-size=32MB being the threshold for
this optimization. There is a change in behaviour at that point but it
does improve beyond that.
(Ideally this threshold would be a processor MSR. That way we could
use this for 2MB pages as well. Oh well.)

> At 42GB/sec, 32MB will take less than a
> millisecond, yes?  I'm not aware of us really having any latency
> targets in these preemption modes, but 1 millisecond sounds pretty
> good.

Agreed. The only complaint threshold I see is 100ms (default value of
sysctl_resched_latency_warn_ms) which is pretty far from ~1ms.

And having a threshold of 32MB might benefit other applications since
we won't be discarding their cachelines in favour of filling up the
cache with zeroes.

I think the only problem cases might be slow uarchs and workloads where
the memory bus is saturated which might dilate the preemption latency.

And, even if the operation takes say ~20ms, that should still leave us
with a reasonably large margin.
(And, any latency senstive users are probably not running with
preempt=none/voluntary.)

--
ankur

