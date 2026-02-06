Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35302ECD98B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 10:01:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CB2D6B009D; Fri,  6 Feb 2026 05:01:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A2BE6B009F; Fri,  6 Feb 2026 05:01:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 878036B00A0; Fri,  6 Feb 2026 05:01:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 78DAC6B009D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 05:01:22 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2EA4A13BCF6
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:01:22 +0000 (UTC)
X-FDA: 84413589204.28.1BD4DE0
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9C40380010
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:01:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XsAY8UWP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JNJPkSEa;
	spf=pass (imf02.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770372078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d/dhCgCdTovjgPoCBUr36Bq+2kHYk2HR2GjJrHsy2xA=;
	b=Eg8hh/8dnHMSHTNImIF51rR3Z1SoecIvaCO+1Q17xM3rV/lznMnZsCcFU2NVLFDCDII5Fd
	VptrcDXx1Ssm2+r81tms8Ao5kAqEB0FnFzKO1Bgi+QLg4HcmuTpmx8rzXZ+1mDfV+2jsaq
	cXUUyZz7ddSmuBcIOqfNChAb2l5yDmE=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XsAY8UWP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JNJPkSEa;
	spf=pass (imf02.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770372078; a=rsa-sha256;
	cv=pass;
	b=m2u0OpjMkgtohjWqRTwP3FTJ+z/sxk7kloPF1Mg72pEaGzNbc2v5nPLTSUbLew0LTmOTCw
	4S3r0ior6EYAFRiWCSLMYfxrgkMHo2T2EMoEVgma0eWssOEbZFei6ONJ9VcLVgi94ChAgZ
	aogmCHn2MbgENIdT0kEiDfL0WV6XsVg=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 615IKros1076776;
	Fri, 6 Feb 2026 10:01:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=d/dhCgCdTovjgPoCBU
	r36Bq+2kHYk2HR2GjJrHsy2xA=; b=XsAY8UWPrrItOnKjYtbtWeUbo3B2YKWyQ6
	9Qll1VUBrEzyiWNalUyyDpySOz1uM7EUW0pW58P7ZhP41DTEx9rgi6iz1XDrhm7F
	L62gsFVod3iHFcwzG/qwtoNPymOgrKl3o7+2ZWPMvfntD3dpFCnciLLwSo83jVyO
	CHqeg9wGmo01NzDbQaSS3h9jcgg5/OPAERhhKIVbtVaIh/0HHnk22WaOeF7vEVvl
	iNh7lg1lhK0uBbD3XNI3ff1X0I8wuVSUhvPzAWoU306mcZwpIQHoOfX2N3LpquZ1
	nSEZoNc3Ta/H94tGtJk3/LvBAO+aulxgD/ZVeI8vr81D87JcyOrA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c50ddgxr5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 10:01:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6169vKZP040276;
	Fri, 6 Feb 2026 10:01:12 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010063.outbound.protection.outlook.com [52.101.46.63])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c55gbxvh6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 10:01:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C0socW+S0aGgG2DTnMpF8DdOUQJcUsre6BBmVms1b8ci95Iu99LZN5rypjbSKIdzqI7UKk0z9ScVc+jA+Axv/29Ik81IYl478LHtxof1Xy/yqxJU+T0LpoqsrzlCfvvhey+hkvmM9hueg/9KDJLB3WFHa8E21G6zr4ZFBMtanPHXkOlhpBOPwDNU/z15HON70aQGIamPaRi4Wheqz9UB3pP00xuNOh0XKeFDhfW1xzNlxsN93teOHVvL9FpuVJsU8qCx/Zx1Fz9iX3dTcUy7Uic6l3+q0rx2vz/xB/J7KIY1plOI1GM/RyBYAjVc7PeufV/AeU3KxB9vwdF5TR02Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d/dhCgCdTovjgPoCBUr36Bq+2kHYk2HR2GjJrHsy2xA=;
 b=gvRvKC3z94C6S1nWa39W1tG6zqtS7AruvezPfG/SzU38S7CtcvUHJcjgLvboEzqPV9EJ48aYug+RoPy9ofeYzE5FtTIAiryvt5VazdhnRvtphh+6WzYZBJOvidooMyfavsG6BAdGX3/zmL5UdG1JbVTvAdmWAdnEGdAYD4xfnzGw9Wr2fkGx83mOZkVcPG/tWZ33WcPmKLmS8U9kw0+1ITfOJAr0V25IUSN8Z4Fl0/d/CiZ+Y40b+Mryfd6VuoNfea4oGlrwDD8cXOtdak5BuB4/FJnYe+bRnPGgB/wN4DbgqchX1BGbDbJG9KZY7ceTEwbnp/SFsetnHIepRrjOng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d/dhCgCdTovjgPoCBUr36Bq+2kHYk2HR2GjJrHsy2xA=;
 b=JNJPkSEajSyMtHLVCkI0EGpCTvVa5e8IHcNNzr/3riUc9mz4FYNVLYkm5GQbb88fkR8IBSIR7s142DjWmkT/XTKmzD5et+N5su2sp0AgbEoPeXb07Hvwu5erHqT2UUkUXdVM4zdT6xEMyKkWUF7rrGhjf7c3mokiltkgqmcPdWo=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by BLAPR10MB4899.namprd10.prod.outlook.com (2603:10b6:208:323::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Fri, 6 Feb
 2026 10:01:09 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 10:01:09 +0000
Date: Fri, 6 Feb 2026 19:01:03 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Hao Li <hao.li@linux.dev>, akpm@linux-foundation.org, cl@gentwo.org,
        rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: let need_slab_obj_exts() return false if
 SLAB_NO_OBJ_EXT is set
Message-ID: <aYW732VZACRIzr-r@hyeyoo>
References: <20260205120709.425719-1-hao.li@linux.dev>
 <aYU7l6P2ikKvnrWT@hyeyoo>
 <67ebb9f2-b383-4b68-949e-239d8c7b18f0@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67ebb9f2-b383-4b68-949e-239d8c7b18f0@suse.cz>
X-ClientProxiedBy: SL2P216CA0088.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2::21) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|BLAPR10MB4899:EE_
X-MS-Office365-Filtering-Correlation-Id: 05ce2c20-c6d2-4d6e-be59-08de6566a68f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bffJhBsC/i+zyn9QsZ9lTEiPsnxfppj8oAtxr25ZSfjQXOgF3qcW6Le3Xo+a?=
 =?us-ascii?Q?49+TT/HawXPFFz0xkvTa4acMRW7csw1UdQZATjKgD8qzSMbQaWieb6BVE6uX?=
 =?us-ascii?Q?OSOQul4wYedmAZVelpuFehFVZ37pcVcrebuhl5xCtalVRocoLbuk0Ncl9b4w?=
 =?us-ascii?Q?TozRaFYZ5CTnsX4/D51QBUWbsFurKpeGyEV0w7aqlT4/E+64/QkbjrJIkUP6?=
 =?us-ascii?Q?L4rN7zs96fM2VsGP/lKr16uoXOwM0bZyJN9bJkUE6MvWfE4RFH+mKRTKeMYK?=
 =?us-ascii?Q?D+6EeGBzGYI4hH5ADBld/r86bWxOvsuliR8oqPOoskzk+TSaO6VzqWSl+6y7?=
 =?us-ascii?Q?ywZ3FGKXnDGHkzHFAxXQXFkzxZ+33TeV5JfzOY78jXd7WMvAkNESXxb3hTHm?=
 =?us-ascii?Q?sh4CxND7YyH+fWgANZ33FMoBeBocLuY9IDGtUzmsGISeETgUrHYIQvWOTzYk?=
 =?us-ascii?Q?JXMf1l7VGWfmI2XTFd8NM1TDC4POpZ7z8p2PwrflDvONTqSSMxG4RqKRDRNA?=
 =?us-ascii?Q?edvbM/vPLCXDCmjpgc9hoqfEY+tbsepyfRkk1yr8L/SXLBoLBplAf/NkK5Es?=
 =?us-ascii?Q?WvI32oM/jcWsr25tgomt9U7Xuy/sWntuLpn5BzJ8Oz3wCkySu8HCKDrYxZ7l?=
 =?us-ascii?Q?kKNnGr+2NyuPu4c9wPZMyiR2bTUgjTPtsdRvn/JmS06Tq7511Q0k3IzXUF7O?=
 =?us-ascii?Q?G9enj1lthbKxjdTG5nE3R/WyyQD3mXtysEpbpNVg0EqpfzygJPoUlzD8ny60?=
 =?us-ascii?Q?VQEl3HpMBcnODOO3EcwWJ8ChFf4pOMEKfI50w83/Qy0L86CRUZaatIiCEETZ?=
 =?us-ascii?Q?ptcj+t/tL2nixMCgz5mQRMwvLI3IQ0yoCU8xXQ0pd2o1DPnTWk08mLilB1GP?=
 =?us-ascii?Q?ruP0mHe6lHYoE2ngRjzn2XWweOjRH7e9N3TVS3THnXTCapVqL5Dabhwg5VxS?=
 =?us-ascii?Q?iid4D5z0APj3GiuRBQabBAlqhZd86Yj9enop3NiON5OuKARd+e9kuoJ1Gk06?=
 =?us-ascii?Q?c1l7Y4I1OIFnLAuka7iA7YHnhpioHHbmEObLLKdfa7uG+OYFiPTINZ4mmF7D?=
 =?us-ascii?Q?NQZH+qllC7RQUVwDp4XAPIRD9k9KevvYlz6VDk0I6X+k/uTtFgI91BBqgtQa?=
 =?us-ascii?Q?WySvERs3HWaN4mEbwmBUu1ZercWAg3P7EG/ceSVZyIWAIbSqcGc3E+mIrNlk?=
 =?us-ascii?Q?NOhBNwglZo1CpL+NjD3PVjDY4muAz383TmgARUT6vcruejypIe8xiLxLWGeB?=
 =?us-ascii?Q?75WyQ4q43zL6baUv/aS/tW8nfjKa1DZ89h2fyjZLGG8FR0bXDTIrHbPMswjN?=
 =?us-ascii?Q?vHDawvG4aIuTLfTI7BD8mk8aa97hz8+x8G4RAG53eO8sJli7BotGeKkFeG+G?=
 =?us-ascii?Q?DUJQ6QEgxqpS1PcnPPsX1pjbdJ2ph8FSDG6eFAXPBrR3zBt3A3o7+XFNPPH1?=
 =?us-ascii?Q?udZfSe9d2Oy2L1Cu457jejNtFqzszwJqJ2KDkcrypdIpMIHjLdx55rbqp9+5?=
 =?us-ascii?Q?GnjNVUWtn2Gm0PqWQgg5YXibZo0ngnTaPk67qZFOEf5bXhUSVRw+WpwyRTvX?=
 =?us-ascii?Q?LIHcENOe//rU+sTw96g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VaZ/RV5TWlnf+J84bMgI8owZl+wTurXS/mVi5en3maYW/tDMqRl+eGzD0/Ps?=
 =?us-ascii?Q?YLvh5NsYf1XKPjF4nuZIVNSpzZk+ckneMhfGoMJTG38iUe45U2e/Tubud10t?=
 =?us-ascii?Q?m1YUsKcUahsf7RQ6Ph3c+jqoGyactEB2jkYJH3l2haE5vbVfTxPS8c4nfFCs?=
 =?us-ascii?Q?iN/+l4eyWl9rdL+jJZFcIPjiJpyXyKioMfO46D+LPoykd3Ow2x9+wmDCXNHK?=
 =?us-ascii?Q?Ei/AJMHnRgIlBrKSeLGdugFzmBn359XFTqJx+zB2kX38xoH8UQ1d5vIsUafj?=
 =?us-ascii?Q?7VJRNUEycU3mPWruooAOOZLRA7/+DFgrFx2MLgA5gI3XT20FkcAfFZumaI5B?=
 =?us-ascii?Q?wIM8toqjCoXm2ZhMAc0dV8bgChY1zGsKSwCFHBApXwQ0Kvd21zurHiCAj218?=
 =?us-ascii?Q?ffHy4vlY3Lo4cQp+oK0f7Woer1J037jqs3TrUSH6u8HFk8AUbAqBQ9KgA656?=
 =?us-ascii?Q?jeDCc7QMhs0l+WTjGHIFMWLLHhtb25ssuVbgMQ44WY7CqaNR0T6xtCnHleNN?=
 =?us-ascii?Q?659QeUFbH/NIO6nAm/z2i/4O+CsAOX8a6pm/1T0kavnyrfUXGeR5dLFkhaIg?=
 =?us-ascii?Q?pnCMijTTqGyQujq2YJe8CMZgIpk0fOU0dsvG6QY7RmiWolBWZu7dfXYu9ccF?=
 =?us-ascii?Q?1n/fDVNNW7TEwW0VJczBkKpmXEyhac6M0LmeAkU439Yj+H5VmjltjwOpC1jj?=
 =?us-ascii?Q?sELubptAtaLJnB+UtdLcl3erL7MMM3TyjL2U3zB1mF14D5Vqg6SaS+Nktk4k?=
 =?us-ascii?Q?rBbCMV869HtP3Y3q7qNlHdNQbG9yQFA0Wt0CrmUXl73qsA8mmgv9WRoKqvCV?=
 =?us-ascii?Q?J0ylccE+iKn0KtLYNFqOoXM0u2GNk4yKyadiDhSurNG4vdgLs0xoyUfDZ112?=
 =?us-ascii?Q?ZJzcKpIfPKSAJVOxAEIGTJxBkwfCpLABfyUjlS/nVvCbD92WIxuhJqaK/jmM?=
 =?us-ascii?Q?94l9VqaF+3Rgx32GOc3t5XNHSpzbz7Unsy7WPr1hxL0nb7URJaW1KS410l4C?=
 =?us-ascii?Q?jp0n/0MRG9kzma+ZWtfihwhW1/24lPmdymv9dyOvzZW94nxv1kuNiouPC3Te?=
 =?us-ascii?Q?+wPZR9Rk4j3/y2dpfuPEkOcjp1AywN9/qRYOPvErjVSujno6H4Tsi1hnXFYN?=
 =?us-ascii?Q?DLRheKa9yeKZAUlI8l7QuMz+xuKW91D/MraWE//lkfGT6UAi5m1hmzGI54Vq?=
 =?us-ascii?Q?fIc6IpRhjUZzBsZXU+s/qYxD4o1KgKSRjAvB/YbZ/TzbCSUHvtm9T45q8XfP?=
 =?us-ascii?Q?rYTrdoZS+Qz1wbr/Rn2+FMC8lfYXVPcggcMNVQZ6NiXiKgILnAmsyzoiXdXu?=
 =?us-ascii?Q?lNHSOcfiIxjHknqtZELLlXX9N6XmrEnh7GwDOb1DJRY02DugM1l85ZbZMsND?=
 =?us-ascii?Q?9hIiQQrY+lzcVzNXDpA38u8as/gedy9C1LCGoT5/KAB50g5xxfd7pHY1aUqP?=
 =?us-ascii?Q?whlXcOYiCIWnoBZhvu4W/Fpnh2aNAdstCVEAMPYLQsitO5prsAo23fafFg86?=
 =?us-ascii?Q?bgxZVHadEl0LGDXKQij0ESVX8jpuwKoJL6OaTzTx1SlKEmQGABqJNNcueukJ?=
 =?us-ascii?Q?0hleS29ThXScJyjfkGn8cStXZS4gV7s9K39lANsreHC06m/Wr+bmjypfGEN1?=
 =?us-ascii?Q?E0gxiDVrgK2l/aXvmOnpPdo4BjHgsOaQpIRkhT4V0lfrag1ps3VjbTDs/eLU?=
 =?us-ascii?Q?yLHTWCSG/nK/IhK9kCnAqDBeDhSMQ6c81RpCtu2XZux5nfgdepfwDelu2lSi?=
 =?us-ascii?Q?VG67+06tCw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xFu91U/tHMMtCIgyuCL2k38jp///VQThwoA8lwlItAZJrPSUHZ4ezzx8ZRe0Du5GlngbRpDUTnXh3jKycrvBPUSmV0G5H2E4xPmcssEUi2+yvVgSj44Y5wvOg+bLvB8fRYhAKsKGs5+mfAObUydxvhdbcIorKckD+R4xcq+M+5G0pl3NSXjwNDMGKQHu+cgtwFdU/aMm8ES9l1sZTHy7l1UbrHWAJdeq8vLN5/E5oHU/8PbHLKFS+wosTOoEGrdENnRD6fGhGkpGk9jm39mnqBOjYSCIFBFaXf/8OCPyDRui5F3k+B7jfNp43E54tHwDeU32ZZ/psxrv8aLc8sGnWXtowSXuaIGKWgwzy/CaPOQXKjF5k53e8z/9vATUG29SjDWkd3wT2wMe7bqWkf59btwpMoVPPHMFpsMwtPWcXyeOjutubrKpNAzYl+w4/MIMdadW+/Tjw+k5TOCkiuJLWxJOHT2wrHHcchXdVTxYEcscI6Byi/k3EFjUrMOf3UX3LunzI3MA3nhEQG58rzPY9nf+3ESrTjzZDKI/3T9qLf3DidEJyQp1hvutKg5xqdK7X3yDBP4HHg1WAyfAakihwphT4TgusVdDqXCikYEPAkw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05ce2c20-c6d2-4d6e-be59-08de6566a68f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 10:01:09.0718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: omOH+6mqr2Bb9l/P5ATf3GgEaIMDFMLUZKBISJjp25FwfG/0ONRMWIaNW8FRLnu7v41ATtxEMZr5YIkcovbqmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4899
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_03,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602060067
X-Authority-Analysis: v=2.4 cv=TvvrRTXh c=1 sm=1 tr=0 ts=6985bbe9 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8
 a=ZxOXg4pr_42UMNvMtNAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: IJr7aeW2WreRJgFgRUYkoCPiZt0YDSRy
X-Proofpoint-ORIG-GUID: IJr7aeW2WreRJgFgRUYkoCPiZt0YDSRy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDA2NyBTYWx0ZWRfX1KsQbtpW6SZI
 nTumZEQlUdZSDj4cPU5jPORYvp2bUUczEeOKQRt0Ah1LCsebryFpiyaMOL9KOxdgcrUXKI0aBEk
 OyoWygHXg6nnBDq0q3GwIfbUMywnxly9+/pNFQtv6eZ8SWG3Djyzl2aXIUsfkZQNipvgh1APRen
 fkZ5NS29m03B28p5Oy6oRgXZ+TpUhkoLREbhZsWzayahKDHteS+WyuXc/0h0ylh9FPMSvmMIGfd
 UlYaRIngcVoYy7fA2c8lCGW9pXAGMk9PtRtcR0VBqP6J9wu8yfSsjJy6dWs4A5ySlVefL46A0tM
 RzW9/9C+Gdds+WCG44JczZIAPsu1hDjIbKfFEQ9EgVBRMHcJM7HhkYyP7Yhuc6mBohS7PMCpLLG
 sjFw22jQylo1tpEVTfn8GqISZqXOnd/C9wANYTxz1pgz/OHLKaK1mIh0slBNJUXWxaBuKGAwGc4
 ePFaDAjvgLyIjMJJoog==
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C40380010
X-Rspamd-Server: rspam07
X-Stat-Signature: 6e5cst4g4cwa6om6xbfcw3s1k6ptdkaf
X-HE-Tag: 1770372078-463478
X-HE-Meta: U2FsdGVkX1+UW7/MXf2clW41sc1fg34Zr/gCB7/8YKjUgfyF5g2e6iJXRZobVuFst7evkoMHG8/Yinayrf8Fp07qXSrAyr1uGEk3pMz7BBzDhXWDCTAO6yA4wuuvq8dkFmlmmEUefuPQ8u87cDuAk/NVsfYtRuAmCHcYmzUlRhNST/77LNw9CtmYwAxo7HaK7cBi4rMRlz3JN6G214v+rPy9BBS3SHLQEUcIr+2hfa85rVBXRexFA1nnrv2w3xC3lxzgQT255Bm+pLthh6TbmsByz3wRARpPX8TGgxd9h4g/6++kPKWSsyrglf5UFdvlymaRjR428S2z6aq6YxkJoET3qe2KZJPwKrz2pS3+Mb97D+/aRVo3AFu0j9otBjfhx55jK/ma4MxgUMmk27a3V8lhZ3n28CTCrjmJWJCQIyJYAIUOGveUNA91U1+UG949FkgmDKSfTctIbQqXo6ZhuyFXkkkJLN0AfIduks0+p+paQLjzDzgxTaIwB+pn7fueM06P5wMsjty8bkLx6Xfjojak05RIV5HLKX0/VeRkn0tJ2cdgTT/AtCOhR5POpeddoEuvcAR+kr5WWE7mnuRyhl+nzdOEomf7l2ESWBSJcywIu6eKUzifO0rQWagRQoe2CF9qwmJIbtT7B+QBRJLG4VO71OSf3fD+LoEUt0BMZUg1/ml5TOntLM13JgP0q+dxk/MVB7dFCWx0vcyxwONCXtutKZw7GtYIxG67pDTiNzCNGArJAnSX/lUEEi/9sh5DDftHJh3eweYpS1TjlVKScNjb+ZlQig2Cp4XzVo6GXllj/jDo1q8cD98JPVh113dfF25q2wrYdKkx+OpmKeWuMI1FUGiZrHf4ctXdIicKJXvwoLgqGQd1XXyOJMCZXQGgQ8Cq9N3UQxmJO5IJxHsgXGbr1+JKOqvHVHM6tw0djDlu3tCoZZUBKq6DuGyE1k992PaLjFROx2VOUDbzUWE
 48/yAMh0
 3c6bLbNHWum+Rtk/b1P7aOsf3sQUX0e4aCniB8Yq0LvJIxoG/EQhO8cg0+hbmMVtYaNx0iYj+HgyTslSmKpzX48ToeMVhzXZRqMmU1olijowEFxDd1ryir43+KrP4pVoko7nLc5LFZspI7INlhkmOtk4cLmqQu5uC94+FbiQ8cWfFUoH0H1qxDV3wHErVATzk8PKrZbImfW78E+JaT73pmiFcTG+TJU/LE177msplRGkjiynlApXUPtjs5+CYqoekw1TZKrkD96kV+nMwS1PPpnhgyh9swuUTg+DW3phgkBRfE9la43m492oRDzv2ZIMZjnXja/7I02/UeHtxlZKqkm2IL7xOYzoZS8oh37t9VTjnyq67tLvfKC6ui51iTAUzhlev7Qr/myUHkI4RzyUmBiJyOFe3G4a43rTahWXlI/9ilVXrGRnCpMSYRN7REulXBuZLT2zC9EQPAFAw9U8RwWMo+E7tXKBiAFP6JZuc4LCAtb95EB9gDnQex4GbBKurL6UMrmb77ynZ4zPcHW+w0eRvuDyN9lb43UbF56brZO8/cZagRp5Gi+rBLmDPYHFgy4HOtPyuLDPE+eF8m2HeW2Rp5YoG3bxXO83CsCdUG5TVZupa+7bBBhxhW9ftOfyfkImICnHFG4auNyrGvjn2qx/hfh9TziXeGfgnF8n6QiNteIgrL3GKJMJTney/7iCyvEMt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 10:40:54AM +0100, Vlastimil Babka wrote:
> On 2/6/26 01:53, Harry Yoo wrote:
> > On Thu, Feb 05, 2026 at 08:07:23PM +0800, Hao Li wrote:
> >> SLAB_NO_OBJ_EXT is set for boot caches, but need_slab_obj_exts() doesn't
> >> check this flag. We should return false unconditionally when
> >> SLAB_NO_OBJ_EXT is set.
> >> 
> >> Signed-off-by: Hao Li <hao.li@linux.dev>
> >> ---
> > 
> > Looks reasonable to me,
> > Acked-by: Harry Yoo <harry.yoo@oracle.com>
> 
> Thanks, added to slab/for-7.0/obj_metadata
> I think it doesn't change anything at the moment?

...unless you enable memory allocation profiling :)

> But a correct thing to do.

-- 
Cheers,
Harry / Hyeonggon

