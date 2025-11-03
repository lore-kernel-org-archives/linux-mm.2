Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43DC3CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 17:51:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A1AA8E00B5; Mon,  3 Nov 2025 12:51:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 878F28E0057; Mon,  3 Nov 2025 12:51:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7193C8E00B5; Mon,  3 Nov 2025 12:51:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 579878E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:51:24 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DF30786A27
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 17:51:23 +0000 (UTC)
X-FDA: 84070037646.26.09281DF
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4DAAFA0019
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 17:51:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fvgb8CVk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DimXwm2q;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762192280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g5bMSt9gcu3F6gXr4lVpPEgV7XJtSO7bWTfR6oh1bfY=;
	b=QEVqFneimySJUEUMGXv4Wf/ueOeEC8SFds1pTFB5asfKXGqvXICKcS3oNKIK5v/jRewdtk
	rXm/wTumNzgw2IxleMKbX6V/MjiL34sOMMSFzMTwBbMed4TT8Rl4zBTpho+Bpm2MIuKFC8
	KyoMhI9hD67cY9KBpZCyR3YwsJNSl7g=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762192280; a=rsa-sha256;
	cv=pass;
	b=xK74b5BOxZAtgPkLDJdAzfm5c/bYIFBqkp8buARWAhAkWAt6GCfi3lF3L4TfgiEvAsz5i8
	9RVO+3M+B82UYxoncHX6GwEiFxlw9ZkjB2Z8KACz37SA+HL3P0/sFzaPl6284h4bkPTTrF
	Tqt/wb99VCFLZnBwTW0oSHVgsW9tgj0=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fvgb8CVk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DimXwm2q;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A3Hit9W008576;
	Mon, 3 Nov 2025 17:51:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=g5bMSt9gcu3F6gXr4l
	VpPEgV7XJtSO7bWTfR6oh1bfY=; b=fvgb8CVkEJ8ofrv787aVdp3ujQHVO4o9S6
	KLnxmLJw6a5ZiwWeaTmg6S8s6mZu6WZKmeJ3SDu3DpojeVuOKKLL7RLBU9Vkd8Jf
	79xhv/XGDq7vH9QGZ6a2v6akzRljRAkbfuz+xLO6U6ehAnmo0Bl1C/SVslyrUm/X
	XzPyKodIVxTslOEmLzlxUUT1JvcMxnoi2TIugNQ4Z+VlKCgaGMY7SSoGPVdNi/hO
	KcE5rLydHNOBDhJliNyF+H4zUb+OC43GF1/eipoaYaWnw/Z3E4+KKXjVtW+V8ew/
	mUXWHw2osZEVlHLd9cNgpVMBJRXFUfFlJ6usu8XPjmIc3FcAoG0g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a712bg0ec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 17:51:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A3GbjsL039791;
	Mon, 3 Nov 2025 17:51:13 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012053.outbound.protection.outlook.com [52.101.53.53])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nj8j71-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 17:51:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I5H3jHhLKjou2Uwd4RCI4npYZ42/vHCaOBL/cgIkYcA6j27PGN/UtusUbwIINAT/en7Gy4oiPbDnBqWHFEeWwGHYInZyjANznKH++8TkmsJP2QFk4njjbnxOkox63i0ykdUpxUKPH3AVsYMQEY2DMUcJu/JXyNDfh6uZlDM3nrlvh2vby8rEkYbpweORELEvpLBkBlOjW00uPtov6xdzhKG1ckDqXCpwHRGW+IkJSdODIG+Ga8DzkojzJFxjj2ZBiB0EcIjQgwhviz7pDOgKQzk4z47nISvV09yK3YidQ3WHCLFjO5ZkkJn3yQ6FxJUwJlBvLEcmp9K/bPM1ZW3KHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g5bMSt9gcu3F6gXr4lVpPEgV7XJtSO7bWTfR6oh1bfY=;
 b=ttz5HMIlAtY6vrOAV9ery5efGR2bTMNJp6drNhr++fKZMiEuuv/mPvqkHRlKcDQFBU8f3NSDYvJt2XDXzuNpWnZoXcP+AzZJueiYkoyizO9q9sJLsy5nd3fXjao4k8W5TMBlwmv1+lBMvM4ZljvHJA5TV81mAjNr2enrigrDLxEwOP4IVUZ3DXCpwL3z6wwA5e9sh+wd/qKFV5KTPNYqw17NpClldG9uD44aj+ut0WHmhFNlD8hY+PjIXWjUWKirAQjhn7ncr3j2zqDSZ/VeYvmcl4BRFiM12/EFkCRZsy6lkadEggEuPFeBmn2BqCJrT0JquXfXV2ghdI00323yvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g5bMSt9gcu3F6gXr4lVpPEgV7XJtSO7bWTfR6oh1bfY=;
 b=DimXwm2qpBjtR6G5rSWgtj1K3uNkFAKLMx7cMNzTPtUFPhoYarDuQ4XHVCcgn9tnX0s/u9bHpvSql7NLe6nnRBGdu/JxnQXeN+KfBxypjhh/00wrtc0VowDIy/5x2WlukPMVrtZI3wWnkklF8O/am4ix5CwTECwfbKJ+gIhdK7c=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB7840.namprd10.prod.outlook.com (2603:10b6:510:2fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Mon, 3 Nov
 2025 17:51:10 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Mon, 3 Nov 2025
 17:51:10 +0000
Date: Mon, 3 Nov 2025 17:51:08 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com,
        ngeoffray@google.com, jannh@google.com,
        David Hildenbrand <david@redhat.com>, Harry Yoo <harry.yoo@oracle.com>,
        Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
        Barry Song <baohua@kernel.org>, SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v2 1/2] mm: always call rmap_walk() on locked folios
Message-ID: <e3cf072c-7523-4931-a060-a2890a30733a@lucifer.local>
References: <20250923071019.775806-1-lokeshgidra@google.com>
 <20250923071019.775806-2-lokeshgidra@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923071019.775806-2-lokeshgidra@google.com>
X-ClientProxiedBy: LO2P265CA0250.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::22) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB7840:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fd2c3c6-8b91-4d3e-8902-08de1b01929a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?27Ww/vN6nEdVwJ+1OHXJrtNBTQd3f1oUhKVETtP6yEowCHT5EYz2mib91aiI?=
 =?us-ascii?Q?qF4uoZZ4CnhzW94eSGUfh+huGhzQiQ4Dt57s/OYMbLf82C7ghWOjC3Tl5Kwb?=
 =?us-ascii?Q?gMJHSlPMQ/0wLKFRulyDmn6rmAHfFUYQry+teuzD//5GpFMOj0ZtTtBHLoTM?=
 =?us-ascii?Q?Pvej7OsjPqOyd/+2Ou4SvNWRN5tR6Wy/LaeBY+TLOq2RI19JlsL0gBgO6B4k?=
 =?us-ascii?Q?FuyWtQ/HTV9hKCPXNO+CHivrphXlWy4lDKBRlVZilqEnRuDQeQQ+mWdAQpp2?=
 =?us-ascii?Q?ZutGvKQm/1QvDlhjOUh/YpaRPB3kjj3qUx8MWyM7PxtD7VOLEZZWwwa9vNKg?=
 =?us-ascii?Q?1/Ze70z3Wf+8/P8bHvHyTLfq6PFpuk3Lp3neIrKjhr7t6mfqC6qfgJ7FByR7?=
 =?us-ascii?Q?ExMe507HI5ZTiDpqiJat/Yrg0rTxsq0KxwfkxepMKzpJbISXZ+owMzauczC6?=
 =?us-ascii?Q?OCwUL/XYLU74V0OGiborLe9UO46o+hqwaD+On3fq8ldj/ivH0fuh1Im/SZu/?=
 =?us-ascii?Q?nWbV7JDSTOk2Fkomf1WZ77oXdJlhOH5zT+Cep34Ss0Mf7CmBGK3x0tU7f/zB?=
 =?us-ascii?Q?BkpiRxE7bSsntGYxpWWCb0k6A7TeUsPXb2x8bINe8/mGm8D73B56WCH+ldmC?=
 =?us-ascii?Q?cwPJqxHcUicHKbrV1NOtrAAN0dd0V8Suc+M24cGdU1CcHY61Z0zv8IcWQh/M?=
 =?us-ascii?Q?FjZLge6DqZO7GCXRm2lRmbOZvdkHvcZelUDiu1hv/EudeMJ/zs4BmyEt4E/7?=
 =?us-ascii?Q?kNODHsIoo3ClHJlFIPQ7uNsdhCagFPu4NPpeBL4jbcoFc79biv2bXHerNHDU?=
 =?us-ascii?Q?CrlKAGOouhIrg0bO4tb5pJpMt5T3b7GtRseg/QExAH5h4r2uKtledbvTz5SI?=
 =?us-ascii?Q?riYVHG5onF+5sNyYf9GIXxl2x8OF3/LRbQRXYAqNG+xPU3lxsIZycoBv1OqN?=
 =?us-ascii?Q?1saGYqY6h21dlqWGu1UGw/DBcpfeyx1nV15Bsb1fqKbAuxypG8nwXpA1khSl?=
 =?us-ascii?Q?mcK9/sD0neueBOLqq27p1H8zRMf7M2BUiFRNv0ldayn+fJxfUZ62Sffes/Tp?=
 =?us-ascii?Q?/1OFJrgkI/nxxGFS5RhnTJ1QVbMvmsHzIdfb4j6+YJFl85WyTU3plj9zVci3?=
 =?us-ascii?Q?HpjzdODd+3UwlljF3Z2Av/0419Eu+U+St02sYVET1zqu4DgTqC2FBbcvHECO?=
 =?us-ascii?Q?G9xYqYlFTTtbpzTl6fnbbMn57UTGazR038SyNBq09R+l/h+wMdHeCuESmjkX?=
 =?us-ascii?Q?+2V3/vu0ozheG9w4PnT+8yfQMH5wVB+k2uYoeiCTMLpwTHIb7DsKDkR9VXPr?=
 =?us-ascii?Q?rHe4NBv22eXawl5FMPhRGrVHtdx6thMioEs+bzY7+XeqJHO+wtlJF99Cdp8P?=
 =?us-ascii?Q?xP3NsxYczFJGvWu3gT/10tBH7feP6HLL71zKmjxtbd86eGJHbRjblsNli3ZP?=
 =?us-ascii?Q?TtNVxl9cS63oOQrn68ZAx8qoewrWGMNb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0kCILMg3Hm2EFSkAkyNyLC2ycOwXKJPQxFhMcwnMGSdtkTNx1dDB0lje7UT9?=
 =?us-ascii?Q?F2aYzm5J9O4xFIC2p9CY2iQb/tmdWW29jjqT3kEVec4xliNCpjUS1yPkPI9E?=
 =?us-ascii?Q?uvks2VPBATRWPqNwgT2QmVp4wPfyUF5R1xSQmTSX9DHDWBR7gVL732mYvsSO?=
 =?us-ascii?Q?uNqreISLTtmrs6oevZxFjpw1U+GKvs6CELGPfJN8msascMVlDVfOibW7D6zW?=
 =?us-ascii?Q?pkpsNZ5vr1zugPGrgmz3MTQBmUzC09YNIZK1lnrbmT1Wo4LbZhMdJngV3u+x?=
 =?us-ascii?Q?AyFebNcwPvzEqIUGTU3Yp+rvSTzOyO0xvQegQ11Hgn/Q698I1Ll/mlfcBxYf?=
 =?us-ascii?Q?avfYNpShho1Mgj2dFiSKKzo+Ygie6jVZ0lJ1X0sPVUIw3Tt0KalydYqHpS75?=
 =?us-ascii?Q?VgpgNXVrwC+3Lm3K2UA1eOMT3GLeqcDEwVArJHdettp13doAPJSjkOLhlaLH?=
 =?us-ascii?Q?pXRRnt13gM+fGs2CvAedVu2DpVVvRxbA3HXTaqowCeXQWcrihVhrovEPBAkU?=
 =?us-ascii?Q?OlJntu7Nh08Auu8oT1K8+ET0wFgit8Ug6C8h/OUvd45qNrJOUIvQio7d6Cvq?=
 =?us-ascii?Q?/rLiQOGsmBg5nFay3sCxr1KCj5X52+kbUJghHWPRuRNFAUZJdPum/XF2uqaV?=
 =?us-ascii?Q?j2LFn/c6grkerMLkBVwmR3i7r3jc0dnG43+j3IT5or8gMnOZ1+ZAIlASrJcM?=
 =?us-ascii?Q?Ys8jbG1WeVPs3nMxV5/ICLOjCz7T5UUwnqsP3hti0ctaylGUtbtD/HVzyxO4?=
 =?us-ascii?Q?3SUV1cHfPYrmN6+M2UpcgYmbIyHPMWGBI1v9/hk8NgWXMuXGv/AbXQah4Cyu?=
 =?us-ascii?Q?tKauiZ28OpeV4oEh/XCMy40NSvIJ6MPsexqSuVuwdsSVeAb/gmKHktd0sLpQ?=
 =?us-ascii?Q?tlxgDTaNP1838YuS3LYPRKqW9xRyvyh5BqG8swAaW8Xbx3eqpgsUWbVmy4Mt?=
 =?us-ascii?Q?1mmfj/AS1jSsJGbhEq8FKMkp4Kqg3ODlj9i2umc2AR7s30DYsV775omscULw?=
 =?us-ascii?Q?Vbl82oq3cEg1pFq8ueI4csehFY9hKjS+ZnO4C/yMgNJJCcJuBQVAgObQoZeP?=
 =?us-ascii?Q?XCac71dd/IIbx34JcopZGC678Lj8xphMqj3CZmYv85OyE95mIen3Ysl59UTP?=
 =?us-ascii?Q?jtUBXqs23Ad4biqV3mhSP9ntnT2jp3PS4BWPsEVLLVzZyo/sopV2OyX/UlUz?=
 =?us-ascii?Q?Yhy67f1ClwkECCcBKN5RQ8RH/XCuLoiovvcndRv4JxBFxwyn8lSQyfkKBVIx?=
 =?us-ascii?Q?FALlBN0UBgU1ir0VZspbs1TwQyiFCCA0DFpQSFE7PY+n7mbv3d/cDi4s3G2E?=
 =?us-ascii?Q?3MOx2ZB4mvBmolvylQSQIRibcNpuM7AMaKboVgzOXuc9JyJjHPTE0qiyTOn0?=
 =?us-ascii?Q?QkuHOkQqAACdKwDBTLa7ceSsWomEp36VG6YXN1JUOrfvT3xX05Jz2p06GqlI?=
 =?us-ascii?Q?wLKQkh32QKbiywbe4rqBi3z/0Ei7tsPWWSf2Afs/1jECh1hrhZpMPq5305qF?=
 =?us-ascii?Q?1mMkwWyhbLjy87/RxtlNA14QI9ce2Ru3mfCwAU4O86m4aoL2wkA0apSpHmB4?=
 =?us-ascii?Q?b78vv2Bi42zha9Q+fXloa3TkYjtC/TryyOMnBEoPshRZge3FwLqIpqWk+3aJ?=
 =?us-ascii?Q?2A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HMZZdojnRYUNVPDTXiF5PP+teXmoxINosJkF4/fof4wvqJ9XLdPNKGTCrvbiXvl/KrHImfer8vxBXmFJrz9nEx3Ay0IbQzijbp+sOB9xiv4HFdmS1n7dC4mfCjIhhyZsry8NqV+vA89MDtaaEkXzHof3I2WsgCARKPg0wfNMCbCh3ryZEihiKphGB7c1waC9tMXeV9boAaPleiZ07a9ouaIV6yDbzevoE3IW0DiDxUyO9hXez5e9l425gVPVmGvTTbERcKc+DF7yGM7HCJCm1qU6RCfFq07g+Y0D1V8hwjiN1ribJneztWKuOJ2RbPc1VH+ovLGaLhpKGRom6miwn3EnkQawKagmx3ee+azZeVo/UHHi0JulZNmgSMOt+eHEOMrltJQeNu8wKw5b7sK962QteNJK67IOxjQzUPXuopPQE7NiBTlN+pO+ZKHwqqFJUnEMwrpJaItf+GbEOz3Lrql+K6GtJY+HLDYa0ZxRTMp052tDbZ7oDdhlTcZySnfX6oMNWI/eodPUY2LPpCKiFRxOlQbEuq+YwxFJPUYJumwCM6Lqy/46MRbNSNxDbRGSFaMEseddiYqQuUl27PZypJeM+zHdskJLHpN8tA5LDGI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fd2c3c6-8b91-4d3e-8902-08de1b01929a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2025 17:51:10.3705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a7T+0FkuQgVMVyGieWRi/ptwNarqb/37V0LF5vco6ry2BrJt6Dqp1+3Hz0V4KnZL9R+nGKfk3y98OcpDqRaV9ELULTZaxCc/w0unRuggOw4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7840
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-03_03,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511030160
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAzMDE1OSBTYWx0ZWRfX+dIP0YTNPWp5
 dZsHADftZSy2JC3MCXOXsImTM5AAsZT2fzGd6TcPDOnyNY/JsN8N4EqAo8pkdWguJtV8eQ1YkEs
 3elKtngoB7Mkd5yfDezyVr445snu5VNTbR4QzoB6aE8HFzaGnJs1Tdb115iBcQ8nCeuENyGZWCw
 cMUfOZbNpnm47MwOoNRro6VSx4pUrKvR1x7A9utyBlZyfEDas10EM+9vuaQt2bqXobuiIAL4bLg
 3Y1jOIMuU6C0gMsorjzOpmWM4wKVF99cXiOHKIQz9XUbUMYVkO4ss+tZmu5yz63JWTZkJj7Eq4j
 P5rNYjpyVDkNhKJyom4fGobg0WzrZq6NC0SUTY1rFT9kP8E9ur0Vj5D33Ya8GCDnW7ucepADiaT
 lWvCKC3cQrDJvsYsSibetysxPdOc0lrz2ti112kJJGirOCo2VBs=
X-Proofpoint-ORIG-GUID: CTYfV3u5j9krYSglvqecn5DL8r-T35aI
X-Proofpoint-GUID: CTYfV3u5j9krYSglvqecn5DL8r-T35aI
X-Authority-Analysis: v=2.4 cv=JeOxbEKV c=1 sm=1 tr=0 ts=6908eb92 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8
 a=mQi1BHE_T7MEjeqlND8A:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12124
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 4DAAFA0019
X-Stat-Signature: dt8rmob47chgy6msm6uhszm131fug9b7
X-HE-Tag: 1762192280-965723
X-HE-Meta: U2FsdGVkX18qyLmChxw0THLvI1+qu7gdZ7gD+lIHsg3BA48IUBxjYr0CwOKxqewbAmxKGeC8r+IKcf8O6eDcwxwJBEFrOwqLxdxhtuFwuH60DMaCPA8+9SoMicser2UVPV4VAHQY3nLmg8LQgBmjSCc7N7w2WI4pFuj+eJvW2XwIJYLWsh1D6uAxVIi9B6d8srMcChN1yg42/3oAe45wD4IO0lLDJ09/LHIcGbi5vKKl/UFMgoK5gGfUFbfCluksmdSNNT2+rgmvgQxD+q3vIMpIsIlU3nedxBrZffLhx9OjirNj3+2HuxYL9gkqnR6SBAlZkrrdrnuZx68uiwVGKX2UTqs/jG/TmATJot/31oiBtPsNqGj30cAbreN5LPHuWJqN4j7IYgk3X7hGkS5u7SB8NAuWjAeLBCid9YEAXJp3AeDQRBR8YVuUp2DZBVvsbfrBQ3COugMl9eHvP8hNh9hQI9qz9bLNCLP6lQpz4Dqo29IiFMoFjIMg/mNZ2Jtg8YnFi9aQy/YVA5WG+CBIH+oQ3XjA/8PlKYCOdlYbQ4ZIFRH7uUt+7yLcaKu4XTZzCRITcVnmW5sLa/CrS2GUZLrHITJTAZ1m+rcx+Z+76gEc0QKyRbnkh+at01e0q6cEmmScnxfej/Lcrwdxnny/L4mM6MyS8luXXLAwwjw6/e+pexA1hf0Kgi1gs8Qu1PK6fEGZnt19CeJb5ObzmB61boZkYBuMSlKOX/4NarOv6kczyt7MuxjQ7ys2ZpuC/peVUTuVjmyXpyJoEu51A5cMCRiTkcFkC+65vkW6Q+Wb0ROJhRchRNPgCPovNCa8LDIr68SWwQbCLBLXk2eDX997dSBwUvRU1lBUnHNrk7yvGsU/BcnrHwyF8fsoZNFKIY9beg0v47G15qapImotNz4MafYu+SPM1MJorEyNYKhFJZM7erPa/insUgnz/42bDiPqzsQGh6JGdnSPPjHv4Z+
 f+HYeQbE
 YiVxRxvi7LKDZYhr4CxSsxM23DjYWDjjZYh0+cGjOaoHnSbydxBF4VEFBI0JHV7/wuBchTkoyE2/fLEjFS+oI0+F3x1nVXoiWIUYyJW0vjReWDyK/1J2oQdt86IEEmqICaMejoE2XafA6MT16bncfRfmLS/cOcvwpJdJuJ49NDegGSdbpt+NXlS3zywv9Q6Vj7/sD2Aylomfy3Mn4oG9ZHrSqfm7iUsE/ZRBR9rMa6XpSTGwmoYHchejvi8v3gkCiRDff5skcJx3ePmEY+fNod14Dql3sp8/Nf1MFRXmZjROk+6nQDrPDGYeWqfKk8j1rGePfb5PuimAvraY+a8AZSggpVuXB3KxNHqPravSZKw3Cy25KdIO49lDtyykivVYM60NRLX3QIE/AdPikaV1hrMRAU8JELvDtrfh0WzHmbcmgu4rrdbpnfbZpoWu7e6DbhWtSlSZCX4+BO50Zrx3ez4Ek3YbodVdn0mdi3xEY9a6RxmvScAvHIo/iITr7UVArZfowJkpZsRg9hN0ky+vg5oYC8thsQSWV2fhFP75Op+EyIjIK+CDxC9LyqCwBHz66FNIRjJBH93dpbNOGaxzR7I6P1mwJuZgaDvMHj4CBox7RfeB/Z9NGAywxXy3X0dTFqTr3zPgCwUSLlMyWvKBMiLiHGWihWiD990wXJM4sprUC5R1SW2eDdFh43uSPfx56+tFdo5p7j9dBUn/XFYacdJFxmA96mGfZsPEoHil+lt6FcLa+8R5MseJsv64QrjCj1nBmSD/9WVVieWk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Apologies for late review, I somehow missed this...!

On Tue, Sep 23, 2025 at 12:10:18AM -0700, Lokesh Gidra wrote:
> Guarantee that rmap_walk() is called on locked folios so that threads
> changing folio->mapping and folio->index for non-KSM anon folios can
> serialize on fine-grained folio lock rather than anon_vma lock. Other
> folio types are already always locked before rmap_walk(). With this, we
> are going from 'not necessarily' locking the non-KSM anon folio to
> 'definitely' locking it during rmap walks.
>
> This patch is in preparation for removing anon_vma write-lock from
> UFFDIO_MOVE.
>
> With this patch, three functions are now expected to be called with a
> locked folio. To be careful of not missing any case, here is the
> exhaustive list of all their callers.
>
> 1) rmap_walk() is called from:
>
> a) folio_referenced()
> b) damon_folio_mkold()
> c) damon_folio_young()
> d) page_idle_clear_pte_refs()
> e) try_to_unmap()
> f) try_to_migrate()
> g) folio_mkclean()
> h) remove_migration_ptes()
>
> In the above list, first 4 are changed in this patch to try-lock non-KSM
> anon folios, similar to other types of folios. The remaining functions
> in the list already hold folio lock when calling rmap_walk().
>
> 2) folio_lock_anon_vma_read() is called from following functions:
>
> a) collect_procs_anon()
> b) page_idle_clear_pte_refs()
> c) damon_folio_mkold()
> d) damon_folio_young()
> e) folio_referenced()
> f) try_to_unmap()
> g) try_to_migrate()
>
> All the functions in above list, except collect_procs_anon(), are
> covered by the rmap_walk() list above. For collect_procs_anon(), with
> kill_procs_now() changed to take folio lock in this patch ensures that
> all callers of folio_lock_anon_vma_read() now hold the lock.
>
> 3) folio_get_anon_vma() is called from following functions, all of which
>    already hold the folio lock:
>
> a) move_pages_huge_pmd()
> b) __folio_split()
> c) move_pages_ptes()
> d) migrate_folio_unmap()
> e) unmap_and_move_huge_page()
>
> Functionally, this patch doesn't break the logic because rmap walkers
> generally do some other check to see if what is expected to mapped did
> happen so it's fine, or otherwise treat things as best-effort.
>
> Among the 4 functions changed in this patch, folio_referenced() is the
> only core-mm function, and is also frequently accessed. To assess the
> impact of locking non-KSM anon folios in
> shrink_active_list()->folio_referenced() path, we performed an app cycle
> test on an arm64 android device. During the whole duration of the test
> there were over 140k invocations of shrink_active_list(), out of which
> over 29k had at least one non-KSM anon folio on which folio_referenced()
> was called. In none of these invocations folio_trylock() failed.
>
> Of course, we now take a lock where we wouldn't previously have. In the
> past it would have had a major impact in causing a CoW write fault to
> copy a page in do_wp_page(), as commit 09854ba94c6a ("mm: do_wp_page()
> simplification") caused a failure to obtain folio lock to result in a
> page copy even if one wasn't necessary.
>
> However, since commit 6c287605fd56 ("mm: remember exclusively mapped
> anonymous pages with PG_anon_exclusive"), and the introduction of the
> folio anon exclusive flag, this issue is significantly mitigated.

Thanks this is great!

>
> The only case remaining that we might worry about from this perspective
> is that of read-only folios immediately after fork where the anon
> exclusive bit will not have been set yet.
>
> We note however in the case of read-only just-forked folios that
> wp_can_reuse_anon_folio() will notice the raised reference count
> established by shrink_active_list() via isolate_lru_folios() and refuse
> to reuse in any case, so this will in fact have no impact - the folio
> lock is ultimately immaterial here.

Great!

>
> All-in-all it appears that there is little opportunity for meaningful
> negative impact from this change.

Thanks.

>
> CC: David Hildenbrand <david@redhat.com>
> CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> CC: Harry Yoo <harry.yoo@oracle.com>
> CC: Peter Xu <peterx@redhat.com>
> CC: Suren Baghdasaryan <surenb@google.com>
> CC: Barry Song <baohua@kernel.org>
> CC: SeongJae Park <sj@kernel.org>
> Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/damon/ops-common.c | 16 ++++------------
>  mm/memory-failure.c   |  3 +++
>  mm/page_idle.c        |  8 ++------
>  mm/rmap.c             | 42 ++++++++++++------------------------------
>  4 files changed, 21 insertions(+), 48 deletions(-)
>
> diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> index 998c5180a603..f61d6dde13dc 100644
> --- a/mm/damon/ops-common.c
> +++ b/mm/damon/ops-common.c
> @@ -162,21 +162,17 @@ void damon_folio_mkold(struct folio *folio)
>  		.rmap_one = damon_folio_mkold_one,
>  		.anon_lock = folio_lock_anon_vma_read,
>  	};
> -	bool need_lock;
>
>  	if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
>  		folio_set_idle(folio);
>  		return;
>  	}
>
> -	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
> -	if (need_lock && !folio_trylock(folio))
> +	if (!folio_trylock(folio))
>  		return;
>
>  	rmap_walk(folio, &rwc);
> -
> -	if (need_lock)
> -		folio_unlock(folio);
> +	folio_unlock(folio);
>
>  }
>
> @@ -228,7 +224,6 @@ bool damon_folio_young(struct folio *folio)
>  		.rmap_one = damon_folio_young_one,
>  		.anon_lock = folio_lock_anon_vma_read,
>  	};
> -	bool need_lock;
>
>  	if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
>  		if (folio_test_idle(folio))
> @@ -237,14 +232,11 @@ bool damon_folio_young(struct folio *folio)
>  			return true;
>  	}
>
> -	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
> -	if (need_lock && !folio_trylock(folio))
> +	if (!folio_trylock(folio))
>  		return false;
>
>  	rmap_walk(folio, &rwc);
> -
> -	if (need_lock)
> -		folio_unlock(folio);
> +	folio_unlock(folio);
>
>  	return accessed;
>  }
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index a24806bb8e82..f698df156bf8 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2143,7 +2143,10 @@ static void kill_procs_now(struct page *p, unsigned long pfn, int flags,
>  {
>  	LIST_HEAD(tokill);
>
> +	folio_lock(folio);
>  	collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
> +	folio_unlock(folio);
> +
>  	kill_procs(&tokill, true, pfn, flags);
>  }
>
> diff --git a/mm/page_idle.c b/mm/page_idle.c
> index a82b340dc204..9bf573d22e87 100644
> --- a/mm/page_idle.c
> +++ b/mm/page_idle.c
> @@ -101,19 +101,15 @@ static void page_idle_clear_pte_refs(struct folio *folio)
>  		.rmap_one = page_idle_clear_pte_refs_one,
>  		.anon_lock = folio_lock_anon_vma_read,
>  	};
> -	bool need_lock;
>
>  	if (!folio_mapped(folio) || !folio_raw_mapping(folio))
>  		return;
>
> -	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
> -	if (need_lock && !folio_trylock(folio))
> +	if (!folio_trylock(folio))
>  		return;
>
>  	rmap_walk(folio, &rwc);
> -
> -	if (need_lock)
> -		folio_unlock(folio);
> +	folio_unlock(folio);
>  }
>
>  static ssize_t page_idle_bitmap_read(struct file *file, struct kobject *kobj,
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 0bc7cf8b7359..fd9f18670440 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -489,17 +489,15 @@ void __init anon_vma_init(void)
>   * if there is a mapcount, we can dereference the anon_vma after observing
>   * those.
>   *
> - * NOTE: the caller should normally hold folio lock when calling this.  If
> - * not, the caller needs to double check the anon_vma didn't change after
> - * taking the anon_vma lock for either read or write (UFFDIO_MOVE can modify it
> - * concurrently without folio lock protection). See folio_lock_anon_vma_read()
> - * which has already covered that, and comment above remap_pages().
> + * NOTE: the caller should hold folio lock when calling this.
>   */
>  struct anon_vma *folio_get_anon_vma(const struct folio *folio)
>  {
>  	struct anon_vma *anon_vma = NULL;
>  	unsigned long anon_mapping;
>
> +	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
> +
>  	rcu_read_lock();
>  	anon_mapping = (unsigned long)READ_ONCE(folio->mapping);
>  	if ((anon_mapping & FOLIO_MAPPING_FLAGS) != FOLIO_MAPPING_ANON)
> @@ -546,7 +544,8 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
>  	struct anon_vma *root_anon_vma;
>  	unsigned long anon_mapping;
>
> -retry:
> +	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
> +
>  	rcu_read_lock();
>  	anon_mapping = (unsigned long)READ_ONCE(folio->mapping);
>  	if ((anon_mapping & FOLIO_MAPPING_FLAGS) != FOLIO_MAPPING_ANON)
> @@ -557,17 +556,6 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
>  	anon_vma = (struct anon_vma *) (anon_mapping - FOLIO_MAPPING_ANON);
>  	root_anon_vma = READ_ONCE(anon_vma->root);
>  	if (down_read_trylock(&root_anon_vma->rwsem)) {
> -		/*
> -		 * folio_move_anon_rmap() might have changed the anon_vma as we
> -		 * might not hold the folio lock here.
> -		 */
> -		if (unlikely((unsigned long)READ_ONCE(folio->mapping) !=
> -			     anon_mapping)) {
> -			up_read(&root_anon_vma->rwsem);
> -			rcu_read_unlock();
> -			goto retry;
> -		}
> -
>  		/*
>  		 * If the folio is still mapped, then this anon_vma is still
>  		 * its anon_vma, and holding the mutex ensures that it will
> @@ -602,18 +590,6 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
>  	rcu_read_unlock();
>  	anon_vma_lock_read(anon_vma);
>
> -	/*
> -	 * folio_move_anon_rmap() might have changed the anon_vma as we might
> -	 * not hold the folio lock here.
> -	 */
> -	if (unlikely((unsigned long)READ_ONCE(folio->mapping) !=
> -		     anon_mapping)) {
> -		anon_vma_unlock_read(anon_vma);
> -		put_anon_vma(anon_vma);
> -		anon_vma = NULL;
> -		goto retry;
> -	}
> -
>  	if (atomic_dec_and_test(&anon_vma->refcount)) {
>  		/*
>  		 * Oops, we held the last refcount, release the lock
> @@ -988,7 +964,7 @@ int folio_referenced(struct folio *folio, int is_locked,
>  	if (!folio_raw_mapping(folio))
>  		return 0;
>
> -	if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio))) {
> +	if (!is_locked) {
>  		we_locked = folio_trylock(folio);
>  		if (!we_locked)
>  			return 1;
> @@ -2820,6 +2796,12 @@ static void rmap_walk_anon(struct folio *folio,
>  	pgoff_t pgoff_start, pgoff_end;
>  	struct anon_vma_chain *avc;
>
> +	/*
> +	 * The folio lock ensures that folio->mapping can't be changed under us
> +	 * to an anon_vma with different root.
> +	 */
> +	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
> +
>  	if (locked) {
>  		anon_vma = folio_anon_vma(folio);
>  		/* anon_vma disappear under us? */
> --
> 2.51.0.534.gc79095c0ca-goog
>
>

