Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBADDCA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 13:46:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40CD36B000A; Thu, 21 Aug 2025 09:46:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BDA66B000C; Thu, 21 Aug 2025 09:46:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25E916B000D; Thu, 21 Aug 2025 09:46:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A5336B000A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 09:46:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8BB47138216
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:46:06 +0000 (UTC)
X-FDA: 83800888332.04.192A9DC
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 27E2920019
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:46:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Fa557fnk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="XD/MxP9q";
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755783963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XxZJfgDLCOyQ0WV+hGiUKloReuPaO4RIY3Ddi6aNHuY=;
	b=XRctoL/0GZyjKDLW3u9hTM6u90FouBuu1lKjrLdetDat/frTHaflaNP9lxprgjfCUDhZIC
	/ye8ce3QTUhdKGMgOEwC5UuzGDGh6cLogvGf8ImQibGVj8R8Vw1e4uMOZQroL/BPD/4Gbr
	L5mjAGa335yPpQ5QTw7BCnykNmb9jJA=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Fa557fnk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="XD/MxP9q";
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755783963; a=rsa-sha256;
	cv=pass;
	b=wqT1TAE9Q/IiBJxKb46Tzxig4HK1TGHqJNc0n1SCd1wzR2t6rZ1kvLi3YIowBS/VUXR0fu
	2p6cQCeVgQEqlU99DVHGl+8cIPAGBA7DpK54+CloL/eJ/106NNkPzArQE3sILr18r7+nNb
	xfkobLHpY1AizsdQpwwjzpvl72U+fZo=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57LCk9lL022271;
	Thu, 21 Aug 2025 13:35:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=XxZJfgDLCOyQ0WV+hG
	iUKloReuPaO4RIY3Ddi6aNHuY=; b=Fa557fnk/8TPGfdV708Vj/8RGt2MId2aFf
	PlBfzIx045z6TDqQWV8BJS4klq4OTX46qPcC/Gck4uK4wegdtZJjxZbhblEVtDel
	4ixGX3EJtNzu+LOHTY3YeCcQngQNPreDhMykRsScmAC05rv0fvFYmz2Emr+Uuv+p
	3VbylF/J6vM0lWzQ1HRcTs6ylrPvDKmIXyaYn/7XZUsXvUTt6+N2RskA1XnnpXyU
	MOqNV2vskDCm9YDOlfXNwDW/pNWySyHAhKFFaxAPkpO0Ugjf/LyWp6FPsl2mMNXq
	j2VRU3qYjumVNEEnFGCUY2nPRKWSlUxOZ3ipSqBcSgoE73loIIPw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0w2bghs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 13:35:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57LCb8Jf020541;
	Thu, 21 Aug 2025 13:35:39 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48nj6g2u4x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 13:35:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=muttxcLal2EwXY+r3OCiI+V+gyfrAG/uS7a+I7h4R8zxIT0LTOa+SlSOSgpfVXXOD+4RllY4/Gf6okQtxp8WWD3QO+ZgDeWP6Rz3K8lTfL/E8gMc/LVpuaukpjCkzm3C3lao4AsvV0HPk3C9M3NqIMSpbUEtEC7NHmJpiuhq0taZJB1jif/xE4DQBcJeAke3tk2mi1KvNlC10js+nlTNz60Ggcr8aWGpbtKNCIIDqMujCK6iRyTChXPvqJg78RArw6WLJ2oDyWKtjXa2OS2AzOmFUqykiJcTXuKBSfLIr3utz6MnVpiPCpHqfnyJDyk58ggWFGE+fg5fwGlf5Y0i6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XxZJfgDLCOyQ0WV+hGiUKloReuPaO4RIY3Ddi6aNHuY=;
 b=Z1CyI7q3GuYA3BHRpVgn/cFvXX7PXjM8VUdyXc8F5ggsrw4JNNpyqTsAw+DgkoatpuaaTtir3mQzs6RiJOAtsk0rjVrdf7OJyykXIM1l/Q1dj7JWJ/t+UhYfKsBIxyR6q6Q3jPB2Qx7r+xZd+FDWb5I7gXEqnDcvTrHA8eDCCAlxaXINdeFLmChQBxOcfILNHr4lhGLf5FhhBUnsfyCnR2Ma88spDRi/lMduxux3hjIGfdcwv/CJ4CczSoW3uXJEVDA/dnh/LBXmbnw+UJ0SiWn1gxExXOodmjTqVbuxFM83PI50a+4vWHEbekqgu0XOBjP0qvaOLxY/E8xxWou5uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XxZJfgDLCOyQ0WV+hGiUKloReuPaO4RIY3Ddi6aNHuY=;
 b=XD/MxP9q6UjuEc5UNFL83BOlUX992V9mrtxE6vQ+bSU/taSMxzxDA10d1b3SV0vwU+78r3zRi+MB3yOVVK4WzXdsbPBkmuEhuRGX7FN5qwvTwZC7P7hQz34oYe3Z4Jb35M2LqG2DdUxcQEMq33m1UIMYiK2qKzQbEwUfjm9JWQw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB7186.namprd10.prod.outlook.com (2603:10b6:610:125::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Thu, 21 Aug
 2025 13:35:31 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.024; Thu, 21 Aug 2025
 13:35:31 +0000
Date: Thu, 21 Aug 2025 14:35:28 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
        corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kirill.shutemov@linux.intel.com, aarcange@redhat.com,
        raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
        tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com,
        jack@suse.cz, cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
Subject: Re: [PATCH v10 09/13] khugepaged: enable collapsing mTHPs even when
 PMD THPs are disabled
Message-ID: <af8a7c77-fc79-4c9e-93e7-f69300580a8d@lucifer.local>
References: <20250819134205.622806-1-npache@redhat.com>
 <20250819134205.622806-10-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819134205.622806-10-npache@redhat.com>
X-ClientProxiedBy: MM0P280CA0088.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB7186:EE_
X-MS-Office365-Filtering-Correlation-Id: 2aa8eea6-bd17-4221-a59f-08dde0b7997e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?e9ps+YffEPFQrdpZX1ZRUAFlwv9aDU7y/xHtvzNPdz2PhcgLid1sFbZmdno+?=
 =?us-ascii?Q?CPmzNQ/G6klrzO6lHu3Pb5WmHtRTFgYgjkSMYrnPEAsn8N93CHlvFWV1w5xJ?=
 =?us-ascii?Q?WgXDM2zWkdrXdQJpXON7TTRBl04fXCl5eHo03iUv/S3aLxti6opKy8aNwILt?=
 =?us-ascii?Q?K+Mu9uVlCplPxWsShazpZ4eOjnrNMVBw6fF3OcgvXuZWK9bDBcY1IdxRLHOd?=
 =?us-ascii?Q?9jXbLNVXUI/+msWG8ZzvaXibilO/Xi2pLsyJl4rYrVnjvJSf2JGQqAjEW8+D?=
 =?us-ascii?Q?ajUpBaz0NrvAj28/xrQszUNpEyFqP3T22YzXZFMTCzs31jkqKo+Q+X7dIjBe?=
 =?us-ascii?Q?N6s/Zu2TxBY2lvaAVHgGYuUkojDL0eZJzIic0z7Lf6xXpUZ7l9JAydK3BrBG?=
 =?us-ascii?Q?o1DEdlBCm0JHE3c6f+JMGp+tvsXJrS8fRX8OuEMBas9Vd0mIQdpMdVAlR1Tx?=
 =?us-ascii?Q?iPm6h6qCTWZ4jsGw15OuYtjLn7U/OeBKRZpEzI7h9Phj1pnddkwod9sbYwpm?=
 =?us-ascii?Q?EkbYoa4n4f2s53Ys51O9dLqnaWkVU6W5EBDjSRkCxMma2+AQ441mOCKhkZnc?=
 =?us-ascii?Q?k4BK/f95QyTWjBFqu/ucVLaUZTXs1riB3Y+Y/LJaOAGsgHE5PpT1ko0QVNAI?=
 =?us-ascii?Q?nhwOM/T4yOC/e+EXy74MKPevnK852D49CqPxnCpBWLLk6X3HsHc2GKYbwlAt?=
 =?us-ascii?Q?iDpSo8iLOpZF5UYTn2EJms3y3V1TOD/wapGMCrf/rChc1O8O/9Z14njcT7BU?=
 =?us-ascii?Q?dQpKFkc4rxZrXNozlF164oNEFV+9rMMo3jgBr6YErwPLifakrO4FpfAePXJ5?=
 =?us-ascii?Q?TFoh+j6rALGJAv8Ky9XoRZDh+3CagryYok6hCAZZC2OIpWIkMQAo2gxsla71?=
 =?us-ascii?Q?b0/LRkZDtE93KD+WPDKI6ysodFtO7PEGMMZ43O7uPc4UI3mmJSPv5WohExEL?=
 =?us-ascii?Q?Rv4u8vQw32ZPSXMb60N+tvQ2ob9ilsRiuIR9u4ZE0n/D6iN2x34MTj3t3TLb?=
 =?us-ascii?Q?SUa6ClXIBgBy80U2yP5yRs1zLBHJuPQKSVUKrTyNqWKXnzO4d7xdAWBSSs7B?=
 =?us-ascii?Q?0LwWag+tyxnqSrgPI39IVovKMFTmPX5or4ZyINwVdWSMNDrbemO1bofps+ai?=
 =?us-ascii?Q?hDeDT+zYQHIbhRGOL0UAsBr0Ufr+1c8afaGea5lSLIBfC7HgAn6ez+LtISrd?=
 =?us-ascii?Q?92TMgV32MLX7mUzBwGK48qJ0EQUl8uU0op6bI+69NoOnZqsGtGE/8j2hKhYT?=
 =?us-ascii?Q?mHY+5Wv70KOTDcnxOLllbgdGpwJPJuru5Skrx4UI0hTM10nGxCcjaR4D03d+?=
 =?us-ascii?Q?wsYcihQ0HNGH4je9hYvDF0baFweaBtcXObjTTE1wll5BzpX9kIQVEuRk8L5t?=
 =?us-ascii?Q?+fvLftjXIfS3tY20bMWtQCVyNldvwSVYpyTJIPnX+IBavwwlshnbghKJ9o30?=
 =?us-ascii?Q?3nbWkajZ5qI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hWAI7Ng8zFnuwGykahBO+FlwKKmT6RusiZVGu2F/5v7qLlbB5n0G9ChYU79P?=
 =?us-ascii?Q?585meoyKktfZS5AOpm06RYtHcBAiUtwZPrHtCt5Px4d3IQ6FUalbyYNECC2O?=
 =?us-ascii?Q?P4d081t7RxXA8bVQ1alxfvUfnnbDuOSL7lod1zdxrbukUF/QaSAP6UQojFpN?=
 =?us-ascii?Q?z6J9FLVURbUDVc6nD3pObE5lUNwDZ+t7XvOGVKbtkUAg0IPOrdjUOnSn5QNL?=
 =?us-ascii?Q?1Mvpcm1OkF2iz+YVK3ubXl3ssZMi9TtxVsUIWlQD4hmOrZuFiFU/UDI0vaFv?=
 =?us-ascii?Q?GzXSF2hUxQqFsDPD++qql6KKe3XczVpL5jTM4Q4VD/5gWV0daftA7swO38IX?=
 =?us-ascii?Q?uLVfPbQ8JMYTvLckDJk4nTumJPHI0IZbwA+4fDaXzNSc1qO9nHcPR6m1fFbW?=
 =?us-ascii?Q?EOU14Q1GTFe69E3T3S/9B1wTkaTMuhsQWKlJjB/1JHsKtyP7kwf0VEClUBVF?=
 =?us-ascii?Q?ZokfyoVBQNxuik8FbMOgjf5G0aweXPf9kjWqfyXALLC2axxfG65mJPYfdS77?=
 =?us-ascii?Q?hMnVi7fL2/okhIjR70nTRhXupcQkUWEMWJLycWN2YdQ93rbm0FFub9VzH9fr?=
 =?us-ascii?Q?0g/ouMNHbRtBlqMD9Iy3S/P3NIBwRFShWB6N/SLUwbAJRnDDFV+2GCv46jIY?=
 =?us-ascii?Q?NE8DXggCSt2tBwwkKaYcqyDs62sZHbR03neT4OPtx1qGNlpW9Cx5FKcSC/hm?=
 =?us-ascii?Q?57Tp0Rq1NNDCAOOfIN5ZNbHr7NIUXEu+PI3eRB8ft+7UqOtrnXXuXQD13A/p?=
 =?us-ascii?Q?3III9n0276jtMGzgx/wZSf3m8eYX7DyI4J50OiYKZvKgf+KhDYREeosiWikA?=
 =?us-ascii?Q?txI45ZQaCqoMgsdrOTGRp0T8mx0j81/PyouGf3RBciYyVZ0XsxHAcF62fuAy?=
 =?us-ascii?Q?Zzj0pXgQUywLpUR32gLed1ZLdL71AQkXm3ww0H0C2HrUXXu5R1iWHMJJOQrd?=
 =?us-ascii?Q?/DmWtGEzNP36wqCsaMaraTFIOPyx+DMMwc3vZk1TwZjVshtv8hFzpzE8Fo6J?=
 =?us-ascii?Q?4s62LV2u3f2RDaWbdidjR+vgBng13hBrwQvKmEgCXJe/GcFne/3rEwtqQXRn?=
 =?us-ascii?Q?DgFlpvP/tspvOde6vqIsNkP1gXjhGou/bbyG++RvwRkOYLkwnwFg4o2egU/m?=
 =?us-ascii?Q?vc21zz1uQe4sgtzP2zq57v7o008XQSNImMZDppTQ5BSV1TGdRGOQg4mCihx1?=
 =?us-ascii?Q?6dVwehB8kDJ3tKZVjr62S1nnZazCqZ8H7LGgdj6mHR4CyGp22Es57Tq5nmRY?=
 =?us-ascii?Q?rPOYSXFBaJ64E+iJLnhllymU+ctOVH7OOCc/DEmGdStB7QkSieI64kuREY/9?=
 =?us-ascii?Q?8r8AMxMixR0y50HqHH0sUdUULbwV1/A6HIawEsNBRD+p3Bfu6E9/7vypM1db?=
 =?us-ascii?Q?i4/u/7bVmjbcFAZ3wQHS57Xirk1ebKji4aNmx5hK7SFO0ywUJJdNbAAZhutt?=
 =?us-ascii?Q?dGQisfLqKemRtZQYa5yGnuuMhwGG5twCE+gFEI2xAWjjZgXv3pmHcu4+AUYM?=
 =?us-ascii?Q?4uZAZSHBPkDnpYZqPkfkCoRG0mLPLP80fv41bFUkybprCsuhmEdQJI/Ym5in?=
 =?us-ascii?Q?A4dZpyYJvtzolHZhaA0BtfVDH1L0Xm04VPoa0uSFE5Wt+7gsrQa1bufHzOYS?=
 =?us-ascii?Q?cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pxxrhi2vvPJ7ONxrvGe5vD2vlWBJNFbjSkrBY6qfg8Uzg+2SG2jK5DnMZrQE6rLxy+T3NNGDkx6lkEL1OaaIsxT4uexUxS3zzRQzMunCVn+1aB8uMqb20Jn3teyPqnA78qNGjjLUvA8gwC5/Z5I+ZuX5SqFcA7zAmtL0VVO6fIcKltBRuiUr+ozrI9naPTd5/gJB2Yu3blB4PN7yN9+VcHFKmR0ufyz5BAM3Jvu7na3qbZdMU4SBQ+NYT9Z/oO6W5clvu7d8IpiProtH9k2PSALfCEfdRopVRzaxw9kh7L840URjRbLUEHuPPrtbbmslGJ0bPBekaLlfRyvKH4py5KzaWL9YDu0F6klcLtHm3nuNFqhkvwnNi9cpz9zGjcjldRVyYhPpnEwoIGHQIkZN34Hxt3TuYM42yuojTAYFBc7BgKWjsY99L8xbgDN2kOAOOd3D+NxItU8hqc0jqMSElfJNqt3mWkYpbXaJfgK+WOPv/mKfULqV7PkURrO418hw0ezFzXLnXLCP9Ij+9qs8kVBWcBTqSI142Dk9cRIIM+huiZYCwPxit75nx5oA/BW/mCh0aYLxepH4UVjpzumXY6W5KOZTnC86ocXIbc9B/uY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aa8eea6-bd17-4221-a59f-08dde0b7997e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 13:35:31.6345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 59IwGEh9WIe+4oiKNb6qjVkj5e5LZo8mYZZCiY77ZNUEpcQEtmvMi2aCUoQOXUw/qjxOdAMXax7MpCGQzgGLwq/R3MthIi27qwmIu6HdjKc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7186
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-21_03,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508210109
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX7Dij34iXitzb
 OgOkwWWMIAxxHIdCm23q40tvmytw8Z6MRbgR1x6qaz6FwaBNZpjh51LgceS+a36MnBcPD19xfUA
 VRuQ0JJK91QCXIqaVfSDWXYNpOS3jgxLScYD3qn9MlzNVsGaEmtoXmCauoJL6rCNU5IIz7l/KF3
 gNxcsZ2f09Wr8BHR62H9jV5jYmptD2GtRtnNfae4HgbciARDGqUEr1AU5Ip7J5S+F6UBNHONCPY
 zb77L2ZHbkkb4VyuAAowwKBhxwW4rY8FOAcJzYEs5TZpt8cpBO9wzupN2BfjNi0zKKrKpnfMeJY
 aYK9QpWEVPAxBQ2yPuHodFgXozDssILcF7GQF2KHyxLW/ZpzeoHY+BqNxYe97/EtSnwym92BueF
 eMpOA/BtDeDEOX4fPSx8vVwbNIL/F+8YZbLBSeybEZBKRXBkSSE=
X-Proofpoint-ORIG-GUID: uNDvILqrHgU0FydeZGJgRvqjP-IozCy2
X-Proofpoint-GUID: uNDvILqrHgU0FydeZGJgRvqjP-IozCy2
X-Authority-Analysis: v=2.4 cv=GoIbOk1C c=1 sm=1 tr=0 ts=68a720ac b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=SRrdq9N9AAAA:8 a=20KFwNOVAAAA:8
 a=X7hCWaasMElsSS5S6T0A:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12069
X-Rspamd-Queue-Id: 27E2920019
X-Rspam-User: 
X-Stat-Signature: j5c8y9rtgq7kgqf5riwgu56j4g3hoofh
X-Rspamd-Server: rspam09
X-HE-Tag: 1755783963-674003
X-HE-Meta: U2FsdGVkX19gCAeDfdnGzyJ+EABPiNzPExG7Eh0MdhHWr04nVLWxlSG9CF7LbH0lRo3Dm912y5tELSgIzRK0b2qo7T3dU22VGtp/QFGlbbdo0g/jKUYS+p6os8t8OltOydiAphit6ycqjHGnyUbMBrr3I/UnuDDJ6Us4ifRbq9baiCpfFMZ0Gs8fNvldgLXaLTfiHRZvltqilj9OZBtUknJ85HMK1GQQHTwWxZOEHr3l9RaMVErjy715JtqZDuNrDZ1VxPIBEn6YSN8sqACWpX1/AzqFfVNDQfM9lkXbxpO5laA70v3VA1WfCjxGqqf4VTIA+P6YTzXAmoffqY6182HiVE+/8BhYs8+u+9cWUY/eXaFhxDLv733/ctD4h59+KCu1CCjV2142mFnFwgnfoI44SsTF4Cu3AOPx85hSl2YcPFajX1Q+BlBYgXpZxdD9CtMdgSTMXpOdLK0L2ygtm+pQSybZMlC//0xmrzug+MX/ftFo6zeQyrbguL3VvZokJ9qmGhwQUd3fSS0qxeXhuX8NPD7RTMO8XS0f3H+B9duUcgQwtihnvNm1b6nvI6mkMcqLxn2icVdAb9WkWpz04A0jqPKl8MtTOYTIDyMmWt/uEas6U9xjmb10VazpgOWp3o0/16Iq8iYjwq1i+9taOfu6YtvHuXRNuFQP/lx1zCQnO7/T5yz5B6GLr5aPPEGL5wjyzuaOfLA3kFeo7IrGrP2/M8dgF2Ekkjwg9LyVHEpZiQ1CQYTpQ2MDNeSrCHIKfITYY5S8qzC+LO1m6RpsvSjAQ5LLXX0KIEJmTAunKXn20Gs0XgUL1k4AcSKcDHDimPNbnh4CQfIeOPG1e0553DhCOXc+x9Sy/GxGWfc5jzK9Qc9J9sXVxB8Gl52h1jJQUAmYdw+fiuwz7YRZvtmZ0fOF0UczNTr5iZxQew570sJtR2FuLT+Zf57R2i9JOeDdsxjC1vY4MDQ/DQftWb3
 lluw1IvS
 eucY68H+DuiwuccbfNRSh+nRu/IwavhKkdvrt6FcHqEU2IS5gvvFbE9GyMtkt6toS++5LLqHzRoHQcOKZLd9JZUg+yq8J6BxaYY4W9pY6CF7RUIbkCCQ1q8zOOTxLLQdT0jTBl93z32J+itNd4WCENR/5HxNyM+KMun+cqCYGgFv2fkKmSWfffmTZgoyvprrwrzjHJ8omLezkHPyzJ91jQnv91eh7M56l0UqXd3lfG7rQr/V0rBx+C1FPNnq/s7PkmyhPodkDwuc2n7d9cWw2HLi4eEPO9u+7keXzp60S8SPRsWsbmCtgguuM/DED5+hDsFUciC6kT6Stp7ID5VQErY0TYwdg80vQj5MsARf99lfvoqYNElVZZpfSsd7Tzpcsa4W+q/v3rr3sMLaN6eAixm34BtdfwBdKPYsFrT/pAyPlq6DAjuImcUuMnvA6LIPXfGjhnaSPqZ+p7fv4CkN5vSAavkU6eFkDoAKB0nQw9QuHkdkGgFr6MedM07nnQjkyx14jItq2NfNDU5/M//0TRYuZYjYdClG/zEO/lxQREt6MepyYOKpwUWLmoLJFnrEyyV0OAOvEVjb6EqCIoTu+MaCabvNWgNu1GN0miHpGRYwRsAB7vnst5+C9TdgD444T7kGP5Zdr59oKbGy4WRazUDce7+lKoiIW17z3I3nACqqxVyM4aAYa38/h3fMeStASA+s5sK8+XsxZX3DjqIq83y5e1w3WyhMAH8G4oh1rZQZzM+kZXzwnW3Ui3JqeSbAXoi50rpBVjEacbkbdYEQNUQMFdg9SaA9p21yJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 07:42:01AM -0600, Nico Pache wrote:
> From: Baolin Wang <baolin.wang@linux.alibaba.com>
>
> We have now allowed mTHP collapse, but thp_vma_allowable_order() still only
> checks if the PMD-sized mTHP is allowed to collapse. This prevents scanning
> and collapsing of 64K mTHP when only 64K mTHP is enabled. Thus, we should
> modify the checks to allow all large orders of anonymous mTHP.
>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 7d9b5100bea1..2cadd07341de 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -491,7 +491,11 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
>  {
>  	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
>  	    hugepage_pmd_enabled()) {
> -		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
> +		unsigned long orders = vma_is_anonymous(vma) ?
> +					THP_ORDERS_ALL_ANON : BIT(PMD_ORDER);

We need some explanation here please, a comment explaining what's going on here
would go a long way.

> +
> +		if (thp_vma_allowable_orders(vma, vm_flags, TVA_KHUGEPAGED,
> +					    orders))
>  			__khugepaged_enter(vma->vm_mm);
>  	}
>  }
> @@ -2671,6 +2675,8 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
>
>  	vma_iter_init(&vmi, mm, khugepaged_scan.address);
>  	for_each_vma(vmi, vma) {
> +		unsigned long orders = vma_is_anonymous(vma) ?
> +					THP_ORDERS_ALL_ANON : BIT(PMD_ORDER);


Can we have this as a separate helper function please? As you're now open-coding
this in two places.

In fact, you can put the comment I mention above there and have that document
what's happening here.

>  		unsigned long hstart, hend;
>
>  		cond_resched();
> @@ -2678,7 +2684,8 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
>  			progress++;
>  			break;
>  		}
> -		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
> +		if (!thp_vma_allowable_orders(vma, vma->vm_flags,
> +			TVA_KHUGEPAGED, orders)) {
>  skip:
>  			progress++;
>  			continue;
> --
> 2.50.1
>

