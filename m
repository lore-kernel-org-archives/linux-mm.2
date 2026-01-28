Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBAC5D46BEE
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 19:00:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25F796B0005; Wed, 28 Jan 2026 14:00:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 237816B0089; Wed, 28 Jan 2026 14:00:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EE976B008A; Wed, 28 Jan 2026 14:00:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EAD966B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 14:00:38 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 911911B134A
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 19:00:38 +0000 (UTC)
X-FDA: 84382288956.29.531E78D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1BE65120012
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 19:00:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KHzYbokX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UeOGE4qz;
	spf=pass (imf29.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769626835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2QMEZnwKBw1wrrhawfTwqKAqrt9cvTfrL+9GsGe7qW8=;
	b=eo+Tdyd5Z4TR5XLt7mHdmMa2OFvfYTZDSbH0VAOcHyieJoTDuS1D9sUFdPylu9rvzDLD84
	XB+qnufQuCbAdn0OA2ZIDLHuQyd/0785BvNSW36iB35vliai5c12jec95Ufd/SI8NmzIX5
	F+VtwDXWCqpxhoYdtRipby/NeWZD8s8=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KHzYbokX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UeOGE4qz;
	spf=pass (imf29.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769626835; a=rsa-sha256;
	cv=pass;
	b=svENFEx290hJXwpDxl++dgmgCUNw8DCowLU1AGcHDbx/+4ostN/PD2695KU/tfi8mVd8Rk
	d3Cf/T7Y+yjoIBiQxwwvx6rmERgz5NArR1B8UR9sE+/7X+rKfveo2HRro7pYKc5lBx4yWj
	ZcsYS7EmPCuFP4zAxPOsHmJusnuR49s=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60SGqPwt1432082;
	Wed, 28 Jan 2026 18:59:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2QMEZnwKBw1wrrhawfTwqKAqrt9cvTfrL+9GsGe7qW8=; b=
	KHzYbokXVQNA/IaHXxFG0AqSdDt/zcJ0hMdObV6zV40M9ig5wdvkcvKyB8VfT96V
	FvRa6juD5oj+zwbfMMOnsdoapjm/ObfuWJhRh4fMeGHYAgi9aozW9mnBCErZIQje
	QlFHSIizWBIkm/LBPKsPTR61ppkwujLon2ptl30ZAsmzZpRP7NMeSa4Ya/Bmg5U+
	KRZnPB9PPKH7gG4KSqbCnF6D9Hhxvv6Y2x0ShlvXUL5m+JHIYfqwjc4E8T2iI4rt
	si7n07qsza+vSWL/0wqxJuVxDlPVA2BOckDTQqQjf2SFo008X3SIo0LkFIqpl543
	+zCGYKVS9eb5GUcrNTYa+Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4by5dj1mme-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jan 2026 18:59:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60SHbARk033142;
	Wed, 28 Jan 2026 18:59:52 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012009.outbound.protection.outlook.com [40.107.209.9])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhba7pk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jan 2026 18:59:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n4jrVy660QkMeU+rjKoox5C/FUdtq9h8vS2MqUOt4ERjpIuzIOt3xpbKtGhoJKi3Cg21OthRDROfBLNQL2J/6Axj/RFu+DzpoeGb/YTKhFQQVU39rapgzUNOsVp1SWO13BR6ygwiCK2fjGglGamfYnppoBngx0PMQmoYocgMD4RCubcP/HrsSUHI3SZHtdtvS7EbO0rtEUiXTC6o/uJ3HwoH9tL9juV5SV/yS56uvEU6qQ8Vc8fGX3qL3jPIJ1MaxFM6iH5Yg9KHQzyNjmcXRLTraJiyfhxQK14didL3v0eqFwhjVt+epUiELEybxKQe5LtqNG+w/PO7p16JjFVHiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2QMEZnwKBw1wrrhawfTwqKAqrt9cvTfrL+9GsGe7qW8=;
 b=FXOIsot0sU4v/1uZNS+2kmKU2PiWl6xstlnWjo2FQbhJYWKiRnPhcyYEllKFSyQBtzf+vBS2D8w3EZ8htgAIPGYtIm5IrQQxExdnIWWHT9Q1ZijZ3i24wzeB+NSV/MUvjpFx6SHSrFP06mYGN05s0Jf+4uSfuGOp8GLWRSzqw9HxkxL43GsyQwcXZzsVhcbxmblvHi37skNDVjGePZZjx1/2U1YO9C7AmMHMeSPD88kMe+4/+eZEbPFBpph9GK3bnGx9PWyOjxRiM46HSwC/a0nHWmVxuTfe700mNjyr4fz9Mss1l4XaMlqdj171FXAlCBmC0ikHP0o03u7fVZm8gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2QMEZnwKBw1wrrhawfTwqKAqrt9cvTfrL+9GsGe7qW8=;
 b=UeOGE4qzCJS1JBceh5Yhq22xxY4m0YoP0i7fVDx6us4OYn+Gf/3qh7CsA+bjXSVRQrVeAGR5fjUDKdJT5GkCjHoQ9jw6XpsRSguhve5FKQNBWJxa1vWRHbN5/UtoNV1NeNcNdUxnS9xWFxc0EJbgitRZau5GgY5TNZqlICoNNWg=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 18:59:46 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:59:44 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, lizhe.67@bytedance.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com, kernel test robot <lkp@intel.com>
Subject: [PATCH v2] mm: folio_zero_user: open code range computation in folio_zero_user()
Date: Wed, 28 Jan 2026 10:59:43 -0800
Message-Id: <20260128185943.2397128-1-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20260107072009.1615991-9-ankur.a.arora@oracle.com>
References: <20260107072009.1615991-9-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:303:8f::32) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DM4PR10MB7505:EE_
X-MS-Office365-Filtering-Correlation-Id: bb8d17ff-cf32-49da-7e31-08de5e9f668f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jHGyd6J71v37pTzRZmLiVZ5JAS7MGK7QgCqnlA75p9Zt97yYsp6hKE473pEq?=
 =?us-ascii?Q?BX1wCP52DIZ2cf7LjMCb2v+mRW+LBhYo/kWZEhvKPWyXkjqq95SrfRHGFhO5?=
 =?us-ascii?Q?UprajfUrznSJ9Jx44/aOAvC7HB8NjMp+L8CLeMK0+WbzUKuaYF+OIago/PRb?=
 =?us-ascii?Q?zkAJEUV6WWsmn2+paPOqPoKulc05NRImvF1fEmRKv5trfmAZ37m1UvOLC2Rs?=
 =?us-ascii?Q?2rlrsBvzh+4fAFou4j3R3JI8kSX/3Hzg3KYtmHdtlqQdilsVv4TbJCR+D86J?=
 =?us-ascii?Q?qSWxqjeJjazi+0repVsfo6L7zg7ES9V2uxo0gmGfcgBsNljDQZx0SoKN4mIe?=
 =?us-ascii?Q?D/SAMNbXChpo7DF2Y4XSDsBM/M2Emw6txkuzyt3LPAZ1RE9RhcK+YRT6iYLh?=
 =?us-ascii?Q?hP7r6X89MZO7tnx5hJAFx9m8xRI1nYBtAii5oLYPIOFQhWSTrLcPBdbfXPbv?=
 =?us-ascii?Q?HFTYtILEbRM8XD9datHP/jV0jo0qFBd9erGfv/Aoq684C5nTIGT+/DUgdxTY?=
 =?us-ascii?Q?oQon7U6u/tD2ISfuduUZAWiyOR2MhMX7fyHAyIBhvvqzHmCJ6DH0d/hfV2eo?=
 =?us-ascii?Q?XJTH7nb3AwZlbmyyzFVxCvaYwRdYpYpI/MMzN2LktWfubF1s+rgPNyio8vQn?=
 =?us-ascii?Q?Z+cktsqiIpT3vlMtpr1s0qTAloe3I7Q2WPKEILTH2XglkmZTS1SlDpbsgouV?=
 =?us-ascii?Q?TOWbYAHPnSWR5SaqK8nX48phqzTO32fc4RAqX1IDtOLlemwi+Zf18qd+XYpo?=
 =?us-ascii?Q?I9MD1S0SeY+iI5ezgLNNQI1PNp9xHVdx5Jlx9O85yGoOKe0vJH98mTTVB+pS?=
 =?us-ascii?Q?3UkUjVcuS+HM5pjtDre25g3a4S9KE9QLjRCom8rjp9eM+6Y/MCk5dHNW0tBT?=
 =?us-ascii?Q?V2c3r+p+Ufp1d6L6N9FzD4/MZTL6Oyxu2e/C8HbZO75r/bByzRYhv/ywBMxJ?=
 =?us-ascii?Q?uFkrVVvK43o6bHuo87kLGMr8+3JYo0W66GUXeNzOs+t977mz+uhpomQPGBGQ?=
 =?us-ascii?Q?seVJXnegKnEYX2DnQIXMxiHvjYi+Kglf9PZ4FbqutbzLwke9PRZWI1WVvWWV?=
 =?us-ascii?Q?XHhyzlLAQtCOlrvqW9+wUNNll4hA1LZDim1s7Z71AMTUfHXtuRCH3b3Rr4W+?=
 =?us-ascii?Q?aQ/MvlxT6rxI+Z6wDgQ6J/dAClcpBoqKY0Ue6Q9UDZ7lrHx8wLoO+KSEupRD?=
 =?us-ascii?Q?cUWfKKp72HNX3s6qrdxEWtXwJehtuO9VKmL2+szBC+lA/fMXYBCiMRK8dFtX?=
 =?us-ascii?Q?sfhZl3M5GU6uwWSG7fpf01tZQpqFN0zH/qpezEDMdVwwOcK5JCtekX8oD9VR?=
 =?us-ascii?Q?uA0+Vz4ZEkQHf70pHUHA16E3huvdtB18ksESavgkhur+xwBMyOqthg1jr5nu?=
 =?us-ascii?Q?0/qvCadYj3+jxpkgNU/keTi2pH93VGS1+cWLAxO4xndD+yGn6Fzkh/pYB7HU?=
 =?us-ascii?Q?3Gb5skGLu+0WFuvFFhhGZ4PPLDELi4keZdhoNjsJc56e87B5qI69Lgt0AwJN?=
 =?us-ascii?Q?8q46kR9Z4V+TMzVwh3ELA9PftOngpSCw6ZUx1Wk1JBc0IgVwRd93VLm82p+4?=
 =?us-ascii?Q?u+sbTodDf+c/Q1lhtu0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OtVGWHavQB/4jM7TrDFcD72IJ/pyxsw+5UJsY+aA0iReZrqsD/qcwGjk9L6F?=
 =?us-ascii?Q?pxsPXLh573OeeZ2LIvF4/YTk0gsZIkFsVtuAsfxYilWfcNoLdZUyn3ZIPqtJ?=
 =?us-ascii?Q?jNEdOnAFYfSfdnxR+vGAa3mHycLNe9lFMGP4yCWqXtXtK4BOnZjY0k5sYyRg?=
 =?us-ascii?Q?JsbDQvODrkcHRN3gv2j8U/T4jSwqXK07BJ7iuESxAQHK+9jTVIMpRQVMuSX7?=
 =?us-ascii?Q?dGr/rN2kioPJRdcRlV6z7YVpFVh32j4TorkyjGAtCNxZjPuZXzjLRL4Ato36?=
 =?us-ascii?Q?fXYpy0uXgC1E9DDV+6Bd7UHfn0I0FDjoCmKBg9VK568tlo2Jj7uaXYu2u3aH?=
 =?us-ascii?Q?rjImfEGQgyzG4B52CuPVOXnlr29gn5d4wJZtFRDzkfzErZNRtG3nvPfdtA3t?=
 =?us-ascii?Q?MA5rut9hiqXgkSJv+wMGkfIj5GpeyJIlNe/ZtR8WkmktZOmarRw6/EHzFPlg?=
 =?us-ascii?Q?imrrZsXozFKlNmxwKPOJQNTRVn4F5VstJF0ZL70bmtXyCEUMWGWKkUzH3McG?=
 =?us-ascii?Q?BDkT5m+AYhOvyO0Qn8PbrrBgaQ4yBc77TyHcmSCLzH9BlPaWvF31cbj+CK/W?=
 =?us-ascii?Q?l0AYGbcWM8HoUjrw19K6eYVp7eIO0xI9PlfFzHxmiHZ37Dm02PngZBskOI8b?=
 =?us-ascii?Q?ReuaEb+qjynSckcjbMASAy86/SUOUyCZpFGUS3SgXiC5ER1yAlEhS6KPeF6+?=
 =?us-ascii?Q?i0f37tFBM9Kt3/agBE6JCedZohMvUDJ6iTE7svXQMRxUFpkHh3875PwvV614?=
 =?us-ascii?Q?8egxYoiAczO7JRWXQrfjV8pm5bqeyCIK5nuzqZCge6N5bfXzZ79XyyYZbY5C?=
 =?us-ascii?Q?JvhuYKEuO0caSdvGnK0eRTo/E2qvXOZuJK+0VK11bC12YlkUguTbIWw4FDY4?=
 =?us-ascii?Q?WdPDGTi/TXyBy4UrNPP8benopt+yVNGUYoIJjsCFfGv0052JHTlieSjuSG5w?=
 =?us-ascii?Q?EuO9pExIaTeC5oZx3pSXM5lpsLVQTuOrSbb6XZV5k3TLiuCjt0CknVMfn/pQ?=
 =?us-ascii?Q?o+rlu+iBdT8B+JkGFeeDENtKXmdve+mXQwCWjtCtA2lsLVteCB0uYEJs3KLF?=
 =?us-ascii?Q?limju+KvWSRe7P88bR7Ts55PaadM83iBJ0zqNxbPToSqcsip8AYV7zJZI4PL?=
 =?us-ascii?Q?//lX1GCscKGThgKLf2f10gFpkSlfbscBURSsQv+74dBC1s6mYU+hUY5mWmbP?=
 =?us-ascii?Q?M385zmBPvZLz43oV+f7L/Vm94OLBe3tYwJC7ahJbB/+7T+Hf5JYrhXF9R4qH?=
 =?us-ascii?Q?8znc0Vsk8105PrKxOlrHHS2SbuN8DRFQ3HjLzXqIyKPS71fO9DFU3q6Zfun1?=
 =?us-ascii?Q?m4Xw6xCJjPt63M9fOPD/krbqpu7MrGQcoHKWKbsxh0sZhHEkwn1iM90AD7lJ?=
 =?us-ascii?Q?qSmBkJez/sycQqSAWzJz0X4baq7h6Fkx5IuORRptWKq7L6OGc7dRVbiJ50Mp?=
 =?us-ascii?Q?7snkw5v2F6uBurll8pm9vnpqbhsn7WDY30MnoFYJn2VnJY35V1Uc0T/Trz7j?=
 =?us-ascii?Q?QqlISJ7Uv2HMeaSJC5SDQrenzZJNyyRRa8OaHS3tfNiJ8Pkh8hf3IMPjmP+t?=
 =?us-ascii?Q?NraZ362fARobBGDFOksssm0e0FfAT1kTLzosFVR8+QDtiK2UGmlGn0tVTqEZ?=
 =?us-ascii?Q?aHt6sUhYdubB0K/dpa84yg3joL0XCaSKAxrsEM/8r+IyzTPF2Q2c0u+YSfjg?=
 =?us-ascii?Q?6B/4WykuhQ00jaK/jgsaz7g3d3kbtgdhOMChnscLxXAMYUv9qLDhnNSs0WSz?=
 =?us-ascii?Q?qaUyCKqv68mY86SskYI7AqrsFLk7v4E=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3t77COSlHGaUf5KtCUufjCdFV2zoAMmDen+i6dL6arG0IpR6TNPrIm8DEtVMbH89czqSwWh+ywd8UvqjLcbf9DvCpuke+YbNpqY0TSE9y3aCeYMyP/HwyJY0OMt/rH7pCaZhauq8INwab106WXXNjHH1ADzCbpcwHUUY6A3z353aItU4RdGeCsZm+x75lhU4aIH/yohieFzjk1kc4QA0US5tB8I1ZRMKZCC/5cENJUczzdGFsvx/msEZfsq9FuHDie2Sxf+eR9WY1ZpzM033oiAx4OViPl5k3+S/WQljOFHhwopRYnJ8pGyK0ZC9cjCqa8VOSkZcm8vntccDutpnMg6r7Myi4aZEIB08cT6iCYzXkXGnejDIfyJFvVx2SRQpYhXDAE4V0seVqM082/X7I8niq+fcQbGHmaC5LmxTj5lYXes6CkTBiQ0AD/hnMS+sDB/DWA5d4yr9m26wfhWARSx9/nCh//UfoHJg7ll8qkE/yCFfGiU0fZoSVToJERx/mixKy37SknCnFgqPIWO9rat88/lM5uzgwB3mzoCHph6p2lVm+SEpxdr6AAMzuH9Jyhgmw2ZTYkJsW6GTdqF1/8fgssniNndjgksx9rDp4rE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb8d17ff-cf32-49da-7e31-08de5e9f668f
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:59:44.7756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JZknsSe9/P/xudof2GLTWm7hr4NefPR0iuvkFTWLSS0B+3ddCOc9xrO3bdu4xWP1FD1HW8KLPKTI4FnrGVZIDHAIEDLH0Gt7Z0edxV5gk3o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7505
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-28_04,2026-01-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601280156
X-Proofpoint-ORIG-GUID: 9K5kBPp0Pa8By_ojcxmD--sxUUyrHuSm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI4MDE1NiBTYWx0ZWRfXyJd5y7wJkvgv
 ruExR5vMQVE+NZhYhf7ivtpapEusitXcHfj75YDuvewjjY5zRpYoxfRRJ783T+50usw14c1oTTC
 shgsyucuJWMD3LKsgGUpvq1liBE/CNhML/bbAqkTKlxvCFwz4//RGblnIQvXsmJswr5PyEweIvD
 mFht3QilC2sQT7yOUzPVvnoGnEJkt6o8WL94j0paEXY3hbtu8q/Po/ZgfYR55+U09cyUxlTL3Ra
 TXS38W+vDZVNDs6wbL/AaqUe8UNURPisA8tHzo0l8svJ78AMpHEIi8yPiDtuhErA0QPLdeVSZnN
 2aYKf2AxPrToNvKi3FtJ3RGHAG9inPR95STXoZ5bnZ8sFUi/XfSe345x0ofgsZwPRMz+AwjxVax
 Orb9DSOHCJdi59MRiz0wsdk85PJR3IjVK3efNQYzG4nOSCjQ1J2es7PAT4OhkoOOxS0urrjElFP
 Q0tX8mO6o8AHPpDgGtw==
X-Authority-Analysis: v=2.4 cv=IrsTsb/g c=1 sm=1 tr=0 ts=697a5ca9 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8
 a=yPCof4ZbAAAA:8 a=UPAns4q9ObfJLkRcdUAA:9
X-Proofpoint-GUID: 9K5kBPp0Pa8By_ojcxmD--sxUUyrHuSm
X-Stat-Signature: mfh7snydzyx7in81mebofg8onf1nrny5
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1BE65120012
X-HE-Tag: 1769626834-745258
X-HE-Meta: U2FsdGVkX1/J6UzSy8JTVmDNWGtbisy9k3qaQxseJOsWd0STbGGLQsUmeGBWyT2+uswwnK1Ol13lqteXMGk5f5ZKvMTHBzo5pfLwMGzvG3zH85CK1aA4/MqCPQtkFgu647k5Lk9vh3zAw7nj59RklKCzkNwPGvFc806du58umYw2Uc+Biw9hZpABTEDzA0vqDCqw5GPKbc4/jcxh7tFMlk8kn8d5bHMs9tHMfJqCrjx1llnP1DhPHobUet30QHMljBckNGvgHjPEIWZgExmKBI0KSWqeea56CnJGxOfP7o7f8NF0eXGzMe7/0a5NFsY/oaHDisV7NBpEDwDsledbQm1E7Dy4dMD2LL+9DxgqlsqvI6Bj8lmHBT+wlFKAd22KsBN4+uLFkIVkInsjNPRlkusk+wzmZweqssOeYUHLqRF502YsM3x1KpwZFb+44hnyi8wnUWohZoYYP7j8M8rsQX/mH4cFtXy0XlevB/GbbVQHDy7MOtLEg/bNBa1f/FXiyJu9aJzPaWXPdG5/boRBK03JVBVTeVQf2ws7ANXlszfZy2qLTXbK474k12MEI6o/Dcr+QmwsT2bTxUFFZF0u4Eeux9Riy6ofu14l8hGkTtLZDREUOpAkpKvKKWnP977CVnSefhrclMK1uGdfT88JVjcc5Y7i3y1NPxng6m6utQxPB1+if3jsn97gU0unNSlxMdNTu+4YevN5Cg5HgtAt2QwrkJwSRJLcSHn4iwjwB1JN0JHMSP9TUv+bae50rdnUUJOeQFmeMYve7zKipoQIIz1gOVZHylCXVQu6gn0WONUfQ1XRCuKM9rSFjzi1qHsWiO22hZtr0rSFjGmpgRkQkEk2KBYZykwZh5mosTlZFewXMCsZMfX0gQJHSOGYIzK6byvhFTJzDSQt+3ondF5k4k7G5lqZiv48aQbFkPI18wJWVa0s0BOmsWAz3wsFE6jZlZfOe9Cm0VBc9QvRbxu
 1mMXJFJ8
 9c/BAr01o5nuVI+5KeP8FInjZjy6STt6j3dX7bj3oQTjtZq6epHDVDTW/Htk13biBHo7VEZzZ7RC33WnkKFy7BhB/djcuDfQsgDbYl7wWzpfusd2ev43OvYuyhofnbvblAQ+FNVOGHgjbWcXj4fne2mLFEM+tEVoDc8RvcC4tzknQM+V4IzXZZ1yiCRMZWRozOE22sW7n1RW4+lzlQuw19RldnKtkyivtMfhqhaAyg9/5rJ3BIq+bt4rGFxsNOK9+elCf71asWBbxvXrU9LUxPnIIXl77pPixgaC77ULHE9fUoeZgx8BmS2qaFXtZtWMFuIgNG+YqAFg7rqBOI7rVfKuCerUzlpHGBXUP4pqGZgSRpRy6BB7m5vRdnEO7ziBV+H+Y9USAXc7VS4m9R6cvqRl+ThwV4Rg9/DtCgN8zmCMQO/B9ysjnnD0uyx9S/DewywIKBemFDa2wJYmW9jyESEiYO6NsN+oG6vtKFQma39kMk804yaBlffeL8lghO8EYa3Kx4vc9r7NiyPs9F21aMg/DcQr3E9+562RSNViwb8Pxh+od8MW5XwUMJkZF9GOL6IJX4C+V2Gjy6I88XUBJko56iWAd3pIbvHB9n++MS7XAX0c/0wWtSGBwNYX5cJyDAkrIVwMiSgYNvZpzYuxFzBVPDwHsSUaCYBoEiRPRglHeD1XFqTxa4GsCO8DDvuBXtVgBpZbJHNMqLEdkecB4gV/V0ZtO5HHYCEQ5MBR5JqhdPtI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

riscv64-gcc-linux-gnu (v8.5) reports a compile time assert in:

   r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - radius, pg.start, pg.end),
 		       clamp_t(s64, fault_idx + radius, pg.start, pg.end));

where it decides that pg.start > pg.end in:
  clamp_t(s64, fault_idx + radius, pg.start, pg.end));

where pg comes from:
  const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);

That does not seem like it could be true. Even for pg.start == pg.end,
we would need folio_test_large() to evaluate to false at compile time:

  static inline unsigned long folio_nr_pages(const struct folio *folio)
  {
	if (!folio_test_large(folio))
		return 1;
	return folio_large_nr_pages(folio);
  }

Workaround by open coding the range computation. Also, simplify the type
declarations for the relevant variables.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601240453.QCjgGdJa-lkp@intel.com/
Fixes: 93552c9a3350 ("mm: folio_zero_user: cache neighbouring pages")
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---

Hi Andrew

As David pointed out, the previous open coded version makes a few
unnecessary changes. Could you queue this one instead?

Thanks
Ankur


 mm/memory.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ce933ee4a3dd..f5bfc082ab61 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7284,7 +7284,7 @@ void folio_zero_user(struct folio *folio, unsigned long addr_hint)
 	const unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
 	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
 	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
-	const int radius = FOLIO_ZERO_LOCALITY_RADIUS;
+	const long radius = FOLIO_ZERO_LOCALITY_RADIUS;
 	struct range r[3];
 	int i;
 
@@ -7292,24 +7292,23 @@ void folio_zero_user(struct folio *folio, unsigned long addr_hint)
 	 * Faulting page and its immediate neighbourhood. Will be cleared at the
 	 * end to keep its cachelines hot.
 	 */
-	r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - radius, pg.start, pg.end),
-			    clamp_t(s64, fault_idx + radius, pg.start, pg.end));
+	r[2] = DEFINE_RANGE(fault_idx - radius < (long)pg.start ? pg.start : fault_idx - radius,
+			    fault_idx + radius > (long)pg.end   ? pg.end   : fault_idx + radius);
+
 
 	/* Region to the left of the fault */
-	r[1] = DEFINE_RANGE(pg.start,
-			    clamp_t(s64, r[2].start - 1, pg.start - 1, r[2].start));
+	r[1] = DEFINE_RANGE(pg.start, r[2].start - 1);
 
 	/* Region to the right of the fault: always valid for the common fault_idx=0 case. */
-	r[0] = DEFINE_RANGE(clamp_t(s64, r[2].end + 1, r[2].end, pg.end + 1),
-			    pg.end);
+	r[0] = DEFINE_RANGE(r[2].end + 1, pg.end);
 
 	for (i = 0; i < ARRAY_SIZE(r); i++) {
 		const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
-		const unsigned int nr_pages = range_len(&r[i]);
+		const long nr_pages = (long)range_len(&r[i]);
 		struct page *page = folio_page(folio, r[i].start);
 
 		if (nr_pages > 0)
-			clear_contig_highpages(page, addr, nr_pages);
+			clear_contig_highpages(page, addr, (unsigned int)nr_pages);
 	}
 }
 
-- 
2.31.1


