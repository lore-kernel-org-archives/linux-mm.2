Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FDE2C79F9F
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 15:37:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 419F86B0167; Mon,  5 Jan 2026 10:37:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EACD6B0168; Mon,  5 Jan 2026 10:37:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C3F36B0169; Mon,  5 Jan 2026 10:37:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1C1F36B0167
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:37:01 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F1F41396FA
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:37:00 +0000 (UTC)
X-FDA: 84298313400.27.7459A09
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id C7438100003
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:36:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=baPFLx7+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XnlrSZwp;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767627417; a=rsa-sha256;
	cv=pass;
	b=lI46QY9PiAqSgWY0hv9vHhU392jweEkSAggD+rueLS37KMGjbwxFjH3+40fHRz0X3oUlGY
	a1s7ybAXB86+RHDGLL/EcsG5PCqgXVPZCCflugcfTlykKSEGtfinkiizB9m8gRFWgp6U2V
	2375xYj3DPamg2EGmBcfM9eagJOEJ9o=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=baPFLx7+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XnlrSZwp;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767627417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZaxIudjBzg5i/ph/hRk+0d6VY1pDJRT+ufMH5DPsPjk=;
	b=FvXBywWYpnECiZI+SKW0CGlxVo3lAWDRrg3B55y3cnkjpajpBYUlcsDKoGEjDXH4qFjea+
	nlr2icZ4YABbUNoS03MaP/5893YiPwZkXgSLoKvCNOBG2QeSL0m0uew/PTZXh7ApP/SWXN
	yBO6eAgLO9eElySKzRkj0BCPG3mero8=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 605FEDfI1679518;
	Mon, 5 Jan 2026 15:36:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ZaxIudjBzg5i/ph/hR
	k+0d6VY1pDJRT+ufMH5DPsPjk=; b=baPFLx7+AkG77ZxCSD6PJpnmhj0jnqDMao
	U6F/c3Iab89hdjMXnkQswBhagpcysKqgHeGA8ChfTj9XqIEBXlP7Slbumg31EOuw
	g0NRmwSala4PXY3YHUZGfGAM8O/e+/ef7DMZow6zsAN3uqZRVFsohOo599Ko8MUp
	rkJF2bC+1CRqoQOZQCm8okFllP31Z+UXX3cugvYhpAZDJA18erLoVVJdz6qYDxvI
	/nfWj58tD3Hzd6e6g0OLoRsK6kmsCh1lwFmFoizBc9dszWAo3AGZpJm8nCGmkzXc
	Apwcp2NV5fcQYU4YWxsk2cN2+dc5/oFExtKoK4u7D+zkO3lbdCTA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev5qhwbx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 15:36:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 605Ev1D2026293;
	Mon, 5 Jan 2026 15:36:49 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011068.outbound.protection.outlook.com [52.101.62.68])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjhrnap-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 15:36:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JvDrSUDI0GjGs+xeS7tqZHTaqj39gzQCYQk7jcI304QyBhB5kEHqz38Vf++HeejB9dUnH07B/XOE7l+vwClAssR3gTAeoFJbBruwGUDs18ubeJdPDmlVdHdi8fpF+pjyFLcotbtIu/17/6d+wUniiDelG9x6ihu+Uf9d3JtpjocJlYSTNjPm92Vs6eANgrisf/csMcuQ4oL/bDJvLO8N4onybj/fitZPVmE63KIoxD3wWZwg5AmUgaXhZnjQP+4889uLT6v0I/43BXdoakwjOn6GW11d/Cc+mxoW8h6FgK7ETSErLvIUQlXhQ3jYMygRiztfDTpfOGZMHANLhfADTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZaxIudjBzg5i/ph/hRk+0d6VY1pDJRT+ufMH5DPsPjk=;
 b=H7vVZ125wME8lrHUc/Zadjm7LLpyXxRmviJRsFMpKsDRHKEPBT4aqftDDhA1Ymv4yHhvzSEi/kdzhOZtX+Gyu30BYPid83kgnLwpewxip4ioEnA2niWrz5QxJul1qDYOBjHPMyaufdHcmp+FjggYZ/jQ9si55lMdgqPBE5DIl8UFN8P9y1LjVH5nzMG+J7RhKy1j67ucN/h33ZiZnIQ10B0EDi++favKX1+0CDi3dgsCliPYGPmFVUgVgaSZz0s2YaywECVaxSWxLk+6qbuiKIl5nkxxhrc3nkQplArUEOCpZEicSTSNp1dW+zbdYt8weZLZGfaRNiPVAcFAA2bSRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZaxIudjBzg5i/ph/hRk+0d6VY1pDJRT+ufMH5DPsPjk=;
 b=XnlrSZwpUYRcDe9a7aBE7Ehj3YKF/8VzOdzub5/cuVl/KiBj6LuXWS5dOGyGmLw3vsyeOotHm1lvcPHU6FquI/Zt7JneQMF9GdHXQ7sgas0JGd+TfUcqRwVnJRngfnwBol18ZMMxIUdh7i3PNtJrhsaFtxXO0VW49IjPfOC9/70=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW4PR10MB6582.namprd10.prod.outlook.com (2603:10b6:303:229::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 15:36:46 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 15:36:46 +0000
Date: Mon, 5 Jan 2026 15:36:48 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        amd-gfx@lists.freedesktop.org, linux-mm@kvack.org,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH v3 1/3] tools/testing/vma/vma_internal.h: provide
 fatal_signal_pending
Message-ID: <a09462c7-af2d-4282-89e3-2cc43777338f@lucifer.local>
References: <45dd9b02-7867-6e5a-4a64-02c4d43c9b68@redhat.com>
 <18f7f4ff-67f8-4a39-b6c4-893bfbed4955@lucifer.local>
 <7014fb92-0d46-4c64-b3ae-0eb9d6b81878@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7014fb92-0d46-4c64-b3ae-0eb9d6b81878@kernel.org>
X-ClientProxiedBy: LO2P265CA0107.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW4PR10MB6582:EE_
X-MS-Office365-Filtering-Correlation-Id: 12249538-8966-4ff3-d9c1-08de4c703c1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ilTHKV0lZhCmQtJ1g+0tLXkRPmoh/fBw7RtHv4zUB6MGsvqgkE9wzvExOp2o?=
 =?us-ascii?Q?K87G00RYxnJwSTrjhoRzZKzOGTEEbaPu5iQSu5kITqk0bmKPKT9UG35RcxrS?=
 =?us-ascii?Q?4Xv0vt4QsT9u1jAdULd7FaSFaNGEGXFHKMj2bYa+H90dSGJYqX49tAVlWTsT?=
 =?us-ascii?Q?0ja0tJQOJswa5QwOdnEMBfmv+4tGI+n1tixHuhGOXHp/4u3fxaH+lufpzP7K?=
 =?us-ascii?Q?caEyOSQDT35JDqtES2jqkTwDwLwZQSoTeQHvGEsY4g+33CPyVrbRxm5gNxZg?=
 =?us-ascii?Q?M/0g4KXIFw+2pIa1ygn7IdJUIwQFGd7KIb50RfotGa4ysCTMKEPnncFO0mOt?=
 =?us-ascii?Q?5RBjZcYlhT2sIF+bJbzVR0YfCzF1wC/gvBx1Fw94v7D/CtJgdi6H9CAfd5q+?=
 =?us-ascii?Q?1cqlgIJ6jYLSpjm9UZriyIDjKe7k95as78lAbmdxet9ydChK8jKV7gVWQYPN?=
 =?us-ascii?Q?LMsUaaSGPOcS6ZCZsjKhE7dm9Y2QbFzLhXs9DLjsNnrcz6xOVc7D3PPu5fs1?=
 =?us-ascii?Q?+yZ1KBU2uEntN8sLyW0bkcG6PwPQFIFIuhVgJngx3NJnVb04E7xHK5p2+7rB?=
 =?us-ascii?Q?KfPkt7ktqqckoRP9APTBFVnVidYJzZkOLMJw87F4t+3NGmwlZU0I/AxZ5qc3?=
 =?us-ascii?Q?9BRKZVKEmJq8Fh5HCVTU2ls4nCL93g7b46C9wn7MVjo5/5DovCSMV8K6fDlD?=
 =?us-ascii?Q?8gyargz//Q0U4FnTwDDYuP3NHSPzCKsE8rXqUe9YzN01ibzOcel2m+sk6It5?=
 =?us-ascii?Q?eT1rxuAxMFGD4XIZSqWRY6AbYTyAMa6FseirgeE8mOmCCrzMaya1P8vDpGh1?=
 =?us-ascii?Q?zCDHfr4CSPmW9KQfAn2cJX20YYUSCBCOl2DpSiPWCl0S/USJIN9VyMPfg3Wc?=
 =?us-ascii?Q?DdiubJHItSnfZwCo23DC6pZvJBFa9XKtkhJ8I/RdzpadoJeOOBrw66bQKUFl?=
 =?us-ascii?Q?o9J4UExNyXe5nZ0KorR7VxfmBVfL7KGPmu7dvhGWR/OCCq02fTT8bpJiFpgP?=
 =?us-ascii?Q?2mp/kwqwyQzjwtdYc2IlhA8OTuvEyATFozODMgFf+vzuUxp0hX8gsZfjQ4Rs?=
 =?us-ascii?Q?rfwiE/mPTUhwl2qQhF/cQqSB7gwTSRx2iEj5/vYA2A967CNKuH8zfaDEpWyB?=
 =?us-ascii?Q?fZnaruIPE9AeiyMDj9OG/dGeDOEVnXJOz1c066gKDa34ELFUBDdfT3RoLJ+f?=
 =?us-ascii?Q?pHs4a+zO/zOiTXcxrK+RIZFYRPTqOth/7Gvt71rDVOfFDuE/2DLE1sFROkry?=
 =?us-ascii?Q?d/VgLlsOwjDNAe8DQ7DWiy4BMQxvjFmRT25ouYKq9A1YZ9M+RYBDe6eNObf4?=
 =?us-ascii?Q?lgRyjLkyssvwBu9qJteBI8UAuO+wWAN/OBc7YPpugfVsjcwCdU0fBn6s0rKh?=
 =?us-ascii?Q?Sb293THYmqX2TQk8Sn/iu+sSclEJZgv2nb8aAFFw9xuWBzB9TJQ5DAqtgtfj?=
 =?us-ascii?Q?LBKrzSrC0izv1wpQc3nnA00jU7ht+Ell?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OJtpb79wE7u42yNOarFwUaLyfT6nFxsCbBKaeI97Bk/kX06BysrkshqQ7oGj?=
 =?us-ascii?Q?pM3QTnrIaDbyvxudoNU7Wf0hykPl977AeiYfgoP9yOEvmCRLL8sGP3bVMTMg?=
 =?us-ascii?Q?CKYY0Ql02z7v64VwBQyjJy6L4AkqE/uD2QK6k+nnGF9GoB79490IsOCV8jrP?=
 =?us-ascii?Q?N5kTcxbx2UHkJ172F7YMblymT+bubvIzfNpSJ13lSG3tswZSVrjWeDSXM9Ab?=
 =?us-ascii?Q?AgUIa46mTua32/107KUCqT4eabhqobe+Tu7DYMfn8n95RcV7K52VJuOsgMWX?=
 =?us-ascii?Q?f7jo0rr3DqJS8hM2ufhZKwtnAmKz0erD3DOuov/z3+hPqN7goTkhTUZOX0X0?=
 =?us-ascii?Q?lbRZMxb5yvNOfN5kxhKW9LES8btqFFP/bqLPmJ0oIUQ2bYOtXxg+kOB8Ll1G?=
 =?us-ascii?Q?2bbkt91+KpLJmEWIGx86/8p13gz1RvZlbATeaEgh9+MyCPtEhxpnBhdk8okx?=
 =?us-ascii?Q?M6Ry+vQbqrnFYl0s61QvXr7QLI0tVFbbVUWAjlG38P2JswKKFQzn5+z4fmQk?=
 =?us-ascii?Q?lxy0re3KVTa2i8auGfN++aFYLpk22+fTtFAXUcFIP+s2jhWirnPeNw63AckL?=
 =?us-ascii?Q?1U4w+6KlgMk4V6Sx+63IOJ77irNKBXLAE+272e9HxadTuPBRJ9wFHW519sxV?=
 =?us-ascii?Q?A7/hZ8wnnLlFLGomguTK2Aw4105ad3weiwOYlkTZO7ftE4I0NbzD70C6mOWz?=
 =?us-ascii?Q?3AFsdjIr9KMewmfLj8AEAk3mFYS2QhMifnBUdPjBcXELu+ALRbnck+S2rvpZ?=
 =?us-ascii?Q?wzSUFXFiwWhoP5t1C6NH8ccG8+88ac3D4w17+H4R1h2q1vKDyrdv4eB8criS?=
 =?us-ascii?Q?39doHyfC6RCSip9eQu4Nn+BPklyPm48H1z2f9hAdfDfdieUYBPOltkYiadri?=
 =?us-ascii?Q?ow5JVL+OOcE/LnUwZvBnjUU8Kzmm0yMit9AFwhPKU75c092jM1T+EByDGoEJ?=
 =?us-ascii?Q?YJFqtNAlWWBFYa2U975CiMtfdamg8eXk9yDUnXRIrwsjJWyn252tbJl3rVBj?=
 =?us-ascii?Q?KvT0/OIKeBzn2q9cSpHvGBFASq/uRbmnUAxIMlKuC5oepN0QBpG2RUmwKeAm?=
 =?us-ascii?Q?ysYWlaT8Zr+aPRPTixKLxR59Kvfa7jGlNsKwnmYbTKafxkBsreGeHDjj7Ary?=
 =?us-ascii?Q?NJiAo2zFN0zTjgL9HcYcJ3CshhnOX3iELeV/uY2LVHioSb2YlA7tDlrzEnac?=
 =?us-ascii?Q?wRwkIa1D+fG8CU5MksqAtKmuf4zxu+mcq4KZThM+LBQ7IV//YAXREd/vABw6?=
 =?us-ascii?Q?yw5oqaUPN5c0wl7Srp+RgNnVfyYM+lRacSKRf9FHi9R0Czo7NGHhj+1ebCr6?=
 =?us-ascii?Q?NgmQ8edFVcbcJqY468uanidJJokh9tBjEDRu/R3vhBwOq7picRLQXD3xzrJh?=
 =?us-ascii?Q?q9Cl3fpoUyZzgBCs5DALlUVQKOK8XPN5H/Fk0qiQ+yYk1X1uq5mfuAzxYmmr?=
 =?us-ascii?Q?PVP+cMiH1Q2Ri7qbWilM6PwEIZRI02gFkyKDtMrQ49REfdCSsGf51wpgCxRK?=
 =?us-ascii?Q?3GNkOntka4pPEj7lmX2Jr/ZF9d+G8Z8WZa3gl4DInkp3NdKK3f0KLE7lhxib?=
 =?us-ascii?Q?G3sHvpRRCoYGja7JAHKm1IWVNGlBfu/9wPuyhBKH8fraIcDvdkBlQTj7ng08?=
 =?us-ascii?Q?cEb8N1W4cOcDJ0oGsmg9X0BXQLmAPVpEzRykLSjeDyuTUfPCNqgkK59N5LoL?=
 =?us-ascii?Q?VGg1fwktf1V2ctNa2AI6mcbIab/YxH1kr4ofPpuhTfbm1OpxuP+8xdG2rwcG?=
 =?us-ascii?Q?zihF3CoWF/uQfq0NIGynzWg3Rgu1dkw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ONrpK3fRwEpjmwtylWvDZRvrK0Sdu8kJSK5sx/fkX5fFypcIFlbAXeUjatHbavW8y0gMrqhsy116xPfc7EOO4LB78raQZR7IWS44wXWsD05g6UKtXu4rxwox6eSewseisZQ+KZO/AS+7xa8frsn/hHkjjui7o7mWEyRElH40ZatWnfB46Jfmbe4zI/PlxrqKU2AiUaqVadyj729flTloFh0oXy24nrPf0noqR5px6CywdlH1mJLjd4ZDk8pw/VusQsy24AthUCh5U5xp0mLbKSVh1dBWJL73ZM7s43hNVRhHVPz01ae6ha7EHSbPPePh5WiU49Z+Yi7G0UxVV5jMJmjduakTgn3OVHQkXIba65G+mOT1kmw4l63d8Oy5pPkCsVyCvEekDSPUFxZj+4dsebC3LHgLxNXn/2eiACA95+6sMVAgsESiV41lvlQ02uJuoTt++nJ/SkRMHfujTQRG/GS78yRxq7ImZAmCm01JQfx0gswmacjvvNu8JYJIDNVh+eocTmxaTyFTaYHrCcrkIw7BNHcL8+cIoKCo3/1wtq+w+ZFcbMrXv/PwVw7ZPAkVPXhQ9NcPFWwuONxollXVD8MilYzTCNFGGdpVMX8bOFE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12249538-8966-4ff3-d9c1-08de4c703c1c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 15:36:46.3052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uiL59WXR36SHpQY1xlhPLSq/aHZloctnbhYfDb0HZzBk9PLWI2WLzJCF6VlRb2IBUcJijinFEbkxmXmOAp1g/PBCeSMsWeKo2XmitKBNwbI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6582
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=686 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601050136
X-Proofpoint-GUID: EVS6-TiYkPelvNn5gQDMGNHfuitPHDCo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDEzNiBTYWx0ZWRfX2D9Zar6NU3d+
 PUs5OIz/zijZkjjGwrO6W0V3A8jOUINqXdY79V/Ebi2XCGUJUYeJALN6qG5SMjF5zeBvYkdwkRL
 XJH1LEQBLI7NbUM1/FrJf9BSeOr62ubVYdHVFw9IiCh+8Fw8bpbU0RrPtwGYjTJA0I4B2j8slFy
 T1ZvRk2mtne8ZE+aerSao06bgY8fSwRZSglMEEcoyXEDADKYYoKlc8JR6+5yDOIgVRBkBpS5he2
 dV41Hu0W/Dtv87FnRQYKEnl7QJb+XU8qgYcneiFH9H7b8Xx6OtfKYTy/xVwfa7pXaGvG+db8oPP
 ap1xwurHqa8XOTjxyykOSBFG7/LslJ8umKt6+WEq8hZWJ4KqptE6VAmyQllqBvBw3ywtcLV077E
 L8aKgql403Gsdo5njwgV0FvY0uAp1RpRCLxO0givBh0bDe6PYPFsZyZ3gGS0JL3d4Vs/hunOKTe
 Sm9aJhqeXcha/biY6Tl7P87BgnJJxS/REYCjQPhU=
X-Proofpoint-ORIG-GUID: EVS6-TiYkPelvNn5gQDMGNHfuitPHDCo
X-Authority-Analysis: v=2.4 cv=cePfb3DM c=1 sm=1 tr=0 ts=695bda92 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=X_9Vj2JaWoXQg-JjlVEA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12110
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C7438100003
X-Stat-Signature: bs4ikchhycyj83rjr8xqsfed74izfyw1
X-HE-Tag: 1767627416-701223
X-HE-Meta: U2FsdGVkX1+lh3w2lnlRMpWLs4woaSuOQ6m0tRhmOExaz4As3FAMKfoT0ww/7QIYvsMdTJCuXAFc5hDjKPOQoF56WlOHgFIArOglsdcXGQbT0rkZcS2YsWmzpYtDcs0PKNyPSLSFVlruznZsGE60LQXn9Afb+mNOd7x/6btvEiN7HbGoToxjGRa0UirWADg8PKG/L+ndGEgr3ZePzoqpCfUSUyf6RgRxOkqi5iE/pFGsIPZ0tT17AKKnLk6Cj2MafMHP9HzzoxzT1IhB8t6l+NvyYMwXivKsRMwCYgqG1LK/k2OZPUJMjxUTcK6253ryyQVcmTMsBy6ildUTfSt2rFaB6r3AAH63y0uSCQAElvnomogDJn0D/0FD6uPyAlggLz1jclRb9VKDCeipUWh6eQIryAnzxmZOFtqr1hIez/fIxWtkYORWTo2ijFlTn39lNXYPOCYdx+9Lh5AJS8zul6Dqdrb5O3UGAHrZynoQULb6lOEC4WXNtfNWXqwVx2cXYlAVExFuBiecRc3LDc5kNde8y2pS8iUTbVvyDajblw7dTtuMLZnXfgxFFVwbOqp5wXHJK9Zs1BES8pilDu4HNbCeDl4iJeefbCUsgLWItkrr5+aj/g5hHq+vFi7BW7ZT8otuxQjzBhaYPiNB9yVbCh4fkbixrJDze5y4oQ5gjix0zYNg2v7SeT6QTKsuSKa7H53TYAzCPY8v15eTfyBW7YbTjPjfMzeH1pJGuIbC/sHHuRw2IFKznJVLgCnoxy5XLKiSLivpUzYQ7x4bFgLUPv+FVKgvvkjYipi2EvPSYAL9ctZjRUzawIh4XbT4EbgfjYd33fJLuxpblW/E6LgPC5iNe6mVKUal6lh7cZiPHmYuO7j+qxGbvICgPCzrB5DhVznzdTuM3PXMNVdQH8w/v5djhNhbF4LM4Hxf5OOJ//U00nd+0MmPkqH+xLB/64r2B5W7eBWOHI1XjkE5Wdc
 U/pT6o5H
 slwJCGYtfB4tD+KCSI47e2qMrNaZuHBgdZbJs6LD0lju0nZbweUlwUmE64YcFxxn0MYjK2GHegpeLSGGBz/KLlPTS6X1hNru7uc23eS/5DgpJV1mnZMhLUo/qzFrKvOxC798cBcsduWyVb039/pCNArV9KC8BPHQoVznlf0xWyKHSVtxEDd4CFA/PqkFe0B15rGbEtw1UBHLwfwW+ZYZ8+Glq44+ToIEnTkDoXEPJ+4QS+CMaQvh/m2cnJQP7FQTHeLUCgvZv1muWX2vww9zjmGO3sgfk8EHc8zHKNgYjWsZyWsGf8CNRByEL6Bn3zdA3T6dEIDekIucoKlRp8vP/BEzD4WdsFVZIpJ8fAdlUd+f6bbq+8fgCT+iCMN65RK3+NYL97EcRd/w1J2fVTGVcvjgGjdYtUd64oY5h51dAfoyTn3e6x1r6GLyZOzz0BvuKEUS12hNL6LfwVHLXBp+YFCzj3Yy0CEmCuCrVqiPCZwNJpf7kKF0RM+/itm69teHlZKo0iHYAMDXkDIFUM/Kirc6IQpQrLjiTAk2bhM09IDfvQpKmfq+TaT95zLTdVXOPkwiOvtU3Y9ZfE00+4elnRExZ9sbOzaGd5ZjYqYM1Tjver0jZdmncRygtUY5kFnzPWnoay2Jogc1ZQ7NcIIEBHdaq5NL/aaHrdAIbifTftpzipKPgvDt5XuUm0T80i8541SN7+6xdOM7q7BGHDUh7PaoBSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 04:06:38PM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/5/26 13:18, Lorenzo Stoakes wrote:
> > On Sun, Jan 04, 2026 at 10:15:36PM +0100, Mikulas Patocka wrote:
> > > Provide a dummy function fatal_signal_pending, because it will be used in
> > > the following patch in the function mm_take_all_locks.
> > >
> > > This commit avoids a test failure when the following patch will be apllied.
> > >
> > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > > Cc: stable@vger.kernel.org
> >
> > No, please don't cc stable. Also don't cc stable without a Fixes tag.
> >
> > This isn't backportable given you now need to backport to 5.10, 5.15, 6.1, 6.6,
> > 6.12, 6.17.
> >
> > I'm not sure how Andrew deals with a mix of Cc: stable and not-cc-stable patches
> > in a series, think he generally doesn't like, but I'm not sure how exactly we
> > are supposed to express order here otherwise. Andrew?
>
> Can't we just have this hunk here as part of patch #2?
>
> Backporting should be rather simple, just drop the hunk on kernels where it
> doesn't apply. Sure, a bit of manual work, but better than making our life
> more complicated here.
>
> But maybe I am missing something.

Because the patch was sent with patch sending-101 issues (yet still merged to
hotfix queue inexplicably) so I assumed manual fixups might be problematic.

But actually because we moved mm_take_all_locks() between files it'll need
manual fixups anyway.

So sure, include this with the patch, whatever.

Just don't break my test...

>
> --
> Cheers
>
> David
>

