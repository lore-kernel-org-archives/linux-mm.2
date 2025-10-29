Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F2D6CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 18:42:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F8238E00CA; Wed, 29 Oct 2025 14:42:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A83E8E00B2; Wed, 29 Oct 2025 14:42:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 721A88E00CA; Wed, 29 Oct 2025 14:42:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 52BD38E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:42:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF90912A13A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:42:26 +0000 (UTC)
X-FDA: 84052022292.12.558C7D8
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 689FB20011
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:42:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GrAnhAzk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CxPctCLm;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761763343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iFsI/eCi/oXczH8sYOPk/3BBRn2tJ8TC6+dM6gKyGMs=;
	b=cLQqTgictJ2Xen/zXdSxezbCcYVE4dUM5eFZutDf3G2QvbFBG4o0phmS+vWWlp6dWu4Rcj
	VgzXLRdABO1vgICdoQHthc4IONX/gu0GEpimQlG4kMLD17jmgiOn8dBYrXb0fZ/g4h246N
	lsZ4R9AFqsaTIZBzEld5M4QMqKe909o=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GrAnhAzk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CxPctCLm;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761763343; a=rsa-sha256;
	cv=pass;
	b=PsayLjeuxQybh4uQk0Wlx1mDJjvjiwkmhMeUus8DR1vDbH6V2w09/OW8zHPQuIH5OQ8rJv
	ElhF0EvEAUGx4lPtdS/1gC7yb7Dp/PCms/PS9SfPmFoZAIKEFXzZxs2JnMJ6wEyFt97FjE
	OIn95ToGuuhlrR+u+CGJEsN90NxCLUk=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59TGfw4H021438;
	Wed, 29 Oct 2025 18:41:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=iFsI/eCi/oXczH8sYO
	Pk/3BBRn2tJ8TC6+dM6gKyGMs=; b=GrAnhAzk5Wab3iBrL3IYphVo+JkcWJzFAu
	bai/mfdWOJJiU47VJlZiSqg005Yl77g+7igOALbi7jtOZgrykFqvZCo3yBtlzje1
	2iUUwYkG9iq6mt+Ykvi3xw2Q2xS4WQPNLj0u8AVhfaB6HWL1W+iEGCyJIuoxOtXs
	IRdzHbkQ4OQcLUx+w2ttECzyyox0QU7uonvsCNHXXjG9NCv4nWM7LnhF2m8oNX39
	V/NYBvvqodkV7aAeF07xaLWQt4fvPTM+YgtYrfpFTtQKYmUyamht0zaVXCZj1w2P
	xA8i8xfUGaEu+DlIyIEUB5FYYwjGn4YSzAPzCtfQT4537p8Nlp8A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a3c3b1xtx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Oct 2025 18:41:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59TH95A1016099;
	Wed, 29 Oct 2025 18:41:38 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010043.outbound.protection.outlook.com [52.101.61.43])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a34q82a2w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Oct 2025 18:41:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nDO7lqZeH2YhAWyAQSKQgEI4uYsrwOLBxBZ9uLbr0VqmKaNPQzZU0z0tP4pSfS0Y43IAkzIy5zf7W9jI0Pw7rfA6nrFGUk6PHrusH8Xs7ibLx1OzYp0xTAgdoRk6Tpj3reQdJqhUFjl0PUyJy9kkNFpwkMTAtVTY9bYCOlTsx2Vcj7p2bDWrmcVQ8iS1o+kxrFd+mDkG2Sm4mUSsR+o9nxrfjEM/tvyCpPv6l7spYoXREupBGNOksDKwry5Tc4BVj2twq4ejczJ/JPT1a4j1xF1QrF4+7592f1/DysxgyBE52901CBgclN8NdRbVmO4lg5vukeRYBcQXN+N2ohp9nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iFsI/eCi/oXczH8sYOPk/3BBRn2tJ8TC6+dM6gKyGMs=;
 b=aC/p+BqM81xvfRXuwdiMrvfz3T9HauxVDrpu8p1U7aFalLJqOT8FiDG2Uj4UfhECHi7S0jfqumkWfX7rIjzFJnwmfW6PkwPvXOuC6szc9O0cD4XnSfqADqMoBDqAHI3GkanC9S9IegTw7CBxYJ+iiO31uF0Ii6UIWSyDXIJqB+eqHMK36UKDxdlPoIbtlEjBaVWbL8owihHJfieALqzQuV2EGLlBoPQFK/VNOgKVo1v1wE2Moz8b7jy4aRZkIOn97ZTjt2r+8LUNaeqAIrtfTLCRpvL8/YaNmGKKBOXK6rZnRJEc2MvFABJ8/ROj2oLjoxlnRrjAeKL1ui7ka9TxwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iFsI/eCi/oXczH8sYOPk/3BBRn2tJ8TC6+dM6gKyGMs=;
 b=CxPctCLm1Bjx39/SsIWe/+ftenK1ShT/e2cEjqZDX9fqD4BnTJvj5mhw0Pt/kol1kwVIsByQU8NM00IwYLgR2Db9QVblNZVuSlSDCM8z0oRBexZIB6L+9954dOgof5SsUGuiGJXTctVXLBeY0fVtNfJnA9k/j87ubOCHPfkd8Os=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB7933.namprd10.prod.outlook.com (2603:10b6:8:1b8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Wed, 29 Oct
 2025 18:41:31 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Wed, 29 Oct 2025
 18:41:31 +0000
Date: Wed, 29 Oct 2025 18:41:28 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, ziy@nvidia.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
        richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
        rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v12 mm-new 06/15] khugepaged: introduce
 collapse_max_ptes_none helper function
Message-ID: <3d6c013c-5592-4bb8-b438-e29787b1ab48@lucifer.local>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-7-npache@redhat.com>
 <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local>
 <063f8369-96c7-4345-ab28-7265ed7214cb@linux.alibaba.com>
 <9a3f2d8d-abd1-488c-8550-21cd12efff3e@lucifer.local>
 <e2a89e74-1533-4a83-8d0f-3f4821750e25@redhat.com>
 <64b9a6cd-d2e4-4142-bf41-abe80bf1f61a@lucifer.local>
 <dc002ef9-53ee-4466-b963-baadfd5162b7@redhat.com>
 <a97780ab-6256-43b7-8c0a-80ecbdc3d52d@lucifer.local>
 <2d8ed924-6d06-42e4-a876-381fb331f926@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d8ed924-6d06-42e4-a876-381fb331f926@redhat.com>
X-ClientProxiedBy: LNXP265CA0073.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB7933:EE_
X-MS-Office365-Filtering-Correlation-Id: ac0738e8-8cce-4c15-c551-08de171ac6f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oo4rCjb/0vMfGf+2z68u3YHdHSs4DlsWUnXAQjs7osJx6/XaXr1jVAq7VfFr?=
 =?us-ascii?Q?hidLTMCwLmq1jKMqVbUcPXB7hQjd+JYfTY2lmbXHhWmXPBtMvfoMdDSh5Pme?=
 =?us-ascii?Q?xqODm0Z7OyBLnZJaZkOoMQuXj6XdRj7ybQottMY64yWAE9dExfUn0OjpoyP1?=
 =?us-ascii?Q?Sa22/w6d2p4BdgngJQlmu65wFmLlaMAzkAb+Xs0Q2HsiVyxrJ7xeVvFlRjUW?=
 =?us-ascii?Q?LQhNr8eMQebFgOEZXB53QhibDtc2jOXvupcmomCDlNGAJ990YybamE1qZpHk?=
 =?us-ascii?Q?oI4qR2abYQbSnN1aibIERq6zx+x6sGKS5ZzGgwNfUZznrjd9Xw6iqZuIe45X?=
 =?us-ascii?Q?sehMrovNkb/Cvcs3bv8HQ9A6hMxUnOJf2LHEU4lMbUXHrppzWLtLAyCBngz7?=
 =?us-ascii?Q?10+JJG4mJQ7g8Ntik9/qd8wakGpP7/q6t+kTrBm1MAk7mx59KYSf+y2/n1eF?=
 =?us-ascii?Q?tz/pDqPsF5v43dHKhGSqmDh/2NINjid5SInne+ErZqaWJO19wYHrs9nhRTXb?=
 =?us-ascii?Q?LuoWg8X+5evLvvWJkURAOVeQulrUBGOWtHQjhRoyget1GeG85UQ/0D1kLsXZ?=
 =?us-ascii?Q?LW4cgT/X+h0X8o7yT26IrOHEONiUcSEscgG9a++vsq0uVo03QUF2B/a2L1Gs?=
 =?us-ascii?Q?w/as9Y+vhtxSpSAzA/un0DPpZyBJpUGbraKn98I+wORjH9SBDYy9R/1ptu5v?=
 =?us-ascii?Q?7NwcVLwJaveSFJg7XKhCxaBFPCD9QC5M2Wzz93FgdqV5T3Dpd7LsQuNLxhMt?=
 =?us-ascii?Q?Mmnb8pCV4VZPaIqz0T2m8SRlG1nrW1/Iee3WW2/qEoJKHe4p+E+DH4mtRwXa?=
 =?us-ascii?Q?bmVzkDVx3NdmtuXkb4FLCOKASbQV83t2NljHDYrbNX6/0Qf3vEnw+zI48W1P?=
 =?us-ascii?Q?M66AsPhLCyysmyVhUJw2IQIV8LkfgbLVdShd0zrbhYbVp9htW7nTYU2kIxar?=
 =?us-ascii?Q?4doH96c1hEO6En+MmSoAkRvBy7MsFME41JrErqy7bIGp95PBoRc84MHRrPyc?=
 =?us-ascii?Q?cOU6E4HAX+GenXtlr0RQyd9rM8dkULv7SpkuYBKacj42q3UI85ifhitwheSo?=
 =?us-ascii?Q?Kv/LAqoIjMCLOuxzAhhRFdzf9pWrb1+5xtzUk2vvTqPUWVYdwu5r1nJIP538?=
 =?us-ascii?Q?yyFfyc5iLPX1xBvJ0glWyk0I43V37ijYit7goUwnGKxi4lYwUbQuIUKgLVMH?=
 =?us-ascii?Q?5zBSSak4/a4W5a2nnVJKyllg81l4QRPr6H8Sb6cO9SNHBqnWvak71q/AaSc5?=
 =?us-ascii?Q?64KXNKdQxnRgUr/JdYl4AWMqvbPZRS9n3lqWvEk3377wpoRbb6A1CgUQgjtZ?=
 =?us-ascii?Q?YWGSk/HZKi2nGnKQpgT2zGtoPghhqwa143Ayf0E5dvShjX6jSoJLH91NOKYi?=
 =?us-ascii?Q?l4BM8t1d2Rb/NCeMSg+pmda0cUsrffH4zt2CSM31Kf8r67v7wuLJHcPFg5to?=
 =?us-ascii?Q?7niTNAdEDGGhlNfwdgzQ8LfMQATt/Ods?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4VaUUAcYmgGC+PLeXkVRyH0p38mmPy1cpeiJj+G0IUbnaoqN7UWJXRv/T1XA?=
 =?us-ascii?Q?7F2WjT+Oc7nENJ4VysZYwVAjxGqYswec9PppWNnDCse130wVasZAigeNXdQL?=
 =?us-ascii?Q?SH2WZzq0BY0SHm+5Uv2+CNy3ryHwgFDGfbmyiKSy5tKskryTq8ucJ/qtmM+N?=
 =?us-ascii?Q?sO/2gLzj0B3Gdv5X2RoprwQDjNkZPwAs0BtyBmsrvw4E3uhmHLgVJF/aNYPY?=
 =?us-ascii?Q?oG4chIiCPd+zNfkkj8T+YUeXn/1h2MZ18NVTzBiFsOGiqXYBFH1xg74YrVUU?=
 =?us-ascii?Q?FB6dN09UsOu41read/pNpPFqmyXgKu+zclf2HwirSu6KaGXioZCwL5kKsI7f?=
 =?us-ascii?Q?q32XeSJ1zIuTlDCycRb85uOEp+h+purVHQAfjSz/3VhG/RJxCUW66J6pC+fi?=
 =?us-ascii?Q?71HveH2Vh3f0u3MyBjvqCHYeqrdJWAZVn0Q+E/1dS1nCMXC9d1jL9ysSlHBz?=
 =?us-ascii?Q?B4p6lnUIZgoDeNi6JaRUwbt4GCAe3NbRpJJDMBl6nrdDoJ7hJbPMhWDYnRLf?=
 =?us-ascii?Q?pXcUWVQ8ADOUk3ycd0pIHwmDg3UJGt0DF22E6uWmkA6YIyhZLo+p3XBgTGx+?=
 =?us-ascii?Q?ScsNNHFnBGRWL2uL041Hd9eUs4Xa6G96o6HUYYLw77lRyn1m89T6Keek3irT?=
 =?us-ascii?Q?vvW5GlLTTxzRfXSDIqficKct4LSrkkkrGDOsJtTJ5KVY8UhgL+/Ah+JL7c75?=
 =?us-ascii?Q?Y9AvdOrW9X0bNl53NAQg5RFTLQ/HmKhvBQGzuMOfCwK0tWWFta50mpopmB53?=
 =?us-ascii?Q?S8UtNY7KLu2GYP7rAUxF2ZZweo91IqTQy480ekY9usQ3zSy9m6zNI4cekuq3?=
 =?us-ascii?Q?xt+PEyBYnzR35ieBQ3ZLaBV9O7gTxzkFFpxRpbktIF+XKdoij4uAJTuZemAj?=
 =?us-ascii?Q?nWPrq9dlOx+nnuBzYpPKwUvdfPq3p7GcJxokjJiLR0KOs7JNq3u90z4tF6Qm?=
 =?us-ascii?Q?ubi2kiApjcxEZobNYGRfcXC0LfvOeGuQOa/nWjg5RHqc9hdbNntDL4FF/992?=
 =?us-ascii?Q?36YDqiP1jyjzSY6LrQz+vo3LYzpG61z6c4sTk/gXU5FHiZc2xFDlyM7zBp8x?=
 =?us-ascii?Q?Lkfal/zEL9NGN4nIeemQurEbVIwHgR7XRyL6ZbpR3NoEGXLel+S3ETuxOS4f?=
 =?us-ascii?Q?3iwXQeBroAMqGambuplqM1FHGBVvz+/VxEN9uf9qvGD+zEgGuQibRi0/B9U/?=
 =?us-ascii?Q?YXAkEAOhWAZqZqrKg8to4+kfTq2vulKkRyzh11qY0HbaRniPjuX9keBDcTko?=
 =?us-ascii?Q?iT5hOrO1gv91ytEW44rswn8A71BNfKkJ2LdR/uAF/6ANbWfjZhRpa7jacI2a?=
 =?us-ascii?Q?8jzgSI0qcbrshiRVTiCvquIK5NVk4DlFyBJCDWV2asnId8LhhnFjpDL+Z897?=
 =?us-ascii?Q?A0SSN4svS1LKEyY2CPFBQUOTOITfvcQamMyXCLChccxXE0T9I7on4S6oyyCv?=
 =?us-ascii?Q?qbE6UWy2fC7VfKDFDpRbeldo0r9yqsWgwQ7lQ2H/jCkSZ49QK3q9NWyp1g9G?=
 =?us-ascii?Q?cxhXfjG2ZE91XmSQwCHTzPRpnk2UJ36lS+oKIIzPj045O+1NCvh9ORQ6Jzrs?=
 =?us-ascii?Q?cDYf8625ooXOPR5JcTYLMpc0NqnEme3IiRP+EXg2bhlRzbvfOyNrjOfNHVVd?=
 =?us-ascii?Q?jw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sHmWm4E5191RNcEz29yJ0MOZYGaiIv3MPGnR7fDN5810/1VnBin0MB/b3r5v8onDTyK84HSFq2oOjVs4Xo7yOYehef7t1/HHd9lYBpX5sUvT3SQMLhMBonf9WE2U2NKSz6COPeQvoXfOISH375l6GuXJwN+qPskg96Ge5DM/a9/8ShE79wVgahPKUYzoNH3OVQe4/Eo0bAdT21znAazlObKwTX4uNA/k9Ljia6J+q2dP3e3WRkZeRErxc3+VMAxkyywslc7U1SDucTrvDj1KQWqkjU8PNmrAB/jBU4SDISElohsWeLZOvJqSquCLXkx6foWuuJlPymtEJhh5jzbxIQoBVbvTBb2n/fRtrRT5Xjww0HH4EfQ8hf2Trmv6ITPFWvWYXowT4LJZhCz//UT7yR1pnP0OQMV6zNweRpirux+/XF51wd7WwaNHgPLdPLNqcRHQsCMopqvcT8Xr521rZwMP7SL91A/w7ETb18bcVX92kq1SOSZ+gwP8I3L99RCqUK8Ms10b8TO/ej8PfKWQyZO2Pa+jmiv621YFLGmCi6cBrwEis6jTAg0xAAk+/LgyVVqu3D3W+OCMHxYh9+6nInxPOS4ybgskVBCai/snhc0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac0738e8-8cce-4c15-c551-08de171ac6f9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 18:41:30.9876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pW98b/NzYaYIQc6L1Hhznm8HIrluxLl44Kb7KivfwPIXTbiL6b0WW7kTtiNND2k3DLgnHfP4jH6acZ194fV+hh0NHjyrEC2vgOgj/VcH2ig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7933
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-29_07,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=965 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510290149
X-Proofpoint-GUID: qtHpjz8SGTKDBQrE4U05pvEQBp6F2nMu
X-Proofpoint-ORIG-GUID: qtHpjz8SGTKDBQrE4U05pvEQBp6F2nMu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI5MDAzNCBTYWx0ZWRfX9Ny133x06Ino
 MbQttDhESAWvFPjEuPBlx3VF4AQlp7OohM3pPfOFfW+AeF4KBWTZKk83M+0X34pPnua6+vCBEL5
 mPvFECy+CmrRBMbXbgq8/Bw+HTYH24+NeuzYBZvz5HU6TigyNKJDRSQM7d46M1dKUP6jNG2k2Yk
 iU+Oq38kI8s+1vrjOU5+Z70yIuWvny1vr4vmO74T9z8mK83fhA6bOKlsYjTKRT1Rs2oIORbSCFO
 2SHFsXjfihghyhevUR1BjOxZJZqDZGkhfIccV9YkDy7dh4Zu415diiW6dGfpGDZ6bW/LVx4H4Il
 W7cKti001Xcr2sYooRefwOxzcEX1dknDCDE17cR61SbhcdhFmM5aP0UO12i0tY32FoCHIlnloJU
 3VgWYpCDNO+gCyLdbc9gQacd4cylD4ZndIxPh6sVvmkHx9B/nQI=
X-Authority-Analysis: v=2.4 cv=S4LUAYsP c=1 sm=1 tr=0 ts=69025fe3 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GeFfA74sqp3Hf4Rl0j4A:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12124
X-Stat-Signature: 5xozehg7n6zzoxuh69i9zkq54wxzgsst
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 689FB20011
X-HE-Tag: 1761763343-477183
X-HE-Meta: U2FsdGVkX18oFyrJ3ug/+VJR2kw2gR7iaVFX06Qji/7MqxmnqC+mq5ACvJCmcxLB/cIauOyjrGyivI/Dsu3x3J4CED9ESsLjicl4hajdicYmjUw31T3sWD6ATIDD0EqfDiU28D3LCViJJipg9SnYvlQDMGrP4wmWo95fTtrAPI10E2iLtY6bI4+JsX4CR/ueACA4wNyDQuwLG/+H7M27Jf2eV7nLRFmA36v3YwjBaXwwGdBSeLEVXCLDg5xDLtRXyOFZgPjn3KhoDevyT4umDASQsuaNDo1uzlFHmMxrDaXRvKR/2C+8FkvpebbLri7L77/TUctbj9dRRAyy3lifHHY2hy/atAvCZIYbsW4K3LL18XmrGyHCltPSdyYrwtbVOsvYz3qvETAhD/5ilov/eXDNTmElbr6nmozfFSem0vIQwbzn4MCx5S4joP1RnJHuEOuEGU1rLpT42pywwyQiY1U/j2JHkpJiryw9An30EytV4pxZsG74Tl+hUBXLH6ocK3q0t4e+1hYdbdXhADc7KgUj0NIMjZ1wC/z6PyGxZy8DDCjgNlViG4jmZJWU61+0J8KoBVsQs5epUC2xESMIMz/oxbPwjEPrHF/2v8BKlkh44k9gBYJVvEcxOyahKSI89MrMcMm0trqXqbSfsTQcvtbro6zdwvhCZStTK/xlDAtnhZ/OkH6nzTJWlBM0ZxVV51vdJW9EoCdv8VKg1mWzYBtpuDhDawejy+DvyKeW12iBAMBvv7k8/10fKriOpCpRL1/YbDpXhwZuvzpPaoMLVXtOU99keHudveF8Z0IKYXg0UwpFTRdvUo1HfXgJ+QWoQFlxfkfE3NVmMwXFQ/FITVUg8Nx/12J1+3cwzenVW1F82zVHXknFli6HUSx3NXJc8SfxdnAB4tvL5h0j2CZbAsZ/gTWJlpFDo26Em8X1DRYtwGb+EcJNygEO36L6we6dN8iuJ3c7ZcnoqkrXBrz
 NmfesSuC
 +kpjFuOIb5kpkiQg37Uu/3MwybGwMKqu5oONAAanku5AuDsn25tsId+7ZGw41S4Jxv1gH2rqZo5N+qxUb9o+9TXPHGXsxqBtaPHU9CkGGzJnkW7V4Gdd9zKMUPfMPZLnWDRtU6HXhWv1zw2VJvZBIyo8aJIn4C9D4Q+QQJRe7ZeMPcsK+3lxbxKMy0/o5C1AJaMoCBLD8XXYRjnh0nlyHhjzzZvTGimb6yj8m766q9t3vfANZKHkcU+2d/r6uO8It4DBTNQfBRGSTW6/kH+fyewEWVHDAVxPa8aAoExrkGJj1i7dLBYqYkCSvCWV+per3NJzVdQCq42h5LAG5ShmD6THrSucXdMVAqgCZWKGiquSQTGhZBZCcDz5DknDId4FYsXVjRb/XMP3iorc87+X8yKFcS81a/cS6sjBGUU3Wwj/l1n/EwZj9/SEg5563SvIVX21I/HL8M5NJS/D7XceXLeoL6D+kX5tn4ozpwbiJNZXGJo95nO67zV24mVMHLqicWuvOined7ELarVt0q49odnrr8nR67TI9bX4ZKAbSDfQ4eGRygHxKFD/Qe3jeYnV0Hrf5ATT939+HgVqTXi0VTT/hsFpV160DgI+1J2dPpv/zZK5DeDlJTth6wajX1es7fHKv1sm4VbYUCy15eJUVO852Xb2yREPIfjidLOlkWT15Ra+fng3CxFHPQGWpDz3izkc+wme8vJynx+EvMOdM8ilArzh3WVlCW8XrihFeMp9HCgQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 04:04:06PM +0100, David Hildenbrand wrote:
> > >
> > > No creep, because you'll always collapse.
> >
> > OK so in the 511 scenario, do we simply immediately collapse to the largest
> > possible _mTHP_ page size if based on adjacent none/zero page entries in the
> > PTE, and _never_ collapse to PMD on this basis even if we do have sufficient
> > none/zero PTE entries to do so?
>
> Right. And if we fail to allocate a PMD, we would collapse to smaller sizes,
> and later, once a PMD is possible, collapse to a PMD.
>
> But there is no creep, as we would have collapsed a PMD right from the start
> either way.

Hmm, would this mean at 511 mTHP collapse _across zero entries_ would only
ever collapse to PMD, except in cases where, for instance, PTE entries
belong to distinct VMAs and so you have to collapse to mTHP as a result?

Or IOW 'always collapse to the largest size you can I don't care if it
takes up more memory'

And at 0, we'd never collapse anything across zero entries, and only when
adjacent present entries can be collapse to mTHP/PMD do we do so?

>
> >
> > And only collapse to PMD size if we have sufficient adjacent PTE entries that
> > are populated?
> >
> > Let's really nail this down actually so we can be super clear what the issue is
> > here.
> >
>
> I hope what I wrote above made sense.

Asking some q's still, probably more a me thing :)

>
> >
> > >
> > > Creep only happens if you wouldn't collapse a PMD without prior mTHP
> > > collapse, but suddenly would in the same scenario simply because you had
> > > prior mTHP collapse.
> > >
> > > At least that's my understanding.
> >
> > OK, that makes sense, is the logic (this may be part of the bit I haven't
> > reviewed yet tbh) then that for khugepaged mTHP we have the system where we
> > always require prior mTHP collapse _first_?
>
> So I would describe creep as
>
> "we would not collapse a PMD THP because max_ptes_none is violated, but
> because we collapsed smaller mTHP THPs before, we essentially suddenly have
> more PTEs that are not none-or-zero, making us suddenly collapse a PMD THP
> at the same place".

Yeah that makes sense.

>
> Assume the following: max_ptes_none = 256
>
> This means we would only collapse if at most half (256/512) of the PTEs are
> none-or-zero.
>
> But imagine the (simplified) PTE layout with PMD = 8 entries to simplify:
>
> [ P Z P Z P Z Z Z ]
>
> 3 Present vs. 5 Zero -> do not collapse a PMD (8)

OK I'm thinking this is more about /ratio/ than anything else.

PMD - <=50% - ok 5/8 = 62.5% no collapse.

>
> But sssume we collapse smaller mTHP (2 entries) first
>
> [ P P P P P P Z Z ]

...512 KB mTHP (2 entries) - <= 50% means we can do...

>
> We collapsed 3x "P Z" into "P P" because the ratio allowed for it.

Yes so that's:

[ P Z P Z P Z Z Z ]

->

[ P P P P P P Z Z ]

Right?

>
> Suddenly we have
>
> 6 Present vs 2 Zero and we collapse a PMD (8)
>
> [ P P P P P P P P ]
>
> That's the "creep" problem.

I guess we try PMD collapse first then mTHP, but the worry is another pass
will collapse to PMD right?


Whereas < 50% ratio means we never end up 'propagating' or 'creeping' like
this because each collapse never provides enough reduction in zero entries
to allow for higher order collapse.

Hence the idea of capping at 255

>
> >
> > >
> > > >
> > > > > max_ptes_none == 0 -> collapse mTHP only if all non-none/zero
> > > > >
> > > > > And for the intermediate values
> > > > >
> > > > > (1) pr_warn() when mTHPs are enabled, stating that mTHP collapse is not
> > > > > supported yet with other values
> > > >
> > > > It feels a bit much to issue a kernel warning every time somebody twiddles that
> > > > value, and it's kind of against user expectation a bit.
> > >
> > > pr_warn_once() is what I meant.
> >
> > Right, but even then it feels a bit extreme, warnings are pretty serious
> > things. Then again there's precedent for this, and it may be the least worse
> > solution.
> >
> > I just picture a cloud provider turning this on with mTHP then getting their
> > monitoring team reporting some urgent communication about warnings in dmesg :)
>
> I mean, one could make the states mutually, maybe?
>
> Disallow enabling mTHP with max_ptes_none set to unsupported values and the
> other way around.
>
> That would probably be cleanest, although the implementation might get a bit
> more involved (but it's solvable).
>
> But the concern could be that there are configs that could suddenly break:
> someone that set max_ptes_none and enabled mTHP.

Yeah we could always return an error on setting to an unsupported value.

I mean pr_warn() is nasty but maybe necessary.

>
>
> I'll note that we could also consider only supporting "max_ptes_none = 511"
> (default) to start with.
>
> The nice thing about that value is that it us fully supported with the
> underused shrinker, because max_ptes_none=511 -> never shrink.

It feels like = 0 would be useful though?

>
> --
> Cheers
>
> David / dhildenb
>

Thanks, Lorenzo

