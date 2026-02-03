Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40D17E87823
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 13:13:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D7736B0089; Tue,  3 Feb 2026 08:13:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75A916B0099; Tue,  3 Feb 2026 08:13:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E77D6B00A8; Tue,  3 Feb 2026 08:13:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4946A6B0089
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 08:13:25 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EBCE3D4F7F
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 13:13:24 +0000 (UTC)
X-FDA: 84403186728.30.F667FAB
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5FF1D1C0012
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 13:13:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kf0Tmno6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=X2rNvrWr;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770124401; a=rsa-sha256;
	cv=pass;
	b=1Q1afySXJaoCqouYdAuP/Ij2x7XUek2jAwnzCAF9tpOr9Vxw7JBzxCHf80gyhZPdb/q5pL
	qIXm21ddW5hI+6R7UummWRWmAPoFlkDrLsvOmaIO3+7sj2kUxAGpQgnCf2p19HgH+ve8Ka
	7vvHhPDZwEr34deIdz7Aj/p6ahjacXs=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kf0Tmno6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=X2rNvrWr;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770124401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rxHw95+Qd8BXUB9H+0OqwAsntUIcVREyXc+TG8GggD4=;
	b=Z+jRCep5oEnyY+oU024hu9GlChdt3I3kOGZMW5QfyGkRl61uJbAXawE75UN9zpBUVcA9XI
	ImqvVRt9eGZFKCnglcGNeMolgWr4WoyOHQqNhpLnDeo4IhfgNLM89q2sDlEX2gufst8qzo
	JXRRGeUi2S/D1sPylDXr3+BXH8ERm4g=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6138vFXf406479;
	Tue, 3 Feb 2026 13:07:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=rxHw95+Qd8BXUB9H+0
	OqwAsntUIcVREyXc+TG8GggD4=; b=kf0Tmno6i9x1cws2Agzf0igyJxJFI0/XKx
	W7z+cY5jVaX5eT8ZeogJPuZGheNRbTwtQt2ZnFsDcdZir8fgiSjm9xLt8M5rGXLH
	zhijurCo5es3bCk3Y95hBjkBncOBLukyfzLImUPP92lRjmYnrEvJYgFaj+1me5Pp
	PAOLnkz/SYGDPrYultg8ELNDTEbE0yn+qSwIlIthn4Xl5po+vP6VI6BHptcwODdP
	IU6PvWDNpvL1uK5vdS4ygW6iel4z9CYv1d8me3fVb4on1i8FzHS4nxLl/ADEIkzZ
	/cTBSylNI8DR6ugG8nGbrXNA7Jr/uq7fvyTObQ61ueUTBc1yUghA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c1atmc1nw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Feb 2026 13:07:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 613D1SOn025622;
	Tue, 3 Feb 2026 13:07:38 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013012.outbound.protection.outlook.com [40.93.196.12])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c2578drpp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Feb 2026 13:07:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E4VO0uDoIKrSV3ehzMLsEmTs7SZsESG8mHaYB4VNBeOERS3VJi1BTUTPz9gWNEZLmTvVwBQinnWvcArVdp5x25USwimX1NDEhhZ/xLGTCDZSYGMEvjgJfe3smH1ejVDnxu96Dal5ezHcrBOn2YCLq2gQ9CPN87Nld81d13DoFjyi0RRmRTeF8xSAnZIAgSo0RpbCojx9W71lK0cHE2acrgAbuneazyH78lyMv+YAtgrv/F2g6y9g41LHFuOWsr/s/oraH4nl8KSV6xtOmTB97jXASTvADUx7pVuCjKalD765seBf6vwU7zLZ1xTlR9ZKaMqhl7Sy0hKKqfMeTwYYtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rxHw95+Qd8BXUB9H+0OqwAsntUIcVREyXc+TG8GggD4=;
 b=xjZyMpAnZGGGYLfK1tN/o4J9xSoY4WTE/QBtdFnohIjmGW1tYoNrzuoDVb6SRY0GbUCAJ1C77cvp1qVqWTI7eZDGryMDbSJqR2pBf/tzjQzSUdGKabxPZynbC2YetoRhsnXwrt8xlhyoYDnfrehe8tQngEIN4UinmreJvRKP8fJQPawyqE1MtN2MbAoGKQbsmJgWvPj+j1URylqsl04ja/El0ygOj+IW2oCum8o47zJlSpXvwT+ryp7yS79VjzC98JG9Z9xVzPLAFnBaOm+NHzhVn8pIjnUGhsi0CVh/sskmTIJxTTiB0NEQKc51icxRS94bwHuRzLM45c+MkonAJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rxHw95+Qd8BXUB9H+0OqwAsntUIcVREyXc+TG8GggD4=;
 b=X2rNvrWrDAWTDdW4pEmUchDC7Ec0uHrcHAHuy1NQIlj7NQOiOfV6AEUWiNrldv6AqpsXRtmggD6GVHPlYpNaepDDZc8cjwXLO0rJVnOKJryGIIpY7AN4JYzTEdmxPSOJ7T/0kikXGrPaTQK+7It09pvpZEdg1wNWIyHGXrFRc2k=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA3PR10MB8139.namprd10.prod.outlook.com (2603:10b6:208:514::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Tue, 3 Feb
 2026 13:07:32 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Tue, 3 Feb 2026
 13:07:32 +0000
Date: Tue, 3 Feb 2026 13:07:32 +0000
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
        richard.weiyang@gmail.com
Subject: Re: [PATCH mm-unstable v14 08/16] khugepaged: generalize
 collapse_huge_page for mTHP collapse
Message-ID: <599ebe0a-086a-4701-b797-dcd801ad02fb@lucifer.local>
References: <20260122192841.128719-1-npache@redhat.com>
 <20260122192841.128719-9-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122192841.128719-9-npache@redhat.com>
X-ClientProxiedBy: LO4P123CA0253.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::6) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA3PR10MB8139:EE_
X-MS-Office365-Filtering-Correlation-Id: a65def12-c435-4f1b-840c-08de63253136
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VCKSRwbyxW1nfAYbaEUcYGpCvPO3AiR86XIQdZzDrQRmbwvkY/ICqw4lPdhL?=
 =?us-ascii?Q?cEh4GUrmLGxtukmyfUPb4fvt9/7kU6nLTHdyDI2E7TneY8W+E8YLILK3nYte?=
 =?us-ascii?Q?0fOncBFSgV3ky37J7ubqwinRDi3CCdOa38TLNm9f7CYPdaE8UkZrG4I8KcPU?=
 =?us-ascii?Q?zXGqEH/rVssRHbONY/2h34pp6BsGKfKDhQ7uRR+x9NzYY69AUkiV4hxAGjQn?=
 =?us-ascii?Q?r6M+y3JEaoFIIeEGYqobNGF30hu3mwKM3MIfVtFcvFBFOk516u1LhBq4NBea?=
 =?us-ascii?Q?nzzZz1fBYWy4K36wbuBeVi+y275a5CpezFVgwiDgg9e8yIq3CC5FTFyoV+kh?=
 =?us-ascii?Q?/9TpBrDfiLOX8SIGYsNVOrYzfo07Cv2xtH6Zz/usWZpfDpZzA4/JG2h46wBv?=
 =?us-ascii?Q?iFbI/XDe8hmxlxByRh3S7XrJapRquTx3Z75IxpbnJ5sN890pXEl8hlhkKFng?=
 =?us-ascii?Q?xiOow5/kQdy8lM16I7fy2HVIsRhi/NIsCmJLNsjbhMwK6j7Sez8aC4hIAxQF?=
 =?us-ascii?Q?34NhKhQo3YZ3p5tqSFjJpo2GKlc+aveB2ld2uSkUpy3glOvdwcD7GOG1FvcO?=
 =?us-ascii?Q?xCm1OtndUnLnmW5xJClY0njxtLoTAqw2W66i0dKfGY2W8J0KFRDrvRl/K8K6?=
 =?us-ascii?Q?vn7sjXyhYEJRPylz1HkKhUSSYnifQTnAqMN6QSJ9WPQ7IB0fdkklbCCKSbD9?=
 =?us-ascii?Q?RBmeAq+9PJwE3aeMdh9JrmZJwyPkShGWFNylFXpEsD0fFEImkdzJPPCT4g1L?=
 =?us-ascii?Q?9Sr3dCL58JA2fsbF+WY6qxY1oMfDU/ypg57g0o87sexTtWBjBnFpSfhCKVfw?=
 =?us-ascii?Q?6wSW0SFrVByf/MzwWZIOBsQa+Z2+I0nQGZNz95ruoBn+exLaYx8LbhvEUbCU?=
 =?us-ascii?Q?ZdH6kJlV2weyp6QIb6rBuKfBYGFJ/fcVrbgODBlF3IOJ1XLW4XTpycMr69ee?=
 =?us-ascii?Q?zpMerYm0tkbWzmEVUjWVSXjmRTKVISEN914IOqy9Pf8MBZYAf7zppZiE2TIw?=
 =?us-ascii?Q?uGRCffwPhQdEMPTIWU3MCBJeceuwWi2PkIMRB4iH2+i8cosXeHJ3WHJ8aVLn?=
 =?us-ascii?Q?FES2vVGCUpeqlSRf29wmVH/ZnsSmC3A3Pep/TLLwSk4DEcqYuqKu8d6DxC0L?=
 =?us-ascii?Q?8+joUI4ZpJrpkYYY0u3U5irZpL9TDNLdXnrYSbRrtM8WlE30HMAJZSAxi/Ox?=
 =?us-ascii?Q?uj+NHcTKqgvGl8iOVvgmCJk+/u08LXSuKiLSY+SoQvwSo13VpmdrgCUGsREn?=
 =?us-ascii?Q?WcXdgiUR+Xvi8cyqJ7H21BZEC88uiO5b9sqpaNRzUBzKpVbKF7fdg4fLsENc?=
 =?us-ascii?Q?DormwlYI4gx/UCQAldfcOle9gpgq0MkYnHYIkN4dIf8pAzyikJBSrh/z++CX?=
 =?us-ascii?Q?XZ5WaqPxhGaCXfbz4ANuzJzaZB1VSJZPyOBKWM2ukdwNfhI449iDT6P8EuPQ?=
 =?us-ascii?Q?aAm8Bd3f3m3lMtam/Y2Td/79pqTtz4vExKtevAqaAUcxq9id6HomDmAOgOeu?=
 =?us-ascii?Q?I5BeqsmWQNMtLQNID6Yhzkc7IWFmaz5UWSyRaM6VNlv7sZHZegVp9X8GFt56?=
 =?us-ascii?Q?3h57db9DBYAbaTCzSWo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HW7lfZsEcxSe/0mczaijjFYLt3j7vTfK3yufaVqnmNLTTaIIsT57D8M/nc6J?=
 =?us-ascii?Q?JLItMHfgcV0K1Dw3A17NmTWGEY/miJTjup2GfFcsNHQPgXw3ZznDJVu+B0cx?=
 =?us-ascii?Q?VOSk6hTlNe5fluTyoOwVkL8FAA0D5AMVGS2k3JGrnHYoO/q+qn05hnV46KY6?=
 =?us-ascii?Q?HQisj778iI+R0O1iXfodlm2KIsXSKkt5il0hiaaqBoAOr21H6kQHVybfOZmb?=
 =?us-ascii?Q?LJgikRsUXs6jVRqTroXRBJSqxNIZf1qMVR00Kb+B3OxlCITF5jRzG6Cu7jP5?=
 =?us-ascii?Q?9r71980jYqSF7Tsz9XdxQXRaPWZysSdRuLn0iBsPXu+7Rpe3JCaltBkgz4h+?=
 =?us-ascii?Q?uRYp2t1PTav9Jd7bCF1JIX/yc1HI8KO8/j0RZ1pibiUF+8GpIJILWB63zlGD?=
 =?us-ascii?Q?ERc0QwYLsObnnthQd7Upo+HYQZ0xoGHhD96K4J3rCPezu/yeleX6eOE92AiS?=
 =?us-ascii?Q?U2xWpMtEg4gEA/kImAVzjBj5K/AFVF7iARCiAAePYe/pU2cNnIA8tF0JX7Wr?=
 =?us-ascii?Q?qnbC7cqfvcstOh6pv8IdXg5l1tjsvqgm5gGn5eT8i9ZtVOjugRD5LoHcAzx8?=
 =?us-ascii?Q?uCvaXB0uoAH9+on6OPfl8b/HeRwPC50+013ekQE64NeAX1W8C+S7Zv36jedR?=
 =?us-ascii?Q?IgLeoaG5kV4iCG4NZTmiwygn5k6lVtLOVnURTlUholUv9Zsj01RwpTsatoc8?=
 =?us-ascii?Q?Giove+IpF+83VawpKzVHo0Gguxcksty25MyA1LQKYZR4qXcO4kysM9+XDNGV?=
 =?us-ascii?Q?uFjpzSlIxBS6CQ9ujVmmGpCGQ6Z8ziUkOQ2H8AaHWTjIVM0fMquxGbeby1MZ?=
 =?us-ascii?Q?bVC5ic4lYemqf2qyDvDBgHZwpOA39Ts5ncVEAgY82hmgIKjkbrCnTR0tqx3b?=
 =?us-ascii?Q?KO0Vldhq0OBZnp7EkAB+5G3i4527Gpj8ZKyD7tysNUeNBuf3xptMXdPdTSqN?=
 =?us-ascii?Q?1OAtCsQloDO7UI7cYG5dtqcV5O8tcLQGevvIVIRIFao3O39PdU7aU6cDcevO?=
 =?us-ascii?Q?L3Aub+I8R+s4ujAJzmEL2ireJrwazwFlhsW7MpCZjSpmkTXpCvbvjsZ8ZFTF?=
 =?us-ascii?Q?/GNj04zBEKprYJAJTRuMO7a2atReque56Gh2Nn5Drz7suF8gjcEqmd4FYEIi?=
 =?us-ascii?Q?xbkVgr0Q2Ff1uMS/IjWuGncHGzxBrhfL/JXx5e9eYV1uHx8VWO+xB+0zJLzG?=
 =?us-ascii?Q?slNz9fc+Jg2XfHcqMlhVEfOJQf1yk2ys41L7j6PLaG51USgmP9VgybYG2E3l?=
 =?us-ascii?Q?td/uL3u4J+Q946SoCC+27fEdO503bINC8GueK2wwStEluY2sY6vCw072U+Ac?=
 =?us-ascii?Q?jlw3dn2fzNl/GdCVlLzbaerNFxzHn6iRyfZn5Yyn0heLyn1DiRBCnoFMGq4l?=
 =?us-ascii?Q?d4KyRhahvGNF3WzXhF5CQFAZFbnNJ0zPjLK6YrUn77Kh2T0ornGMuvKTkNws?=
 =?us-ascii?Q?H4arfXWQk909KWHcsljspm3u2YIJNy10jii9e9WPDKeIaVZxreu9oLIVmTpz?=
 =?us-ascii?Q?ZlF2ACdu0CRThulglpa9pZo/5X5GBfJYnqcZzdTpXSs6a7G7ermpH1MFeqoA?=
 =?us-ascii?Q?R8LS95L614zwiOjkFnKzPkbpoS1cH4c5blaon6vvnfnlb8OA9KrRTv8gt1pe?=
 =?us-ascii?Q?iayJNC7I68/5GgJq4aWSU4qpm0Gf7f0A7ENkjYwHzQG/3yOE15MBAzDCU0SA?=
 =?us-ascii?Q?KqpJQX4+ZzsKK0fwef/aZlisgYmae0pao01eAczxPLbYb5QcuRLIRKBJcMNl?=
 =?us-ascii?Q?hiWjDjfsgnucgqGan0FgM7VS5iGazfA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lm4moD1QviGO7Kc9FKVCZkWL51V6IgD5AP1b37xhykpIVILqbEQo2EY/TQWqMUJmmnQg6B2q6RxfZFLbAoKEHaFAK2TccDurt7Dog8TrkQMtNjzoooOAixwL6/+3rzlrD/p+qmQfYRuR+qAOeIhnim3KkNqAyyFWVNzNdRU/BOjTc/Ifqw6OWMB/7bIJ2BqR0utGI3sdHSOws30g2vJJ5R+kn5wRRNKM4vYnPViDHHyqauw+kaRSGpgvFKRdEOQ/u1/f9WANZ7iif9ssOrR49B1RsudHHvZFCOrnpJ1j48/XWvb5WAzNL8F6GUeF3zYbLd+xZDU1U/8MWfWUjUjXRrX4zGY+CcsfZqKiHw2WWSvuv7kmKZmjoFbXPXRhspVYWkmR9J5pBq4EVyyQTjQHzhP/9zW0D1kSvDmBnaJO+rEcNYoNTHdvUPSu7vH+/6X6dnVUMSexeK5d8FLEWahRurBdibshM4eRedOQ5Sz5OrJKL3JlSDy1q2oI/PZn/bMZsRC2ii2hpLZ9phYykncST6oN6Ao+Y2QMvRrP7tKgXxgGfchTBPl0uMgaJ1AZaK/5Wby9lY77m+nZpAGcDaGRodN/lKR5tcl6QoxcDL36ZY0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a65def12-c435-4f1b-840c-08de63253136
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 13:07:32.4934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2gifcqCaEiwI+kzlpq+rOui11W9Gx/Ci2bk8U2R0s5XsxT8nIP/9SVyemBbEEf7KL9SvqHxmlz3wNLPmVt+4WvXAUSTd0YwYAJXp/pW+ShI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8139
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_04,2026-02-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602030104
X-Proofpoint-ORIG-GUID: 8SL3Icj-xNo29ZrC59blE555IUJjShhQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAzMDEwNSBTYWx0ZWRfX4YN9pf7bGej4
 Ahnp+BuTsgw/MT8As5MTu29GlA38jlcie2KrQJ1d6J52CoHgnxweFa/vDGyYp31cG695eR2U98k
 8WeDBQ2Ga1b1FPm6D+31W3N9+nFr9o1gOTq00fwwym22IKpM5e6BQ7RFBSCC6WsM4ocCDRAgOKh
 sdNRRLVGSpQ+CN9OfpmDbHu96jo2X45eInMmoG6GiXh2evS2+ieJFimIK9w1pxqlkPAqsSAUdAl
 l8Pqk7KxknxJ7TvS7ks3fhnbzmFUk+TYQzfvWVrCxEFtaEoTFPByqPKDTLCcEzQC12+HWKMsF2A
 XXVHkbewziHhxAlMoNtc2PovKTQmvLK3J+NGkCEqZX1jEbn7LEYWLzi/xE0B5zrMX6z9JwLYVrm
 LUehe1MCQSpEIDcPzTJXYGSrEPlO1PLvag9hNsNPzlT4j5Oxrn2Fljm7z7SX3/y5B8ZI0DxMGp0
 iJS5kZeq9sKiIHlG8v5+Q//o9bg0ffT5jrLnbEok=
X-Proofpoint-GUID: 8SL3Icj-xNo29ZrC59blE555IUJjShhQ
X-Authority-Analysis: v=2.4 cv=E+nAZKdl c=1 sm=1 tr=0 ts=6981f31b b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=SRrdq9N9AAAA:8 a=20KFwNOVAAAA:8 a=bLsKCNuO4QSNxImC1BIA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:13644
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5FF1D1C0012
X-Stat-Signature: f3d53mef51pgt6iije8epj4t4658obg5
X-HE-Tag: 1770124401-362208
X-HE-Meta: U2FsdGVkX18hIR3dLvRspu/P7a88GMOVLTCuAkSNoF0+yXdWUiaZjbuSv4u7auHj/qHeDrKxkG6LmsxPMGt3LonQzN42bmXvABSNFSAJT761qWkIa1PYcp5YCrmTT4nzDvehmfzJBhSl5TMh6OkCuaGWGOVtHCvJN4C99sf2zqbwxjEe8J9m3O53XKml2b6Gl9UckGZBCQA8vy7OB9EnDNvIpE1g9LDG0/44C4C4UsZlO23EG1TKQ89Lp4A9tly+11y8kERSvAsUYoewOFNCFLkLX1Ihe2op39y4A7sHBDjt3Qk3B4O9CZHVT0HsNO8EI20qwiTkt4wPof+BR569yIzrlkTsXWWrb45JZuPLSGTPO/H6/18L2HDfaUibE3Jb3JkfU+J4TtSZD0V9mmfvCDtkIAQJl+Gch2BRbei5rfHJT7/VSr0nlp4CMROWVXmkz8MRA6o+s3d3jeujuULqpOaheWPbSUOTxmcxx7AQd4Btk8oDZbKUqWJis6xEMJ9udI5FYZAPq340BkqXky3EdDUGMRtxuqqyUebuSyMWZyAkTOuCfEPnEcUtPI/39fgP9c6kbF5vRpQu12KEf5cHbYwBrnJsGY3cE/SFNOhyrm3TeMaNqNEueJSJugb7SpPevurNnCRaW0+NKWuG4cJL+5SaOy76wJmUkGsppUYhJnncEkNCaKL3a5W2aT68+XKFr6ndfZM+xs8JcA8GP492PQvCBdvV3EyJg+wAlW/YaezQtyE3GQMjU0YPlmZ+GR1/hxLwZhuCYLHGZDkEKhi/NE4bNcDPXsp2p/uMhLQQbrbp+kuiuNxv2z2J0IEAPpW6m0i9CR94KCuh8M70u0ukLkJut1IHfpJ13rqe8USCECFi7+PlZBZOxUGqq55X9zMyyReJg5R3eRjV3Px89hkt9BjoWJvSE5RJS214n77SjXRDAKcPKOKwpfNzt1Ud2UaJEwE8RsGev5vDnewGv/Q
 wmiqyp2n
 X760qJ7qUFckO1TQYLoaiGxMIegWHofNGJvKgsO6/e/2kXe4D/6Krbqf5PRGlz48QdZZEKT455Lvmt0OeT57RPRKN5ImWvf+OaVA3b/+2Poi/JBlAHeWEaUxcxeTxGr47MEtQ6qsJOsV6P6C4DpvlB3IGTpEja3z2GZVJuVTdT5GYE2oQmz5J08/QCAKU66Gj2wkoSQTTCn/mqz4WQWer55qO/6LcFJna3JSUKsFIFC3OQJoRyenyFDrdiQM1EhDNT/bCmobwzx7w1oIWEan5u7+xxFsFTUNbNdt78AWhasx/IOKbUwL/cPHVg+Do2y1vnjYLlAWpXIXCLcUgn7ulZjNnMO9zw8jbzc1zh2BdwH+61OFp1qgR/piUMmCgNAdGmT/qNzdBgTNn/vNbLOarZawoK0WPqmEoT/0ceotC+uLd5Rm1pVfy4u1gZAWBPn5xNdXuHQlkJT+McZKhe3LdRcPmjbACLszdaCa49kKHN7RaX/iqJwDJPUgY1/73PFH/wZEytofaCKz4EbJ+Kxfap89Wz/W9CQwUKLh015uyVtETTaHkKr1aCRaAtJV0ktfTZPPxpPPTBCt2Ajy13twKbDCRWaTSOMSxiWQuSXhG2wV+JBJrF3AjrKHycgmeX0/7P2FpsAlt1FUuhoHhfKfQgSMzjmhhwEKdi4pGYzLNz9+/ajQTwYYAsb8CEURwJuRj8lpbcn/MwBEq44MB+lKutwiuosTxvbR9v+rZ6hKFSSVbg+Yoc0WhDqObiXTP1PWPoASHnCtYLmoBjPzC3Kfy58BGc3YxODqQtb4qk7IiYwc9dXWmeKSQs9546AxifsP1e49m
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 12:28:33PM -0700, Nico Pache wrote:
> Pass an order and offset to collapse_huge_page to support collapsing anon
> memory to arbitrary orders within a PMD. order indicates what mTHP size we
> are attempting to collapse to, and offset indicates were in the PMD to
> start the collapse attempt.
>
> For non-PMD collapse we must leave the anon VMA write locked until after
> we collapse the mTHP-- in the PMD case all the pages are isolated, but in
> the mTHP case this is not true, and we must keep the lock to prevent
> changes to the VMA from occurring.
>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 111 +++++++++++++++++++++++++++++++-----------------
>  1 file changed, 71 insertions(+), 40 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 9b7e05827749..76cb17243793 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1151,44 +1151,54 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
>  	return SCAN_SUCCEED;
>  }
>
> -static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long address,
> -		int referenced, int unmapped, struct collapse_control *cc)
> +static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
> +		int referenced, int unmapped, struct collapse_control *cc,
> +		bool *mmap_locked, unsigned int order)
>  {
>  	LIST_HEAD(compound_pagelist);
>  	pmd_t *pmd, _pmd;
> -	pte_t *pte;
> +	pte_t *pte = NULL;
>  	pgtable_t pgtable;
>  	struct folio *folio;
>  	spinlock_t *pmd_ptl, *pte_ptl;
>  	enum scan_result result = SCAN_FAIL;
>  	struct vm_area_struct *vma;
>  	struct mmu_notifier_range range;
> +	bool anon_vma_locked = false;
> +	const unsigned long nr_pages = 1UL << order;
> +	const unsigned long pmd_address = start_addr & HPAGE_PMD_MASK;
>
> -	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
> +	VM_WARN_ON_ONCE(pmd_address & ~HPAGE_PMD_MASK);
>
>  	/*
>  	 * Before allocating the hugepage, release the mmap_lock read lock.
>  	 * The allocation can take potentially a long time if it involves
>  	 * sync compaction, and we do not need to hold the mmap_lock during
>  	 * that. We will recheck the vma after taking it again in write mode.
> +	 * If collapsing mTHPs we may have already released the read_lock.
>  	 */
> -	mmap_read_unlock(mm);
> +	if (*mmap_locked) {
> +		mmap_read_unlock(mm);
> +		*mmap_locked = false;
> +	}
>
> -	result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
> +	result = alloc_charge_folio(&folio, mm, cc, order);
>  	if (result != SCAN_SUCCEED)
>  		goto out_nolock;
>
>  	mmap_read_lock(mm);
> -	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
> -					 HPAGE_PMD_ORDER);
> +	*mmap_locked = true;
> +	result = hugepage_vma_revalidate(mm, pmd_address, true, &vma, cc, order);

Why would we use the PMD address here rather than the actual start address?

Also please add /*expect_anon=*/ before the 'true' because it's hard to
understand what that references.

>  	if (result != SCAN_SUCCEED) {
>  		mmap_read_unlock(mm);
> +		*mmap_locked = false;
>  		goto out_nolock;
>  	}
>
> -	result = find_pmd_or_thp_or_none(mm, address, &pmd);
> +	result = find_pmd_or_thp_or_none(mm, pmd_address, &pmd);
>  	if (result != SCAN_SUCCEED) {
>  		mmap_read_unlock(mm);
> +		*mmap_locked = false;
>  		goto out_nolock;
>  	}
>
> @@ -1198,13 +1208,16 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  		 * released when it fails. So we jump out_nolock directly in
>  		 * that case.  Continuing to collapse causes inconsistency.
>  		 */
> -		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
> -						     referenced, HPAGE_PMD_ORDER);
> -		if (result != SCAN_SUCCEED)
> +		result = __collapse_huge_page_swapin(mm, vma, start_addr, pmd,
> +						     referenced, order);
> +		if (result != SCAN_SUCCEED) {
> +			*mmap_locked = false;
>  			goto out_nolock;
> +		}
>  	}
>
>  	mmap_read_unlock(mm);
> +	*mmap_locked = false;
>  	/*
>  	 * Prevent all access to pagetables with the exception of
>  	 * gup_fast later handled by the ptep_clear_flush and the VM
> @@ -1214,20 +1227,20 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  	 * mmap_lock.
>  	 */
>  	mmap_write_lock(mm);
> -	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
> -					 HPAGE_PMD_ORDER);
> +	result = hugepage_vma_revalidate(mm, pmd_address, true, &vma, cc, order);
>  	if (result != SCAN_SUCCEED)
>  		goto out_up_write;
>  	/* check if the pmd is still valid */
>  	vma_start_write(vma);
> -	result = check_pmd_still_valid(mm, address, pmd);
> +	result = check_pmd_still_valid(mm, pmd_address, pmd);
>  	if (result != SCAN_SUCCEED)
>  		goto out_up_write;
>
>  	anon_vma_lock_write(vma->anon_vma);
> +	anon_vma_locked = true;
>
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
> -				address + HPAGE_PMD_SIZE);
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, start_addr,
> +				start_addr + (PAGE_SIZE << order));
>  	mmu_notifier_invalidate_range_start(&range);
>
>  	pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
> @@ -1239,24 +1252,21 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  	 * Parallel GUP-fast is fine since GUP-fast will back off when
>  	 * it detects PMD is changed.
>  	 */
> -	_pmd = pmdp_collapse_flush(vma, address, pmd);
> +	_pmd = pmdp_collapse_flush(vma, pmd_address, pmd);
>  	spin_unlock(pmd_ptl);
>  	mmu_notifier_invalidate_range_end(&range);
>  	tlb_remove_table_sync_one();
>
> -	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
> +	pte = pte_offset_map_lock(mm, &_pmd, start_addr, &pte_ptl);
>  	if (pte) {
> -		result = __collapse_huge_page_isolate(vma, address, pte, cc,
> -						      HPAGE_PMD_ORDER,
> -						      &compound_pagelist);
> +		result = __collapse_huge_page_isolate(vma, start_addr, pte, cc,
> +						      order, &compound_pagelist);
>  		spin_unlock(pte_ptl);
>  	} else {
>  		result = SCAN_NO_PTE_TABLE;
>  	}
>
>  	if (unlikely(result != SCAN_SUCCEED)) {
> -		if (pte)
> -			pte_unmap(pte);
>  		spin_lock(pmd_ptl);
>  		BUG_ON(!pmd_none(*pmd));
>  		/*
> @@ -1266,21 +1276,21 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  		 */
>  		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
>  		spin_unlock(pmd_ptl);
> -		anon_vma_unlock_write(vma->anon_vma);
>  		goto out_up_write;
>  	}
>
>  	/*
> -	 * All pages are isolated and locked so anon_vma rmap
> -	 * can't run anymore.
> +	 * For PMD collapse all pages are isolated and locked so anon_vma
> +	 * rmap can't run anymore. For mTHP collapse we must hold the lock
>  	 */
> -	anon_vma_unlock_write(vma->anon_vma);
> +	if (is_pmd_order(order)) {
> +		anon_vma_unlock_write(vma->anon_vma);
> +		anon_vma_locked = false;
> +	}
>
>  	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
> -					   vma, address, pte_ptl,
> -					   HPAGE_PMD_ORDER,
> -					   &compound_pagelist);
> -	pte_unmap(pte);
> +					   vma, start_addr, pte_ptl,
> +					   order, &compound_pagelist);
>  	if (unlikely(result != SCAN_SUCCEED))
>  		goto out_up_write;
>
> @@ -1290,20 +1300,42 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  	 * write.
>  	 */
>  	__folio_mark_uptodate(folio);
> -	pgtable = pmd_pgtable(_pmd);
> +	if (is_pmd_order(order)) { /* PMD collapse */
> +		pgtable = pmd_pgtable(_pmd);
>
> -	spin_lock(pmd_ptl);
> -	BUG_ON(!pmd_none(*pmd));
> -	pgtable_trans_huge_deposit(mm, pmd, pgtable);
> -	map_anon_folio_pmd_nopf(folio, pmd, vma, address);
> +		spin_lock(pmd_ptl);
> +		WARN_ON_ONCE(!pmd_none(*pmd));
> +		pgtable_trans_huge_deposit(mm, pmd, pgtable);
> +		map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_address);
> +	} else { /* mTHP collapse */
> +		pte_t mthp_pte = mk_pte(folio_page(folio, 0), vma->vm_page_prot);
> +
> +		mthp_pte = maybe_mkwrite(pte_mkdirty(mthp_pte), vma);
> +		spin_lock(pmd_ptl);
> +		WARN_ON_ONCE(!pmd_none(*pmd));
> +		folio_ref_add(folio, nr_pages - 1);
> +		folio_add_new_anon_rmap(folio, vma, start_addr, RMAP_EXCLUSIVE);
> +		folio_add_lru_vma(folio, vma);
> +		set_ptes(vma->vm_mm, start_addr, pte, mthp_pte, nr_pages);
> +		update_mmu_cache_range(NULL, vma, start_addr, pte, nr_pages);
> +
> +		smp_wmb(); /* make PTEs visible before PMD. See pmd_install() */
> +		pmd_populate(mm, pmd, pmd_pgtable(_pmd));

I seriously hate this being open-coded, can we separate it out into another
function?

> +	}
>  	spin_unlock(pmd_ptl);
>
>  	folio = NULL;
>
>  	result = SCAN_SUCCEED;
>  out_up_write:
> +	if (anon_vma_locked)
> +		anon_vma_unlock_write(vma->anon_vma);

Thanks it's much better tracking this specifically.

The whole damn thing needs refactoring (by this I mean - khugepaged and really
THP in general to be clear :) but it's not your fault.

Could I ask though whether you might help out with some cleanups after this
lands :)

I feel like we all need to do our bit to pay down some technical debt!

> +	if (pte)
> +		pte_unmap(pte);
>  	mmap_write_unlock(mm);
> +	*mmap_locked = false;
>  out_nolock:
> +	WARN_ON_ONCE(*mmap_locked);
>  	if (folio)
>  		folio_put(folio);
>  	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
> @@ -1471,9 +1503,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  	pte_unmap_unlock(pte, ptl);
>  	if (result == SCAN_SUCCEED) {
>  		result = collapse_huge_page(mm, start_addr, referenced,
> -					    unmapped, cc);
> -		/* collapse_huge_page will return with the mmap_lock released */
> -		*mmap_locked = false;
> +					    unmapped, cc, mmap_locked,
> +					    HPAGE_PMD_ORDER);
>  	}
>  out:
>  	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
> --
> 2.52.0
>

Cheers, Lorenzo

