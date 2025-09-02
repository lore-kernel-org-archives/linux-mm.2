Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30D05CA100C
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:16:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E50368E001B; Tue,  2 Sep 2025 04:16:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E27948E0015; Tue,  2 Sep 2025 04:16:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF0798E001B; Tue,  2 Sep 2025 04:16:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B83DC8E0015
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:16:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BA9A4C0B84
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:08:50 +0000 (UTC)
X-FDA: 83843584020.25.5FF9EB4
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7AAFB8000E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:08:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=E1iMJbex;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uq9GxSme;
	spf=pass (imf02.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756800527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oHTzgdpkxHfh8afM0ND875XPX4BmCQKEx1oplTGLf5U=;
	b=zxYAC7tvxs4TQiwxCr3h1O+KgBsczVziOqyo0FIQMuffUIwxFa+GwDWNwG9uefzY6RSqd1
	kGzAl2kdwaga8C/28yojsIc2IQKvs1CVQiE6uVZtBji0l4qsrtlktwe3emv1lvgDMDkMSk
	w+7cvMTp9egOvjeEASTjY6Ip6EJfwOw=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=E1iMJbex;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uq9GxSme;
	spf=pass (imf02.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756800527; a=rsa-sha256;
	cv=pass;
	b=CbI7aX7nNDKFxm8Txxhc0e12TfKen6JG8yHcJ4+pFHrLHipZojBRVIwJEfRI7h2SYiSRuY
	p3S0a5nZOpfYFOxXbFhqbd+ltepDVzHr7TqLoDUeUyNOHP9eocMOCSeUO4dDZWW7wWluta
	ckKYWdZEe4lyVqBMs9u6FBsMt9Jf+0A=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5826fjuT006936;
	Tue, 2 Sep 2025 08:08:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=oHTzgdpkxHfh8afM
	0ND875XPX4BmCQKEx1oplTGLf5U=; b=E1iMJbexxZe+3QbLPvElOD9i1Q/2+feJ
	8tyqMZTdMYbxmYI3RE0Z05580tozm1BhhrcIgIGMmEu6eh+kTFUxZ3nDKswiW3rS
	xykzKUMFwbn2wJ6+iDXYwzVdumbzR8wH9rOsAjq+LRxQqFKAq70RQRxryW9IH71v
	CkydhsjtwfD8fBwT24lOxIT08l2rPDX1dlb1geG2jnVsxIKL3GralJZqwZ/M2foY
	qI/kF3SeehYD9/YJC15XUrNptcJ1IkIVLgdszx/EZm68JuoB4sc0s1bE1MeridFp
	sgfQmRno8FkNw0bPUgl9bPp6HK9Gd9yCvpg29Hiq1B0VxnnRMvmaIg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48usm9khd1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 08:08:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5827Z7UQ004220;
	Tue, 2 Sep 2025 08:08:21 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqr8t46r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 08:08:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aNrqS3mAKj0eSpBvXBwYwO7NURXBOQkBqvh3zMVAhwImhkUkxnsdYn1UUhsnkfxk570jZ5hp4HUaYzzKscdZVSl1xOUmlwGj4D4UbGjP8Hbd+Q/cwM8/7ozj1GA7SDn7po603V1SSXfBJmA1IZwJ3Nth69GMEUMzXU7dkNHcVD1re1Os5XHZHaEOnohoeQjjYIUa23uEq2wVdDKA3KzKuIS+diN4AGSrfJxtzKVUXi68jXZu15QqYRpgM9sHdthpfdXYyNc/QFDPs1Dcjt3ZdDRbP5e3q4QXrOwdJGVU36Mvywa5D33218l36OzE2H9bEYYoYvMqX8CiZjc7xB1ddw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oHTzgdpkxHfh8afM0ND875XPX4BmCQKEx1oplTGLf5U=;
 b=MJiE6dxKJ5OLK1Zx8niJTf9kP1SJpUkvo5qIl577HCx9cMLxdPFzfvoITnaoYJXudNl2No7HMuDba/zLusBCfp8tUnlIUlAEOpMznfDso7vmtAjxUAtZs4OKmnB8V2FcS0cNnj9CRiWDQc03CWQpBBzm8crGqQ+HK7NJyMQZFcmcuRMN94DRMsLLSHMCpDUZV1XNMt6C8M2IT7UOgFNpqpBAJhehchp6u0oeVBzF2hTAwHHWdErISaLUoo01wWBgz+CJLRFWk/KrhA0OJt3Bx2tBLV0rS+eRmjhIeT4DetYx7ujUGlTHkZFWfcDqq5PiTuZwYpfYEFb2yXWL7YjD1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHTzgdpkxHfh8afM0ND875XPX4BmCQKEx1oplTGLf5U=;
 b=uq9GxSmedPI0CGpXxxQJ5GumVYM4qoIffeHB+Br9GRunVtdCxp0a/4+zn2SOJHL34R8T7TwqoYI7TbXZxiCuF/rRhGrGk9pkhak598tsF7CXUFvXryhLDYV7Eetj0GGlGnuXvKCKHAnTg+kN5MFy4Acgmp1LiCMx/ARLQ0FW5fk=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by BLAPR10MB5139.namprd10.prod.outlook.com (2603:10b6:208:307::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.16; Tue, 2 Sep
 2025 08:08:17 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9052.013; Tue, 2 Sep 2025
 08:08:17 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v6 00/15] mm: folio_zero_user: clear contiguous pages
Date: Tue,  2 Sep 2025 01:08:01 -0700
Message-Id: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0069.namprd04.prod.outlook.com
 (2603:10b6:303:6b::14) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|BLAPR10MB5139:EE_
X-MS-Office365-Filtering-Correlation-Id: 90361bba-2cfe-4c7f-c674-08dde9f7dfb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iqNRvuN/3HShZQQFUBgjFHLoveIARAF5xJ5zfVsr+0ytc4W8pbpaSORmjOc6?=
 =?us-ascii?Q?LX50IB1hO3imilxn1bURsYbJ++CtYDzi+OEozR9aJRwxgmwHWscCibTdFV5A?=
 =?us-ascii?Q?jYU5V9LDdZXEk/wX6QbKM8FrZynl0bL8M84kktv6bxxTUheDkG93hIPJBkXb?=
 =?us-ascii?Q?hsAm8PkehqvcShY6gQxPKGc21kvbm8Nv1m25whsor1uZ7sYl0HyeaDlnGWAO?=
 =?us-ascii?Q?/d664cNuOW8+QGsQe0q45EDXYod9cn8kP3DL50HjcFf4LiLWG/qgoDFwph/4?=
 =?us-ascii?Q?/0H0krjIo3ejtrL5ekaVimg0pdgn93G0uxZ8PCJ0GsmTu46eqqEJrbCsjGK/?=
 =?us-ascii?Q?1YyPo1UV4/Yq0ZyJnShigeDyuQleu0hUE7x5cwR00sJ0rrD5yfHkn1gJzAI+?=
 =?us-ascii?Q?ooF41HAx5bDQdIa3WefYgol3zM0qLCC0P+tEOguOWRfc/nD1xHD08TuDeKru?=
 =?us-ascii?Q?bZsESV7MNZyi/PD2yQkaCGsaL77rxiUxag/SPu+ioB5eOEfWAmqaf/HBK7/H?=
 =?us-ascii?Q?7ywlt7CyaLypzORuj1HWRzU7kBizjOCYWuHJ54UMyLGkM69R4MhHzyqKuHdg?=
 =?us-ascii?Q?kwXvBZ3TXwuLJT9bcj6xHa5uFgKHhrNxH4Tmwbkaq6gchWfDPxuTtSXwEEQG?=
 =?us-ascii?Q?pxJgIHpe2uE1ob7vtVazW+UwJUHKFAkh/uGC6Ia9RclM9F3tkbg+kVhpuVKL?=
 =?us-ascii?Q?RmjpGpdGHLBquG4S941ITc1BuRduJbOMGA2ubBqFbWbUWW5tHc+Lv4LMJ+uV?=
 =?us-ascii?Q?6YRzQYSy05iI0yB6al0wL4w/472m4z5SKyFk0dk4oxFjBIHUPYHQH1S5uXeF?=
 =?us-ascii?Q?HFa9VivNEfvjCtshRdB3+IO/0ji6fIc2x2BICnUGT4V80hxDX6ptAfo4lNn9?=
 =?us-ascii?Q?mR0eZqgMvFDlPOVKgi2yfgMYBu7JOhDz7OdinAHBzE3ze3RYmUZHTgUixC+0?=
 =?us-ascii?Q?98w1dCflYnMY9lnWhvpF3izoT8NChcxbEfVRAZ8ZmpKeIMs7LhEuu+WIyXoN?=
 =?us-ascii?Q?/fwRlitpA1dM/F5dRVcTRm19+N379Fap2ZJtBxYW/HBgxoZG60dYlC6vhcDF?=
 =?us-ascii?Q?paGOw6DexYKiEFGUwdrwrNGeKlS9d3rkr9Npcd/24U2LNIbrEXbjn7DbgmTC?=
 =?us-ascii?Q?gQScahUsPpHE1gF/UXbZ37wfLERGdwsm4UijbshbqGltYF9g1v+YuAyJDodS?=
 =?us-ascii?Q?WNMwonMvJEmuY8g1TNJdUutU26DPdgfgERRnzSm30d1G3ZModhQ2BhXGwJSv?=
 =?us-ascii?Q?CUo1QHinj23lNP5YfVRNtg9SBr+VupDGL6+NEKGW6GZ1qMRZd/hVk8bcpCsn?=
 =?us-ascii?Q?rC6dEbiwMdyzD+k7G7LK0AxfgEiGw67wA+REfUVW6Cw0rSJrEw0CRz+ylLat?=
 =?us-ascii?Q?cRhpEzP0fFTeh6xLLieYdqD/xj8p?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gOUhQPPFC0ygYDvoTM5SW0FqM0mmwobSjd2faYg+s3eB48BnN+tIPEso0qC3?=
 =?us-ascii?Q?/8tz4qS9uMW86rqxfZNeTj9VJEaLT/EIcORukl0eDCHclBAiTwvVsx2ex57Y?=
 =?us-ascii?Q?ANMNsRkVL8z4iHAeSstazjApgo/lIkhpPiOmmTVAjt0B33spyVMapC7hjmTq?=
 =?us-ascii?Q?ajRL1DiKkV2J5f2t/aWjRQlhk/IQFnRtuv+//ZbckcBAMN1ZOlMqRXuY8bi/?=
 =?us-ascii?Q?TgUW/BjZrq1CBzcVNfScF9X8O7QOfS2BdWYD9mc77eyPGgIEPcwUumu1J8eR?=
 =?us-ascii?Q?BBVYaASRlvn4rxEEcmr20DaBQa9CYwaoM7ihDh+KgJW9MMiVEQfTXs0IAGVy?=
 =?us-ascii?Q?Sif/1aYLwwCn3jYBSqWQ593P3sDt7vLTTuMs4SWF+zt83B/dR6nJnPBcTfgo?=
 =?us-ascii?Q?6j20EeG55KMt43VOwMfFHz7qh5B/68OqFWdO0MkpgjdcYDRXAWSTXGx/oYJz?=
 =?us-ascii?Q?/sMdc7okte/0MCOn5VyDBoByU5dx+iFC4Mxouae/gYVkon3Kvj/nOhRQkzXQ?=
 =?us-ascii?Q?6GtHrGgLCLYZATG5XMoTt1m17Ig7B/KaSamh1Wm4XoHzyzhL19GheZLwOpPV?=
 =?us-ascii?Q?T+oeaKz9LIY4d/FX6mqYy+NIItmp7nrOk/RGWxi7wV3v6ai91LOZVEl0g43I?=
 =?us-ascii?Q?utcjnBD3Uhs8RExT1jUIgOjpD8rZjEnbSVP/UtmfsDfiBlXou4SXjVdl8CYd?=
 =?us-ascii?Q?089950X0CVyDPIlLzqJMa2rSA3vZTn3Xh4/L/rL12Z2jv2EnWqPpeFT3P785?=
 =?us-ascii?Q?WPZZ++OUL19ovsLCIiDCOEZLz902eLuKodsGlbSCQN7dCfq9xvz9L5ATwRQH?=
 =?us-ascii?Q?I4napv0pEQyf9A8XFzqCIoEdtx+lzDmiQSkh5dfOPNqD4KGoNVl35QxYGv5j?=
 =?us-ascii?Q?f7Zunok89dAleXCTx9AD9/NHZESppOOIe89MPrQEY74Ccl4wdkllXIpCSmEU?=
 =?us-ascii?Q?5c1uETmhwVjX8FQM0k6sNgvU5faOBhroMRZPKEarD68IQ06lPLf0BtbBxJnF?=
 =?us-ascii?Q?F27udxSUgDAGsAp6lgfyIfPNtiwOPsQNac7m9GIsvDyFyGGougbZ46EJc1q9?=
 =?us-ascii?Q?EnQnkYOH83bGBIPGMCt9W4xlph/L7iUOEL0Jr2hVVB+i+HdHiT5BSrWLnn9+?=
 =?us-ascii?Q?Rnx0Cvmd0S+nRY5K6vUQorRvalYb/UOY75Xg2lN8KzboxrCVYfWtcf4mS1D1?=
 =?us-ascii?Q?q8xiZU9OkpBEb8uwuACr2Be1x2mm/D+ClDU09YmLw+NjzP7LgLAPqshfkyjo?=
 =?us-ascii?Q?E6+bOupMTWltfNskAjDDP3vbRNsR2oXwOcah1NkBdzCPj9Bpo6bDzL2aHkKU?=
 =?us-ascii?Q?IqMCPxIJEugGLeaE1agcj7B/zAWsCNuGn//zMzHAi/iKknEW9NLZdnu6XIdA?=
 =?us-ascii?Q?WzFQMVyZbb/8rWFOM+69cODFkzYnszSPVNz+oeT934ZlgSRpopq8djt9EDli?=
 =?us-ascii?Q?eg39GfAnSqKHMQI4gQ37Wj8hNx3iC9LVf+xuyoqZ3p8/BQC4Uy3676lc+83T?=
 =?us-ascii?Q?4XESeOIZfJKk0wfvVZ702aWiYSHhhB/YecWt8RFpMvnOkQe0FCqh1ZQ4p8aB?=
 =?us-ascii?Q?CXrJfafdO/VbRghmXzFfJ9ebbTl6IaafELUaLRhUmHWfE/hyBFWoEJn7sStW?=
 =?us-ascii?Q?Pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+taXttdBuV1AhkJh3co28fIuKm7/1Qn1LDralzOn16EiXcUFrgzY75vkg9SmRqYKf85A5pOMtrcxA4JhjuIkgzJI/NNU4g+x1IQsg22S/7wB40yrp/hOaqfFyJLOpEoesHU4x4DklOit/sQ1wC6A5w0MJJZJ+rgmApnMU4BWVTm3Adapad5FZ1oKd4Hkd4TfeGW4pGriw6jYFrEDDGKFMEBvalM61u6fv01GwYVPt2pK7ZFQKvBagzCJ+Bvf4MVhR1LHbOu32PNzKC9NerZb3xg3/RzwEeo4T4t7GXu+lw4DKHiUQW3YYqkyO13UygHSaFmdGQjm6bn5tZG4MJmgwx58f37Qtg+sjnHydpXIPvRqQrei13eSMJhuveW9xzAbviYm7QqqbT2do+TAkXuGCFrTCtmZAoU69zzKfR7wZSMozEk8hqz9OTafJlpbQzBpAwVqIkoKmeLF9yTUuy+WjdAMLf1gXAQDaIP/tvXbfhbwXNBwIBYt6uUdyaksQb91lys/f65FGd2MD/5thK8kt3BekUQf6MP1pPAUSN8MoqbFrNzxR//ctD9avKTv2oj6jp4rTJAwBQBVp2GmQBSMQb52JbLtXyg5s3PTpkuWTnM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90361bba-2cfe-4c7f-c674-08dde9f7dfb5
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 08:08:17.7154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NKyYF4Q5LMsh9dl+FyiWbDoF8J+vIGap+mIVZYkEzU4MhbI3ZegpLOxoxHJHQQAdyXYCCVCR9eSrs9R0z0Ns6nq/PrOUX9OGJkBO4TpTjN0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5139
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-02_02,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509020081
X-Proofpoint-GUID: ig2FODDs_8UU9rnlPaVuZ-jx-ym_zgzD
X-Authority-Analysis: v=2.4 cv=I7xlRMgg c=1 sm=1 tr=0 ts=68b6a5f7 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=zd2uoN0lAAAA:8
 a=NEAV23lmAAAA:8 a=dwtZxa6-cFIMZWPJcc8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMSBTYWx0ZWRfXzyaMh4OVobdU
 TaQolOTmsulW7dDI6XSbryfNQ1pOlOgGi0k427q3jzTqmnGM+OcGHIRUiHWjBOIVAP2rvOzOtys
 Co3zT/Ly8cjj1MWknIfQJ+lvmMCUk1kHOB46coU3lMIZ/OgimDn36pSbdvYqOi5ieu8Sq2p7IyR
 JDmvguFrzZPMm0x8VwJAm3VU6A5X+0HqoxVMXy1SNiajUJDKSj/TPQiT+fwe5QQEpTeW49BXYiL
 4uVoyfPaIAplbrQOUBr8QBn2Hqq0YRLZeYAMSmzcCDNnl7Cw0YhKlDKTYHG0NVg0xUwekYJMBGR
 dfvnaPc1wqNTrlz1yWyA1V2dEBgGY5TL5BcDRzL3KW2xPiFgtsUMSWcWRgycnisg0GVqWZoBEPL
 k/WZdz2V
X-Proofpoint-ORIG-GUID: ig2FODDs_8UU9rnlPaVuZ-jx-ym_zgzD
X-Stat-Signature: zjxw9wq66szts51pfiwo58ja8o6sgp9c
X-Rspam-User: 
X-Rspamd-Queue-Id: 7AAFB8000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1756800527-185959
X-HE-Meta: U2FsdGVkX1+dg8vkRl1t6gxHKvpuoSkR/YanrCzgBxp4iA2HDLvOEXv10etdP8i200bCPjwokKVPZOZ9VdDxFiTD3n5nO5NNXGMKb9fUr4zxM2XDT83Lle+w93+Ssw3UOHY/6J6diMAis9WY+47F54kDkfTzKR3vbA3JxVWzG5pfLc4uxgK+N0cmM1VdklTqYbfTpY/2S3OCy42WKzC4OqOGIqtoTG+gRqYD5BXDoEieFM9X3xGY7bL7QKdzs+FxZo8y/+4PUiUaybym7fmOO+LFlUDfafyXR6ToLIBhgHJzSdmHMZjTU/rzpOPA/ZbCKlP4q+yXqocfxrJJHgupFOq14WCSHFR55w03uz+EYYrMpE5S3kGUfd+w/JCHfvKZHffyMngBZAs5O3I0vNgTDNTps8Ve/BLrQlnxt3uCpja+GTELH7/3Yv8rSmBq974+MPJ3IwPNccPy4Of8vLDoJzQuFtSzf0KIYIcMX4zVI2w8zCGbIlp9NII/npg3oqHcgCjR/g+NOnKR2YT/8WBiY7FuaB+jZ1JmNfPAdso/Q+bO1+4uGuvkcHAfVbKhJI6WBuht/v/qcPBQS88MDdoUpiV+Zr9H94MvEAU5Ali0K8d770p8PopgsuXIkTqO3sye9STEwKmFP/HoZye7RQJysRIVufidVye7Jj3T/eW+QA7YY0nQ+0ssiZm8rz+3mvqDkV7mpU2/0IX2nVqb7wSYYrkCffuHC5ddKoJj/e4QCOyPWNLLaIEQ6J/IvYVnT3HdhCH9/xMH93TTPzytb2stQrYedFbVryQRhtzM/jsIqWKdhTaYg9XpUd87VvUrGW+cpfSTz2rvvMPHNb/XL2Z0m3EKq3lbqc1ky3L2WBmWWgcJeva7ZjZQDIUk8WEhGoMRkOkH24K0WdAD+rSlqg0fLwsaEKdRQWT39uS8PoRyv6JR9vWzsj6YoWMSlIVdXjdUoJEGXRj1ZkpndcQIpWo
 8HDDSUrg
 6cs/lWMS90uHVbz90dpjtqT5SIdjrtB4JfS/ai8B2gsX4aRhZDATtDWu9FeUEb7HGhj1ASmRN495BdBsRPg4A/oPhvVmepx3Is+eTWCLg7M1fatL34ejv9P3YTfEn+MkWfYQSXwOXAtTA1v3FM3380SdEoyJRcfoHLStmbz1XywZrisnW+NQCDEEQiv02gQrUIkuq/jJ4NfSh68kTkfmCck8c4E8VQx4odvd5grMl5ecpHCddYJCSYbXSjmfwtePYSzUUZ1NZwoO6Qlr5IY/fkqWxB0LLyG2zGjhIzl1LkWRLUOh8ZJN3oPAD5FPn8YmOnXD55SODSD7G/JOIcKkm7222SpQtbUtewpXXJtH5245LVF02wiIGpA30XRWicnDz8G0VhSkf+EztKfT2NK9sdUGFji9JBs3WOhCexJWRmYMVaXtHPsSuVbUb0A7COOq2icGm0jHlPmPMASEC9VzAH6NA0x/GQzw7nGQ9p03uZn0s+3kS9DAYGtlb3VJQEmeyCxGv7bWwlQo80j2+UEtj9eGmLz891tuknHMZXTB5/aqK52USjQWrRAspx5w3eg11KYWXLTXmvGPLwepHMcUb/qRvlXlpbbOQdzy+1pjI31Mnlry6Q/tfleznkDYOoouoM7o9M3YItRAUT+Wws5gIjeKXjIrRrFdtGTvSOkCX/QCTz5JjLedgytIKk6BDV/a1Y7Vh1Dmk9EAvdpd18XZeCRQ8py9CLxmFfzOs1OQ3W0mksDDiK1Lw+eoOCgEyUbqdUigZ1sOsxRX01V6xIA5FKYA9twRJMBZRz8Ct9jKFDtw/dpf2R4uddoodsg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series adds clearing of contiguous page ranges for hugepages,
improving on the current page-at-a-time approach in two ways:

 - amortizes the per-page setup cost over a larger extent

 - when using string instructions, exposes the real region size
   to the processor.

A processor could use a knowledge of the extent to optimize the
clearing.  AMD Zen uarchs, as an example, elide allocation of
cachelines for regions larger than L3-size.

Demand faulting a 64GB region shows performance improvements:

 $ perf bench mem map -p $pg-sz -f demand -s 64GB -l 5

                 mm/folio_zero_user    x86/folio_zero_user       change
                  (GB/s  +- %stdev)     (GB/s  +- %stdev)

   pg-sz=2MB       11.82  +- 0.67%        16.48  +-  0.30%       + 39.4%	preempt=*

   pg-sz=1GB       17.14  +- 1.39%        17.42  +-  0.98% [#]   +  1.6%	preempt=none|voluntary
   pg-sz=1GB       17.51  +- 1.19%        43.23  +-  5.22%       +146.8%	preempt=full|lazy

[#] Milan uses a threshold of LLC-size (~32MB) for eliding cacheline
allocation, which is higher than the maximum extent used on x86
(ARCH_CONTIG_PAGE_NR=8MB), so preempt=none|voluntary sees no improvement
with pg-sz=1GB.

Raghavendra also tested v3/v4 on AMD Genoa and sees similar improvements [1].


Changelog:

v6:
 - perf bench mem: update man pages and other cleanups (Namhyung Kim)
 - unify folio_zero_user() for HIGHMEM, !HIGHMEM options instead of
   working through a new config option (David Hildenbrand).
   - cleanups and simlification around that.

v5:
 - move the non HIGHMEM implementation of folio_zero_user() from x86
   to common code (Dave Hansen)
 - Minor naming cleanups, commit messages etc

v4:
 - adds perf bench workloads to exercise mmap() populate/demand-fault (Ingo)
 - inline stosb etc (PeterZ)
 - handle cooperative preemption models (Ingo)
 - interface and other cleanups all over (Ingo)
 (https://lore.kernel.org/lkml/20250616052223.723982-1-ankur.a.arora@oracle.com/)

v3:
 - get rid of preemption dependency (TIF_ALLOW_RESCHED); this version
   was limited to preempt=full|lazy.
 - override folio_zero_user() (Linus)
 (https://lore.kernel.org/lkml/20250414034607.762653-1-ankur.a.arora@oracle.com/)

v2:
 - addressed review comments from peterz, tglx.
 - Removed clear_user_pages(), and CONFIG_X86_32:clear_pages()
 - General code cleanup
 (https://lore.kernel.org/lkml/20230830184958.2333078-1-ankur.a.arora@oracle.com/)

Comments appreciated!

Also at:
  github.com/terminus/linux clear-pages.v5

[1] https://lore.kernel.org/lkml/fffd4dad-2cb9-4bc9-8a80-a70be687fd54@amd.com/

Ankur Arora (15):
  perf bench mem: Remove repetition around time measurement
  perf bench mem: Defer type munging of size to float
  perf bench mem: Move mem op parameters into a structure
  perf bench mem: Pull out init/fini logic
  perf bench mem: Switch from zalloc() to mmap()
  perf bench mem: Allow mapping of hugepages
  perf bench mem: Allow chunking on a memory region
  perf bench mem: Refactor mem_options
  perf bench mem: Add mmap() workloads
  x86/mm: Simplify clear_page_*
  mm: define clear_pages(), clear_user_pages()
  highmem: define clear_highpages()
  mm: memory: support clearing page ranges
  x86/clear_page: Introduce clear_pages()
  x86/clear_pages: Support clearing of page-extents

 arch/x86/include/asm/page_32.h               |   6 +
 arch/x86/include/asm/page_64.h               |  72 +++-
 arch/x86/lib/clear_page_64.S                 |  39 +-
 include/linux/highmem.h                      |  12 +
 include/linux/mm.h                           |  32 ++
 mm/memory.c                                  |  82 +++-
 tools/perf/Documentation/perf-bench.txt      |  58 ++-
 tools/perf/bench/bench.h                     |   1 +
 tools/perf/bench/mem-functions.c             | 390 ++++++++++++++-----
 tools/perf/bench/mem-memcpy-arch.h           |   2 +-
 tools/perf/bench/mem-memcpy-x86-64-asm-def.h |   4 +
 tools/perf/bench/mem-memset-arch.h           |   2 +-
 tools/perf/bench/mem-memset-x86-64-asm-def.h |   4 +
 tools/perf/builtin-bench.c                   |   1 +
 14 files changed, 535 insertions(+), 170 deletions(-)

-- 
2.31.1


