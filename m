Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23540E7C712
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 11:43:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D4466B008C; Tue,  3 Feb 2026 06:43:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59F0B6B0099; Tue,  3 Feb 2026 06:43:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 456726B009F; Tue,  3 Feb 2026 06:43:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 311DA6B008C
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 06:43:49 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C1B03C1BBA
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 11:43:48 +0000 (UTC)
X-FDA: 84402960936.27.D4F4FAD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 75AB94000C
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 11:43:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XqOgDA+i;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=oQ6CE9te;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770119025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aPFzhYdQTBJNMvQAzTHcV2UTTDRXsHIxg4c1emypA/4=;
	b=vr5xnSO1WBuTLg/8Tju3p/SpW8OX/Ry70Ij3BK2WtLcqnXLF7jybkdpHrbFkq1p3u4R2Kj
	kMXuw2KzMSOM/kfwp/fCyK0auMRK++7axApfl10gggdxrJUULQcH8iFG6sVny9q319myAr
	mwq/pBhhvU7/rZilISWCGFtaT3EChLw=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XqOgDA+i;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=oQ6CE9te;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770119025; a=rsa-sha256;
	cv=pass;
	b=KBktNIUfrRd7+k6e1p2ZSvfs6Jkl9NyEt2UenpA8yrxMEy3i+pWmtK8mp8AbZAAk5E/yHR
	iahMP/LIp1TRv4iJV7O73dOFK87NTITyGO3JrqonOk+IHDZkv1jlkXZS8iw2m71ZwD7e+B
	SrNbQQuagim0+fN1SGG3r98FytD4h/M=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6138vQwn3652502;
	Tue, 3 Feb 2026 11:43:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=aPFzhYdQTBJNMvQAzT
	HcV2UTTDRXsHIxg4c1emypA/4=; b=XqOgDA+iFrNgnYgX71F5SXWrvIX0rkrXWf
	hsEDMUkM834mxedNNnD/Zpd2TVneiImYTrEqO/eiIJpNHz4jNJTOgkVp1Muqw7d4
	d7ohMZPq1o+RlVabcsSBEPsLha8GmqO3v6yuWBXqGOcIkAoT+6TalSN3pkJy79sf
	FkovMbUQDjeI9RbFzSqfwb06AIdkOJn2aySK5iFjOkNkpk/tcaWyXaFBtdmkB6HB
	xQWpguYWS9/wLQ/Qrnauh856W2D2+dHaRpfTE0cZJUQD1hSA5FXtMXDUyv0y8hnZ
	azSKP9wneZOq0PoHDF0ZyPdbn9uFlwQSHCS8FXTJoH7X+yhEnjZg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c1as3bvy4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Feb 2026 11:43:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 613ACWaW025839;
	Tue, 3 Feb 2026 11:43:19 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013025.outbound.protection.outlook.com [40.107.201.25])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c2578b0hv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Feb 2026 11:43:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vtUaMwg0l3W1RTaiKJ8CptRvZFGVsmMUGjCsXf30DpsVqxmRkOUvF12jiCbRk0YzZh7zsCRLJ4U8RpvSjAukF51k3s4k9TmIYddYtn2Aqx4WxOCV3/X3UtrSZd9TEnExc7D9oBaYhXmsmHxhX/4Md3FTDg/W2a//3kOX4OlVzPiA7CwDWfnrZQTTggt0cLeMMjNu4oOP1E0GTYDA0FMwTvuily6/p0Beu0LQCzpRiMY8UVj/41RgttA2DfhzNrbFGtxgyHJct5hVctBp8nacRLBe9o+Q+WmlCwWbg367NnILpL/OWWGlsOWtimyCjHf2/wui0mr6zuk8M3c5Lcpw1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aPFzhYdQTBJNMvQAzTHcV2UTTDRXsHIxg4c1emypA/4=;
 b=iMqtbZH+QawxAgw/tj945aFpdZJ6ElNfVS93yozY+fufRP0diqSuOhnS+H0j3HPyPOHCuLfz6u3Rz3ctH4tuegfPhnc1m4CWVMcbUDz3LhwAaniiBfDGd4U7HDplG3YUZHglfRaShO4P7VUPk6nUDhaJJmAYTbBQ7Rbpd/5OfMaMJ/rJ88FnFamtYdWf8vKIPSz85OuRD0iH7PhKT7kkkqbUY+Tjo4N5an5670LhhePmTgZ0fKs0U3WMqCAMl5auSQtxCU9ieriu/I+nlLDGuzv0Nc6ttXDHyjcIZ3ESct7wUb3Nn7TeTt+Olq0+yyreXcKIVvf9Hj4aQB4bqVB0sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aPFzhYdQTBJNMvQAzTHcV2UTTDRXsHIxg4c1emypA/4=;
 b=oQ6CE9te7a4RdqdPrz9YrInPkcZrewXvR+tKj3EqD1HLvp2BvC/xtTGvSReE2LeQI4CzLb6K3SY3OYZjevRdb+MI+qkKDQCGhrQhILbhDR1G6qt1GNzWweQIMt5/ImRtTo70E4okB2CO6Fejvd3W3GOpypdNYApkTazHAZlDLbA=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by SJ2PR10MB7812.namprd10.prod.outlook.com (2603:10b6:a03:574::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Tue, 3 Feb
 2026 11:43:13 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Tue, 3 Feb 2026
 11:43:12 +0000
Date: Tue, 3 Feb 2026 11:43:11 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
        lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
        joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
        gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
        jannh@google.com, pfalcato@suse.de, jackmanb@google.com,
        hannes@cmpxchg.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        cl@gentwo.org, jglisse@google.com, zokeefe@google.com,
        rientjes@google.com, rdunlap@infradead.org, hughd@google.com,
        richard.weiyang@gmail.com, David Hildenbrand <david@redhat.com>,
        shivankg@amd.com
Subject: Re: [PATCH mm-unstable v14 03/16] introduce collapse_single_pmd to
 unify khugepaged and madvise_collapse
Message-ID: <6035e6c6-f090-44b0-8098-5b734fc3137b@lucifer.local>
References: <20260122192841.128719-1-npache@redhat.com>
 <20260122192841.128719-4-npache@redhat.com>
 <b824f131-3e51-422c-9e98-044b0a2928a6@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b824f131-3e51-422c-9e98-044b0a2928a6@redhat.com>
X-ClientProxiedBy: LO4P265CA0027.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::17) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|SJ2PR10MB7812:EE_
X-MS-Office365-Filtering-Correlation-Id: d9e46287-b844-4e84-cba0-08de63196903
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wMfmogGxp1w08H3IkVQ4xJsZ0abC37ZxayiXj5aCUV4JiQJatPx9ZNhhx65O?=
 =?us-ascii?Q?3/y3/mIflO5xQmzLnl6VBvrhQ8qA0z653zCYvEXEhjN/YgBPJXxowjMXaoKi?=
 =?us-ascii?Q?QXrLt2a3dTVD1gGA6V9cftS8Hzd8tQc2Y+CRJ7FilTSxO5n8Fa4sjsmSI5Y4?=
 =?us-ascii?Q?KG4stHllJce9mImdP/inszPqfxfMpcxbk2oGFr2YyJb169mug7FA50RAe+Mw?=
 =?us-ascii?Q?jagnRe9sU8mLOJWQzMvOf77pQ8SdWsNj2hmcLI5fuQCleJpnZ3Oy/vDKoB4j?=
 =?us-ascii?Q?X7PUbPuPyA75qqxEDPfvUPcV5DBQs6gqDcAZsbXaDUSpIMQTVaPMGoVEpaSm?=
 =?us-ascii?Q?Zf4EYmTCAc+MiY67D76VSEvHJ+wJPbXJxy/CPLXm+YPOHs8H4/F7qD1SBC2A?=
 =?us-ascii?Q?cTWk5iryLoChUIZtliSZ+f6cqUsMJu66bjPoJCEQRInbDKXbaS9BP3iR4/gr?=
 =?us-ascii?Q?NCSIYj5kVEFxjVl1z4mVuXArAJd1pcn7JUWzQcqbi5ZTbVcPHb5RB7AD1ZaX?=
 =?us-ascii?Q?XEFibXMb5N7h7GlJNrtAVgqKZxF3xosH155xi2pYJBtNapYI3CQHSaFV0IMc?=
 =?us-ascii?Q?ScBy1nObxRCXwrYbAxDb9S8zfIMBvcWfLqdaJS4sO6TwOolJn1dwnpEUNS8z?=
 =?us-ascii?Q?NuzNLteiDzC5IUBCC0rttvP2Tm4hN0MZxluQIZtlPoFYAUAmMZR6saVFujnl?=
 =?us-ascii?Q?UPIUu4h1OMXDY8A+nXuYXXnpwhv6OPtZ7Sx/69ctFFmdl5d+/B7osDiL+f8F?=
 =?us-ascii?Q?rf8JudAsadoZblkcbaNoMbCttNqxjIj+UFfKjb4HQBRdSAfv/lI/ZGSKxUm+?=
 =?us-ascii?Q?e96XCU1yArQR19k0wW7mFeE4prX4imO/EydvnqoinTusscBinpSRTFHE2Yv2?=
 =?us-ascii?Q?HmrGcSpF7JPeoMlQ8zVYndrAZncIdwxedV9wZFOAqBLPJzrYUxqgA4heBxXF?=
 =?us-ascii?Q?B2lsIySfH1yAXh/THtTjjOexxyw+BE6Z3E8dZlSnPwLryuK6rYrWzVZTqZxj?=
 =?us-ascii?Q?2Ec93zxDsMD9/WXpnAN9jg38SIXpWEa2Dz0RLjdF8rwUIY4BU8bBwjCB9QhG?=
 =?us-ascii?Q?lj0KFEZ3aPtrHolcKFIH6Ir9ZtA1lDxa2pjLGGy67j4udDLVo1UTU2E+yNMG?=
 =?us-ascii?Q?qO+veBgrfkY1eI62VYJMvF58vV8jFY8Sd5nNBleJFB2gFt3xDVhvBKKthPde?=
 =?us-ascii?Q?wSJbuwkIQ/Rt2+NzKRweToGEFwSEs+dl3eOeuyEmsLvgzb6e35NpBzdwlNN7?=
 =?us-ascii?Q?R222S44lUCQqr/5XDX9bKba2cniHAu55IAymmVj6BMm/70/4MdWnsIwd0fBB?=
 =?us-ascii?Q?+x0aYC3ua9nsFhTxWNBrcPIm5jSKV9Arbrza1M1BCG6B5pnqRUY1s4UZSpqE?=
 =?us-ascii?Q?ldTRQ2kw4xEJIdvqCKXEWRvmGubQe777/8OZsl1sEvsgkFpbzCxpCl5O3pif?=
 =?us-ascii?Q?H6bOGiWOlb81xin9q0bZHGjwCI6AVXqphPhtsI3TseGgzwFIPqMNuCX6eMMT?=
 =?us-ascii?Q?SR/6VpkGMGDo6nJne/oAk2JD7QQpZa5unDB3a+KocyIN7CLV73G8t3ZD5Qxz?=
 =?us-ascii?Q?LRv64rUcmt1XC2MpRmc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YB1M1aId/qFQnHZBKAHcTcaLAVdQd1tIEjtpTpy6ie/ZhFqWrMoztqefnK4O?=
 =?us-ascii?Q?SzsKHwesh1P8Sxl7gbPJSvKX3r9JIyn4FKa8GWwQxk/DlDcoqD4tJ4bg8AIj?=
 =?us-ascii?Q?dnJZZ5h5gszKTAsOL+C6KOtOGNfQo7kdes00++0by6Urdz26xrl/e1+wA4yY?=
 =?us-ascii?Q?xz8bYJrmV1Q2Zgu0PzEtGlF1+gYhokTANhZkaEYiRowcGqGuZlYo+sFXEI2J?=
 =?us-ascii?Q?cUNPgPNnoKLPEjCtUsOZPj4YpNu/63d9Anu3kPJWOeGkl7BXo+z19Es+Ybeg?=
 =?us-ascii?Q?v0MtdISZ9mxZYJhEcm2WPktCaGoh5stx/B9XG1AyJisj1jFuETp53JnQ5aAL?=
 =?us-ascii?Q?cq5Zik2PV9Vusw1iiVqijgCioG9ecy9ypF0z5sEmfLZBkXmZJXrYb6ZMCHHk?=
 =?us-ascii?Q?+ssgFwDQNmgLI+8zL/hSvc1NUiIzZ1caTWeP/00yCvV4kpCorgQBgOhsUUTs?=
 =?us-ascii?Q?2yx/UfWc5diB7yIXRkCPB/R2+46ABDuuTCVilQuOEXk/tBIb1X4h9fPJoqpq?=
 =?us-ascii?Q?WXdV7EBF8+Tn4OErs/ZwPYSw4LOYF1cglPNJBT76SP4JZJGaQVjiFSb2atXz?=
 =?us-ascii?Q?NyA8iiR2/jctaex0B6Z2EZ6+7OfbT1dOyfHklNYupXeiCo11bj3LFWpI/4uy?=
 =?us-ascii?Q?Rb5FnCGc7P3usvZCDtX+nEfMZCZnnFESY83NzJQLl4WN7rTV0F+7l5Ba4ruH?=
 =?us-ascii?Q?iYCAK9hCpPekTr5jlpYe+9lyYEAu0VXrqnYt3+p60KFmskLE3gJTD+dWUNb/?=
 =?us-ascii?Q?B5dux4hqAf8x5Bsar8NJIJ7CfoSvD0t+LMS9OiQpnKe/EUnKd/Lk/ZoGeQLr?=
 =?us-ascii?Q?BCFv7qetHNo9jS62EUhXYxeCuLhsitKnyvOy9WRcQfKKmZJmH0LHTZp797nA?=
 =?us-ascii?Q?ORL5GMW7qhHv2JdN0qt6r6SmB2UXzANVzqbsaHMRGpEZUbem2gk3cOGakwiS?=
 =?us-ascii?Q?5wKbbbZ9KYXiScfz6GJzCNeQ+UgU/OnMoxV21pc/vfhXofP4dkNUyN4aAXwv?=
 =?us-ascii?Q?YWWnMrw6XkFeB7QBL7/mZhBp7CB0HKRkeSkj+2/dJqphoWnDn+CVU99eKTEa?=
 =?us-ascii?Q?MqZHYp4T7BlT6VLNjNUBIXd/ddEa3NbDXYyTln23XeY3QRsNZe+Admkfnfip?=
 =?us-ascii?Q?hTu/uth2uPYvsUvZDtao/inuK7kVmjwslQt3rwQVllRrB6UKO1Ach+vmmf/C?=
 =?us-ascii?Q?nsyNU3hm4SmUpDmZn73cdtHQT+3HFb8U+YlxnSKuNSkXW1TZ2bhYzqfLqPYW?=
 =?us-ascii?Q?jkN0/rtY8w2Y5GBp/X59mwHyLFj/7qbDYB0MyUGnv7ysRdcmtTqM+t1KGrxn?=
 =?us-ascii?Q?IdmFvasdySg9senad5EorY38ATUa2n8ywMSIq4uLugFdwUxLbCMzyZbTQc0G?=
 =?us-ascii?Q?UbcM74GtKLEtTZt1aEOVEtN2ez9GFSxpf644+5/QMckeSLOHdDj1tJ8Vh/SI?=
 =?us-ascii?Q?7vkH27I4cm4zwbDA05LROuygqCYll06EJ8yCAoIx1byySH+FC5j4tNO1TH1G?=
 =?us-ascii?Q?gM8CpYm3it4ofNlSmJymDqgQcrfI7E97M0nV6HeIppp3j9pO+LxzyXUZCs7U?=
 =?us-ascii?Q?hcdpOKDDdvU2dxjDqUzfWuT2WJlN2Q4Eahwtsar13P2wCJveEnlLEtjgSGcR?=
 =?us-ascii?Q?d606MJojXQETURnDJWnAHnVdZ1UdPCNqwKIkhU92Sa5H8vOt4RhHmGtvR81L?=
 =?us-ascii?Q?HA814ajDrHWP933ZuFWPrvkeD0IRn+ZPHG0ySqf4hIrZq5OIqoSof+VB7XI4?=
 =?us-ascii?Q?NVPA4eQ7SGCxaF2tNuvLXeHSCI4qm88=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nquzj6LoyC8Hnk4A4+XDm7tfBQV8fc8X3OQT04gfnoF7Swtq31QL6OrZlOPZfgEpa+uJwxzd2GLXcPuRvP1nRuF+CW9X1OcEvk3Ck8skp3kkDA/0vXRyOzvMBE5l4RmAVT8mhlg8qLnohK1/94pQtryFKGn8EA3R8ttguMlA+a9zmzUaKHPrdyYKypO2axQSyHhU8K/onePXntdVq7SN0wt+NxeTMSKPuWH4RMuLdEN61T8vCGptyRBcmz3/8vrTsUPbeatl2a6vN0hUpmUm/5yBlUh+dIaLKebKaenwy0s5NwjhnJeEfaYyBglfwzzCAXqC8B0hhNGhoJvmyQIPgpPuS15pkSyNnXmy066gPxyI00Vdp4R0vfGhMdzCRtiNpBC+CYC08lhsfg/i6ReX3/nMER+qb7/z5GCvMYw4Ww+JGKCSzmfB+rzZRfLtZNsqC+5CgddhVuOs4mzTYlk1rE2FJVmqnOhVbZT754jy6ngxpQ8Avx89YyYU3eWTMP5p3msFfLH9Ds9ZPp5iy9XBNBuz6MSE+gPCVTnX4KhYfzeH3J9qUBoiL4b8ImjYHTqWHCox+O97X6knvn5A8CASAHdIlWZWUQ839SJAvEbUhOA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9e46287-b844-4e84-cba0-08de63196903
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 11:43:12.8720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9KOngTDwr7m4UMu7U6Ilm7eAqD+Z7ffeVcPksKexUL/TV0VT3jd1TeIxW5iAx1y0RrjDv0yjNdk5hJ7MdjYsmayw9wPXp2WemoFV3E9Zfbw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7812
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_03,2026-02-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602030093
X-Proofpoint-ORIG-GUID: AnW1Yd5D2iwKQf9-DX-x0plKP-XD0yYt
X-Authority-Analysis: v=2.4 cv=Sq6dKfO0 c=1 sm=1 tr=0 ts=6981df58 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=WW_QZW4_xX5mUVyJACUA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:13644
X-Proofpoint-GUID: AnW1Yd5D2iwKQf9-DX-x0plKP-XD0yYt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAzMDA5MyBTYWx0ZWRfX8ZrAQ8Hi40hp
 gaKUBVf7KOLfKWcASp17o+armiivlpnqmebsN1Yf0BEbRHfEVRzJ48zRo7n8Km1BFcOJTVqbiPP
 hTWYM0qOB/Gt+LTH/DsceFn3jgSDqnU2s1FPf3InKJDNaB+7eQVn4M0JMXkak2Rm61OcsGuwxEK
 MEYsAFfss94EYXfSiOL6jOXM0qauw9UsNdqyZsDshXfHYXCTybhL2UztlT+FuCCeIGKjIZYxVg2
 Fb55+wn2OlQMbTQLWQpg2zTGe1Oum5Q49gA/Qw9awURUHdJrFcJZj6S5UzzfPobknHoBt43F9iB
 p6eNECX+4xaM1aYDpnNqZC61kmTp4fYgwggVol6B70JhRy6UPPzrM2fHITaG/xP7GM20DVgRMeD
 OC1BBf8CPIwWBgQXIpwGU34VthBctkkAFGXFD15StNEjcLnUydytnRGfOsXpLL9Jn+1eRXYK4PT
 KXSTmJlZilV56a8+0PMNfAHvaJ9a85Plt3fZWPIw=
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 75AB94000C
X-Stat-Signature: mtzy8thbb8q9kigc9y44dswk1t9tazdc
X-Rspam-User: 
X-HE-Tag: 1770119025-162222
X-HE-Meta: U2FsdGVkX18CkQX+oxdNZ5EkEhjf73kKUEIdP7/f/GYpzmtV0sjHTCUuLxaXt/nbget9HuWWLIczVh3oOGYibgd6yRHirfa3u1Pr1kqV+U+lFCnaADSvpHdRRPPWHdQWuKUdEWA7TxylE7xIHBgx6Pm3sw1ixZrAhlmVvfyc0JmWiVCkhfgU0aA8v3ESmCfiy2HxzU5lheU1q34haI2HFNNHpduz6jq54g7Pc80XisaxQyaTG0K0N9B6j6mIn1gFszYOhDP4jz3D5WjgywWvmupiynVbF9BCNbdHDi5I9LJMQmjUJlFr0h3JM/7v5eAluPr2zAHDdjPPZGaoLxxPFxF07PqfxMc6UUlhK9IKXKziX8sCBapCht5VAzczbuoN+VAUeVfi5By6tstjOjgrK9gOXH1VJaiEVi90NolqtjVwHpqh4RlCMKvh6AX3j0iONxCebZADv15nXDi0PldpdI98eeZc0oL7QLKoL7TXu6Y4mw3JZCJO11fW++x5dHApJiK4CSPf569WygCDGiaN3+FngAfedyKirvYQwNYL2a8rYj6kN4FZ1ZirB7WT2sqhnjpMrgZugP+ry31/gQONJBlEhsiUZ8wv0IrfVwWLomqHS/hpXa0fMsHrv/DwaajgioH6hJIBV4cCBV66r95s0mixRt21M6j1TwtSFsTGXo7TFk3qQ6K3Cf0B9gih9EbcUMIITL34fMdCyikriuxTw+WWuNmIEb62xNoK2SGXJ8atT+6gdCtvCuZ+A2fHTOZj9rFbX2KrDj7mjoThxe5K0BAzxhA1NuqmAY48uEUJ5T/VF3B6LrKuuYhMidLMMySZVcCQFlYkKMnrLKrNW1s1jLcZpOwlt0cl2i6EuL3DS1NOEZmwSlhr2hnKn06qtDvvbXXyDlDKsHQOXLuJtGYt978obqbUeVWs/msrZGIBI8Md8N1eOTtlcKsDGpNYRkhPAfOkV1NFqSS75V/x+wN
 YkRO+ZgA
 oMlhhUIRsInLh1t5PG4g/VETp0tBavD8Na1BqceARGv2HkncIJEtjliNKVEZgMhc66DhK45zPAs0258fa6C22SW4ku8Y2P+OCuXOo7YCO55+BWQ+kPaUFl3eihNIJGd7B/NOz+GXcRQUB+xHzrIPHHmBVKEBan/dNqCfVw0dBmgXD5ehcd1zd8VgmFKeFf49KhNmA2Tak7Gg5rbe7J8LzTq+NX4rd3U3UtU9EfTxRiPoKGbBZ0/QrpyCq/9qhTrnEQKsoOwZVcTjUVTAgP2/K9UghaKU06G0dLVU7rOLk68qbCguOkbjIjY9nSkhXzG4Pl2A2Jdv9oWDw9evVvUYYah2IR26sjPT5zE0iPep9fQVRoVaYKk7E5PP9k+RX/wk8HOAjaY5VOsZv4LNXXlLO6cytBbysJZyQl9wgfzbajXhX2Z1pUo2eMHcHhsVFRxu5MSWvGBrDzIQcqOdwC9Z6+L8rGM2l/D9QYAVnOCQr7cj3ozswSS8AtxxFo6typhdvT9xJfx4THkaSTijbPudqWL9FEb/Zg9uswQaUiURKMOCNuqgPDy0GN7M0kuHwEfrZYQHr3TRM8kX3mrIvO4emPvRIjFFq1FZJQ136C2hXcu8GBW1EmIPy4Xlmd6JPqKBUYZIIITA55XFG1Af/TW8SMsCvL45KuR830qZGL2S6jUIJfxMJW163F4XfyuTBXXvjqYNrDnZ3S8zIUpxqfTRuRz6NXsVI24ueTsEd3yqkYmO/uAXSBS6IYqFsvLo0tC8ug3aqAOV5XOv27hSFbkmIMVDN8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 09:38:37AM -0700, Nico Pache wrote:
> Hi Andrew,
>
> could you please apply the following fixup to avoid potentially using a stale
> VMA in the new writeback-retry logic for madvise collapse.
>
> Thank you!
> -- Nico
>
> ----8<----
> commit a9ac3b1bfa926dd707ac3a785583f8d7a0579578
> Author: Nico Pache <npache@redhat.com>
> Date:   Fri Jan 23 16:32:42 2026 -0700
>
>     madvise writeback retry logic fix
>
>     Signed-off-by: Nico Pache <npache@redhat.com>
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 59e5a5588d85..2b054f7d9753 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2418,6 +2418,14 @@ static enum scan_result collapse_single_pmd(unsigned long
> addr,
>  	mmap_read_unlock(mm);
>  	*mmap_locked = false;
>  	result = collapse_scan_file(mm, addr, file, pgoff, cc);
> +
> +	if (!cc->is_khugepaged && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
> +	    mapping_can_writeback(file->f_mapping)) {
> +		const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
> +		const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
> +
> +		filemap_write_and_wait_range(file->f_mapping, lstart, lend);
> +	}
>  	fput(file);
>
>  	if (result != SCAN_PTE_MAPPED_HUGEPAGE)
> @@ -2840,19 +2848,8 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned
> long start,
>  			*lock_dropped = true;
>
>  		if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb) {
> -			struct file *file = get_file(vma->vm_file);
> -			pgoff_t pgoff = linear_page_index(vma, addr);
> -
> -			if (mapping_can_writeback(file->f_mapping)) {
> -				loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
> -				loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
> -
> -				filemap_write_and_wait_range(file->f_mapping, lstart, lend);
> -				triggered_wb = true;
> -				fput(file);
> -				goto retry;
> -			}
> -			fput(file);
> +			triggered_wb = true;
> +			goto retry;
>  		}

LGTM, with this in place you can add back my tag to the patch.

It'd be good to reference this in the commit message, but you can do that
on a respin.

So:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

