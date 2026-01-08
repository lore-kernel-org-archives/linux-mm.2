Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59BCBD1D47D
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 15:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7784D6B0089; Thu,  8 Jan 2026 10:30:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7186B6B0092; Thu,  8 Jan 2026 10:30:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A5D46B0093; Thu,  8 Jan 2026 10:30:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 48C356B0089
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:30:54 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EE9051601D2
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:30:53 +0000 (UTC)
X-FDA: 84309184386.02.B345125
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5BF11C0012
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:30:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GVQAlLAN;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jipuokNY;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf22.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767886250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NDSPqPtMXbFI2AYpxXqV/gDJnTzttLpMkKCuQYVKpJs=;
	b=biaAESlqZMbNfPtGNSW4X8e3QLzGQckLtoqnXP7CoOVe7zMGZVSbure0LP1suNhNS4D/8Q
	5IZ1VGtctLyjeMP0SljgRxowQqb+eVyeTRg9fhEb+ijZVVlDHmlW7CH4ONxAYpfE2RJEr6
	lBbVx87Q4gPbTDkZYGTxOx3JM8XjaNI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767886250; a=rsa-sha256;
	cv=pass;
	b=nuAG2Jiv1g8pXSwLLmCNiQ8c0qjN9gVUYLcsNZNUd3O26SfVBauadvKn6aDsJjjdWFbBo/
	8IJah0tWZGQ7wV90Gam+7qfDHeV51wKGUzuRzczN6VnRSkzkh+YJ/dCXGl5Fg3FcKORos7
	fvd9OzNv1WOSRnK39MWxqIWMCLd+vrg=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GVQAlLAN;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jipuokNY;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf22.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 608F52CR796019;
	Thu, 8 Jan 2026 15:30:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=NDSPqPtMXbFI2AYpxXqV/gDJnTzttLpMkKCuQYVKpJs=; b=
	GVQAlLANsspGUzG6L9Jj3a2rSOU2dgZ947No9o7WTdK75rak8GTSuIIF8aae2zPf
	AVYrcyl8rBTpiVO2iJhjb2gCYNfVWgodY+YfQxO0lQkBqLdHilAX6g+IFo4lAuy0
	T9wHcaZrIZDXttX3f1Ade9WUJLX2lbRaQUK1TdEC5Gn24Co2J97RyC41GecY616B
	//TlLbR66CjhNaDmiWI8+s+4rdnOwKxO/uXKr2UvMVU//M+5i8f7IeNRf6QtXSEc
	vBcwn9USutFj6ZzOoRaxTMLlckOWS/WuX2iw+NnXtWdjQROq82B73gOcY5WqDJH/
	LIaBlV5EVFl4qblO5dpxMg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bjewjg1cq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 15:30:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 608F8M0m030832;
	Thu, 8 Jan 2026 15:30:43 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012052.outbound.protection.outlook.com [52.101.48.52])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjf8fv6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 15:30:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nnyo/cp7QRnAsf5xbVv5CL8fk3nRwcGgKYxn2KkOVKXgj79PZ+KbNDV4ab4IEYldbRDkuC+QddfQEG3r3ECecYRpws07mIfx4nqeljrGa0Q+4vbhZ+b3WYpzwyIPE4Db3LKqspTs/MIbHaAL+aObx4ldk7rAcxUJS93Zk/Lvcuj48H4HIwcvzAlsTi3wOhZNI31f23cvTY5lHl40ACM/nm25T5wQYZ4BzwtDNfq4/xlcnWgjgmraSBSgO/0aBmPlGF0RjxZv0yynb1xtl+VQ34hczjnESW1caubOBjuqFogEEl/LzsufF1lb9x0mI6T7cnhFZsfLdMO39qYalGRFrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NDSPqPtMXbFI2AYpxXqV/gDJnTzttLpMkKCuQYVKpJs=;
 b=gDnf2ajX47X9a8eTtTrt9Pfl4pD4dzgnL0sFmdhW1Cbon6hz4TU2ly6++UogScmU5d/CRISPPdB5W6Uu/92PNvpdGMmjlG8SYM16vkvdYxQLVfvdVauPZS7ZpT/T6yMLa2motpuownFQKmAMuYP0rkIa7qImrlX2BPKFokTsbGtOtg2gGN6u6r+yOR8tJ+I31+wrHoNY8aqpx/ZMsWlSbhiN2NKUxQa3I9vfXwzkrXlUah/HWo6+wb46dZMd0h0haf3X5LZeEr0KlRXxfzCLkj+ztdJaW7WWGC3CTtfZWKU6ZBOF1wSqJ6tcVMS+vbIGlF/c5i6coPWJllvhzItAjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NDSPqPtMXbFI2AYpxXqV/gDJnTzttLpMkKCuQYVKpJs=;
 b=jipuokNYG3AfrwHMBeAvN5bafGb9g3SO3f+dSvJsZymTN5QdakbcaiyN9aKDHTYWeZ6XFbielxmQoEA4kc4Y2OQ2PQd4pI7AtohxX8K3xw+JRWg79F30RuIUUjTLYWuwhFwN5NCfEIjNeQnP0DAxK1tUNwxawoln26NJ6O5CSZE=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH7PR10MB5697.namprd10.prod.outlook.com (2603:10b6:510:130::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 15:30:39 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 15:30:39 +0000
Date: Thu, 8 Jan 2026 10:30:35 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pedro Falcato <pfalcato@suse.de>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org,
        linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
        Jann Horn <jannh@google.com>
Subject: Re: [PATCH v4 2/2] amdgpu: delete the "Failed to register MMU
 notifier" message
Message-ID: <n52oa2kp4chrqbafwifhhhkdm6idrabu5vcorcxm7w26obidet@rlsa7zow5fpq>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mikulas Patocka <mpatocka@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Pedro Falcato <pfalcato@suse.de>, 
	Alex Deucher <alexander.deucher@amd.com>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org, linux-mm@kvack.org, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>
References: <20260107203113.690118053@debian4.vm>
 <20260107203230.880324802@debian4.vm>
 <abf1bd1e-22f6-4cc4-b6e5-61fad2a82901@lucifer.local>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <abf1bd1e-22f6-4cc4-b6e5-61fad2a82901@lucifer.local>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT1PR01CA0155.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::34) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH7PR10MB5697:EE_
X-MS-Office365-Filtering-Correlation-Id: 9762776f-a1ca-4731-1e4c-08de4ecae09d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?9MxNId+ECUjE3J1AJqJyQY0iqERkBk57P2u1y5XiSbtkepylV+voVlpNpN?=
 =?iso-8859-1?Q?C2imTRJJ4WisqWsIDlVY2H5GSfdTzJRXXvAtiUXgsPCrRvFnF+QQsUaZEj?=
 =?iso-8859-1?Q?d3KfUBzkoku6GTzS1SQDBUmyoLtCGNNUlnZx1phv0c6yz6FIi5SX8IBMO6?=
 =?iso-8859-1?Q?Am94NxK+miRZ5VkMV/R8ROvnuzhz3Y6MpZPqPp2n9A7+iFsu88YDfVfxWP?=
 =?iso-8859-1?Q?N5Gx3UIxZU4E3KurIannjIbbZ0qwAFui4lfmaWoBS90u5QyRrPxyEAzKso?=
 =?iso-8859-1?Q?02Auj/dfPYiMxQrdGWaV8Yt8LvtK8hGTBacwXGBGAc7xAa3ChMdvOiWV/2?=
 =?iso-8859-1?Q?e9Wth3ohMk1IQ0X5vU07yFwhyOnaNufDcGocS0GTDpy4tIxuLtJNn6FPxT?=
 =?iso-8859-1?Q?LkVmgduhf7Ywmzkz4L0NuvTxNkCgNiztOaCz64JGDHgLdIiXxjjvl37Aj9?=
 =?iso-8859-1?Q?qjzlirJaOfjq2Bra3VQofUHvf6u5D0zMQLp0wSG2N3L6gp3jKHLxB3HJdJ?=
 =?iso-8859-1?Q?S1FaOFNae1zQUX9w2bUoLPmnsu+whbUbd7W3RZLgBMgWihf14ht3yXt2oC?=
 =?iso-8859-1?Q?Z+QMxg28HiDRtHiLUj38oJCjP5EgnxXx32zv2pNWAkKZiqnyUt6aO8+ddc?=
 =?iso-8859-1?Q?WkGToHdiRFD1tyXNgjWgxhG12WQkHsxYP2K8AX+Sv9CCsHZtCP7LFrfw1V?=
 =?iso-8859-1?Q?J+9pxu0XCXEDqAYrCseJU2ulZzrHk5mmCNYX9up0iuWQzdYTBmiG0T+tcg?=
 =?iso-8859-1?Q?9JNYIN0wwfDzdu8RZDB8Pk+sAOM9KwvozxR5uTJcTLmwfMGX8/kd+a5Zyq?=
 =?iso-8859-1?Q?fCWRN+lcZvJJQB6mG029QLsxSQ38/o0GyB6CpHpvJnUz93mWwccfqCuYNe?=
 =?iso-8859-1?Q?EiBgS7MRLHihRh8HheByNGXdYy1iE3+RgKU6mwTeuPUiMvHKOsn42ikLny?=
 =?iso-8859-1?Q?4kK3CRTsKvy30XpLIRoP7jl6TkQlU15pM0bJU2PYrM1x4yQB4SNyy67t6F?=
 =?iso-8859-1?Q?mYwBQ1EPrrbg7zAefVU2W6NmpUkEZwsxVsro26oPGlkDagAeab3zKMeNlr?=
 =?iso-8859-1?Q?eaK7xgQ7c+oJVXMU+D2+qWe3zc8CAEuPKhVZa8Xkod7zygjb6OKFR+DfdH?=
 =?iso-8859-1?Q?LDrD77yfDqjk6RQNDerYFLvbTBCWYQzX4DH2eydo04kb0OBjHb6Kye5sut?=
 =?iso-8859-1?Q?J3EcC13IZHwaTJc3dtvtP43zAk7kYG9+K1CAupIgUr3hlbbg2T+dzQ/AQ1?=
 =?iso-8859-1?Q?y//dNAiT7dPNS4cZQJ4eHVJQVsXA6s8bbRb6O3qtdsqKeA2eDPBqmbApwQ?=
 =?iso-8859-1?Q?TvEBPungCdce+YlrOmC6SX2fg0uNEJ4mjK+rJ1dUYV+bWrnWnBF8kAGphU?=
 =?iso-8859-1?Q?ly1EHUa9Cfm++/aBa8KqH7GPmBA87X2X0tA0pOaCHo+6V95qn0CsPd3wLV?=
 =?iso-8859-1?Q?b/FXHgW02I+4QknwdzmP+BFE3rEIb7xZ1ea08g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?BKuhsoxdNTI+MB3cvVRJYixpImXUJapmQT3dP+u+B7qBd0XlzhazdNzN56?=
 =?iso-8859-1?Q?5s7GQs6DRNYPFCUv+qBMUPyINfPTPk3Pi/HxTHb6cVTmRrUaxu5ppvNYiB?=
 =?iso-8859-1?Q?yGg3QNHgx8bq/iEWmMkT3LO+fYNdTKwSN1mbPj7clJGj8wuDGkyiDP0WFA?=
 =?iso-8859-1?Q?kw4M67wFD7EBNlmj+nPeZ0JYvXU+ch4Emlk7Ecs6Qq6wRIGTopUyIXJcQN?=
 =?iso-8859-1?Q?+eln7MZON1RjT5LFrwN+SzNm2jFx1SeXmjLu3zvEzqM787bzaZhuWJ3T9r?=
 =?iso-8859-1?Q?8l/v2nSiUENUmXeCKUxIORQI8iUMoAkIVrBCOm1piJHvOT7sIrL/koQkyw?=
 =?iso-8859-1?Q?DaPFkOvy1ilRZoIO2IAlmkRMcJ6meIf4QhLqQI50sud4kdHjilfdcWKPC+?=
 =?iso-8859-1?Q?HRhuWD1KTMrn3wELCDDmeoVUbdCdvKUScmR3mo17PX9LnCwjQYguMbbj/0?=
 =?iso-8859-1?Q?siaiee9fAXukqkp7eZXBOOo81HMnSlciSvE4R9Qazg8pcuTSko6PDJKkqP?=
 =?iso-8859-1?Q?Q0/NLIWJSli/smIxV49/8uPPvXjfgfrJ6uxz3X8KSaiSZtQkUJN9Y4+WCd?=
 =?iso-8859-1?Q?fGOtqXT5reCoacLqIQFLopxaMrxYDr0XPwQ/6nya757gNZdeS0dPrLSrr0?=
 =?iso-8859-1?Q?j7dvH6P2jhtwYHHgtZmEg5UJ/QlR1YZl8rMp9poHoUHTkJtEzcjHgWc5DL?=
 =?iso-8859-1?Q?SPgeORGpietn0L8dBVvt1YnHutoOrE1JodFIcs/L3JFVf3OeXI+2bv0zRE?=
 =?iso-8859-1?Q?w2xpPTnKJDnSSX+X9jWYhWF5wnn5wtQMjeAn8ggeu692flrg8T0lVbFCFr?=
 =?iso-8859-1?Q?8QRFK6uRPQMg587FkHw8dOr8n7P1nZaIkXZ9ySlEjjSKSVXlydDl56+hAU?=
 =?iso-8859-1?Q?i1GC+05fbkWMi7rvaj4uHeMr7sWn7+IBE8dqPhfTCVrt/BdcfPaaHrV/Nh?=
 =?iso-8859-1?Q?XjlM20JURWEKzJHpuNU/12kzULu8pi/j4qe22yXL1DoWHqf3y2r4B7lhmr?=
 =?iso-8859-1?Q?mAukytJ+ps7/dbe4dWpNIvVfA5Gflqn8mmLmxME69oJJMWM/WRCJIATsBz?=
 =?iso-8859-1?Q?eL5d+wS2j/4eqA2HVUJqMFq1wGcbdpbNPemnPEOUjuOwCZpOu/Bhhg017h?=
 =?iso-8859-1?Q?mrLsalRwqFwVGHPBgWWm//eoqZ9OyFFnjmgsGI4WpUiw4A280woaMBkvwc?=
 =?iso-8859-1?Q?5kwA3LQI4Sg8kemarhIsjZcHhjLc8k9gm+S9UBb2OE8BlrSgwBQfhnZIEU?=
 =?iso-8859-1?Q?NqWtUyeV+KzdvHiWoSTnc2/SqGbtsZUrfHIh+7CbpDNV6+EJvfPm6t9nKz?=
 =?iso-8859-1?Q?M0wOrSPAoMkvO8Aqw9kMe1wNbjC6i8362D41MujKN9Msi04NbU0Qt+mV+t?=
 =?iso-8859-1?Q?NAlZ0yDqSGXkhWuxZh6UyyloU0bcK16KrwPvWm0WAH+1+ofhPD1cvkydr7?=
 =?iso-8859-1?Q?aJHuyKld0OHSQlNvKx0JJ8V2fSNhFiFnfRetMuqBwVMXWNlxC+HxifLSMn?=
 =?iso-8859-1?Q?hL0vxtzi/0BAMprw02zF+9ey0DmjUP2K3VnD3E+pKliAXXcxZoWPGZUhTn?=
 =?iso-8859-1?Q?FxtZ7wqEAwE08TYvkXEzM7Cg6xKoxnvMrmN/fwuTzKnaH16RP4LYlsOdGH?=
 =?iso-8859-1?Q?k5Jk18r8/W2W3X1rz00xWyqvObL9x6QyiggAiLT9OF4FSZJpFqgIZzyjiG?=
 =?iso-8859-1?Q?4hDaa2ffTlL6ysc/0BPzrTvFv7WneH8Qpcl5ThOlmhUvRwqb+O8ak2nhnL?=
 =?iso-8859-1?Q?NVGKuyTDzBD5lBreXqt6dfSt4GwqecB8QFzgpBBN7qBi2h/JSNBoUq1kwE?=
 =?iso-8859-1?Q?ZSRu4Yc78A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xnkOf3d/PSiG2E2UUs/V735EkIY6iI1eMhvCGrOiszQFZt5xzJd4wMcIFPJLc8cBrpV8PNwqOK0rAms70j8h0qcl52ZyH38uWS00YOnz7VpcIdUsLIJLoL/I8ZiSTFG8plhuVV5o4wj/dXgD7w3VFi+u6RspcBc9yh5v0UEJ0hCmxwhXBVh89eO01Db1ayLsZZoi7bNNUJLbZ6ZNTPaAnIaXuUyr2H1f0vg0MaWocWWe/XG7eI81EUuMKmKU6SRSOySDYN9FQJ1DsJLkkmROp1ZKAyETODhU6QBSeR0BlATEJMPVjMzrzDkg4BWjz6KsJZY6MooTUgTsebYiUak1zFBozkxL3MROvGZ+iwSWwqL9RWPvbBXJWlYuMW0c+hSo9/N+1WUBPjogEYVJGpRKKrzjOu5azU3cLl2f1hxP4xdR+FyOCkmwFS1vDbsLpMgqo/f6o4dHp1P0H50UZ7QCBj/JreCz61h0VTISC9WAiQlO3LhIOD+ZLw7PBszrlI+tyMEFi4cOTIaRIMiSJvWVXCirQifokGZGePIYf/a2sXeSHgFDrReUeHcQXeDaLt4/nIQUqOuNUnlEpuhGbob677UiwMbJq+AnxBG9LQp9KgA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9762776f-a1ca-4731-1e4c-08de4ecae09d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 15:30:39.3972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IGXhm1ocTD5EU0pbGvrDGithj23Sqmun4fbusnaQasSQOLxeBiztPsMF3Xrt6jvQzgdg0M8ROegBQlRlid+/ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5697
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_03,2026-01-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601080112
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDExMyBTYWx0ZWRfX+gS2mlbWfLXr
 Vi0/4VlfwM1F93ZmE/6bUv6Dn15L6irZfgJ2XekolcWP5KD4qBdJy+w1WQjEFwiY/6gQZOdk7V5
 n4V7n6jcLjeMYLi8WPhv5c4Ma50RRZ0V8liX97LVkU8axf1veHc12iQN8EKZ6lL0zqtYwW7t8gW
 93APmmsJGNT0ToTWpK0yj6CsXmZk0PgsMzxhRM4cr71zjC6/oyjLB8eq+dIqkyueMHxTT7qy3F5
 OxJjIzTpWZ3akUsDDob7dlipyT5VDi68ucOQdOIb/fGOzwNAwX5+OjoHbMj3XDOxOGgyUougKE0
 FtDjwACSH36X2n0UoMZM8G0esF04hMiXL+EXjhsh/NbhLnJ6xSeg3hexXVTxnsk3kHI5Q9NA0Ul
 +3MsvWybVHE3Ha7S0oAHvPXcGbJEnBTDTuDN3GlwrdMLvfYYbwHu24FwHisBs8NAZ8fxDq4tRAA
 5+sRl+40KU5nPs7DoPht8os4LtIT1uSUe0ydHty4=
X-Authority-Analysis: v=2.4 cv=PqGergM3 c=1 sm=1 tr=0 ts=695fcda5 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=AuJ5XBkW6YnNA73EvkIA:9 a=wPNLvfGTeEIA:10
 cc=ntf awl=host:13654
X-Proofpoint-ORIG-GUID: 3haelq8_wZPw5vc9PVJHH6qEIgemVRAm
X-Proofpoint-GUID: 3haelq8_wZPw5vc9PVJHH6qEIgemVRAm
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5BF11C0012
X-Stat-Signature: 1om1knz9mrtuk84eu7jt16uawiiuoo9r
X-HE-Tag: 1767886250-211190
X-HE-Meta: U2FsdGVkX19uCfAwD25GpfXW9Rdd3h8Si2ehiYf/xkz2BIGumrpQtlpRoKokgj59ygnczCGgXXIVi8aEigWBhEyvf22nBJlKWErXqihr68PEaA0e71/EySYsrt+WswsvlMiCX1jBNAq6PqdbLwhG+N8wl1uO2RJgubXTcvUEuuWSlHaLQZdWRgCAb8VkqGuuCnYa2hgfw3MUJYgEIWIHZJZbKJpGR8i5tSA71073hy2y9aT8p8jqMGBPVpTaGlRuba3MLPMSMeUG6RyaX86WErwibHm8EQ4Nec+a2Cd/jFuRGApLEP0FzE7WjxU/BYpOWVesQkw0Wt2d5jAnOVUk7LgRI52TveBWOUo822RroWmQly4wiBt0dqm/5YPaeKnJJWMPZPQ+zQaBYKm5bMcmesLtLo3khGRK9rLmXdTaP305AaWnJk0/jtfTqZenWhD5RqJF1xhYNfqPDYcjYTdOnbm/maY9OOKLo9CqBj8kKObGFReotzzvU73FcqhrA/Z0a4q5d0TyKD92dJzwEavLv3ZrYH+yTHHi6haQEQ93h1/ueKdE52HZWHCE8+RWpZVMEXpzIEAmsnBIsekhmyZrf67D4XdKl60i2oL7wJpImcRpdbebRiLoHHWhXpA2zRjL+Oc6bfau96vsAoPZKE2pQ6WdjGMaS2ZqGqOLq447hEi6EOo2YyctRiU0qWHmuY9oc0fEBgzra0NCWL3HltaZT8vjNd1Ynqic8pLhyU0dNDac1xU5KQqaYBJoBWdV/H7LSFv8H8m/my1O2frN3QtMWswSaM6clg9yXuCwS+k0Qk7ikBpLpWMwBXvdM/CEwuixrmK4XXdYBKii7/+Wxnij2u8gniTpXtLZ/nnsNuJBiMXSmcf6XMeRsBE4xZfxYWW1VsGut/Y84VRhFunMDov0eVFd7Bi50hQ2Z0ZfsGnQkPBydxGSLoKXPEjstdDPTWws2PY0XXfxp+kJ82Pvs1u
 7+bgdD1w
 zMgqOfHzulycA0m4CKRhGrLWboLvn7mKjyKvK6zGpGdXGt8cskJIi8nf/AK/mtVgRZteHnpXiUw29qC/9X5o9UJVKCCI26M35mlE2pwQGzqPjruUEUJJQMx/Fhg4keJxIpRiUuip3Y7oIJVOp4LEATIAOU7bS1bKe9D/fa10lH7jTH9vo1fr+wwtvhcDNcUn2/f+E9m2QyQgpKCF2QPgtbr48/j/wkGLeKnzMqHDIQXhRBLtDaaXOXLB0QR2ox68Hz5CuP0LNFLtGLTIyrsZLPVn0DTWOh6dlxCp+txFlCkFTQnqOrv8wh8n7cFDYU3fC3Df53WibrFc9ND7nS0Vu/QFCSD3s8lApRWu90fRvEr+b1sytCeAPPaJn3S5rRWLQXzuXuhL2Wkyfi4XvBsr6Mc/U1WZmtg/7hN8hAuiCms5skW1I3kh0cGTDJcxBD+Py2tLxok3gL+uVAuRCbFFpFEiOWQRLF5WvWQFjeI3CmRbV6DYwNDCsZiuySDyWfnVchbZizig0RehUVJvpMOMLPCwhVr0Kl+FQzh5jWk75tli8jF7hB39OXNTnHhLPr9q3VC5fm7UR7QpCqQhWJYJg7R7x1sl+uyQgSaEWk4aVfLdnRrv0y4CsM1puLdbFZhmFhCtU04PU54YZd8/Ri9+WXQM2kqRhYJTh2PbDdYoiRKsgBu8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [260108 10:20]:
> On Wed, Jan 07, 2026 at 09:31:15PM +0100, Mikulas Patocka wrote:
> > This error may happen if mm_take_all_locks was interrupted by a signal =
-
> > the userspace will retry an ioctl that returned -EINTR, so there is no
> > need to report it to the syslog.
> >
> > Christian K=F6nig suggested to remove this message at all, so let's do =
it.
> >
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>=20
> I don't really see the point in this being part of the series here... see=
ms
> to me a patch that could be applied any time, so why not send that
> separately to the amd driver people?
>=20
> I mean maybe it's not al that important but still.

I really think changing this to info would be better.  It was (and may
be) useful to some?

Obviously the amd folks need to work on signal handling and this would
help them..

But then again, as Lorenzo said, we don't really need to be involved in
this patch.

>=20
> >
> > ---
> >  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    5 +----
> >  1 file changed, 1 insertion(+), 4 deletions(-)
> >
> > Index: mm/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- mm.orig/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c	2026-01-07=
 20:09:51.000000000 +0100
> > +++ mm/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c	2026-01-07 20:1=
2:11.000000000 +0100
> > @@ -1069,11 +1069,8 @@ static int init_user_pages(struct kgd_me
> >  	}
> >
> >  	ret =3D amdgpu_hmm_register(bo, user_addr);
> > -	if (ret) {
> > -		pr_err("%s: Failed to register MMU notifier: %d\n",
> > -		       __func__, ret);
> > +	if (ret)
> >  		goto out;
> > -	}
> >
> >  	if (criu_resume) {
> >  		/*
> >
> >

