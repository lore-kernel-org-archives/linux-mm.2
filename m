Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 741F4C79F88
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 12:16:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A538D6B0133; Mon,  5 Jan 2026 07:16:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B81E6B0135; Mon,  5 Jan 2026 07:16:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6474F6B0136; Mon,  5 Jan 2026 07:16:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 375986B0133
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 07:16:10 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D8DC4142559
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:16:09 +0000 (UTC)
X-FDA: 84297807258.04.3E8A9CE
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7F0464000F
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:16:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=adrPL91p;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JXhvU6Pe;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767615366; a=rsa-sha256;
	cv=pass;
	b=pHDiQohhAEPl914oaqHe0v3X9b8+PuHZXoFy4oLhQJiJ7LfMTpSuVZKvMHsPbfETDZrfgq
	OkvRTIM2QKH5QamfWYlz8GZlOopi0oJvnbT/Eb9t+2v/Qh6ikuwGV42pE5bmLeAbOL2LEM
	jt9XIvacwmjcBvxcfiOAmDd62czRLQU=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=adrPL91p;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JXhvU6Pe;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767615366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s/3b2Fo0d3RqnjF+IDVX4zZdKHDrSozMZCXLz8gAJkg=;
	b=dH4YDlnS9qtrFjC8jOlQ1rv/cNRRSOmXOp9SPfHlVSOoeHhBG2jt3KblHaJDASLmsLjDLj
	wPG6N3AGZynz3U61qdclO4NZ/rrTFuaoPruP6elhrvZsx92oUvRsSr4DN4on9QAikEZUcU
	e5kpKfBZ1TUotBUiqqGyesFGK8lIUAY=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 604NZ2vu151566;
	Mon, 5 Jan 2026 12:15:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=s/3b2Fo0d3RqnjF+ID
	VX4zZdKHDrSozMZCXLz8gAJkg=; b=adrPL91p0dL/c76ln/nY1GptYJUcbGJaVU
	li0qFB4e0gr45D5MahVDE63+rI2UgsCLuvUKqmk0br20uF/1EbkqeAhz0zHJz3d8
	jq9MdbWcLojQEpHrt/OFZk7LozOmNtmuuUrmKL6iQB35+r/6gerhQWjrtRIw/7q8
	n8P75L0PobtxukINj5Gj3Bee+Vpgbr1Gcg8MxBUHSfvZH6HX75fAnU7WAiCzrN6/
	/hUBCU3aPsT9VPjYYJ/KY3FXEfCWmxh+l2pZUy15ZyOMchCDd9VaxVD88RE523Zv
	WhFgEgs9NSUXQqSno4d/WWOU7SV4IILfmQllB+4k1IzN3BUWAHZQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev37smsc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 12:15:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 605C3Q3C034042;
	Mon, 5 Jan 2026 12:15:53 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011024.outbound.protection.outlook.com [52.101.62.24])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj7anbt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 12:15:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LdvqPImBIcskcdL+wlB9I378USw6r6Ht34/tYW/RZbXWkuHQ4iHJtC0RRAT+IH8VE/Y9CTf+t9UDNA/ojIeWT/+YNlPrnWhBx109EzpAiBHF3wt7qYlYsZ/EP4tc85VHaRGfJ4QNV6hS4qZ9c4fehtJpK7NqD5d8G5zwCsrqJ6C8BCU4IoxitMb71fCCaw05gpeGIW1OMReRpf8L3t0Y/IQuVGrP1h9jh0VH2qm40WQ6rgobbUnQ9Nr7Pu2VBd5lMpNj4nXwFjoR0g0FONWpizMtJHMmA9xDC5BvMzsTk2sRRycKfS6Z6Gf+GZCU+yYsoRoSfggqzrtEcaDEzRvzqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s/3b2Fo0d3RqnjF+IDVX4zZdKHDrSozMZCXLz8gAJkg=;
 b=gt3YWC6vN1NHhagy/x92ar8d2upGOfz/5IYCoH+SHaUrVNE3/O44hkcm7jfEQlKfWRq0VJqP5J0rF0twS972WovFcH08Oy0vYA+9Kmfz3KQkrXaA66jKf+XGtKaSHEFKRx2E5xjXDtEfXQN+Bp56aFVmdZatO43xYBcSM5/3NrmMVBO/J+a86rEEDkxFkJCP5s5qW3jnaOJGrKxRduTr9t2xz75tDRS3dDdk9WTJ2TPrToCvZvxwuuPU0XiyxtTcuqYH34TJxwjwmCpYMzHpPGzFNkdyRuxqL1bYrcwPK3IIqYFeUAUcnn9IQn9gzEwayv43aIRXu/BLr34pLfMn0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s/3b2Fo0d3RqnjF+IDVX4zZdKHDrSozMZCXLz8gAJkg=;
 b=JXhvU6PeLgun/zhuKplHS3RlOqhpbunM9jSWHjcU5MV8MhhpUhWb95FSKYFnjIz01HqhvraXxP0/id3fYxMURlhYA2kEKEHmaMpbJCsl7RqyN5zPvITUOVHNTj42+PipAE29rS0KxH5OX1fxQL7gz78mi/lLqKmw1shFkOKIEt0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ1PR10MB5977.namprd10.prod.outlook.com (2603:10b6:a03:488::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 12:15:50 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 12:15:50 +0000
Date: Mon, 5 Jan 2026 12:15:52 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org,
        linux-mm@kvack.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 2/3] mm: only interrupt taking all mm locks on fatal
 signal
Message-ID: <81253632-da9e-4061-a9d2-949953b61c65@lucifer.local>
References: <b672e17b-461d-16ae-e7d3-45d3c1aab142@redhat.com>
 <e435395f-90b3-4603-b305-8a52913cd0e5@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e435395f-90b3-4603-b305-8a52913cd0e5@suse.cz>
X-ClientProxiedBy: LO2P123CA0089.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::22) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ1PR10MB5977:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bc95b30-9921-4e8a-0a63-08de4c542a39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eTjYsBFbZFU+p6R0lULQhruF3LF6kyZUHwSuKT0ue8TqfmoCM0mmJswglrpc?=
 =?us-ascii?Q?ksbxmZ+5qp0fEzxI4UxMdRZEjszjPBLoDS15BlEsN/yLQ4YLGLLkaeYiXngT?=
 =?us-ascii?Q?341PrAHLq049tXw4MZhKyFT9oVnm69XhhcUgN17pN46mwoGGox9w3cRWOLEx?=
 =?us-ascii?Q?TgnXMNyVDrR/VEhEZDkNyzA4wSHTp/QJY8RFg3PiJktwtR08G2ysht7m2ZEJ?=
 =?us-ascii?Q?cIoHO7B7CQM8nwoiT5baeYaDSI0IF4+70qgXeaBKDbVyn3bxUY4i71ph4flQ?=
 =?us-ascii?Q?dE2DdAxC/dV0dwMSQjZYAPHPQuUDrx3UyS0KKdFKwvYpM5RKSVIFExIv8iP0?=
 =?us-ascii?Q?tv84/2NbCOSq9hCyY6X5f7o5A6/p0dQYOKBCPCLxqqttSglFQxa/rqW2Yeav?=
 =?us-ascii?Q?RLxAwBdE44pGqEW3ow5tFhS2M6lxgTVyLVhLH/kHPLHmKiNAq2fzdjj1HnHO?=
 =?us-ascii?Q?BKGvzYXSeH3bYRMY976Reomqikkl2TA0CPjWXuXfZo70y7pru66BUGmrBwR8?=
 =?us-ascii?Q?gWmHtU+14MFDgI9CkWLh7Vgg3xU6GJwRFfoD1MsRN4u1qkyYhdcC7AZ7Rxef?=
 =?us-ascii?Q?Z5PsUphKQ3WENw53foLaoJv81eGrWKnfLFaYNAiWrc0pGVD8Fy0Ersq1op8y?=
 =?us-ascii?Q?IQWzsrT9Wz3gLZy3CIlNo4UpeYzh8p+TevR4cVuW5aERD8G+NSUA313ceJEu?=
 =?us-ascii?Q?+wZ6EzpT2WJG1EZhCkKR3uANgh0OGXDE4cMvgk3xC4BHPfsS/EWFPubvS8UK?=
 =?us-ascii?Q?TD6yrCULsuONbu5w/8pcRDcE3k4KkVHfnj/LP3S1AvFKG8zUxTCjoummu2yX?=
 =?us-ascii?Q?zxfrfWqMzfSOw4TlGTwoPwlwq8O/w2em+MziaelcZjicMFiCD5vwsnfWtKvk?=
 =?us-ascii?Q?E3dGkuvwgJu8c6EctW1wTsYexDNDWIyiUA6H9BUnfJ5w7Aj2tivlEieBncB7?=
 =?us-ascii?Q?oEojyCXVAaOR3GaOPy1WMFENl87oP2B25WCx5Hrv/s8IGHfijBnxnMakR6hi?=
 =?us-ascii?Q?SEXNmIUeajPxGMggeu8D1mWgeWMra/PmX7QANDApFxtV6IeNErfE3Y6WQHQ/?=
 =?us-ascii?Q?W2TMGnPeD2QGjRai1KMyfzFWzp4z/7FGsazFZODYpyPtC/8B4vTqP9hcHwU4?=
 =?us-ascii?Q?RbwQ9c3nx030L0pbDwYh5k9b4MbDI+KfNBOWZG2IZyoaiafCWzoP1k7anUKz?=
 =?us-ascii?Q?CB/wvdotauQxAmKlZRjTSLznkOV4ocKRMEMuzIoEbtAAzy9yNv58bN310gUD?=
 =?us-ascii?Q?6AZ0ePf5OvEDsxYToSEW/VQ9DEVTu4CrcnKIhS6eul3lrft/qQcg9/JiH4Sj?=
 =?us-ascii?Q?Dhmq1yq3BImXdjF2PkdtajgIxTdivPPjDvm5PFjcjKpHxfbYpNqFvBiVNXkN?=
 =?us-ascii?Q?6xx8RLxPoS3C25eYRnfvPcQ5VLtID1yh7nitQxW/cNRR46hAiQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7qGi8R+St25QR/zkqoEwBKlkWKxPSH18N3UAyntltbO+j5TgeYvMucVv9t8U?=
 =?us-ascii?Q?v+6b9fZDP9vOVbuoQo9lX32bTjEoZgPVJgyNFTOwnzSZ3HdjZ651OMI8cZ88?=
 =?us-ascii?Q?M/21DU1idvk3+X507P6WJXX6L/5p1XEPaJvtVwurHNIYFw/O8kV3TBhqOXo5?=
 =?us-ascii?Q?D/fkVYFRka0E7vK2XDx1qrvWnxCZlgQDPSeDoUN1yd8oHNTXbyifXLIqI8QC?=
 =?us-ascii?Q?n07nJe0bcAHzUG5pk4gbLhKHBY+mKrWShWtvYYxjs2MY87plbuykd4cnHnbA?=
 =?us-ascii?Q?RcuEuxvblCSRGfUzSgMLIiEsQxqpFwW6tHBJv3cPkQzBdht1lpMdDTJWOQaL?=
 =?us-ascii?Q?MCwJxIBlgk7AL7IZ2Uz9ZcZ79IOF077elDdVbHbQuHtDzNZibckrTz/2KB0t?=
 =?us-ascii?Q?XTtqYnfBhPyDQUKyOTAg12notXuBJVEsREHsKp/TDINq2PQ5rprIq78QqhSg?=
 =?us-ascii?Q?JePlainZf0v7HIS1Y6+xQhSEoYmiqirhncR27j72EWn8BhG14hZOLZdQeRD9?=
 =?us-ascii?Q?MBaFf/x7jeZFfyxMIQMvqll/r/7kx/xqIWj/ATk5NqdlgOJkKG8paJFBLejk?=
 =?us-ascii?Q?GU07zD6l8F6NzeC9q8z8oylRmR+wKMMFAeKOz7cf9jRwu4FZVcjBcwb5LEmR?=
 =?us-ascii?Q?1FO8RZX0lzQItAfO6IdM1Bk4QC0ttYspCLIkf7Yp1yu8M9B+N6AatWudRC/u?=
 =?us-ascii?Q?YwFrG1JV0cbkDAopm1VMFIUcs624/idqD+zYaPI18B7W6wewB28ylLGdvLFu?=
 =?us-ascii?Q?+ndVVB6f+aMNxig4YyC0YPIaZqfajXGSCw6K9hsN/LhgI2/5EKAa2f9L7BvR?=
 =?us-ascii?Q?GMt9N/UMlqfRVnrKwuoYH2R/pASCIFCVRD/gv/Ry+E5fkpexlcUnqC1J8kIr?=
 =?us-ascii?Q?kW25CS2qfc8TJ9hF/iisnK60EipLj4+LseE7+A7tF7SCvCx+o8vqGbfR3dvG?=
 =?us-ascii?Q?3XjZAvy8qbrExUYI3NfwC5rQRjCtKMExkVj9unMXyZC2dyta+CHxhdCEtb6P?=
 =?us-ascii?Q?XCaGwC+X7gt2SeraGj3KuB2kM4gxYLFlm3q5AluB5I5iV3p6Oq/Qpwqvj0C+?=
 =?us-ascii?Q?bW+AM6VbzPPqhdh2pgnUyOQs2fBue6tlJAzEF8yXUInkQ9UplTj0O2XJCgZL?=
 =?us-ascii?Q?RSFX8QI52qz/Iy3jo+G514ItKUETr2Y4mMWHRChSJLWHIRjQizFRBB8ZnAlP?=
 =?us-ascii?Q?j8ZSRqviX3cHDX3h9aCi3gJWxpcMr9IKeC0Y7JR8qW0kS4Hg8viTuegizFiW?=
 =?us-ascii?Q?ABv5wWfcgt+CPC0fQ/gwT5wLg0rhcy9EVjSsC5khp8zFrpIMZyXnNeXRjIPn?=
 =?us-ascii?Q?6hy1dRMHqnCyTAQdX4U52lmGDYme+643iBu/fdli8MqPo+GguqZPbROAf/cK?=
 =?us-ascii?Q?2S4U4todm+kxYnYhSBdoyb6AnhSYuOGPXC9O054nqfJjzxgNCzSn6IuBb/oJ?=
 =?us-ascii?Q?8zLGGRoVWulH4gG7NFj5skmvh1iY6Gdh34QXHxgpOJQHLUOG1ltbj9Qwx2IT?=
 =?us-ascii?Q?/cSjnl3XcpyMlp1y8RC9+r6aMutpXHFgOwK3zzSpgEhWk9ewGbLnkSF8xeFw?=
 =?us-ascii?Q?y93wI2rkFIk7lWA0MwrBZ+coE3pmKFO5HqUiXdv3l2PpDNFyuyC7bj1kjVZr?=
 =?us-ascii?Q?6/UvGDCrukXAdOsYW5fd0AUclQMiaStXzD/sdxPonf6ssqaAegOxtpKVu+do?=
 =?us-ascii?Q?T7MVTPyZ+MBXjy6Skxf/h2C/Bl9SeQTTAIrikKhAxbIcYyrfyR9M2fdAetgT?=
 =?us-ascii?Q?baS5PP20HX5G2aqaZsf8exOs/IZuz0Y=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DhLbf0VG14mXDMWW+vmlbBNyx6zqcDzA4f/AzmvgrPpWmgl+1mdbeoqZOT/8B4mj3MXE3BXRkfmaC4vXCGWWa3Fot4I6urGorf2G7cINgoKl7AeUdvE6LgyR8U7RlemejdcGu8DLgVlVdOtHZxbWwY8m6gi/OLcm6yYbnbFmSGQxIOCZVPgIQMi4VEII+nHAEBsKBkggKvbdgCqdfq19ssU2rWNbqX547TtAymu3XKtQoBM3Owm44rayQ6cRjxJV2Ee8hSiwUJ8oFuqZIiQPKknzwXht4PIfP+ViZWpdkdLBS01x02hGnRGSSZ1JQJE9wG4ddixVroa3jIeKMxSEMGx90ggg+3Ehvw7MHTm4JrwDbhO+rKuEsnnIqPYWi8EyHDOcDwhtQnfNyFA0BTRvdf0FSrvygoS+AVJQ+u2GO8iyknFhCRRGU/V8JtkvMgNVc68WVId9iSLGdjPgvf2CzkZf31VKZ+NnxCeigdynVXExErSlNYkwZo38nl3t1aRZCnGbP9M2+3uJ0OCcBKbuBlhPUpii9oQ2Yaxe/sS1RK/DI+XWeklmvCvmOPLVtWtkjivKm0h91FXirhI2DTolBam46PDXPcxp8T3lxFlG7Ro=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bc95b30-9921-4e8a-0a63-08de4c542a39
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 12:15:50.3441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WQ6T+V0Ja8mI4fIFP4GZLeioDM2ZOr8WgbeWA3P31Wszch6S4RYS7I9rbe2cMk4Uru+LXXIPCa+kIIod42kRxNgSLoMFC/W44hR9PdUt7YM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5977
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601050107
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDEwOCBTYWx0ZWRfX3KMSZt4vcgDb
 GohFDO0WkDmDyKEgFnjlxS7uneSvw64O9T7YxZSEDjQtj+pFNy97acC5cSNSobNoYDdYfMEmUXh
 c43Kdm6pgqwOKqWGrHSGHwDYy9c36wcANeG0LxQSgKvl+I2I+E8UYdnpTRgcL0kfTZwXTn5tEbh
 /89+p7OEu59mdNJ6pjipN0NHLA+hCLPFNgFIACCk+9fiMksR0u9zGQBn4YhspLAsNzpDrTq7WRw
 7Q/eyRhNAa7sFQfyXx7xtJbsCiraToh0sRQX55+L8L3SQONQE+KuWahQXmBe6CfwF6X4H7Ut/Gf
 P8ZYwel7lhhnW3VdK5qV91nl2hFk6iifL62jhjHnFPiIfZ55Q0Chewp6z8t5x3qIXLu6q8tZcqE
 jd/w+mTRu+C8D8g0B1ldiyU2+Y89CMU+gb68LD4vjSBPtQt/A12nSK6xkz2+hh1Ir6wJsuzazSl
 T3c8i4IX7dvzt7p698g==
X-Proofpoint-GUID: u3JjQMb7WZqbGjb8IlK16jpThUGJu2wo
X-Proofpoint-ORIG-GUID: u3JjQMb7WZqbGjb8IlK16jpThUGJu2wo
X-Authority-Analysis: v=2.4 cv=F89at6hN c=1 sm=1 tr=0 ts=695bab7b b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=e5mUnYsNAAAA:8 a=Hbzmh3xeAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=8vaXWntpNIPSRtNi90YA:9 a=CjuIK1q_8ugA:10 a=g7YHAZv9ijwA:10
 a=Vxmtnl_E_bksehYqCbjh:22 a=xeQfQEM6LeUqCIeUoqQN:22
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F0464000F
X-Rspamd-Server: rspam10
X-Stat-Signature: 9y3zp446k9f3h6ar7ndxihgcpbo8s5t7
X-HE-Tag: 1767615366-249606
X-HE-Meta: U2FsdGVkX1/Db5W/WLAtjUtfhr+N7bZOyGuUXNi+R81lsgY3j2v9UEr0mhrhv47Jhw1kVqe5Vpa+FsGl1XKZl34Ly3eR2L5lDJ/EwLQX47f1fVGZhQbu8S1Dx7OXI2QV3TR0XpWKNotK12FnMFL+45ZUaC+BA7+wtPLcCqWhxjCUUYo463lRQZ6BaoyovTkYS/1l5SU4dGF+GJSiPsf0AYaMLvfuRlCgV9h2g///srowB6woGuJJM4cyilzrwmglgjNnz56KgF9ZFssGLTAANqZqjd/28kwusLK/kAU2N9GeutbQc5bgovsoDsMWPmYgSkfvZUrm9uQ7viXUodM5GNUXQPhY32AAlzjn5hQwrVghWKmfCIbar0NuDi5hP45Gubr50buCfa5mp+DvpMlYTFZCO6WoCkO3Q8gYqvuY3nZlxmOJhXTDpbbpbCp21YnT5zyqCzcI25UAXsnxeFQC5AHJd+Nn1/ql2n4+zQacn+odfA2pJgT7s2S9GaTBd+wFXe9uws5H5jPqRTKwS4JlB9K/PqUT3MSTE0dYqExFkbxEwCryTfa78OqI2F5CKSEHejkoqGVsTNeoL7eNcI+99sMvtg6CnhyNcKAkrRvMTof6LoYQMNjPHOhnR97EsUp3r9iymtnEGjC7ayZofial7RysbjAKWPtxDaRJRM9kId5er8wGxQP0TnjeX1MZ55p/lzMHaQBwWmOeXIb991aSAGanA9EvzlMX7d3kvKtt5ekF5g+Trjn3OfxBMzAeeaZlDnmv0iIup8jyJ8B/YJjQANH8ri14KLBnTHPaeO9wG6+3u/oZ4gkcxJWb/PG7+U6DivggvDlcZLO8GCabxqynF08P02ClpaSHYqo/gvy7k/53rrHf7x+cZkQcfNMZNQ/KrWESjcvqtaI3SJZujAJVRxTG2h0kDkZ+27PGykU5tG9rKaKteTpAR0T767H8LAfMcwiRS3obahZRjDxnaRg
 G+wTk5KW
 kxuHvZD0oG6Oa+RiLrAeDUI5mCniSNws/fWKMYa0Zm58eE4YOdaZi0cRv6a1hRyh4X9mdMkECYlcgZ3ethmAUg/0GaD7IdKklgerZ1But0tZK9JfjXnn0sCPzIcvYtwUG6G9477wdr3JHlONB2aZAmnTRiyfKPgmpeUdlyBt1fGAIG0iJNWVj0Ja9jffuyuGwxwEGKc8hLG/6uQYC2pOUN8emd2grDa5rN01ZWcynIyh2LlkM3ZVXXSea2GGXyVVvB+9fQi4FVMDRJL5vGrcH5ywAiuJrHR5KAfJB36fGAYackH+73bTQmwjk2jLEsX+wblkGnow/4ojG7PASBRgQuMIkrW4NZcE43WXLNGLVBiv93SVY4yL7k1bCXJws57mU5sp/7hAm8OYZPmEe22wh8gOixLpOlmshBC7C3Hkm4ke3VJ93FS10lJP79SNrmun6/i+jdxwydmjhekLZYdK8RHbF8IALMxHJY4qbWok1ChHmZQpsmpGufCmZ92TBRwZ63AB5PwJ4JVRQNrj52YPaQADohn6ID8mO5AGbR85LgnIAiQdk6IuaMRveUtygo6ufSdQU83aCywweAiGWYlX/PBfeAMuP9vC4jUO8eY13tVnRUNHGkphpopT94qThwOYsvitWSnsRkJwwEuPAErWNPSD45ORo40iExbVQ/4+avVfl2rEppOEGqjxymvOpxIY8w69QAVWb6MfgxJuksu3R8vczPjWMQIpfjUaE2MCNHkJLyA5M3u7RnBhiUyx4XSF+VCT/GXUGcgrmdRDVBwGgNMdnDalJTgPTGglX1u4QAU0xEkgsBXyjm55xd7RAFMaHVScaaxZr3UH49no=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 11:42:26AM +0100, Vlastimil Babka wrote:
> On 1/4/26 22:17, Mikulas Patocka wrote:
> > If a process sets up a timer that periodically sends a signal in short
> > intervals and if it executes some kernel code that calls
> > mm_take_all_locks, we get random -EINTR failures.
> >
> > The function mm_take_all_locks fails with -EINTR if there is pending
> > signal. The -EINTR is propagated up the call stack to userspace and
> > userspace fails if it gets this error.
> >
> > In order to fix these failures, this commit changes
> > signal_pending(current) to fatal_signal_pending(current) in
> > mm_take_all_locks, so that it is interrupted only if the signal is
> > actually killing the process.
> >
> > For example, this bug happens when using OpenCL on AMDGPU. Sometimes,
> > probing the OpenCL device fails (strace shows that open("/dev/kfd")
> > failed with -EINTR). Sometimes we get the message "amdgpu:
> > init_user_pages: Failed to register MMU notifier: -4" in the syslog.
> >
> > The bug can be reproduced with the following program.
> >
> > To run this program, you need AMD graphics card and the package
> > "rocm-opencl" installed. You must not have the package "mesa-opencl-icd"
> > installed, because it redirects the default OpenCL implementation to
> > itself.
> >
> > include <stdio.h>
> > include <stdlib.h>
> > include <unistd.h>
> > include <string.h>
> > include <signal.h>
> > include <sys/time.h>
> >
> > define CL_TARGET_OPENCL_VERSION	300
> > include <CL/opencl.h>
> >
> > static void fn(void)
> > {
> > 	while (1) {
> > 		int32_t err;
> > 		cl_device_id device;
> > 		err = clGetDeviceIDs(NULL, CL_DEVICE_TYPE_GPU, 1, &device, NULL);
> > 		if (err != CL_SUCCESS) {
> > 			fprintf(stderr, "clGetDeviceIDs failed: %d\n", err);
> > 			exit(1);
> > 		}
> > 		write(2, "-", 1);
> > 	}
> > }
> >
> > static void alrm(int sig)
> > {
> > 	write(2, ".", 1);
> > }
> >
> > int main(void)
> > {
> > 	struct itimerval it;
> > 	struct sigaction sa;
> > 	memset(&sa, 0, sizeof sa);
> > 	sa.sa_handler = alrm;
> > 	sa.sa_flags = SA_RESTART;
> > 	sigaction(SIGALRM, &sa, NULL);
> > 	it.it_interval.tv_sec = 0;
> > 	it.it_interval.tv_usec = 50;
> > 	it.it_value.tv_sec = 0;
> > 	it.it_value.tv_usec = 50;
> > 	setitimer(ITIMER_REAL, &it, NULL);
> > 	fn();
> > 	return 1;
> > }
> >
> > I'm submitting this patch for the stable kernels, because this bug may
> > cause random failures in any code that calls mm_take_all_locks.
> >
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Link: https://lists.freedesktop.org/archives/amd-gfx/2025-November/133141.html
> > Link: https://yhbt.net/lore/linux-mm/6f16b618-26fc-3031-abe8-65c2090262e7@redhat.com/T/#u
> > Cc: stable@vger.kernel.org
> > Fixes: 7906d00cd1f6 ("mmu-notifiers: add mm_take_all_locks() operation")
>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>

Also feel free to add:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

On assumption that nobody is explicitly relying on bizarre-o 'interrupt this if
_any_ signal arises'. But since it's making _actual workloads_ break I don't see
how this can be wrong.

>
> This makes sense to me as a backportable bugfix. But I wonder if going
> forward we should rather make all that locking killable instead of the
> hopeful checks between individual lock attempts.

Agreed. But anything like that should be a follow-up, let's get this
backported first.

>
> >
> > ---
> >  mm/vma.c |    8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > Index: mm/mm/vma.c
> > ===================================================================
> > --- mm.orig/mm/vma.c	2026-01-04 21:19:13.000000000 +0100
> > +++ mm/mm/vma.c	2026-01-04 21:19:13.000000000 +0100
> > @@ -2166,14 +2166,14 @@ int mm_take_all_locks(struct mm_struct *
> >  	 * is reached.
> >  	 */
> >  	for_each_vma(vmi, vma) {
> > -		if (signal_pending(current))
> > +		if (fatal_signal_pending(current))
> >  			goto out_unlock;
> >  		vma_start_write(vma);
>
> E.g. here I think we already added a killable variant recently?

Definitely unbackportable ;)

>
> >  	}
> >
> >  	vma_iter_init(&vmi, mm, 0);
> >  	for_each_vma(vmi, vma) {
> > -		if (signal_pending(current))
> > +		if (fatal_signal_pending(current))
> >  			goto out_unlock;
> >  		if (vma->vm_file && vma->vm_file->f_mapping &&
> >  				is_vm_hugetlb_page(vma))
> > @@ -2182,7 +2182,7 @@ int mm_take_all_locks(struct mm_struct *
> >
> >  	vma_iter_init(&vmi, mm, 0);
> >  	for_each_vma(vmi, vma) {
> > -		if (signal_pending(current))
> > +		if (fatal_signal_pending(current))
> >  			goto out_unlock;
> >  		if (vma->vm_file && vma->vm_file->f_mapping &&
> >  				!is_vm_hugetlb_page(vma))
> > @@ -2191,7 +2191,7 @@ int mm_take_all_locks(struct mm_struct *
> >
> >  	vma_iter_init(&vmi, mm, 0);
> >  	for_each_vma(vmi, vma) {
> > -		if (signal_pending(current))
> > +		if (fatal_signal_pending(current))
> >  			goto out_unlock;
> >  		if (vma->anon_vma)
> >  			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
> >
>
>

